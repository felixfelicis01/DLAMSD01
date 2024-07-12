//
//  GameModeSelectionView.swift
//  GeoQuiz
//
//  Created by Felix Horn on 28.06.24.
//

import SwiftUI

struct GameModeSelectionView: View {
    @ObservedObject var quizManager: QuizManager
    @Binding var selectedGameMode: String
    @State private var currentIndex: Int = 0
    
    var body: some View {
        let gameModes = quizManager.gameModes
        
        VStack {
            Text("Wählen Sie den Spielmodus")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Horizontal navigierbares Menü
            HStack {
                // Linker Pfeil
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundColor(currentIndex > 0 ? .white : .gray)
                    .onTapGesture {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            selectedGameMode = gameModes[currentIndex]
                        }
                    }

                TabView(selection: $currentIndex) {
                    ForEach(gameModes.indices, id: \.self) { index in
                        Text(gameModes[index])
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedGameMode == gameModes[index] ? Color.blue : Color.clear)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 100)
                
                // Rechter Pfeil
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(currentIndex < gameModes.count - 1 ? .white : .gray)
                    .onTapGesture {
                        if currentIndex < gameModes.count - 1 {
                            currentIndex += 1
                            selectedGameMode = gameModes[currentIndex]
                        }
                    }
            }
            .padding(.horizontal, 10)
        }
        .background(Color(hex: "#153243"))
        .cornerRadius(10)
        .padding()
        .onChange(of: currentIndex) { newIndex in
            selectedGameMode = gameModes[newIndex]
        }
    }
}

struct GameModeSelectionView_Previews: PreviewProvider {
    @State static var selectedGameMode = "Modus 1"
    
    static var previews: some View {
        GameModeSelectionView(quizManager: QuizManager(), selectedGameMode: $selectedGameMode)
    }
}
