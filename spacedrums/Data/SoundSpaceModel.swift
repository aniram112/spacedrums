import Foundation
import Combine

class SoundSpaceModel: ObservableObject {
    @Published var data: [SoundViewModel] = [
        SoundViewModel(file: .hiTom, volume: 50, isActive: true, pitch: 100),
        SoundViewModel(file: .midTom, volume: 100, isActive: true, pitch: 2000)
    ]

    func addSound(sound: SoundViewModel) {
        if let row = data.firstIndex(where: {$0.pitch == sound.pitch}) {
            data[row] = sound
        } else {
           data.append(sound)
        }
    }

    func muteSound(sound: SoundViewModel) {
        guard let ind = data.firstIndex(of: sound) else { return }
        data[ind].isActive.toggle()
    }

    func changeVolume(sound: SoundViewModel, _ value: Int) {
        guard let ind = data.firstIndex(of: sound) else { return }
        data[ind].volume = value
    }
}
