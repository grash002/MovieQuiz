import Foundation

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    
    var questionCount:Int { get }
    
    var questionsDidShows:[Int] { get set }
}
