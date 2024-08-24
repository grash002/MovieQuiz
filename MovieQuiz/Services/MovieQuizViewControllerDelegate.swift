import UIKit

protocol MovieQuizViewControllerDelegate: AnyObject {
    func hideLoadingIndicator()
    func enabledButtons()
    func resetUI()
    func partialResetUI()
    func disabledButtons()
    func showBorderColor(isGreen: Bool)
    func show(quiz: QuizStepViewModel)
    func alertPresent(alert: UIAlertController, alertModel: AlertModel)
}
