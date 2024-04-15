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


    init(mode: AddSoundMode, pitch: Int) {
        self.mode = mode
        self.pitch = pitch
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
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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

            //Text("\(pitch)Hz").modifier(regular()).padding(.bottom, 20)
            Text("Analyzing the pitсh...").modifier(regular())
        }.onAppear {
            listen()
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
                button(text: "Add", action: usePitch)
                button(text: "Try again", action: tryAgain)
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
            Text("\(pitch)Hz")
                .foregroundColor(.white)
                .font(.system(size: 80, weight: .semibold))

        }
    }

    func listen() {
        let detector = PitchDetector()
        detector.start()
        detector.startDetection { p in
            router.routeTo(.addSound(mode: .detected, pitch: p))
        }
    }

    func usePitch(){
        print("yeet \(pitch)")
        router.routeTo(.collection(sound: SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: pitch)))
    }

    func tryAgain(){
        //router.routeBack() // ui bag
        router.routeTo(.addSound(mode: .listening, pitch: pitch))
    }

    private let mode: AddSoundMode
    private let pitch: Int

}

struct regular: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .semibold))
    }
}

#Preview("listening"){
    AddSoundView(mode: .listening, pitch: 0)
}

#Preview("detected"){
    AddSoundView(mode: .detected, pitch: 0)
}

/*struct AddSoundView_Previews: PreviewProvider {
 static var previews: some View {
 AddSoundView(mode: .listening)
 AddSoundView(mode: .detected)
 }
 }*/
