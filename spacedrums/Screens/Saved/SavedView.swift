import SwiftUI

struct SavedSpaceModel: Codable {
    var name: String
    var sources: [SoundViewModel]
    var date: String
}

// TODO: Accessibility
struct SavedView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
    @EnvironmentObject var soundSpace: SoundSpaceModel

    @State var shouldPresentSheet = false
    @State var loginMode: LoginState = .unauthorized

    var body: some View {
        VStack(spacing: 20) {
            navbar
            if SavedData.shared.spaces.isEmpty {
                emptyView
                Spacer().frame(maxWidth: .infinity)
            } else {
                List{
                    ForEach(SavedData.shared.spaces, id: \.name) { item in
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
            }
        }
        .animation(.easeIn(duration: 0.1), value: SavedData.shared.spaces.count)
        .sheet(isPresented: $shouldPresentSheet) {
            CloudSheet(mode: $loginMode.animation())
        }
        .background(ImageResources.background.resizable().scaledToFill().edgesIgnoringSafeArea(.all).accessibilityHidden(true))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    var navbar: some View {
        HStack {
            Button(action: openCloudStorage){
                Image(systemName: "cloud.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, alignment: .trailing)

        }.padding(.horizontal,20)

    }

    var emptyView: some View {
        button(
            text: StringResources.Main.start,
            action: start,
            width: 240,
            height: 110,
            radius: 30,
            fontSize: 40
        )
        .padding(.top, 300)
    }

    var loginSheet: some View {
        VStack(spacing: 30) {
            button(
                text: "Login",
                action: {},
                width: 180,
                height: 82,
                radius: 22,
                fontSize: 30
            )
            button(
                text: "Sign up",
                action: {},
                width: 180,
                height: 82,
                radius: 22,
                fontSize: 30
            )

        }

    }

    func openCloudStorage(){
        shouldPresentSheet.toggle()
        loginMode = .unauthorized
    }

    func delete(item: SavedSpaceModel) {
        SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        SavedData.saveData()
    }

    func record(model: SavedSpaceModel) -> some View {
        return ZStack{
            Rectangle()
                .background(.white.opacity(0.3))
                .blendMode(.plusLighter)
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
        .onTapGesture {
            openSpace(model.sources)

        }


    }

    private func start(){
        router.routeTo(.addSound(mode: .listening, pitch: 0))
    }

    private func openSpace(_ sources: [SoundViewModel]) {
        print("pupupu")
        soundSpace.data = sources
        router.routeTo(.main)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
