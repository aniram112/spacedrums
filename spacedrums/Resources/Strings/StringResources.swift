//
//  StringResources.swift
//  spacedrums
//
//  Created by Marina Roshchupkina on 20.04.2024.
//

import Foundation
enum StringResources {
    enum Main {
        static let start = NSLocalizedString(
            "Main.start",
            comment: "Start button"
        )

        static let open = NSLocalizedString(
            "Main.open",
            comment: "Open button"
        )

        static let save = NSLocalizedString(
            "Main.save",
            comment: "Save button"
        )

        enum Alert {

            static let title = NSLocalizedString(
                "Main.Alert.title",
                comment: "Alert text"
            )

            static let placeholder = NSLocalizedString(
                "Main.Alert.placeholder",
                comment: "Alert placeholder"
            )

            static let save = NSLocalizedString(
                "Main.Alert.save",
                comment: "Alert button"
            )

            static let cancel = NSLocalizedString(
                "Main.Alert.cancel",
                comment: "Alert button"
            )

        }

        enum SoundView {
            static let mute = NSLocalizedString(
                "Main.SoundView.mute",
                comment: "SoundView button"
            )

            static let unmute = NSLocalizedString(
                "Main.SoundView.unmute",
                comment: "SoundView button"
            )

            static let change = NSLocalizedString(
                "Main.SoundView.change",
                comment: "SoundView button"
            )

            static let volume = NSLocalizedString(
                "Main.SoundView.volume",
                comment: "SoundView button"
            )

            static let circle = NSLocalizedString(
                "Main.SoundView.circle",
                comment: "SoundView button"
            )

        }
    }
    enum Collection {
        static let add = NSLocalizedString(
            "Collection.add",
            comment: "Collection button"
        )

        static let trySound = NSLocalizedString(
            "Collection.trySound",
            comment: "Collection button"
        )
    }

    enum AddSound {
        enum Listening {
            static let topText = NSLocalizedString(
                "AddSound.Listening.topText",
                comment: "AddSound text"
            )

            static let bottomText = NSLocalizedString(
                "AddSound.Listening.bottomText",
                comment: "AddSound text"
            )
        }

        enum Detected {
            static let topText = NSLocalizedString(
                "AddSound.Detected.topText",
                comment: "AddSound text"
            )

            static let frequency = NSLocalizedString(
                "AddSound.Detected.frequency",
                comment: "AddSound button"
            )

            static let bottomText = NSLocalizedString(
                "AddSound.Detected.bottomText",
                comment: "AddSound text"
            )

            static let add = NSLocalizedString(
                "AddSound.Detected.add",
                comment: "AddSound button"
            )

            static let again = NSLocalizedString(
                "AddSound.Detected.again",
                comment: "AddSound button"
            )
        }

    }

    enum CloudSheet {
        enum Errors {
            static let undefined = NSLocalizedString(
                "CloudSheet.Errors.undefined",
                comment: "CloudSheet error text"
            )
            
            static let invalidEmail = NSLocalizedString(
                "CloudSheet.Errors.invalidEmail",
                comment: "CloudSheet error text"
            )

            static let notFound = NSLocalizedString(
                "CloudSheet.Errors.notFound",
                comment: "CloudSheet error text"
            )

            static let wrongPassword = NSLocalizedString(
                "CloudSheet.Errors.wrongPassword",
                comment: "CloudSheet error text"
            )

            static let tooMany = NSLocalizedString(
                "CloudSheet.Errors.tooMany",
                comment: "CloudSheet error text"
            )

            static let alreadyInUse = NSLocalizedString(
                "CloudSheet.Errors.alreadyInUse",
                comment: "CloudSheet error text"
            )

            static let weakPassword = NSLocalizedString(
                "CloudSheet.Errors.weakPassword",
                comment: "CloudSheet error text"
            )
        }

        static let login = NSLocalizedString(
            "CloudSheet.login",
            comment: "CloudSheet button"
        )

        static let signUp = NSLocalizedString(
            "CloudSheet.signUp",
            comment: "CloudSheet button"
        )

        static let logout = NSLocalizedString(
            "CloudSheet.logout",
            comment: "CloudSheet button"
        )

        static let load = NSLocalizedString(
            "CloudSheet.load",
            comment: "CloudSheet button"
        )

        static let save = NSLocalizedString(
            "CloudSheet.save",
            comment: "CloudSheet button"
        )
    }

}
