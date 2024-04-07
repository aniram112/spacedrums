import Foundation
import AVFAudio
import UIKit
import AudioKit

/*
 class PlayersView: UIViewController {

    let mixer = AKMixer()
    let players: [AKPlayer] = {
        do {
            let filenames = ["mixing_1_vocal.mp3",
                             "mixing_2_drums.mp3",
                             "mixing_3_synth.mp3",
                             "mixing_4_bass.mp3"]

            return try filenames.map { AKPlayer(audioFile: try AKAudioFile(readFileName: $0)) }
        } catch {
            fatalError()
        }
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        makeConnections()
        startAudioEngine()
        preparePlayers()
        startPlayers()
    }

    func makeConnections() {
        players.forEach { $0 >>> mixer }
        AudioKit.output = mixer
    }

    func startAudioEngine() {
        do {
            try AudioKit.start()
        } catch {
            print(error)
            fatalError()
        }
    }

    func preparePlayers() {
        players.forEach { player in
            player.isLooping = true
            player.buffering = .always
            player.prepare()
        }
    }

    func startPlayers() {
        let startTime = AVAudioTime.now() + 0.25
        players.forEach { $0.start(at: startTime) }
    }

}
 */
