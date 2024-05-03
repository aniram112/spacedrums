import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
    @State private var showingAlert = false
    @State private var name = ""
    @StateObject var conductor = MainConductor()
    @State var inTrackerOn = true

    typealias Strings = StringResources.Main
    //var delegate: SpaceDelegate?

    var mock = [
        SoundViewModel(file: .kick, volume: 80, isActive: true, pitch: 440),
        SoundViewModel(file: .clap, volume: 70, isActive: false, pitch: 220),
    ]

    //@State var data: [SoundViewModel] = []

    @EnvironmentObject var soundSpace: SoundSpaceModel

    var body: some View {
        VStack {
            navbar
            if soundSpace.data.isEmpty {
                emptyView
                Spacer()
            } else {
                List{
                    ForEach(soundSpace.data, id: \.file.name) { item in
                        SoundView(model: item, muteButton: soundSpace.muteSound)
                            .padding(.bottom, 20)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    delete(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }.accessibilityElement(children: .contain)
                }
                .onChange(of: inTrackerOn) { newValue in
                    if newValue {
                        conductor.resume()
                    } else {
                        conductor.pause()
                    }
                }
                .onChange(of: soundSpace.data){ newValue in
                    conductor.loadSounds(models: soundSpace.data)
                }
                .onAppear {
                    if !soundSpace.data.isEmpty {
                        conductor.setup()
                        conductor.loadSounds(models: soundSpace.data)
                    }
                    SavedData.loadData()
                }
                .listStyle(.plain)
            }
        }
        //.background(Colors.backgroundGradient)
        .background(ImageResources.background.resizable().scaledToFill().ignoresSafeArea().accessibilityHidden(true))
        .navigationBarHidden(true)
        .navigationTitle("")
    }

    var navbar: some View {
        HStack {
            HStack(spacing: 20){
                Button(action: openSaved){
                    Text(Strings.open)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }//.frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { showingAlert.toggle() }){
                    Text(Strings.save)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }.alert(Strings.Alert.title, isPresented: $showingAlert) {
                    TextField(Strings.Alert.placeholder, text: $name).foregroundColor(.white)
                    Button(Strings.Alert.save, action: saveSpace)
                    Button(Strings.Alert.cancel, role: .cancel) { }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            Button(action: addSound){
                Text("+")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, alignment: .trailing)

        }.padding(.horizontal,20)

    }

    var emptyView: some View {
        button(
            text: Strings.start,
            action: addSound,
            width: 240,
            height: 110,
            radius: 30,
            fontSize: 40
        )
        .padding(.top, 300)
    }

    func addSound() {
        inTrackerOn = false
        router.routeTo(.addSound(mode: .listening, pitch: 0))
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            router.routeTo(.addSound(mode: .detected))
        }*/
    }

    func openSaved(){
        inTrackerOn = false
        router.routeTo(.saved)
    }

    func saveSpace(){
        let mytime = Date()
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .short
        format.dateFormat = "dd.MM.yyyy HH:mm"
        let newModel = SavedSpaceModel(name: name, sources: soundSpace.data, date: format.string(from: mytime))
        SavedData.shared.spaces.append(newModel)
        SavedData.saveData()
    }

    func delete(item: SoundViewModel) {
        soundSpace.data.removeAll(where: {$0.pitch == item.pitch})
        conductor.loadSounds(models: soundSpace.data)
        print("deleted")
        print(soundSpace.data.count)
        //SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        //SavedData.saveData()
    }
}
#Preview {
    MainView()
}
