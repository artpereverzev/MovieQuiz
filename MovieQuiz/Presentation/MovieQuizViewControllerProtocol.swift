//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 23.05.2025.
//
protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func resetImageBorder()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
} 
