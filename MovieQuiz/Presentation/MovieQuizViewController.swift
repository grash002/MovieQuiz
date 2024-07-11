import UIKit


final class MovieQuizViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    private var currentQuestion = QuizQuestion(image: "", text: "", correctAnswer: true)
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return quizStepViewModel
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image =  step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        
        imageView.layer.borderColor = isCorrect ? UIColor.yGreen.cgColor : UIColor.yRed.cgColor
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            }
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers)/\(questions.count)",
                preferredStyle: .alert)
            
            let nilQuestion = QuizQuestion(image: "", text: "", correctAnswer: true)
            let nilQuizStepViewModel = convert(model: nilQuestion)
            
            let action = UIAlertAction(title: "Сыграть снова!", style: .default) { [weak self] _ in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.imageView.layer.borderColor = UIColor.yBlack.cgColor
                self?.currentQuestion = self?.questions[self?.currentQuestionIndex ?? 0] ?? nilQuestion
                self?.show(quiz: self?.convert(model: self?.currentQuestion ?? nilQuestion) ?? nilQuizStepViewModel)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            imageView.layer.borderColor = UIColor.yBlack.cgColor
            show(quiz: convert(model: currentQuestion))
        }
        
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonNo.layer.cornerRadius = 15
        buttonYes.layer.cornerRadius = 15
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.yBlack.cgColor
        
        currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
}
