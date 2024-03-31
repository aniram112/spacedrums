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
    background: Color = .white.opacity(0.3)
) -> some View {
    return Button(action: action){
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.system(size: 20, weight: .bold))

        }.frame(width: width, height: height)
            .background(background)
            .blendMode(blendMode)
            .cornerRadius(radius)
            .foregroundColor(.white)

    }
    .buttonStyle(ScaleButtonStyle())
}
