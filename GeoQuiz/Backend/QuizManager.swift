//
//  QuizManager.swift
//  GeoQuiz
//
//  Created by Felix Horn on 07.06.24.
//

// QuizManager.swift

import SwiftUI
import CoreHaptics

class QuizManager: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var highscore: Int = UserDefaults.standard.integer(forKey: "highscore")
    @Published var streak: Int = UserDefaults.standard.integer(forKey: "streak")
    @Published var currentQuestion: ShuffledQuestion?
    @Published var selectedDifficulty: Int = 1
    @Published var selectedContinent: String = "Die gesamte Welt" {
        didSet {
            errorMessage = nil // Fehler zurücksetzen bei Änderung der Einstellungen
        }
    }
    @Published var isQuizCompleted: Bool = false
    @Published var numberOfQuestions: Int = 4 {
        didSet {
            errorMessage = nil // Fehler zurücksetzen bei Änderung der Einstellungen
        }
    }
    @Published var answeredQuestions: [AnsweredQuestion] = []
    @Published var showStreakAlert: Bool = false
    @Published var hapticsEnabled: Bool = true
    @Published var errorMessage: ErrorMessage? = nil
    @Published var streakMessage: String = ""
    @Published var quizHistory: [CompletedQuiz] = [] {
        didSet {
            saveQuizHistory()
        }
    }
    @Published var gameModes = ["Hauptstädte", "Modus 2", "Modus 3"]
    private var hapticsEngine: CHHapticEngine?
    private var doublePointsRoundsRemaining: Int {
        get {
            return UserDefaults.standard.integer(forKey: "doublePointsRoundsRemaining")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "doublePointsRoundsRemaining")
        }
    }
    private var completedRounds: Int = 0
    @Published var devMode: Bool = false
    
    // Initiale Speicherung eingelesener Fragen
    var questions: [QuizQuestion] = []
    // Speicherung zufällig ausgewählter Fragen für die zu beginnende Runde unter Ausschluss von Doppelungen
    var shuffledQuestions: [QuizQuestion] = []
    private var usedQuestions: Set<String> = Set()
    // Fragen werden entsprechend des gewählten Schwierigkeitsgrades und des gewählten Kontinents ausgewählt
    var filteredQuestions: [QuizQuestion] {
        var filtered = questions.filter { $0.difficulty == selectedDifficulty }
        if selectedContinent != "Die gesamte Welt" {
            filtered = filtered.filter { $0.continent == selectedContinent }
        }
        return filtered.shuffled()
    }
    
    var availableContinents: [String] {
        ["Die gesamte Welt", "Europa", "Asien", "Afrika", "Nordamerika", "Südamerika", "Australien und Ozeanien"].filter { continent in
            isCategoryAvailable(for: continent)
        }
    }
    
    init() {
        loadQuestions()
        setupHaptics()
        updateStreak()
        loadQuizHistory()
    }
    
    // Die Kontinentauswahl wird anhand der Verfügbarkeit geeigneter Fragen im gewählten Schwierigkeitsgrad festgelegt
    func isCategoryAvailable(for continent: String) -> Bool {
        let questionsInCategory = questions.filter { $0.continent == continent && $0.difficulty == selectedDifficulty }
        return questionsInCategory.count >= numberOfQuestions
    }
    
    // Initialisierung einer Quizrunde
    func startQuiz() {
        let filtered = filteredQuestions
        if filtered.isEmpty {
            errorMessage = ErrorMessage(message: "Keine Fragen gefunden, die den Kriterien entsprechen.")
            return
        }
        
        score = 0
        currentQuestionIndex = 0
        isQuizCompleted = false
        answeredQuestions = []
        usedQuestions.removeAll()
        
        let availableQuestions = filtered.filter { !usedQuestions.contains($0.question) }
        
        if availableQuestions.count < numberOfQuestions {
            errorMessage = ErrorMessage(message: "Nicht genügend Fragen in der gewählten Kategorie und Schwierigkeitsgrad vorhanden.")
            return
        }
        
        shuffledQuestions = Array(availableQuestions.shuffled().prefix(numberOfQuestions))
        restartHapticsEngine()
        loadNextQuestion()
    }
    
    // Zeigt die nächste Frage an, sofern die aktuelle Frage nicht die letzte Frage der Runde ist
    func loadNextQuestion() {
        if currentQuestionIndex < numberOfQuestions && currentQuestionIndex < shuffledQuestions.count {
            let question = shuffledQuestions[currentQuestionIndex]
            usedQuestions.insert(question.question)
            let shuffledAnswers = question.answers.shuffled()
            let correctAnswerIndex = shuffledAnswers.firstIndex(of: question.answers[question.correctAnswer])!
            currentQuestion = ShuffledQuestion(question: question.question, answers: shuffledAnswers, correctAnswerIndex: correctAnswerIndex)
            currentQuestionIndex += 1
        } else {
            completedRounds += 1
            isQuizCompleted = true
            endQuiz()
            updateHighscore()
            if doublePointsRoundsRemaining > 0 {
                doublePointsRoundsRemaining -= 1
            }
        }
    }
    
    // Prüfung der Antworten und Punktevergabe unter Berücksichtigung der Antwort und des Schwierigkeitsgrades
    func checkAnswer(selectedIndex: Int) {
        guard let currentQuestion = currentQuestion else { return }
        let originalQuestion = shuffledQuestions[currentQuestionIndex - 1]
        let answeredQuestion = AnsweredQuestion(
            question: originalQuestion,
            selectedAnswer: selectedIndex,
            correctAnswer: currentQuestion.correctAnswerIndex,
            shuffledAnswers: currentQuestion.answers,
            originalCorrectAnswerIndex: originalQuestion.correctAnswer
        )
        answeredQuestions.append(answeredQuestion)
        
        // Berechnung der Punkte mit Berücksichtigung der doppelten Punkte für die ersten drei Runden
        var points = originalQuestion.difficulty
        if doublePointsRoundsRemaining > 0 {
            points *= 2
        }
        
        if selectedIndex == currentQuestion.correctAnswerIndex {
            score += points
        }
        loadNextQuestion()
    }
    
    func updateHighscore() {
        if score > highscore {
            highscore = score
            UserDefaults.standard.set(highscore, forKey: "highscore")
        }
    }
    
    // Prüfung und Aktualisierung des Streaks bzw. der täglichen Anmeldungen auf Kalendertagesbasis
    func updateStreak() {
            let calendar = Calendar.current
            let today = Date()
            
            if let lastPlayedDate = UserDefaults.standard.object(forKey: "lastPlayedDate") as? Date {
                if calendar.isDateInYesterday(lastPlayedDate) {
                    streak += 1
                    showStreakAlert = true
                    streakMessage = "Glückwunsch zum \(streak)-Tage-Streak!"
                } else if !calendar.isDateInToday(lastPlayedDate) {
                    streakMessage = "Du hast gestern ausgesetzt und deshalb deinen \(streak)-Tage-Streak verloren"
                    streak = 0
                    showStreakAlert = true
                }
            } else {
                streak = 1
                showStreakAlert = true
                streakMessage = "Glückwunsch zum \(streak)-Tage-Streak!"
            }
            
            if streak > 0 && streak % 10 == 0 {
                streakMessage = "Glückwunsch zum \(streak)-Tage-Streak! Die nächsten 3 Runden gibt es doppelte Punkte."
                // Weitere Logik für den 10-Tage-Streak
            }
            
            UserDefaults.standard.set(streak, forKey: "streak")
            UserDefaults.standard.set(today, forKey: "lastPlayedDate")
        }
    
    // Speichern des Egebnisses in der Historie
    func endQuiz() {
        let totalPoints = answeredQuestions.reduce(0) { $0 + $1.question.difficulty }
        let completedQuiz = CompletedQuiz(
            date: Date(),
            score: score,
            totalPoints: totalPoints,
            answeredQuestions: answeredQuestions
        )
        quizHistory.append(completedQuiz)
        quizHistory.sort { $0.date > $1.date } // Sortieren der Liste nach Datum
        updateHighscore()
    }
    // Aktualisierung der persistenten Quizhistorie
    func saveQuizHistory() {
        do {
            let data = try JSONEncoder().encode(quizHistory)
            UserDefaults.standard.set(data, forKey: "quizHistory")
        } catch {
            print("Fehler beim Speichern der Quiz-Historie: \(error)")
        }
    }

    func loadQuizHistory() {
        if let data = UserDefaults.standard.data(forKey: "quizHistory") {
            do {
                quizHistory = try JSONDecoder().decode([CompletedQuiz].self, from: data)
                quizHistory.sort { $0.date > $1.date } // Sortieren der Liste nach Datum
            } catch {
                print("Fehler beim Laden der Quiz-Historie: \(error)")
            }
        }
    }
    // Methode zum manuellen Setzen des Streaks auf 10; Entwickler-/Testfunktion, ggf. entfernen/auskommentieren
    func setStreakToTen() {
        streak = 10
        doublePointsRoundsRemaining = 3
        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedDate")
        showStreakAlert = true
        streakMessage = "Glückwunsch zum \(streak)-Tage-Streak! Doppelte Punkte für die nächsten 3 Runden."
    }
    // Methode zum manuellen Setzen des Streaks auf 0; Entwickler-/Testfunktion, ggf. entfernen/auskommentieren
    func setStreakToZero() {
        streak = 0
        doublePointsRoundsRemaining = 0
        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedDate")
        showStreakAlert = false
    }
    
    func determineContinent(for question: String) -> String {
        return "Europa"
    }
}

