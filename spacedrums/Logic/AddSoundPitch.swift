import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit

struct PitchData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
}

class PitchDetector: ObservableObject, HasAudioEngine {
    @Published var data = PitchData()
    var detectedPitches: [PitchData] = []

    let engine = AudioEngine()
    let initialDevice: Device

    let mic: AudioEngine.InputNode

    let silence: Fader

    var tracker: PitchTap?

    init() {
        try? Settings.session.setActive(false, options: .notifyOthersOnDeactivation)
        try? Settings.setSession(category: .playAndRecord, with: [.allowBluetooth, .defaultToSpeaker])
        try? Settings.session.setActive(true, options: .notifyOthersOnDeactivation)
        guard let input = engine.input else { fatalError() }
        guard let device = engine.inputDevice else { fatalError() }

        print("add \(device.deviceID)")

        initialDevice = device

        mic = input
        silence = Fader(mic, gain: 0)
        engine.output = silence

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        tracker?.start()
    }

    func startDetection(completionHandler: @escaping (Int) -> Void){
        detectedPitches = []
        tracker?.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.tracker?.stop()
            self.engine.stop()
            let sorted = self.detectedPitches.sorted{ $0.pitch < $1.pitch }

            if self.detectedPitches.count == 0 {
                completionHandler(-1)
                return
            }
            
            var median: Float = 0.0
            if sorted.count % 2 == 0 && sorted.count > 0 {
                let first = sorted[(sorted.count / 2)].pitch
                let second = sorted[(sorted.count / 2) - 1].pitch
                median = (first + second) / 2
            } else {
                median = sorted[(sorted.count - 1) / 2].pitch
            }
            print(sorted.map{ $0.pitch })
            print(median)
            // TODO Inter-quartile range или еще как-то убрать аутлаеров
            completionHandler(Int(median))
        }
    }

    func calculateMedian(array: [Int]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2])
        }
    }

    func averagePitch() -> Int {
        detectedPitches.sort{ $0.pitch > $1.pitch }
        print(self.detectedPitches.map{ $0.pitch })

        return 0
    }


    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }
        data.pitch = pitch
        data.amplitude = amp
        detectedPitches.append(PitchData(pitch: pitch, amplitude: amp))
    }
}
