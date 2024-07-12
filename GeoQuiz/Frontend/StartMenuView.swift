//
//  StartMenuView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 28.06.24.
//

import SwiftUI

struct StartMenuView: View {
    @State private var showGameSettings = false
    @State private var showHistory = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundStyle()
                VStack {
                    Spacer()
                    
                    // Gestenmenü zur Spielmodusauswahl
                    Text("Wischen Sie, um den Spielmodus auszuwählen")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()

                    Button(action: {
                        showGameSettings = true
                    }) {
                        Text("Beginnen")
                            .padding()
                            .background(Color(hex: "#00F2FE"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(GeneralButtonStyle())
                    .padding()
                    
                    Spacer()

                    HStack {
                        Button(action: {
                            showHistory = true
                        }) {
                            Image(systemName: "book")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(NavigationLink("", destination: HistoryView(quizManager: QuizManager()), isActive: $showHistory).hidden())

                        Spacer()

                        Button(action: {
                            showSettings = true
                        }) {
                            Image("gear-307380_1280")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(NavigationLink("", destination: SettingsView(quizManager: QuizManager()), isActive: $showSettings).hidden())
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    StartMenuView()
}
