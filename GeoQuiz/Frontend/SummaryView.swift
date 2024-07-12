//
//  SummaryView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

import Foundation
import SwiftUI

struct SummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var quizManager: QuizManager
   // @Binding var showSummary: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrundansicht hinzufügen
                BackgroundStyle()
                VStack {
                    Text("Zusammenfassung")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Dein Score: \(quizManager.score)")
                        .font(.title)
                        .padding()
                    
                    Text("Highscore: \(quizManager.highscore)")
                        .font(.title)
                        .padding()
                    
                    List(quizManager.answeredQuestions, id: \.question.question) { answeredQuestion in
                        VStack(alignment: .leading) {
                            Text(answeredQuestion.question.question)
                                .font(.headline)
                            ForEach(0..<answeredQuestion.shuffledAnswers.count, id: \.self) { index in
                                HStack {
                                    Text(answeredQuestion.shuffledAnswers[index])
                                    Spacer()
                                    if index == answeredQuestion.selectedAnswer {
                                        if index == answeredQuestion.correctAnswer {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    if index == answeredQuestion.correctAnswer && index != answeredQuestion.selectedAnswer {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(destination: ContentView(quizManager: quizManager).navigationBarBackButtonHidden()) {
                        Text("Startmenü")
                    }
                    .buttonStyle(GeneralButtonStyle())
                    .padding()
                }
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .contentView:
                        ContentView(quizManager: quizManager)
                    default:
                        EmptyView()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
