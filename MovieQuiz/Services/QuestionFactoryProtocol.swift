//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 26.04.2025.
//

protocol QuestionFactoryProtocol {
    var isDataLoaded: Bool { get set }
    
    func requestNextQuestion()
    func loadData()
}
