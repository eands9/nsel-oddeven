//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    
    var randomNumA : Int = 0
    var randomNumB : Int = 0
    var randomNumC : Int = 0
    var firstNum : Int = 0
    var secondNum : Int = 0

    var questionTxt : String = ""
    var answerCorrect : Int = 0
    var answerUser : Int = 0
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        randomNumA = Int.random(in: 10 ..< 101)
        randomNumB = Int.random(in: 10 ..< 101)
        randomNumC = Int(arc4random_uniform(2))
        
        pickNumA()

        if randomNumC == 0{
            questionLabel.text = "How many even numbers between \(firstNum) and \(secondNum)?"
        }
        else{
            questionLabel.text = "How many odd numbers between \(firstNum) and \(secondNum)?"
        }
        
        
    }
    
    func checkAnswer(){
        getCorrectAnswer()
        answerUser = (answerTxt.text! as NSString).integerValue
        
        if answerUser == answerCorrect{
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            askQuestion()
            answerTxt.text = ""
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    
    /*
     If looking for even
     - and both numbers are odd, subtract the two numbers and divide by 2
     - and both numbers are even, subtract the two numbers and divide by 2 and then subtract 1
     - and one is even but not the other, subtract the two numbers and then subtract 1 and then divide by 2
     
     If looking for odd
     - and both numbers are even, subtract the two numbers and divide by 2
     - and both numbers are odd, subtract the two numbers and divide by 2 and then subtract 1
     - and one is even but not the other, subtract the two numbers and then subtract 1 and then divide by 2
     */
    
    func getCorrectAnswer(){
        if randomNumC == 0{
            if firstNum % 2 == 0 && secondNum % 2 == 0{
                answerCorrect = (((secondNum - firstNum)/2)-1)
            }
            else if firstNum % 2 == 0 && secondNum % 2 == 1{
                answerCorrect = ((((secondNum - 1) - firstNum)/2))
            }
            else if firstNum % 2 == 1 && secondNum % 2 == 1{
                answerCorrect = (((secondNum - firstNum)/2))
            }
            else if firstNum % 2 == 1 && secondNum % 2 == 0{
                answerCorrect = (((secondNum - (firstNum + 1))/2))
            }
        }
        else{
            if firstNum % 2 == 0 && secondNum % 2 == 0{
                answerCorrect = ((secondNum - firstNum)/2)
            }
            else if firstNum % 2 == 0 && secondNum % 2 == 1{
                answerCorrect = ((((secondNum - 1) - firstNum)/2))
            }
            else if firstNum % 2 == 1 && secondNum % 2 == 1{
                answerCorrect = ((((secondNum - firstNum)/2)-1))
            }
            else if firstNum % 2 == 1 && secondNum % 2 == 0{
                answerCorrect = ((((secondNum - firstNum)-1)/2))
            }
        }
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
    
    func pickNumA(){
        if randomNumA < randomNumB{
            firstNum = randomNumA
            secondNum = randomNumB + 5
        }
        else{
            firstNum = randomNumB
            secondNum = randomNumA + 5
        }
    }
}

