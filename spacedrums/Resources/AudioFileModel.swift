import Foundation
import AVFoundation
import UIKit

struct AudioFileModel: Hashable, Codable {
    enum File: String, Codable {
        case mp3
        case wav

        var type: AVFileType {
            switch self {
            case .mp3:
                return AVFileType.mp3
            case .wav:
                return AVFileType.wav
            }
        }
    }

    var name: String
    var file: File
    var icon: String
}

extension AudioFileModel {
    static var mock: AudioFileModel {
        return AudioFileModel(name: "mock", file: .mp3, icon: "mock")
    }

    static var mock2: AudioFileModel {
        return AudioFileModel(name: "mockmock", file: .mp3, icon: "mock")
    }

    static var kick: AudioFileModel {
        return AudioFileModel(name: "Drums/kick", file: .wav, icon: "kick")
    }

    static var snare: AudioFileModel {
        return AudioFileModel(name: "Drums/snare", file: .wav, icon: "snare")
    }

    static var snare2: AudioFileModel {
        return AudioFileModel(name: "Drums/snare-2", file: .wav, icon: "snare")
    }

    static var hat: AudioFileModel {
        return AudioFileModel(name: "Drums/hi-hat", file: .wav, icon:  "hi-hat")
    }

    static var cymbal: AudioFileModel {
        return AudioFileModel(name: "Drums/cymbal", file: .wav, icon: "hi-hat")
    }

    static var clap: AudioFileModel {
        return AudioFileModel(name: "Drums/clap", file: .wav, icon: "clap")
    }

    static var collection = [
        "Drums" : [AudioFileModel.kick, AudioFileModel.snare,
                   AudioFileModel.hat, AudioFileModel.clap,
                   AudioFileModel.cymbal, AudioFileModel.snare2],
        "Mock two" : [AudioFileModel.mock, AudioFileModel.mock2 ]
    ]

}
