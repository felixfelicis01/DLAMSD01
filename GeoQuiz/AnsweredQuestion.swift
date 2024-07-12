//
//  AnsweredQuestion.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

import Foundation
import SwiftUI

struct AnsweredQuestion: Codable {
    let question: QuizQuestion
    let selectedAnswer: Int
    let correctAnswer: Int
    let shuffledAnswers: [String]
    let originalCorrectAnswerIndex: Int
}
