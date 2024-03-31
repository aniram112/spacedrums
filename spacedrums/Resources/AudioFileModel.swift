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

    static var collection = [
        "Mock" : [AudioFileModel.mock,
                  AudioFileModel.mock2,
                  AudioFileModel.mock,
                  AudioFileModel.mock,
                  AudioFileModel.mock],
        "Mock two" : [AudioFileModel.mock]

    ]

}
