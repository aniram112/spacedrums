import AudioKit
import AVFAudio
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import Foundation

struct SoundSample {
    var sound: SoundViewModel
    var midiNote: Int
    var audioFile: AVAudioFile?

    init(_ sound: SoundViewModel, note: Int) {
        self.sound = sound
        midiNote = note

        guard let url = Bundle.main.url(forResource: sound.file.name, withExtension: "wav") else { return }
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: \(sound.file.name)")
        }
    }
}

class MainConductor: ObservableObject, HasAudioEngine {
    @Published var data = PitchData()
    @Published var gain = 0.0
    @Published var trackerRunning = false

    let engine = AudioEngine()

    var initialDevice: Device?
    var mic: AudioEngine.InputNode?
    var tracker: PitchTap?
    var silence: Fader?

    var instrument = AppleSampler()
    let mixer = Mixer()

    var sounds: [SoundSample] = []

    func setup() {
        try? Settings.session.setActive(false, options: .notifyOthersOnDeactivation)
        try? Settings.setSession(category: .playAndRecord, with: [.allowBluetooth, .defaultToSpeaker])
        try? Settings.session.setActive(true, options: .notifyOthersOnDeactivation)
        guard let input = engine.input else { fatalError() }
        guard let device = engine.inputDevice else { fatalError() }

        initialDevice = device

        mic = input

        instrument.amplitude = 12
        mixer.volume = 20

        let silencer = Fader(input, gain: 0)
        mixer.addInput(silencer)
        mixer.addInput(instrument)
        engine.output = mixer
        try? engine.start()

        guard let microphone = mic else { return }
        silence = Fader(microphone, gain: 0)

        //resume()
    }

    init() {
        print(" init")
    }

    deinit {
        print(" deinit")
    }

    func update(_ pitch: AUValue, _ amp: AUValue) {
        guard amp > 0.07 else { return }
        //print("yeet \(pitch)")
        if amp > 0.1 {
            guard !sounds.isEmpty else { return }
            guard let sound = getClosestSound(Int(pitch)) else { return }
            instrument.volume = AUValue(sound.sound.volume)/100
            instrument.play(noteNumber: MIDINoteNumber(sound.midiNote))
            //print("yeet should play note")
        }

        data.pitch = pitch
        data.amplitude = amp

    }

    func loadSounds(models: [SoundViewModel]) {
        guard !models.isEmpty else { 
            sounds = []
            return
        }
        sounds = models.compactMap { SoundSample($0,note: $0.file.note)}
        do {
            let files = sounds.map {
                $0.audioFile!
            }
            try instrument.loadAudioFiles(files)

        } catch {
            Log("Files Didn't Load")
        }
    }
    
    func resume(){
        try? Settings.session.setActive(false, options: .notifyOthersOnDeactivation)
        try? Settings.setSession(category: .playAndRecord, with: [.allowBluetooth, .defaultToSpeaker])
        try? Settings.session.setActive(true, options: .notifyOthersOnDeactivation)
        try? engine.start()
        print("resume")
        guard let microphone = mic else { return }
        trackerRunning = true
        tracker = PitchTap(microphone) { [weak self] pitch, amp in
            if let self = self {
                DispatchQueue.main.async {
                    self.update(pitch[0], amp[0])
                }
            }
        }
        tracker?.start()
        instrument.volume = 1
    }

    func pause() {
        print("pause")
        instrument.stop()
        instrument.volume = 0
        tracker?.stop()
        engine.stop()
    }

    func getClosestSound(_ pitch: Int) -> SoundSample? {
        let values = sounds
        let match = values.reduce(values[0]) { abs($0.sound.pitch-pitch) < abs($1.sound.pitch-pitch) ? $0 : $1 }
        let index = values.firstIndex(where: {$0.sound.pitch == match.sound.pitch}) ?? 0
        return sounds[index].sound.isActive ? sounds[index] : nil
        //return sounds[index]
    }
}
