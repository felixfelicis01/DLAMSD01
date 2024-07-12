//
//  QuizSetupView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 28.06.24.
//

import SwiftUI

struct QuizSetupView: View {
    @ObservedObject var quizManager: QuizManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundStyle()
                
                VStack {
                    DifficultySelectionView(quizManager: quizManager)
                    ContinentSelectionView(quizManager: quizManager)
                    NumberOfQuestionsSelectionView(quizManager: quizManager)
                    
                    NavigationLink(destination: QuizView(quizManager: quizManager)) {
                        Text("Quiz starten")
                    }
                    .buttonStyle(GeneralButtonStyle())
                    .padding()
                }
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .quizView:
                        QuizView(quizManager: quizManager)
                    default:
                        EmptyView()
                    }
                }
                .navigationBarTitle("Spielvorbereitung", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    dismiss() // This dismisses the current view, navigating back to ContentView
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

#Preview {
    QuizSetupView(quizManager: QuizManager())
}
