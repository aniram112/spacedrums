import Foundation
import SwiftUI
import Lottie

enum AddSoundMode {
    case listening
    case detected
}

struct AddSoundView: View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss

    init(mode: AddSoundMode) {
        self.mode = mode
    }
    //@Environment(\.presentationMode) var presentationMode =

    var body: some View {
        ZStack(alignment: .top) {
            ImageResources.background
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            switch mode {
            case .listening:
                listening.padding(.top, 130)
            case .detected:
                detected.padding(.top, 130)
            }
        }.navigationTitle("")
    }

    var listening: some View {
        VStack {
            Text("Play the sound a few times")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .semibold))
                .multilineTextAlignment(.center)
            LottieView(animation: LottieAnimation.named("sound-wave"))
            .looping()
            //.opacity(0.3)
            //.blendMode(.plusLighter)



            Text(pitch).modifier(regular()).padding(.bottom, 20)
            Text("Analyzing the pitсh...").modifier(regular())
        }
    }

    var detected: some View {
        VStack {
            Text("Found frequency")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .semibold))
                .padding(.bottom, 80)
            frequency.padding(.bottom, 80)
            Text("Use it?").foregroundColor(.white).modifier(regular()).padding(.bottom, 50)
            HStack(alignment: .center, spacing: 40) {
                button(text: "Add", action: {router.routeTo(.main)})
                button(text: "Try again", action: {dismiss()})
            }

        }

    }

    var frequency: some View {
        ZStack {
            Rectangle()
                .background(.white.opacity(0.3))
                .blendMode(.plusLighter)
                .frame(width: 350, height: 160)
                .fixedSize()
                .cornerRadius(20)
            Text(pitch)
                .foregroundColor(.white)
                .font(.system(size: 80, weight: .semibold))

        }
    }

    private let mode: AddSoundMode
    private let pitch: String = "440Hz"

}

struct regular: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .semibold))
    }
}

#Preview("listening"){
    AddSoundView(mode: .listening)
}

#Preview("detected"){
    AddSoundView(mode: .detected)
}

/*struct AddSoundView_Previews: PreviewProvider {
    static var previews: some View {
        AddSoundView(mode: .listening)
        AddSoundView(mode: .detected)
    }
}*/
