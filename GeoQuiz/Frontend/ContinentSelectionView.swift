//
//  ContinentSelectionView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 21.06.24.
//

import Foundation
import SwiftUI

struct ContinentSelectionView: View {
    @ObservedObject var quizManager: QuizManager
    @State private var showMenu = false

    var body: some View {
        VStack {
            Text("Wähle den Kontinent")
                .font(.headline)
                .padding(.bottom, 5)

            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                HStack {
                    Text(quizManager.selectedContinent)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(hex: "#153243"))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            }
            .background(
                VStack {
                    if showMenu {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(quizManager.availableContinents, id: \.self) { continent in
                                Button(action: {
                                    withAnimation {
                                        quizManager.selectedContinent = continent
                                        showMenu = false
                                    }
                                }) {
                                    HStack {
                                        Text(continent)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(hex: "#153243"))
                                    .hoverEffect(.highlight)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .background(Color(hex: "#153243"))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                        .transition(.opacity)
                        .zIndex(1)
                        .frame(maxHeight: min(CGFloat(quizManager.availableContinents.count) * 44, 200)) // Begrenzen Sie die Höhe des Dropdowns
                        .offset(y: 50) // Positionierung des Dropdown-Menüs
                    }
                }
                .background(Color.clear)
                , alignment: .topLeading
            )
        }
        .padding()
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if showMenu {
                        withAnimation {
                            showMenu = false
                        }
                    }
                }
        )
        .zIndex(1) // Ensure the dropdown is above other elements
    }
}

struct ContinentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContinentSelectionView(quizManager: QuizManager())
    }
}
