//
//  ContentView.swift
//  Milestone Projects 4-6
//
//  Created by Gustavo Perbone on 25/01/22.
//

import SwiftUI

struct Question{
    var body: String
    var answer: Int
}


struct ContentView: View {
    @State var isShowingGame = false
    @State var isShowingScore = false
    @State private var multiplicationTable : Int = 2
    let numberOfQuestionsArray = [5, 10, 20]
    @State private var numberOfQuestionsChosen = 1
    @State private var questions = [Question]()
    //@State private var questions = [Question(body: "0 x 0 =", answer: 1)]
    @State private var questionNumber = 0
    @State private var userAnswer =  Int()
    @State private var currentRound =  1
    @State private var score =  0
    @State private var lastOneCorrect = true
    
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [ Color(red: 0, green: 0.9, blue: 1), Color(red: 0, green: 0.5, blue: 1)]), center: .center, startRadius: 1, endRadius: 400)
                .ignoresSafeArea()
            
            VStack{
                Image("giraffe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
                Text("Multiplication Game")
                    .fontWeight(.bold)
                    .foregroundColor(Color.yellow)
                    .padding()
                    .font(.largeTitle)
                
                Spacer()
                
                //Config
                if !isShowingGame && !isShowingScore{
                    Section{
                        Stepper("\(multiplicationTable)", value: $multiplicationTable, in: 2...12)
                    } header: {
                        Text("Up to which table...?")
                            .font(.title)
                    }
                    
                    Section{
                        Picker("Number of questions",  selection: $numberOfQuestionsChosen) {
                            ForEach(0..<numberOfQuestionsArray.count){
                                Text("\(numberOfQuestionsArray[$0])")
                            }
                        } .pickerStyle(.segmented)
                    } header: {
                        Text("How many questions?")
                            .font(.title)
                    }
                    Spacer()
                    Spacer()
                    Button {
                      setUpGame()
                    } label: {
                        Text("Start")
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(Color.cyan)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                //Game
                if isShowingGame && !isShowingScore {
                    HStack(alignment: .center){
                        Text(questions[questionNumber].body)

                            
                        TextField("User Answer", value: $userAnswer, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80, height: nil)
                            .multilineTextAlignment(.center)
                    }
                    .font(.system(size: 64))
                    
                    Button {
                      nextQuestion()
                    } label: {
                        Text("Submit")
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(Color.cyan)
                            .cornerRadius(10)
                    }
                    
                    Spacer()

                    Text("Score \(score)/\(numberOfQuestionsArray[numberOfQuestionsChosen])")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(currentRound == 1 ? .black : (lastOneCorrect ? .green : .red))
                    
                    Text("Round \(currentRound)/\(numberOfQuestionsArray[numberOfQuestionsChosen])")
                        .font(.title2)
                    Spacer()
                }
                
                if isShowingScore{
                    Text("Thanks for playing!")
                        .font(.system(size: 25))
                        .foregroundColor(.purple)
                    Text("You scored \(score)/\(numberOfQuestionsArray[numberOfQuestionsChosen])!")
                        .font(.system(size: 50))
                        .foregroundColor(.purple)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                      endGame()
                    } label: {
                        Text("Play Again")
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(Color.cyan)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        }
    }

    func setUpGame(){
        var mult1 = Int()
        var mult2 = Int()
        
        for _ in 0..<numberOfQuestionsArray[numberOfQuestionsChosen]{
            mult1 = Int.random(in: 1...multiplicationTable)
            mult2 = Int.random(in: 1...10)
            
            questions.append(Question(body: "\(mult1) x \(mult2) = ", answer: (mult1 * mult2)))
        }
        
        //starts Game
        withAnimation{
            isShowingGame = true
        }
    }
    
    func nextQuestion(){
        if userAnswer == (questions[questionNumber].answer){
            
            score += 1
            withAnimation{
            lastOneCorrect = true
            }
        } else{
            withAnimation{
            lastOneCorrect = false
            }
        }


        if currentRound < numberOfQuestionsArray[numberOfQuestionsChosen]{
            questionNumber += 1
            currentRound += 1
        } else if currentRound == numberOfQuestionsArray[numberOfQuestionsChosen]{
            withAnimation{
                isShowingGame = false
                isShowingScore = true
            }
         
        }
    }

    func endGame(){
        //remover todas qustoes
        questions.removeAll()
        currentRound = 1
        score = 0
        numberOfQuestionsChosen = 1
        questionNumber = 0
        multiplicationTable = 2
        
        withAnimation{
            isShowingGame = false
            isShowingScore = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
