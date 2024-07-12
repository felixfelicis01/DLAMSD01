//
//  BookIconView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 21.06.24.
//

import Foundation
import SwiftUI

struct BookIconView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1.5)
                )
            
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .offset(x: 2, y: 2)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1.5)
                )
        }
        .frame(width: 24, height: 24)
    }
}

struct BookIconView_Previews: PreviewProvider {
    static var previews: some View {
        BookIconView()
    }
}
