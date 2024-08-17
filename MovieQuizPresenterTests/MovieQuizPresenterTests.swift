import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerDelegate {
    func hideLoadingIndicator() {
        
    }
    
    func prepareForRequestNextQuestion() {
        
    }
    
    func enabledButtons() {
        
    }
    
    func resetUI() {
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
    }
    
    func show(quiz: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func alertPresent(alert: UIAlertController, alertModel: MovieQuiz.AlertModel) {
        
    }
    
    
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewControllerDelegate: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
