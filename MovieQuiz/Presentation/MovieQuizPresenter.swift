import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Internal Properties
    
    weak var viewControllerDelegate: MovieQuizViewControllerDelegate?
    var correctAnswers = 0
    var questionCount = 10
    var currentQuestion: QuizQuestion?
    var currentQuestionIndex = 0
    
    // MARK: - Private Properties
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    
    // MARK: - Private methods
    
    private func showNetworkError(message: String) {
        guard let viewControllerDelegate = viewControllerDelegate else { return }
        viewControllerDelegate.hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    completion: nil)
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    // MARK: - Internal methods
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionCount)")
        return quizStepViewModel
    }
    
    
    func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionCount - 1 {
            
            let gameResult = GameResult(correct: correctAnswers, total: questionCount, date: Date())
            
            statisticService?.store(gameResult: gameResult)
            alertPresenter?.showEndGameAlert()
            
        } else {
            viewControllerDelegate?.partialResetUI()
            switchToNextQuestionIndex()
            questionFactory?.requestNextQuestion()
        }
        
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        viewControllerDelegate?.hideLoadingIndicator()
        let viewModel = self.convert(model: question)
        currentQuestion = question
        
        DispatchQueue.main.async { [weak viewControllerDelegate] in
            viewControllerDelegate?.show(quiz: viewModel)
            viewControllerDelegate?.enabledButtons()
        }
    }

    
    func switchToNextQuestionIndex() {
        currentQuestionIndex += 1
    }
    
    
    func getCurrentQuestionIndex() -> Int {
        currentQuestionIndex
    }
    
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        viewControllerDelegate?.hideLoadingIndicator()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    func yesOrNoButtonClicked(givenAnsver: Bool) {
        let isCorrect = givenAnsver == currentQuestion?.correctAnswer
        viewControllerDelegate?.disabledButtons()
        viewControllerDelegate?.showBorderColor(isGreen: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.correctAnswers += isCorrect ? 1 : 0
            self.showNextQuestionOrResults()
        }
    }
    
    
    func resetGame() {
        questionFactory?.loadData()
        currentQuestionIndex = 0
        correctAnswers = 0
        viewControllerDelegate?.resetUI()
    }
    
    
    // MARK: - Lifecycle
    
    init(viewControllerDelegate: MovieQuizViewControllerDelegate) {
        self.viewControllerDelegate = viewControllerDelegate
        
        self.statisticService = StatisticService()
        self.alertPresenter = AlertPresenter(delegate: self, statisticServiceDelegate: statisticService)
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        questionFactory?.loadData()
    }
}
