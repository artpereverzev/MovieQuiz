//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 27.04.2025.
//
import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
