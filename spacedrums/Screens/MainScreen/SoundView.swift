import Foundation
import SwiftUI
import Sliders

struct SoundViewModel: Hashable, Codable {
    let file: AudioFileModel
    var volume: Int
    var isActive: Bool
    let pitch: Int
}

struct SoundView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var soundSpace: SoundSpaceModel

    typealias Strings = StringResources.Main.SoundView

    var model: SoundViewModel
    var muteButton: (SoundViewModel) -> Void
    @State var sliderValue = 0.5
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(model.isActive ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
                .background(.white.opacity(0.3))
                .blendMode(model.isActive ? .plusLighter : .sourceAtop)
                .cornerRadius(20)
                .padding(.horizontal, 5)
                .frame(height: 130)
                //.fixedSize()

                .accessibilityLabel(model.isActive ? "active sound cell" : "disabled sound cell")

            HStack(alignment: .center, spacing: 0) {

                pitchView

                Spacer(minLength: 20)
                VStack(alignment: .leading, spacing: 10){
                    Text(getDisplayName(model.file.name))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(model.isActive ? .white : .gray)
                        .padding(.top, 5)
                    slider
                        .onAppear {
                        sliderValue = Double(model.volume)/100
                        }
                        .onChange(of: sliderValue) { newValue in
                            soundSpace.changeVolume(sound: model, Int(newValue*100))
                        }
                        .frame(height: 24)
                        //.padding(.bottom, 10)
                    //Text(String(format: Strings.volume, model.volume))
                       // .font(.system(size: 20, weight: .semibold))
                      //  .foregroundColor(model.isActive ? .white : .gray)
                    HStack {
                        soundButton(text: Strings.change, action: { router.routeTo(.collection(sound: model)) })
                        soundButton(text: model.isActive ? Strings.mute : Strings.unmute, action: { muteButton(model) })
                    }

                }
            }.padding(.horizontal, 20)
            //.frame(width: 300, height: 130).fixedSize()
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

    var slider: some View {
        ValueSlider(value: $sliderValue)
            .valueSliderStyle(
                HorizontalValueSliderStyle(
                    track:  HorizontalValueTrack(
                        view: Capsule()
                            .background(.gray.opacity(0.3))
                            .blendMode(.plusLighter)
                    )
                    .background(Capsule().foregroundColor(model.isActive ? Color.white.opacity(0.2) : Color.gray.opacity(0.2)))
                    .blendMode(.plusLighter)
                    .frame(height: 24),
                    thumb: Text("\(Int(sliderValue*100))")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold)),
                    //Circle().foregroundColor(.clear),
                    thumbSize: CGSize(width: 40, height: 24),
                    thumbInteractiveSize: CGSize(width: 80, height: 24),
                    options: .interactiveTrack
                )
            )
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
