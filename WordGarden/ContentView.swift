//
//  ContentView.swift
//  WordGarden
//
//  Created by Gabe Witcher on 3/11/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    private static let maximumGuesses = 8 // Need to refer to this as Self.maximumGuesses
    
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = maximumGuesses
    @State private var guessedLetter = ""
    @State private var revealedWord = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another Word"
    @State private var audioPlayer: AVAudioPlayer!
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            //TODO: switch to wordToGuess[curentWordIndex]
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
                            upDateGameplay()
                        }
                    
                    
                    Button("Guess a Letter") {
                        guessALetter()
                        upDateGameplay()
                        
                    }
                    .disabled(guessedLetter.isEmpty)
                    .buttonStyle(.bordered)
                    .tint(.mint)
                }
                .padding(.horizontal)
            } else {
                
                Button(playAgainButtonLabel) {
                    //if all the words have been guessed
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    //Reset after word was guessed or missed
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
                    lettersGuessed = ""
                    guessesRemaining = Self.maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How Many Guesses To Uncover The Hidden Word?"
                    playAgainHidden = true
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
            
        }
        .ignoresSafeArea(edges: .bottom )
        .onAppear {
            wordToGuess = wordsToGuess[currentWordIndex]
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
        
    }
    
    func upDateGameplay() {
        //TODO: Redo this with localizedStringKey
        
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            //animate crumbling leaf
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
        } else {
            playSound(soundName: "correct")
        }
        if !revealedWord.contains("_") {
            gameStatusMessage = "You Guessed It! It took you \(lettersGuessed.count) Guesses to Guess The Word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-guessed")
        } else if guessesRemaining == 0 { // Word missed
            gameStatusMessage = "So Sorry. You are all out of Guesses"
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-not-guessed")
        } else { //Keep Guessing
            gameStatusMessage = "You've Made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've tried all the words. Restart from the beginning?"
        }
        guessedLetter = ""
    }
    
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not load file \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioplayer")
        }
    }
}

#Preview {
    ContentView()
}
