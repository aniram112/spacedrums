import SwiftUI
import AVFAudio
import AudioKit

class MicSettings: ObservableObject {
    @Published var microphone: Device = .init(name: "no device", deviceID: "0")

    func setNewMic(device: Device?) {
        if let device {
            microphone = device
        }
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
                Text("Microphone")
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
        do {
            try AudioEngine.setInputDevice(device)
            micSettings.setNewMic(device: device)
        } catch let err {
            print(device.deviceID)
            print(err)
        }
    }
}
