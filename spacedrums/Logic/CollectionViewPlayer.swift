import Foundation
import AVFAudio
import AudioKit

class CollectionViewPlayer: ObservableObject, HasAudioEngine  {
    let engine = AudioEngine()
    let player = AudioPlayer()

    init() {
        engine.output = player
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
        loadFile(file: file)
        player.play()
    }
}
