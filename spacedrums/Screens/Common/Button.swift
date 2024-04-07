import Foundation
import SwiftUI

func button
(
    text: String,
    action: @escaping () -> Void,
    width: CGFloat = 120,
    height: CGFloat = 55,
    radius: CGFloat = 15,
    blendMode: BlendMode = .plusLighter,
    background: Color = .white.opacity(0.3)
) -> some View {
    return Button(action: action){
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.system(size: 20, weight: .bold))

        }.frame(width: width, height: height)
            .background(background)
            .blendMode(blendMode)
            .cornerRadius(radius)
            .foregroundColor(.white)

    }
    .buttonStyle(ScaleButtonStyle())
}

func navigationButton
(
    text: String,
    destination: some View,
    width: CGFloat = 120,
    height: CGFloat = 55,
    radius: CGFloat = 15,
    blendMode: BlendMode = .plusLighter,
    background: Color = .white.opacity(0.3)
) -> some View {
    return NavigationButton(
        action: {},
        destination: {destination},
        label: { HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.system(size: 20, weight: .bold))

        }.frame(width: width, height: height)
                .background(background)
                .blendMode(blendMode)
                .cornerRadius(radius)
                .foregroundColor(.white)
                .background(NavigationLink("", destination: destination).opacity(0))
                .buttonStyle(ScaleButtonStyle())
        }
    )

    /* return HStack(alignment: .center, spacing: 10) {
     Text(text)
     .font(.system(size: 20, weight: .bold))

     }.frame(width: width, height: height)
     .background(background)
     .blendMode(blendMode)
     .cornerRadius(radius)
     .foregroundColor(.white)
     .background(NavigationLink("", destination: destination).opacity(0))
     .buttonStyle(ScaleButtonStyle())*/
}


struct NavigationButton<Destination: View, Label: View>: View {
    var action: () -> Void = { }
    var destination: () -> Destination
    var label: () -> Label

    @State private var isActive: Bool = false

    var body: some View {
        Button(action: {
            self.action()
            self.isActive.toggle()
        }) {
            self.label()
            //.background(
            /*ScrollView { // Fixes a bug where the navigation bar may become hidden on the pushed view
             NavigationDestination(isPresented: self.$isActive, destination:  self.destination())
             NavigationLink(destination: LazyDestination { self.destination() },
             isActive: self.$isActive) { EmptyView() }
             }*/
            //)
        }
        .navigationDestination(isPresented: self.$isActive, destination:  destination)
    }
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}
