import Foundation
import SwiftUI
import Firebase

enum LoginState {
    case unauthorized
    case login
    case save
}

enum SheetFraction {
    static let compact: PresentationDetent = .fraction(0.3)
    static let full: PresentationDetent = .fraction(0.9)
}

struct CloudSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var mode: LoginState
    @State private var sheetDetent: PresentationDetent = SheetFraction.compact
    @State private var email = ""
    @State private var password = ""
    @State var loggedIn = false
    @State var userId: String? = nil

    var body: some View {
        ZStack {
            ImageResources.background
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .accessibilityHidden(true)
            switch mode {
            case .unauthorized:
                unauthorized
            case .login:
                VStack {
                    loginTextFields
                    loginButtons
                        .padding(.top, 80)
                }
            case .save:
                save
            }
        }.onAppear(perform: {
            Auth.auth().addStateDidChangeListener{ auth, user in
                if user != nil {
                    mode = .save
                    userId = user?.uid ?? nil
                    sheetDetent = SheetFraction.compact
                    loggedIn.toggle()
                } else {
                    mode = .login
                    sheetDetent = SheetFraction.full
                }
            }
        })
        .presentationDragIndicator(.visible)
        .presentationDetents(
            [SheetFraction.compact, SheetFraction.full], selection: $sheetDetent
        )
    }

    // юзлесс?
    var unauthorized: some View {
        VStack(spacing: 30) {
            button(
                text: "Login",
                action: {
                    mode = .login
                    sheetDetent = SheetFraction.full
                },
                width: 180,
                height: 82,
                radius: 22,
                fontSize: 30
            )
        }
    }

    var loginTextFields: some View {
        VStack(spacing: 10) {
            TextField("Email", text: $email)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .textFieldStyle(.plain)
                .padding(.top, 20)
                .textInputAutocapitalization(.never)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 350, height: 1)
                .padding(.bottom, 10)
            SecureField("Password", text: $password)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.never)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 350, height: 1)
                .padding(.bottom, 10)
        }
        .padding(.horizontal,10)
        .background(Color.white.opacity(0.3))
        .blendMode(.plusLighter)
        .cornerRadius(10)
        .padding(.horizontal,40)
    }

    var loginButtons: some View {
        HStack(spacing: 30) {
            button(
                text: "Login",
                action: login
            )
            button(
                text: "Sign up",
                action: register
            )

        }.padding(.horizontal,40)
    }

    var save: some View {
        VStack(spacing: 60) {
            HStack(spacing: 30) {
                button(
                    text: "Save",
                    action: {}
                )
                button(
                    text: "Load",
                    action: fetchData
                )

            }.padding(.top, 40)
            button(
                text: "Logout",
                action: logout,
                background: .clear,
                fontSize: 16
            )
        }
    }

    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error ?? "error")
                // показать ошибку
            } else {
                mode = .save
                sheetDetent = SheetFraction.compact
            }
        }
    }

    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error ?? "error")
                // показать ошибку
            }
        }
    }

    func logout(){
        do {
            try Auth.auth().signOut()
            loggedIn.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func fetchData() {
        var savedSpaces = [SavedSpaceModel]()
        let id = Auth.auth().currentUser?.uid ?? ""
         let docRef = Firestore.firestore()
             .collection("spaces")
             .document(id)
             .collection("savedspaces")

        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error ?? "error")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let model = parseData(data)
                    savedSpaces.append(model)
                }
                SavedData.shared.spaces = savedSpaces
                dismiss()

            }
        }
     }

    func parseData(_ data: [String: Any]) -> SavedSpaceModel{
        let name = data["name"] as? String ?? ""
        let date = data["date"] as? String ?? ""
        let sources = data["sources"] as? [[String: Any]] ?? [[:]]
        var models = [SoundViewModel]()
        for source in sources {
            let volume = source["volume"] as? Int ?? 0
            let pitch = source["pitch"] as? Int ?? 0
            let isActive = source["isActive"] as? Int ?? 0
            let file = getFile(source["file"] as? String ?? "")
            let model = SoundViewModel(file: file, volume: volume, isActive: isActive == 1, pitch: pitch)
            models.append(model)
        }
        return SavedSpaceModel(name: name, sources: models, date: date)
    }

}
