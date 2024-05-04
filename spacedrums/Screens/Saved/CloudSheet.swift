import Foundation
import SwiftUI
import Firebase

enum LoginState {
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
    @State private var errorLabel = " "

    var body: some View {
        ZStack {
            ImageResources.sheet
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .accessibilityHidden(true)
            switch mode {
            case .login:
                VStack(spacing: 5) {
                    loginTextFields
                    Text(errorLabel)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.top, 10)
                    loginButtons
                        .padding(.top, 80)
                }
            case .save:
                save
            }
        }
        .onAppear(perform: {
            Auth.auth().addStateDidChangeListener{ auth, user in
                if user != nil {
                    mode = .save
                    sheetDetent = SheetFraction.compact
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
                    action: saveDataToFirebase
                )
                button(
                    text: "Load",
                    action: fetchDataFromFirebase
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
}

extension CloudSheet {
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                if let error = error as NSError? {
                    if let errorCode = error.userInfo["FIRAuthErrorUserInfoNameKey"] as? String {
                        if errorCode == "ERROR_INVALID_EMAIL" {
                            errorLabel = "Invalid email"
                        } else if errorCode == "ERROR_USER_NOT_FOUND" {
                            errorLabel = "User not found"
                        } else if errorCode == "ERROR_WRONG_PASSWORD" {
                            errorLabel = "Wrong password"
                        } else if errorCode == "ERROR_TOO_MANY_REQUESTS" {
                            errorLabel = "Too many requests"
                        } else {
                            errorLabel = "Undefined error"
                        }
                    }
                } else {
                    errorLabel = "Undefined error"
                }
            } else {
                errorLabel = " "
                mode = .save
                sheetDetent = SheetFraction.compact
            }
        }
    }

    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                if let error = error as NSError? {
                    if let errorCode = error.userInfo["FIRAuthErrorUserInfoNameKey"] as? String {
                        if errorCode == "ERROR_INVALID_EMAIL" {
                            errorLabel = "Invalid email"
                        } else if errorCode == "ERROR_EMAIL_ALREADY_IN_USE" {
                            errorLabel = "Email is already in use"
                        } else if errorCode == "ERROR_WEAK_PASSWORD" {
                            errorLabel = "Weak password"
                        } else if errorCode == "ERROR_TOO_MANY_REQUESTS" {
                            errorLabel = "Too many requests"
                        } else {
                            errorLabel = "Undefined error"
                        }
                    }
                } else {
                    errorLabel = "Undefined error"
                }
            } else {
                errorLabel = " "
                mode = .save
                sheetDetent = SheetFraction.compact
            }
        }
    }

    func logout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func fetchDataFromFirebase() {
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
                    let model = SavedData.parseData(data)
                    savedSpaces.append(model)
                }
                SavedData.shared.spaces = savedSpaces
                SavedData.saveData()
                dismiss()
            }
        }
    }

    func saveDataToFirebase() {
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
                    document.reference.delete()
                }
            }

            for space in SavedData.shared.spaces {
                let data = SavedData.encodeData(space)
                docRef.addDocument(data: data)
            }
        }
    }

}
