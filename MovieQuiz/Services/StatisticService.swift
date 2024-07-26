import Foundation

class StatisticService: StatisticServiceProtocol {
    
    private let storage = UserDefaults.standard
    
    private enum KeysStats: String {
        case correct
        case gamesCount
    }
    
    private enum KeysBestGameStats: String {
        case correctBestGame
        case totalBestGame
        case dateBestGame
    }
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: KeysStats.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: KeysStats.gamesCount.rawValue)
        }
    }
    
    var correctAnswers: Int {
        get {
            storage.integer(forKey: KeysStats.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: KeysStats.correct.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            GameResult(correct: storage.integer(forKey: KeysBestGameStats.correctBestGame.rawValue),
                       total: storage.integer(forKey: KeysBestGameStats.totalBestGame.rawValue),
                       date: storage.object(forKey: KeysBestGameStats.dateBestGame.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: KeysBestGameStats.correctBestGame.rawValue)
            storage.set(newValue.total, forKey: KeysBestGameStats.totalBestGame.rawValue)
            storage.set(newValue.date, forKey: KeysBestGameStats.dateBestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correctAnswers)/(Double(gamesCount) * 10)  * 100
    }
    
    func store(gameResult: GameResult) {
        if gameResult.isBetterThen(bestGame){
            bestGame = gameResult
        }
        
        gamesCount += 1
        correctAnswers += gameResult.correct
    }
}
