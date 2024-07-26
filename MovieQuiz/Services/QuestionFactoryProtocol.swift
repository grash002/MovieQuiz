import Foundation

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    
    var questionCount:Int { get }
}
