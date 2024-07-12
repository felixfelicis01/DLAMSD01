//
//  AnswerButtonStyle.swift
//  GeoQuiz
//
//  Created by Felix Horn on 15.06.24.
//

import Foundation
import SwiftUI

struct AnswerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 250, height: 25) // Feste Breite und Höhe für alle Buttons
            .padding() // Innenabstand
            .background(
                Color(hex: "#5C0029")
            )
            .foregroundColor(.white) // Textfarbe
            .cornerRadius(8) // Eckradius
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Leichte Skalierung bei Druck
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Leichte Transparenz bei Druck
    }
}
/*
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
*/
