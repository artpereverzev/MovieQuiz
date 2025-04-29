import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Project properties
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    @IBOutlet private weak var filmImage: UIImageView!
    
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var statisticService: StatisticServiceProtocol?
    
    private var alertPresenter: AlertPresenter?
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    
    // MARK: - App life cycle starts here
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUIDesign()
        
        statisticService = StatisticService()
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - Actions related to buttons: YES & NO
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == true {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    // MARK: - Method for converting mock-data
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage(systemName: "questionmark.square.fill")!
        let convertResult = QuizStepViewModel(image: image,
                                              question: model.text,
                                              questionNumber: String(currentQuestionIndex + 1) + "/\(questionsAmount)")
        return convertResult
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    func didPresentAlert(controller: UIAlertController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(controller, animated: true)
        }
    }
    
    // MARK: - Methods for showing different screen data
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        filmImage.image = step.image
        questionLabel.text = step.question
    }
    
    // Method for handling next scene and showing right/wrong answer
    private func showAnswerResult(isCorrect: Bool) {
        filmImage.layer.masksToBounds = true
        filmImage.layer.borderWidth = 8
        filmImage.layer.cornerRadius = 20
        
        if isCorrect {
            filmImage.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            filmImage.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.showNextQuestionOrResults()
        }
    }
    
    // Method for handling data for the next scene or prepare final result with statistic info (alert)
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            let bestGame = statisticService.bestGame
            let message = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                //message: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.restartGame() }
            )
            
            // Calling method to store quiz result data for next usage in statistic
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            resetImageBorder()
            alertPresenter?.show(alert: alertModel)
            correctAnswers = 0
        } else {
            currentQuestionIndex += 1
            resetImageBorder()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Method for handling data for the next scene or prepare final result (alert)
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
    
    // MARK: - Methods for additional UI setup, such as fonts, text, sizes etc.
    private func setupUIDesign() {
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        indexLabel.text = "1/10"
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        questionTitleLabel.text = "Вопрос:"
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23.0)
        
        filmImage.layer.masksToBounds = true
        filmImage.layer.cornerRadius = 20
        
        buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        buttonNo.layer.cornerRadius = CGFloat(15.0)
        
        buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20.0)
        buttonYes.layer.cornerRadius = CGFloat(15.0)
    }
    
    private func resetImageBorder() {
        filmImage.layer.masksToBounds = true
        filmImage.layer.borderWidth = 0
        filmImage.layer.cornerRadius = 20
        filmImage.layer.borderColor = .none
    }
}
