import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
   //func showNetworkError(message: String)
}
