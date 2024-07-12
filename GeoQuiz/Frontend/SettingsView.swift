//
//  SettingsView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 13.06.24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var quizManager: QuizManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Hintergrundansicht hinzufügen
            BackgroundStyle()
            
            VStack {
                Toggle("Haptisches Feedback", isOn: $quizManager.hapticsEnabled)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Aktivierung/Deaktivierung der Entwicklerwerkzeuge; zum Setzen des Streaks auf 0 oder 10
                Toggle("Entwicklermodus", isOn: $quizManager.devMode)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationBarTitle("Einstellungen", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            })
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(quizManager: QuizManager())
    }
}
