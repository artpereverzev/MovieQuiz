import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Project properties
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - App's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        setupUIDesign()
    }
    
    // MARK: - Actions related to buttons: YES & NO
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        presenter.noButtonClicked()
    }
    
    // MARK: - PRIVATE METHODS
    // MARK: - Method for additional UI setup, such as fonts, text, sizes etc.
    private func setupUIDesign() {
        DispatchQueue.main.async { [weak self] in
            self?.indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
            
            self?.questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
            
            self?.questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23.0)
            
            self?.filmImage.layer.masksToBounds = true
            self?.filmImage.layer.cornerRadius = 20
            
            self?.buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
            self?.buttonNo.layer.cornerRadius = CGFloat(15.0)
            
            self?.buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
            self?.buttonYes.layer.cornerRadius = CGFloat(15.0)
        }
    }
    
    // MARK: - Methods for changing current button statuses and temprarily disable them in button handlers
    private func disableButtons() {
        buttonYes.isEnabled = false
        buttonNo.isEnabled = false
    }
    
    private func enableButtons() {
        buttonYes.isEnabled = true
        buttonNo.isEnabled = true
    }
    
    private func disableButtonsTemporarily() {
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.enableButtons()
        }
    }
    
    // MARK: - PUBLIC METHODS
    // MARK: - Methods for showing different screen data
    func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        filmImage.image = step.image
        questionLabel.text = step.question
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "GameResult"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        action.accessibilityIdentifier = "AlertButton"

        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Method for showing network error
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Methods for showing network error
    // Method for reseting image border color after scenes
    func resetImageBorder() {
        DispatchQueue.main.async { [weak self] in
            self?.filmImage.layer.masksToBounds = true
            self?.filmImage.layer.borderWidth = 0
            self?.filmImage.layer.cornerRadius = 20
            self?.filmImage.layer.borderColor = .none
        }
    }
    
    // Method for showing right/wrong answer border colors
    func highlightImageBorder(isCorrectAnswer: Bool) {
        filmImage.layer.masksToBounds = true
        filmImage.layer.borderWidth = 8
        filmImage.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // MARK: - Activity Indicator
    // Methods for activity indicator (show or hide)
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.isHidden = false
            self?.activityIndicator?.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true
        }
    }
    
    
}
