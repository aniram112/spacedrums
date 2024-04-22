import Foundation
import SwiftUI

struct SoundViewModel: Hashable {
    let file: AudioFileModel
    let volume: Int
    var isActive: Bool
    let pitch: Int
}

struct SoundView: View {
    @EnvironmentObject var router: Router

    typealias Strings = StringResources.Main.SoundView

    var model: SoundViewModel
    var muteButton: (SoundViewModel) -> Void
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(model.isActive ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
                .background(.white.opacity(0.3))
                .blendMode(model.isActive ? .plusLighter : .sourceAtop)
                .frame(width: 350, height: 120)
                .fixedSize()
                .cornerRadius(20)

            HStack(alignment: .center, spacing: 0) {

                pitchView

                Spacer(minLength: 20)
                VStack(alignment: .leading){
                    Text(getDisplayName(model.file.name))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(model.isActive ? .white : .gray)
                    Text(String(format: Strings.volume, model.volume))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(model.isActive ? .white : .gray)
                    HStack {
                        soundButton(text: Strings.change, action: { router.routeTo(.collection(sound: model)) })
                        soundButton(text: model.isActive ? Strings.mute : Strings.unmute, action: { muteButton(model) })
                    }

                }
            }.frame(width: 300, height: 120).fixedSize()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    var pitchView: some View {
        ZStack {
            Circle()
                .stroke(model.isActive ? .white : .gray, lineWidth: 3)
                .frame(width:90, height: 90)
                .foregroundColor(.clear)
            Text(String(format: Strings.circle, model.pitch))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(model.isActive ? .white : .gray)
        }
    }

    func soundButton(text: String, action: @escaping () -> Void) -> some View{
        return button(
            text: text,
            action: action,
            width: 100,
            height: 40,
            radius: 20,
            blendMode: model.isActive ? .plusLighter : .sourceAtop,
            background: .white.opacity(0.2),
            fontSize: 16
        )
    }
}

