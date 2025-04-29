//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 27.04.2025.
//
import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didPresentAlert(controller: UIAlertController)
}
