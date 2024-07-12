//
//  HistoryView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 14.06.24.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @ObservedObject var quizManager: QuizManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundStyle()
            
            VStack {
                Text("Historie")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    ForEach(quizManager.quizHistory) { quiz in
                        NavigationLink(destination: QuizDetailView(quiz: quiz)) {
                            VStack(alignment: .leading) {
                                Text("Quiz vom \(quiz.date, formatter: itemFormatter)")
                                Text("Punkte: \(quiz.score)/\(quiz.totalPoints)")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(quizManager: QuizManager())
    }
}
