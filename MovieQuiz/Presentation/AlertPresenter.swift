import UIKit

class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    var statisticServiceDelegate: StatisticServiceProtocol?
    
    func showAlert() {
        
        guard let delegate = delegate, let statisticServiceDelegate = statisticServiceDelegate else {
            return
        }
        let correctAnswers = delegate.correctAnswers
        let questionCount = delegate.questionCount
        let gamesCountStatistic = statisticServiceDelegate.gamesCount
        let bestGame = statisticServiceDelegate.bestGame
        let totalAccuracy = statisticServiceDelegate.totalAccuracy
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: """
                                    Ваш результат: \(correctAnswers)/\(questionCount)
                                    Количество сыгранных квизов: \(gamesCountStatistic)
                                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                                    Средняя точность: \(String(format: "%.2f", totalAccuracy))%
                                    """,
                                    buttonText: "Сыграть еще раз",
                                    completion: nil)
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak delegate] _ in
            guard let delegate = delegate else {
                return
            }
            delegate.resetGame()
        }
        
        alert.addAction(action)
        
        delegate.present(alert, animated: true, completion: alertModel.completion)
    }
    
    init(delegate: AlertPresenterDelegate?, statisticServiceDelegate: StatisticServiceProtocol?) {
        self.delegate = delegate
        self.statisticServiceDelegate = statisticServiceDelegate
    }
}
