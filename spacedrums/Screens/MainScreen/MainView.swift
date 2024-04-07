import Foundation
import SwiftUI

struct MainView:  View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
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
            VStack {
                navbar
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
            }
            .background(ImageResources.background.resizable().scaledToFill().ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationTitle("")
    }

    var navbar: some View{
        HStack {
            HStack(spacing: 20){
                Button(action: { router.routeTo(.saved) }){
                    Text("Open")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }//.frame(maxWidth: .infinity, alignment: .leading)
                Text("Save")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize()
                    //.frame(maxWidth: .infinity, alignment: .center)
               // button(text: "Save", action: {}).frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {router.routeTo(.addSound)}){
                Text("+")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, alignment: .trailing)

        }.padding(.horizontal,20)

    }

    func delete(item: SoundViewModel) {
        //SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        //SavedData.saveData()
    }
}
#Preview {
    MainView()
}
