import Foundation
import SwiftUI

struct SoundViewModel {
    let file: AudioFileModel
    let volume: Int
    let isActive: Bool
    let pitch: Double
}

struct SoundView: View {
    var model: SoundViewModel
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
                    Text("пупупу")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(model.isActive ? .white : .gray)
                    Text("volume: пупупу")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(model.isActive ? .white : .gray)
                    HStack {
                        soundButton(text: "Change", action: {})
                        soundButton(text: model.isActive ? "Mute": "Unmute", action: {})
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
            Text("440Hz")
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
            background: .white.opacity(0.2)
        )
    }

    func getDisplayName(_ name: String) -> String {
        return String(name.split(separator: "/").last ?? "file")
    }
}

