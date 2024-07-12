import Foundation
import SwiftUI

enum NavigationTarget: Hashable {
    case quizSetup
    case quizView
    case summaryView
    case contentView
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @ObservedObject var quizManager = QuizManager()
    @State private var selectedGameMode = "Hauptstädte"

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundStyle()
                
                VStack {
                    if quizManager.showStreakAlert {
                        Text(quizManager.streakMessage)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .padding(.bottom)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    quizManager.showStreakAlert = false
                                }
                            }
                    }
                    
                    Text("GeoQuiz")
                        .titleTextStyle()
                        .padding()
                    
                    Text("Highscore: \(quizManager.highscore)")
                        .onAppear {
                            quizManager.updateHighscore()
                        }
                    
                    Text("Streak: \(quizManager.streak) Tage")
                    
                    GameModeSelectionView(quizManager: quizManager, selectedGameMode: $selectedGameMode)
                    
                    NavigationLink(destination: QuizSetupView(quizManager: quizManager)) {
                        Text("Weiter")
                    }
                    .buttonStyle(GeneralButtonStyle())
                    .padding()
                }
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .quizSetup:
                        QuizSetupView(quizManager: quizManager)
                    default:
                        EmptyView()
                    }
                }
                
                if quizManager.devMode {
                    HStack {
                        Button(action: {
                            quizManager.setStreakToTen()
                            quizManager.performHapticFeedback()
                        }) {
                            Text("Streak 10")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        
                        Button(action: {
                            quizManager.setStreakToZero()
                            quizManager.performHapticFeedback()
                        }) {
                            Text("Streak 0")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
            }
                .onAppear {
                    quizManager.updateStreak()
                }
                .alert(item: $quizManager.errorMessage) { errorMessage in
                    Alert(
                        title: Text("Fehler"),
                        message: Text(errorMessage.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationBarItems(
                    leading: NavigationLink(destination: HistoryView(quizManager: quizManager)) {
                        BookIconView()
                            .frame(width: 24, height: 24)
                    },
                    trailing: NavigationLink(destination: SettingsView(quizManager: quizManager)) {
                        Image("gear-307380_1280")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                )
            }
        }
    }

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
