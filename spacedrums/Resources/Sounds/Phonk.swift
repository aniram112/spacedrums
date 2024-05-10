import Foundation

extension AudioFileModel {

    static var bellOne: AudioFileModel {
        return AudioFileModel(name: "Phonk/bell_1_A6", file: .wav, note: 93, icon: "bell")
    }

    static var bellTwo: AudioFileModel {
        return AudioFileModel(name: "Phonk/bell_2_B5", file: .wav, note: 83, icon: "bell")
    }

    static var chime: AudioFileModel {
        return AudioFileModel(name: "Phonk/chime_A5", file: .wav, note: 81, icon: "chimes")
    }

    static var cowbellOne: AudioFileModel {
        return AudioFileModel(name: "Phonk/cowbell_1_C4", file: .wav, note: 60, icon: "cowbell")
    }

    static var cowbellTwo: AudioFileModel {
        return AudioFileModel(name: "Phonk/cowbell_2_C5", file: .wav, note: 72, icon: "cowbell")
    }

    static var cowbellThree: AudioFileModel {
        return AudioFileModel(name: "Phonk/cowbell_3_F5", file: .wav, note: 77, icon: "cowbell")
    }

    static var shaker: AudioFileModel {
        return AudioFileModel(name: "Phonk/shaker_E5", file: .wav, note: 76, icon: "shaker")
    }

    static var snarePhonk: AudioFileModel {
        return AudioFileModel(name: "Phonk/snare_B6", file: .wav, note: 95, icon: "snare")
    }

}
