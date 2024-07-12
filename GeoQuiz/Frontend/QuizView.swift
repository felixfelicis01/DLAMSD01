//
//  QuizView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

import Foundation
import SwiftUI

struct QuizView: View {
    @ObservedObject var quizManager: QuizManager
    @Environment(\.dismiss) private var dismiss
    //@State private var showSummary = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrundansicht hinzufügen
                BackgroundStyle()
                VStack {
                    // Fortschrittsanzeige hinzufügen
                    if !quizManager.isQuizCompleted {
                        Text("\(quizManager.currentQuestionIndex)/\(quizManager.numberOfQuestions)")
                            .font(.headline)
                            .padding()
                    }
                    
                    if quizManager.isQuizCompleted {
                        NavigationLink(destination: SummaryView(quizManager: quizManager)) {
                            Text("Zum Ergebnis")
                        }
                        .buttonStyle(GeneralButtonStyle())
                        .padding()
                    } else if let question = quizManager.currentQuestion {
                        Text(question.question)
                            .font(.title)
                            .padding()
                        
                        ForEach(0..<question.answers.count, id: \.self) { index in
                            Button(action: {
                                quizManager.checkAnswer(selectedIndex: index)
                                quizManager.performHapticFeedback()
                            }) {
                                Text(question.answers[index])
                                    .font(.custom("Roboto-Bold", size: 24))
                                    .padding()
                            }
                            .buttonStyle(AnswerButtonStyle())
                        }
                    }
                }
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .summaryView:
                        SummaryView(quizManager: quizManager)
                    default:
                        EmptyView()
                    }
                }
                .onAppear {
                    quizManager.startQuiz()
                }
                .navigationBarItems(leading: Button(action: {
                    dismiss() // Kehrt zur vorherigen View (QuizSetupView) zurück
                }) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                })
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
