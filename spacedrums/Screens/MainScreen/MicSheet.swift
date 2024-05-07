import SwiftUI
import AVFAudio
import AudioKit

struct MicSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var microphone : Device

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
                Text(microphone.deviceID)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .regular))
                InputDevicePicker(device: $microphone)
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents(
            [.fraction(0.7)]
        )
    }
}

struct InputDevicePicker: View {
    @Binding var device: Device

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
        } catch let err {
            print(device.deviceID)
            print(err)
        }
    }
}
