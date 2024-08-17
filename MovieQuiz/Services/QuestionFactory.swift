import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    // MARK: - Private properties
    
   /* private let questions: [QuizQuestion] = [
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
    */
    
    private var moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private var questionsDontShow:[Int] = []
    
    //MARK: - Public properties
    
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Public methods
    
    func loadData() {
        moviesLoader.loadMovies {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = []
                    let allMovies = mostPopularMovies.items
                    
                    for _ in 0..<10 {
                        guard let movie = allMovies.randomElement() else { return }
                        self.movies.append(movie)
                    }
                    
                    self.delegate?.questionCount = self.movies.count
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = self.delegate?.getCurrentQuestionIndex() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            var image = Data()
            
            do {
                image = try Data(contentsOf: movie.imageURL)
            }
            catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let questionRating = Float((6...9).randomElement() ?? 0)
            
            let text = "Рейтинг этого фильма больше \(Int(questionRating))?"
            let correctAnswer = rating > questionRating
            
            let question = QuizQuestion(image: image, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    //MARK: - init
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
