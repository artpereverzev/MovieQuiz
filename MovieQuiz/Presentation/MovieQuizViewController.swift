import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Project properties
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    @IBOutlet private weak var filmImage: UIImageView!
    
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswers: Int = 0
    
    // Mock data init starts here
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // MARK: - App life cycle starts here
    override func viewDidLoad() {
        let currentQuestion = questions[currentQuestionIndex]
        let convertedModel = convert(model: currentQuestion)
        
        setupUIDesign()
        show(quiz: convertedModel)
        super.viewDidLoad()
    }
    
    // MARK: - Actions related to buttons: YES & NO
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        
        if questions[currentQuestionIndex].correctAnswer == false {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtonsTemporarily()
        
        if questions[currentQuestionIndex].correctAnswer == true {
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
                                              questionNumber: String(currentQuestionIndex + 1))
        return convertResult
    }
    
    // MARK: - Methods for showing different screen data
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber + "/10"
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    // Method for handling data for the next scene or prepare final result (alert)
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: ???/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            resetImageBorder()
            showFinalResults(quiz: viewModel)
            
            correctAnswers = 0
        } else {
            currentQuestionIndex += 1
            
            resetImageBorder()
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // Method for alert creation
    private func showFinalResults(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат \(correctAnswers)/10",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
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

// MARK: - Structures for quiz models: base, next step, results
struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
