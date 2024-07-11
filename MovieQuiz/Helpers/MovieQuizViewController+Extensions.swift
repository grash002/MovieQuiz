import UIKit

extension MovieQuizViewController {
    // MARK: - Structs
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
}
