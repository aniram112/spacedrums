import SwiftUI
import AVFoundation

struct CollectionView: View {
    //@Environment(\.presentationMode) var presentationMode

    @State var data = AudioFileModel.collection["Drums"]
    @State var selectedFile: AudioFileModel?
    let categoriesArray = Array(AudioFileModel.collection.keys.sorted())
    let columns = [GridItem(.adaptive(minimum: 70))]
    //let action: (_ file: AudioFileModel) -> Void = {file in }

    @StateObject var player = CollectionViewPlayer()

    var body: some View {
        VStack(spacing: 20){
            categories
                //.padding(.top,40)
                .padding(.horizontal,20)
            grid
            HStack(alignment: .center, spacing: 40) {
                button(text: "Add", action: {addSound(file: selectedFile)})
                button(text: "Try", action: {playSound()})
            }
        }
        .background(ImageResources.background.resizable().scaledToFill().edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            player.start()
        }
        .onDisappear {
            player.stop()
        }
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
                self.data = AudioFileModel.collection[name]
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
        guard let selectedFile else { return }
        player.play(file: selectedFile)
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
