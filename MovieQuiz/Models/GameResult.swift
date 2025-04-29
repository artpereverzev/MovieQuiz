//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 29.04.2025.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareResult(_ result: GameResult) -> Bool {
        correct > result.correct
    }
}
