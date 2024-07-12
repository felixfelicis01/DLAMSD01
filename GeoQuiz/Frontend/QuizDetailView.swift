//
//  QuizDetailView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 14.06.24.
//

import Foundation
import SwiftUI

struct QuizDetailView: View {
    let quiz: CompletedQuiz
    
    var body: some View {
        List {
            ForEach(quiz.answeredQuestions, id: \.question) { answeredQuestion in
                VStack(alignment: .leading) {
                    Text(answeredQuestion.question.question)
                        .font(.headline)
                    ForEach(answeredQuestion.shuffledAnswers.indices, id: \.self) { index in
                        HStack {
                            Text(answeredQuestion.shuffledAnswers[index])
                            if index == answeredQuestion.selectedAnswer {
                                Text(" (Deine Antwort)")
                                    .foregroundColor(index == answeredQuestion.correctAnswer ? .green : .red)
                            }
                            if index == answeredQuestion.correctAnswer {
                                Text(" (Richtig)")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Quiz Details")
    }
}
