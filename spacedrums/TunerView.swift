import AudioKit
import AVFAudio
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteNameWithSharps = "-"
    var noteNameWithFlats = "-"
}

class TunerConductor: ObservableObject, HasAudioEngine {
    @Published var data = TunerData()
    @Published var isPink = false
    @Published var gain = 0.0

    let engine = AudioEngine()
    let initialDevice: Device
    //let micBooster: Fader

    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader

    var tracker: PitchTap!
    let musicEngine = AudioEngine()
    var instrument = AppleSampler()

    let player = AudioPlayer()
    let mixer = Mixer()

    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    init() {
        guard let input = engine.input else { fatalError() }
        guard let device = engine.inputDevice else { fatalError() }

        initialDevice = device

        mic = input
        let micMixer = Mixer(mic)

        let silencer = Fader(input, gain: 0)
        mixer.addInput(silencer)
        //mixer.addInput(player)
        mixer.addInput(instrument)
        engine.output = mixer

        guard let url = Bundle.main.url(forResource: "Drums/snare-2", withExtension: "wav") else {
            fatalError("\"cheeb-snr.wav\" file not found.")
        }
        do {
            let file = try AVAudioFile(forReading: url)
            //try player.load(file: file)
            try instrument.loadAudioFile(file)
        } catch {
            print("yeet error")
        }

        //player.play()
        //instrument.play()

        //micBooster = Fader(micMixer)
        //micBooster.gain = 10
        //micBooster.volume

        //let pitchShifter = PitchShifter(micBooster, shift: 5)
        //engine.output = pitchShifter

        try? engine.start()

        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        //instrument.avAudioNode


        //try? musicEngine.start()
        // musicEngine.output = instrument

        tracker.start()
        //try? musicEngine.start()
        // if (playingNote) {
        //    instrument.play(noteNumber: MIDINoteNumber(36), velocity: 90, channel: 0)
        // }
    }

    func update(_ pitch: AUValue, _ amp: AUValue) {
        //print("yeet \(pitch)")
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.07 else { return }

        //if (abs(data.pitch - pitch) >= 10 )
        //{
        if isPink { isPink = false }
        else { isPink = true }
        //print("yeet changing colors \(isPink)")
        if amp > 0.1 {
            //playingNote = true
            //player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                self.instrument.play()
                //print("yeet should play note")
            }
            //instrument.play(noteNumber: MIDINoteNumber(36), velocity: 90, channel: 0)

        }// else { playingNote = false }

        data.pitch = pitch
        data.amplitude = amp

        /*var frequency = pitch
         while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
         frequency /= 2.0
         }
         while frequency < Float(noteFrequencies[0]) {
         frequency *= 2.0
         }

         var minDistance: Float = 10000.0
         var index = 0

         for possibleIndex in 0 ..< noteFrequencies.count {
         let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
         if distance < minDistance {
         index = possibleIndex
         minDistance = distance
         }
         }
         let octave = Int(log2f(pitch / frequency))
         data.noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
         data.noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"*/
    }
}

struct TunerView: View {
    //@StateObject var conductor = TunerConductor()
   @StateObject var conductor = PitchDetector()

    var body: some View {
        VStack(spacing: 50) {
            Text("\(conductor.data.pitch, specifier: "%0.1f")")
            Text("\(conductor.data.amplitude, specifier: "%0.1f")")
            InputDevicePicker(device: conductor.initialDevice)
            /*HStack {
             Text("Frequency")
             Spacer()
             Text("\(conductor.data.pitch, specifier: "%0.1f")")
             }.padding()

             HStack {
             Text("Amplitude")
             Spacer()
             Text("\(conductor.data.amplitude, specifier: "%0.1f")")
             }.padding()

             HStack {
             Text("Note Name")
             Spacer()
             Text("\(conductor.data.noteNameWithSharps) / \(conductor.data.noteNameWithFlats)")
             }.padding()*/
        }
        //.cookbookNavBarTitle("Tuner")
        .onAppear {
            conductor.start()
            conductor.startDetection{ _ in }
            //conductor.tracker.start()
        }
        .onDisappear {
            conductor.stop()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        //.background(conductor.isPink ? .pink : .blue)
        .background(.blue)


    }
}

struct InputDevicePicker: View {
    @State var device: Device

    var body: some View {
        Picker("Input: \(device.deviceID)", selection: $device) {
            ForEach(getDevices(), id: \.self) {
                Text($0.deviceID)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: device, perform: setInputDevice)
        .background(.red)
    }

    func getDevices() -> [Device] {
        AudioEngine.inputDevices.compactMap { $0 }
    }

    func setInputDevice(to device: Device) {
        do {
            try AudioEngine.setInputDevice(device)
        } catch let err {
            print(err)
        }
    }
}
