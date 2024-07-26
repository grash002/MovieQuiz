import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    // MARK: - Private properties
    
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
    
    private var questionsDidShows:[Int] = []
    private var questionsDontShows:[Int] {
        var questionsDontShows:[Int] = []
        for i in 0..<questions.count{
            if !questionsDidShows.contains(i){
                questionsDontShows.append(i)
            }
        }
        return questionsDontShows
    }
    
    
    //MARK: - Public properties
    
    var questionCount: Int {
        return questions.count
    }
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Public methods
    
    func requestNextQuestion() {
        guard let index = questionsDontShows.randomElement()
        else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        delegate?.didReceiveNextQuestion(question: questions[safe: index])
        questionsDidShows.append(index)
    }
    
    //MARK: - init
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
}
