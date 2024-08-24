import UIKit

protocol AlertPresenterDelegate: AnyObject {
    var correctAnswers:Int {get set}
    var questionCount:Int {get set}
    var currentQuestionIndex:Int {get set}
    var viewControllerDelegate: MovieQuizViewControllerDelegate? { get }
    func resetGame()
}
