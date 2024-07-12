//
//  NumberOfQuestionsSelectionView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 21.06.24.
//

import Foundation
import SwiftUI

struct NumberOfQuestionsSelectionView: View {
    @ObservedObject var quizManager: QuizManager

    var body: some View {
        VStack {
            Text("Wähle die Anzahl der Fragen")
                .font(.headline)
                .padding(.bottom, 5)
            
            Stepper(value: $quizManager.numberOfQuestions, in: 4...21) {
                Text("Anzahl der Fragen: \(quizManager.numberOfQuestions)")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(hex: "#153243"))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(hex: "#284B63"), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .foregroundColor(.white)
        }
        .padding()
    }
}

struct NumberOfQuestionsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NumberOfQuestionsSelectionView(quizManager: QuizManager())
    }
}
