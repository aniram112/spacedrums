import Foundation
import AVFAudio
import AudioKit

class CollectionViewPlayer: ObservableObject, HasAudioEngine  {
    let engine = AudioEngine()
    let player = AudioPlayer()

    func setup() {
        engine.output = player
        try? Settings.session.setActive(false, options: .notifyOthersOnDeactivation)
        try? Settings.setSession(category: .playback, with: [.allowBluetooth])
        try? Settings.session.setActive(true, options: .notifyOthersOnDeactivation)
        //try? engine.start()
    }

    func loadFile(file: AudioFileModel) {
        guard let url = Bundle.main.url(forResource: file.name, withExtension: "wav") else {
            fatalError("\(file.name) file not found.")
        }
        do {
            let file = try AVAudioFile(forReading: url)
            try player.load(file: file)
        } catch {
            print("yeet error")
        }
    }

    func play(file: AudioFileModel) {
        try? engine.start()
        loadFile(file: file)
        player.play()
        /*for d in AudioEngine.outputDevices {
            print("\(d.name) \(d.debugDescription)")
        }*/
    }
}
