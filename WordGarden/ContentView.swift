//
//  ContentView.swift
//  WordGarden
//
//  Created by Gabe Witcher on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    @State private var gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
    @State private var curentWord = 0
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Words To Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words In Game: \(wordsToGuess.count)")
                }
            }
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //TODO: switch to wordToGUess[currentWord]
            Text("_ _ _ _ _ ")
                .font(.title)
            
            if playAgainHidden {
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                    
                    
                    Button("Guess a Letter") {
                        //TODO: guess a lett button action here
                        textFieldIsFocused = false
                        //guessedLetter = ""
                       
                    }
                    .disabled(guessedLetter.isEmpty)
                    .buttonStyle(.bordered)
                    .tint(.mint)
                }
                .padding(.horizontal)
            } else {
                
                Button("Another Word") {
                    //TODO: Another Word button action
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }

            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
            
        }
        .ignoresSafeArea(edges: .bottom )
    }
    
}

#Preview {
    ContentView()
}