// Peripheriefunktionen
extension QuizManager {
    // Einlesen der Fragen
    func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            do {
                var data = try Data(contentsOf: url)
                var questions = try JSONDecoder().decode([QuizQuestion].self, from: data)
                for i in 0..<questions.count {
                    if questions[i].continent == nil {
                        questions[i].continent = determineContinent(for: questions[i].question)
                    }
                }
                self.questions = questions
            } catch {
                print("Failed to load questions: \(error)")
            }
        }
    }
    
    // Initialisierung des haptischen Feedbacks aka "Klopfen" des Handys beim Drücken von Buttons
    func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticsEngine = try CHHapticEngine()
            try hapticsEngine?.start()
        } catch {
            print("Haptics Engine Error: \(error)")
        }
    }
    
    // Methode zum Neustarten der Haptik-Engine
    func restartHapticsEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            if let hapticsEngine = hapticsEngine {
                try hapticsEngine.start()
            } else {
                hapticsEngine = try CHHapticEngine()
                try hapticsEngine?.start()
            }
        } catch {
            print("Failed to restart haptics engine: \(error)")
        }
    }
    
    // Ausführung des haptischen Feedbacks
    func performHapticFeedback() {
        guard hapticsEnabled else { return }
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticsEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to perform haptic feedback: \(error)")
        }
    }
}
