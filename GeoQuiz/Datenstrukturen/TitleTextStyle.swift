//
//  TitleTextStyle.swift
//  GeoQuiz
//
//  Created by Felix Horn on 20.06.24.
//

import Foundation
import SwiftUI

struct TitleTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Roboto-Bold", size: 40)) // Schriftart und Größe
            .foregroundColor(.white) // Textfarbe
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4) // Schatten
    }
}

extension View {
    func titleTextStyle() -> some View {
        self.modifier(TitleTextStyle())
    }
}
