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
    @State private var gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
    @State private var curentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    @State private var revealedWord = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]
    
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
            
            //TODO: switch to wordToGUess[curentWordIndex]
            Text(revealedWord)
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
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                        }
                    
                    
                    Button("Guess a Letter") {
                        guessALetter()
                       
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
        .onAppear {
            wordToGuess = wordsToGuess[curentWordIndex]
            // Create a code with a repeating value
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        }
    }
    func guessALetter() {
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord = wordToGuess.map{ letter in
            lettersGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
        guessedLetter = ""
    }
}

#Preview {
    ContentView()
}
