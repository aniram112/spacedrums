import SwiftUI
import AVFoundation

struct CollectionView: View {
    //let data = (1...100).map { "Item \($0)" }
    var data = (1...28).map { AudioFileModel(name: "\($0)", file: .mp3, icon: "mock") }
    @Environment(\.presentationMode) var presentationMode
    //@State var data = AudioFileModel.collection["Mock"]
    var categoriesArray = Array(AudioFileModel.collection.keys.sorted())
    let columns = [GridItem(.adaptive(minimum: 70))]
    var action: (_ file: AudioFileModel) -> Void = {file in }
    @State var selectedFile: AudioFileModel?
    /*@State var audioSource =  AudioSource(
        audio:  .kick,
        point: CGPoint(
            x: 0.5,
            y: 0.5
        )
    )*/

    var body: some View {
        VStack(spacing: 20){
            categories
                .padding(.top,40)
                .padding(.horizontal,20)
            grid
            HStack(alignment: .center, spacing: 40) {
                button(text: "Add", action: {addSound(file: selectedFile)})
                button(text: "Try", action: {playSound()})
            }
        }.background(ImageResources.background.resizable().scaledToFill().edgesIgnoringSafeArea(.all))
    }


    var categories: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20){
                ForEach(categoriesArray, id: \.self) { item in
                    category(name: item)
                }
            }
        }
    }

    func category(name: String) -> some View {
        return Text(name)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .onTapGesture {
                //self.data = AudioFileModel.collection[name]
            }
    }

    var grid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(data ?? [], id: \.self) { item in
                    CollectionCellView(file: item, selectedCell: self.$selectedFile)
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
        }
    }

    private func playSound() {
        /*guard let selectedFile else { return }
        self.audioSource = AudioSource(
            audio: selectedFile,
            point: CGPoint(
                x: 0.5,
                y: 0.5
            )
        )
        self.audioSource.runAudio()

        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            print("Timer fired!")
            self.audioSource.stopAudio()
        }*/

    }

    private func addSound(file: AudioFileModel?) {
        /*guard let file else {return}
        action(file)
        self.audioSource.stopAudio()
        self.presentationMode.wrappedValue.dismiss()*/
    }

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

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
