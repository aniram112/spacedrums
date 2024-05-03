import Sliders
import SwiftUI

struct Sliders: View {
    @State var value = 0.5

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(.white.opacity(0.3))
                .blendMode(.plusLighter)
                .frame(width: 350, height: 120)
                .fixedSize()
                .cornerRadius(20)
            ValueSlider(value: $value)
                .valueSliderStyle(
                    HorizontalValueSliderStyle(
                        track:  HorizontalValueTrack(
                            view: Capsule()
                                .background(.gray.opacity(0.3))
                                .blendMode(.plusLighter)
                        )
                        .background(Capsule().foregroundColor(Color.white.opacity(0.2)))
                        .blendMode(.plusLighter)
                        .frame(height: 30),

                        thumb: Text("\(Int(value*100))")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold)),
                        //Circle().foregroundColor(.clear),
                        thumbSize: CGSize(width: 80, height: 30),
                        thumbInteractiveSize: CGSize(width: 100, height: 40),
                        options: .interactiveTrack
                    )
                )
                .padding(.horizontal,30)
        }.background(ImageResources.background.resizable().scaledToFill())
    }
}

#Preview {
    Sliders()
}
