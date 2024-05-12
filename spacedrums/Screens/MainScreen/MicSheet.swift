import SwiftUI
import AVFAudio
import AudioKit

class MicSettings: ObservableObject {
    @Published var microphone: Device = AudioEngine.inputDevices[0]
    @Published var alreadySet = false

    func setNewMic(device: Device?) {
        print("setNewMic \(device?.deviceID)")
        if let device {
            microphone = device
            do {
                try AudioEngine.setInputDevice(device)
            } catch let err {
                print(device.deviceID)
                print(err)
            }
        }
        alreadySet = true
    }

    func getInitialMic() -> Device? {
        print("alreadySet \(alreadySet)")
        if alreadySet {  return microphone }
        let session = AVAudioSession.sharedInstance()
        if let portDescription = session.preferredInput ?? session.currentRoute.inputs.first {
            return Device(portDescription: portDescription)
        }
        return nil
    }
}

struct MicSheet: View {
    @EnvironmentObject var micSettings: MicSettings

    var body: some View {
        ZStack{
            ImageResources.sheet
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .accessibilityHidden(true)

            VStack(spacing: 20) {
                Text(StringResources.Main.microphone)
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .semibold))
                Text(micSettings.microphone.deviceID)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .regular))
                InputDevicePicker(device: micSettings.microphone)
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents(
            [.fraction(0.7)]
        )
    }
}

struct InputDevicePicker: View {
    @State var device: Device
    @EnvironmentObject var micSettings: MicSettings

    var body: some View {
        Picker("Input: \(device.deviceID)", selection: $device) {
            ForEach(getDevices(), id: \.self) {
                Text($0.deviceID)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
        }
        .pickerStyle(.inline)
        .onChange(of: device, perform: setInputDevice)
    }

    func getDevices() -> [Device] {
        AudioEngine.inputDevices.compactMap { $0 }
    }

    func setInputDevice(to device: Device) {
        micSettings.setNewMic(device: device)
        /*do {
            try AudioEngine.setInputDevice(device)
            micSettings.setNewMic(device: device)
        } catch let err {
            print(device.deviceID)
            print(err)
        }*/
    }
}
