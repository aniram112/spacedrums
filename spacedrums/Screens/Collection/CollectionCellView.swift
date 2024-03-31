import Foundation
import SwiftUI

struct CollectionCellView: View {
    var file: AudioFileModel
    @Binding var selectedCell: AudioFileModel?
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    //.foregroundColor(selectedCell == file ? .red : .blue)
                    .background(.white.opacity(0.3))
                    .blendMode(.plusLighter)
                    .frame(width: 60, height: 60)
                    .fixedSize()
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(selectedCell == file ? .white : .clear, lineWidth: 3)
                        )
                Image(file.icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)

            }
            Text(getDisplayName(file.name)).font(.system(size: 11)).foregroundColor(.white)
        }.onTapGesture {
            selectedCell = file
        }
    }

    func getDisplayName(_ name: String) -> String {
        return String(name.split(separator: "/").last ?? "file")
    }
}
