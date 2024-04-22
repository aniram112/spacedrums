import Foundation
import Combine

class SoundSpaceModel: ObservableObject {
    @Published var data: [SoundViewModel] = []

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
}
