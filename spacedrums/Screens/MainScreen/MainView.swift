import Foundation
import SwiftUI
import AudioKit

struct MainView: View {
    @Environment(\.isPresented) var isPresented
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var router: Router
    @EnvironmentObject var micSettings: MicSettings
    @EnvironmentObject var soundSpace: SoundSpaceModel

    @State private var showingAlert = false
    @State var shouldPresentSheet = false
    @State private var name = ""

    @StateObject var conductor = MainConductor()

    typealias Strings = StringResources.Main

    var mock = [
        SoundViewModel(file: .kick, volume: 80, isActive: true, pitch: 440),
        SoundViewModel(file: .clap, volume: 70, isActive: false, pitch: 220),
    ]

    //@State var data: [SoundViewModel] = []

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
                .onChange(of: soundSpace.data){ newValue in
                    conductor.loadSounds(models: soundSpace.data)
                }
                .listStyle(.plain)
            }
        }
        .onFirstAppear {
            print("main view on first appear")
            conductor.setup()
            conductor.pause()
            conductor.resume()
            micSettings.setNewMic(device: conductor.initialDevice)
            SavedData.loadData()
        }
        .onAppear {
            print("main view on appear")
            if !soundSpace.data.isEmpty {
                conductor.loadSounds(models: soundSpace.data)
                micSettings.setNewMic(device: micSettings.getInitialMic())
                conductor.resume()
            }
        }
        .onDisappear {
            print("main view on dissapear")
            conductor.pause()
        }
        .sheet(isPresented: $shouldPresentSheet) {
            MicSheet()
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
                }
                Button(action: { showingAlert.toggle() }){
                    Text(Strings.save)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .fixedSize()
                }.alert(Strings.Alert.title, isPresented: $showingAlert) {
                    TextField(Strings.Alert.placeholder, text: $name)
                        .foregroundColor(Color(red: 0.03, green: 0.4, blue: 0.38))
                    Button(Strings.Alert.save, action: saveSpace)
                    Button(Strings.Alert.cancel, role: .cancel) { }
                }
                    Button(action: openMicSettings){
                        Image(systemName: "mic.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .fixedSize()
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
        router.routeTo(.addSound(mode: .listening, pitch: 0))
    }

    func openSaved(){
        router.routeTo(.saved)
    }

    func openMicSettings(){
        shouldPresentSheet.toggle()
        //стопить звук?
    }


    func saveSpace(){
        let mytime = Date()
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .short
        format.dateFormat = "dd.MM.yyyy HH:mm"
        let count = SavedData.shared.spaces.filter { $0.name.hasPrefix(name)}.count
        if count > 0 {
            name = name + String(count)
        }
        let newModel = SavedSpaceModel(name: name, sources: soundSpace.data, date: format.string(from: mytime))
        SavedData.shared.spaces.append(newModel)
        SavedData.saveData()
    }

    func delete(item: SoundViewModel) {
        soundSpace.data.removeAll(where: {$0.pitch == item.pitch})
        conductor.loadSounds(models: soundSpace.data)
    }
}
#Preview {
    MainView()
}


public struct OnFirstAppearModifier: ViewModifier {

    private let onFirstAppearAction: () -> ()
    @State private var hasAppeared = false

    public init(_ onFirstAppearAction: @escaping () -> ()) {
        self.onFirstAppearAction = onFirstAppearAction
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                onFirstAppearAction()
            }
    }
}

extension View {
    func onFirstAppear(_ onFirstAppearAction: @escaping () -> () ) -> some View {
        return modifier(OnFirstAppearModifier(onFirstAppearAction))
    }
}
