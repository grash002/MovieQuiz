import UIKit

protocol AlertPresenterDelegate: AnyObject, UIViewController {
    var correctAnswers:Int {get set}
    var questionCount:Int {get set}
    var currentQuestionIndex:Int {get set}
    func resetGame()
}
