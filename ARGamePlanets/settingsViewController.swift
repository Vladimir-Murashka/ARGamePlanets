//
//  settingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//


import UIKit

final class SettingsViewController: UIViewController {
    
    private lazy var levelStepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsViewController()
    }
    
    private func setupSettingsViewController() {
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .green
    }
}
