import Foundation

protocol StatisticServiceProtocol:AnyObject {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(gameResult: GameResult)
}
