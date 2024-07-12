//
//  BackgroundStyle.swift
//  GeoQuiz
//
//  Created by Felix Horn on 14.06.24.
//

import Foundation
import SwiftUI

struct BackgroundStyle: View {
    var body: some View {
        Color(hex: "#4FACFA")
            .edgesIgnoringSafeArea(.all)
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
