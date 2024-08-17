import Foundation

protocol AlertPresenterProtocol:AnyObject {
    func showAlert(alertModel: AlertModel)
    func showEndGameAlert()
}
