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
    
    static var collection = [
        "Drums" : [AudioFileModel.kick, AudioFileModel.snare,
                   AudioFileModel.hat, AudioFileModel.clap,
                   AudioFileModel.openHat, AudioFileModel.hiTom,
                   AudioFileModel.midTom, AudioFileModel.loTom],
        "Xylophone" : [AudioFileModel.xyloA, AudioFileModel.xyloB,
                       AudioFileModel.xyloC, AudioFileModel.xyloD,
                       AudioFileModel.xyloE, AudioFileModel.xyloF],
        "Phonk" : [AudioFileModel.bellOne, AudioFileModel.bellTwo,
                   AudioFileModel.chime, AudioFileModel.cowbellOne,
                   AudioFileModel.cowbellTwo, AudioFileModel.cowbellThree,
                   AudioFileModel.shaker, AudioFileModel.snarePhonk],
        "Вeer" : []
    ]
}

func getDisplayName(_ name: String) -> String {
    let sound = String(name.split(separator: "/").last ?? "file")
    return sound.split(separator: "_").dropLast().joined(separator: " ")
}

func getFile(_ name: String) -> AudioFileModel {
    for (_, values) in AudioFileModel.collection {
        for model in values {
            if model.name == name {
                return model
            }
        }
    }
    return .mock
}
