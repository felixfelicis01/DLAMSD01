//
//  QuizQuestion.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

import Foundation

struct QuizQuestion: Codable, Identifiable, Hashable {
    var id = UUID()
    let question: String
    let answers: [String]
    let correctAnswer: Int
    let difficulty: Int
    var continent: String?

    private enum CodingKeys: String, CodingKey {
        case question, answers, correctAnswer, difficulty, continent
    }
}

