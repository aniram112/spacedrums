import SwiftUI

struct SavedSpaceModel: Codable {
    var name: String
    var sources: [String]
    var date: String
}


struct SavedView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
    //var delegate: SpaceDelegate?

    var mock = [SavedSpaceModel(name: "mock", sources: ["a"], date: "13.12.1312"),
                SavedSpaceModel(name: "not mock", sources: ["a"], date: "13.12.1312"),
                SavedSpaceModel(name: "mock mock", sources: ["a"], date: "13.12.1312"),
                SavedSpaceModel(name: "mock", sources: ["a"], date: "13.12.1312"),
                SavedSpaceModel(name: "mock", sources: ["a"], date: "13.12.1312"),
                SavedSpaceModel(name: "mock", sources: ["a"], date: "13.12.1312")]

    var empty: [SavedSpaceModel] = []

    var body: some View {
        List{
            ForEach(mock, id: \.name) { item in
                record(model: item).padding(.bottom, 10).swipeActions(edge: .trailing) {
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
        .toolbarColorScheme(.dark, for: .navigationBar)
        //.toolbarBackground(.blendMode(.plusLighter), for: .navigationBar)

        //.background(Colors.backgroundFigma.ignoresSafeArea())
        //.navigationBarHidden(true)
    }

    func delete(item: SavedSpaceModel) {
        //SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        //SavedData.saveData()
    }

    func record(model: SavedSpaceModel) -> some View {
        return ZStack{
            Rectangle()
                .background(.white.opacity(0.3))
                .blendMode(.plusLighter)

                //.background(.white.opacity(0.15))
                //.blendMode(.plusLighter)

                .frame(width: 350, height: 90)
                .fixedSize()
                .cornerRadius(20)
            HStack(alignment: .center, spacing: 0){
                VStack(alignment: .leading){
                    Text(model.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text(model.date)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                }
                Spacer()
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width:50, height: 50)
                    .foregroundColor(.white)
                
            }.frame(width: 300, height: 80).fixedSize()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        //.background(NavigationLink("", destination: MainView()).opacity(0))
        .onTapGesture {
            openSpace(model.sources)

        }


    }

    private func openSpace(_ sources: [String]) {
        print("pupupu")
        router.routeTo(.main)
        //delegate?.setSpace(newSources: sources)
        //self.presentationMode.wrappedValue.dismiss()
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
