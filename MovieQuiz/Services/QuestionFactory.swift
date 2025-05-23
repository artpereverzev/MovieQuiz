//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 26.04.2025.
//
import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    var isDataLoaded: Bool = false
    
    init(moviesLoader: MoviesLoading) {
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                    self.isDataLoaded = true
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                    self.isDataLoaded = false
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let quizRating = Int.random(in: 6...9)
            
            let text = "Рейтинг этого фильма больше чем \(quizRating)?"
            let correctAnswer = rating > Float(quizRating)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
