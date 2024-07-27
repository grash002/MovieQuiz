import UIKit


final class MovieQuizViewController: UIViewController {
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    // MARK: - Private Properties
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Internal Properties
   
    var currentQuestionIndex = 0
    var correctAnswers = 0
    var questionCount = 0
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        
    }
    
    // MARK: - Private Methods
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image =  step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionFactory?.questionCount ?? 0)")
        return quizStepViewModel
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        
        imageView.layer.borderColor = isCorrect ? UIColor.yGreen.cgColor : UIColor.yRed.cgColor
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionCount - 1 {
            
            let gameResult = GameResult(correct: correctAnswers, total: questionCount, date: Date())
            
            statisticService?.store(gameResult: gameResult)
            alertPresenter?.showAlert()
            
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = UIColor.yBlack.cgColor
            questionFactory?.requestNextQuestion()
        }
        
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true
    }
    
    // MARK: - Internal methods
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        self.currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        imageView.layer.borderColor = UIColor.yBlack.cgColor
        questionFactory?.questionsDidShows = []
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(delegate: self, statisticServiceDelegate: statisticService)
        
        buttonNo.layer.cornerRadius = 15
        buttonYes.layer.cornerRadius = 15
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.yBlack.cgColor
        
        questionFactory?.requestNextQuestion()
        questionCount = questionFactory?.questionCount ?? 0
    }
}


extension MovieQuizViewController: QuestionFactoryDelegate, AlertPresenterDelegate {

}
