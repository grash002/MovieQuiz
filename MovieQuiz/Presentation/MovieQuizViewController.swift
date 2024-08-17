import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerDelegate, MovieQuizViewControllerProtocol {
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Internal Properties
    
    var presenter: MovieQuizPresenter?
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter?.yesOrNoButtonClicked(givenAnsver: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter?.yesOrNoButtonClicked(givenAnsver: false)
    }
    
    
    // MARK: - Internal methods
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image =  step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    func showAnswerResult(isCorrect: Bool) {
        
        disabledButtons()
        imageView.layer.borderColor = isCorrect ? UIColor.yGreen.cgColor : UIColor.yRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak presenter] in
            guard let presenter = presenter else { return }
            
            presenter.correctAnswers += isCorrect ? 1 : 0
            presenter.showNextQuestionOrResults()
        }
    }
    
    
    func prepareForRequestNextQuestion() {
        presenter?.switchToNextQuestionIndex()
        imageView.layer.borderColor = UIColor.yBlack.cgColor
        showLoadingIndicator()
        presenter?.requestNextQuestion()
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        presenter?.didReceiveNextQuestion(question: question)
    }
    
    
    func enabledButtons() {
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true
    }
    
    
    func disabledButtons() {
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
    }
    
    
    func resetUI() {
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: QuizStepViewModel(image: UIImage(), question: "", questionNumber: "0/10"))
            self?.showLoadingIndicator()
        }
        imageView.layer.borderColor = UIColor.yBlack.cgColor
    }
    
    
    func alertPresent (alert: UIAlertController, alertModel: AlertModel) {
        present(alert, animated: true, completion: alertModel.completion)
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewControllerDelegate: self)
        
        buttonNo.layer.cornerRadius = 15
        buttonYes.layer.cornerRadius = 15
        disabledButtons()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.yBlack.cgColor
        
        show(quiz: QuizStepViewModel(image: UIImage(), question: "", questionNumber: "0/10"))
        showLoadingIndicator()
        
    }
}


