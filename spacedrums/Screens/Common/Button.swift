import Foundation
import SwiftUI

func button
(
    text: String,
    action: @escaping () -> Void,
    width: CGFloat = 120,
    height: CGFloat = 55,
    radius: CGFloat = 15,
    blendMode: BlendMode = .plusLighter,
    background: Color = .white.opacity(0.3),
    fontSize: CGFloat = 20
) -> some View {
    return Button(action: action){
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.system(size: fontSize, weight: .bold))

        }.frame(width: width, height: height)
            .background(background)
            .blendMode(blendMode)
            .cornerRadius(radius)
            .foregroundColor(.white)

    }
    .buttonStyle(ScaleButtonStyle())
    .accessibilityLabel(text)
    .accessibilityAddTraits(.isButton)

}

struct ScaleButtonStyle: ButtonStyle {

    public init(scaleEffect: CGFloat = 0.96, duration: Double = 0.15) {
        self.scaleEffect = scaleEffect
        self.duration = duration
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }

    private let scaleEffect: CGFloat
    private let duration: Double
}
