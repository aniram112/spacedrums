import Foundation
import SwiftUI

struct MainView:  View {
    @Environment(\.presentationMode) var presentationMode
    //var delegate: SpaceDelegate?

    var mock = [
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock2, volume: 80, isActive: false, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0)
    ]

    //var empty: [SavedSpaceModel] = []

    var body: some View {
        List{
            ForEach(mock, id: \.file.name) { item in
                SoundView(model: item)
                    .padding(.bottom, 20)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            delete(item: item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        //.background(Colors.backgroundFigma.ignoresSafeArea())
        .background(ImageResources.background.resizable().scaledToFill().ignoresSafeArea())
        //.background(Colors.backgroundFigma.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    func delete(item: SoundViewModel) {
        //SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        //SavedData.saveData()
    }
}
#Preview {
    MainView()
}
