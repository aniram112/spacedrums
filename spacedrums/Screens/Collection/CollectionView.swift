import SwiftUI
import AVFoundation

struct CollectionView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var soundSpace: SoundSpaceModel

    @State var data = AudioFileModel.collection["Drums"]
    @State var selectedFile: AudioFileModel?
    
    let categoriesArray = Array(AudioFileModel.collection.keys.sorted())
    let columns = [GridItem(.adaptive(minimum: 70))]
    let currentSound: SoundViewModel

    var player = CollectionViewPlayer()

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
            //player.start()
            player.setup()
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
        guard let file else {return}
        let newSound = SoundViewModel(
            file: file,
            volume: currentSound.volume,
            isActive: currentSound.isActive,
            pitch: currentSound.pitch
        )
        soundSpace.addSound(sound: newSound)
        router.routeTo(.main)

        /*action(file)
        self.audioSource.stopAudio()
        self.presentationMode.wrappedValue.dismiss()*/
    }

}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(currentSound: SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440))
    }
}
