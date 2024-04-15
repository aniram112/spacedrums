import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
    @State private var showingAlert = false
    @State private var name = ""
    var conductor = MainConductor()
    @State var inTrackerOn = true

    //var delegate: SpaceDelegate?

    /*var mock = [
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock2, volume: 80, isActive: false, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0),
        SoundViewModel(file: .mock, volume: 80, isActive: true, pitch: 440.0)
    ]*/

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
                .onAppear {
                    if !soundSpace.data.isEmpty {
                        conductor.setup()
                        conductor.loadSounds(models: soundSpace.data)
                        //conductor.resume()
                        //print("yview appeared")
                    }
                }
                .onDisappear {
                    //conductor.pause()
                    //print("yview disappeared")
                }
                .listStyle(.plain)
            }
        }
        //.background(Colors.backgroundGradient)
        .background(ImageResources.background.resizable().scaledToFill().ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationTitle("")
    }

    var navbar: some View {
        HStack {
            HStack(spacing: 20){
                Button(action: saveSpace){
                    Text("Open")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }//.frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { showingAlert.toggle() }){
                    Text("Save")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }.alert("Enter space name", isPresented: $showingAlert) {
                    TextField("New space", text: $name)
                    Button("Save", action: {})
                    Button("Cancel", role: .cancel) { }
                }

                Toggle(isOn: $inTrackerOn, label: {
                    Text("isOn")
                })
                .padding(.horizontal)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .onChange(of: inTrackerOn) { newValue in
                    if newValue {
                        conductor.resume()
                    } else {
                        conductor.pause()
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            Button(action: addSound){
                Text("+")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, alignment: .trailing)

        }.padding(.horizontal,20)

    }

    // TODO
    var emptyView: some View {
        button(
            text: "Start",
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

    func saveSpace(){
        inTrackerOn = false
        router.routeTo(.saved)

    }

    func delete(item: SoundViewModel) {
        //SavedData.shared.spaces.removeAll(where: {$0.name == item.name})
        //SavedData.saveData()
    }
}
#Preview {
    MainView()
}
