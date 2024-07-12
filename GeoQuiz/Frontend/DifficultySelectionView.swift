//
//  DifficultySelectionView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 22.06.24.
//

import Foundation
import SwiftUI

struct DifficultySelectionView: View {
    @ObservedObject var quizManager: QuizManager
    
    var body: some View {
        VStack {
            Text("Wähle den Schwierigkeitsgrad")
                .font(.headline)
            Picker("Schwierigkeitsgrad", selection: $quizManager.selectedDifficulty) {
                Text("Leicht").tag(1)
                Text("Mittel").tag(2)
                Text("Schwer").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color(hex: "#00F2FE"))
            .cornerRadius(8)
            .padding()
        }
    }
}
