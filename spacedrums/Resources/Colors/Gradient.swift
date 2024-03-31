//
//  Gradient.swift
//  spacedrums
//
//  Created by Marina Roshchupkina on 20.03.2024.
//

import SwiftUI
struct Colors {
    static let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 223/255, green: 52/255, blue: 29/255), location: 0.00),
            Gradient.Stop(color: .black, location: 0.48),
            Gradient.Stop(color: Color(red: 22/255, green: 217/255, blue: 205/255), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0.94, y: 1)
    )

    static let backgroundFigma = LinearGradient(
        colors: [
            Color(red: 0.68, green: 0.15, blue: 0.08),
            .black,
            Color(red: 0.04, green: 0.57, blue: 0.54)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundTwo = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.68, green: 0.15, blue: 0.08), location: 0.00),
            //Gradient.Stop(color: .black, location: 0.48),
            Gradient.Stop(color: Color(red: 0.04, green: 0.57, blue: 0.54), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0.94, y: 1)
    )

}
