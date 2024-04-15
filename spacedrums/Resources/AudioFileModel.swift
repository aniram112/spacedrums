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
    var note: Int
    var icon: String
}

extension AudioFileModel {
    static var mock: AudioFileModel {
        return AudioFileModel(name: "mock", file: .mp3, note: 0, icon: "mock")
    }

    static var mock2: AudioFileModel {
        return AudioFileModel(name: "mockmock", file: .mp3, note: 0, icon: "mock")
    }


    static var kick: AudioFileModel {
        return AudioFileModel(name: "Drums/bass_drum_C1", file: .wav, note: 24, icon: "kick")
    }

    static var snare: AudioFileModel {
        return AudioFileModel(name: "Drums/snare_D1", file: .wav, note: 26, icon: "snare")
    }

    static var hat: AudioFileModel {
        return AudioFileModel(name: "Drums/closed_hi_hat_F#1", file: .wav, note: 30, icon:  "hi-hat")
    }

    static var openHat: AudioFileModel {
        return AudioFileModel(name: "Drums/open_hi_hat_A#1", file: .wav, note: 34, icon:  "hi-hat")
    }

    static var clap: AudioFileModel {
        return AudioFileModel(name: "Drums/clap_D#1", file: .wav, note: 27, icon: "clap")
    }

    static var hiTom: AudioFileModel {
        return AudioFileModel(name: "Drums/hi_tom_D2", file: .wav, note: 38, icon: "snare")
    }

    static var midTom: AudioFileModel {
        return AudioFileModel(name: "Drums/mid_tom_B1", file: .wav, note: 35, icon: "snare")
    }

    static var loTom: AudioFileModel {
        return AudioFileModel(name: "Drums/lo_tom_F1", file: .wav, note: 29, icon: "snare")
    }


    static var collection = [
        "Drums" : [AudioFileModel.kick, AudioFileModel.snare,
                   AudioFileModel.hat, AudioFileModel.clap,
                   AudioFileModel.openHat, AudioFileModel.hiTom,
                   AudioFileModel.midTom, AudioFileModel.loTom],
        "Mock two" : [AudioFileModel.mock, AudioFileModel.mock2]
    ]
}

func getDisplayName(_ name: String) -> String {
    let sound = String(name.split(separator: "/").last ?? "file")
    return sound.split(separator: "_").dropLast().joined(separator: " ")

}
