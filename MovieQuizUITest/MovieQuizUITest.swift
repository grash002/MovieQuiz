import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        XCTAssertFalse(firstPoster == secondPoster)
        
    }
    
    func testNoButton() throws {
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testAllert() throws {
        let buttonsList = ["Yes", "No"]
        
        let firstGamePoster = app.images["Poster"].screenshot().pngRepresentation
        
        for _ in 0...9 {
            let currentButton = buttonsList.randomElement() ?? ""
            app.buttons[currentButton].tap()
            sleep(2)
        }
        
        let statisticAlert = app.alerts.firstMatch
        let statisticAlertButton = statisticAlert.buttons.firstMatch
        
        
        XCTAssert(!statisticAlert.description.isEmpty)
        
        
        statisticAlertButton.tap()
        sleep(1)
        
        
        let secondGamePoster = app.images["Poster"].screenshot().pngRepresentation
        
        
        XCTAssert(firstGamePoster != secondGamePoster)
    }
}
