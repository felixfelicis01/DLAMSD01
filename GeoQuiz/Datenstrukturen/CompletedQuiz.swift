//
//  CompletedQuiz.swift
//  GeoQuiz
//
//  Created by Felix Horn on 14.06.24.
//

import Foundation
struct CompletedQuiz: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let score: Int
    let totalPoints: Int
    let answeredQuestions: [AnsweredQuestion]
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
