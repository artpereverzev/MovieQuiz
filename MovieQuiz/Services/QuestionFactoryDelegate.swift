//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 27.04.2025.
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
