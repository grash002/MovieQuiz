import UIKit

protocol MovieQuizViewControllerDelegate: AnyObject {
    func hideLoadingIndicator() 
    func prepareForRequestNextQuestion()
    func enabledButtons()
    func resetUI()
    func showAnswerResult(isCorrect: Bool)
    func show(quiz: QuizStepViewModel)
    func alertPresent(alert: UIAlertController, alertModel: AlertModel)
}
