//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 27.04.2025.
//
import Foundation
import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func show(alert model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        
        alert.addAction(action)
        delegate?.didPresentAlert(controller: alert)
    }
}
