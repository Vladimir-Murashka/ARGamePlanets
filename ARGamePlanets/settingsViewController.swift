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
        stepper.maximumValue = 20
        stepper.minimumValue = 1
        stepper.value = 5
        stepper.stepValue = 1
        stepper.backgroundColor = .black
        stepper.layer.cornerRadius = 8
        stepper.addTarget(self, action: #selector(levelStepperPressed), for: .valueChanged)
        return stepper
    }()
    
    lazy var levelLable: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        label.text = "\(Int(levelStepper.value))"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infoLevelLable: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Уровень сложности"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var levelStackView: UIStackView = {
        let stackView = UIStackView()
        //stackView.spacing = 12
        //stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsViewController()
    }
    
    @objc func levelStepperPressed(_ sender: UIButton) {
        levelLable.text = "\(Int(levelStepper.value))"
    }
    
    private func setupSettingsViewController() {
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(levelStackView)
        
        levelStackView.addArrangedSubview(infoLevelLable)
        levelStackView.addArrangedSubview(levelLable)
        levelStackView.addArrangedSubview(levelStepper)
    }
    
    private func setupLayout() {
        view.backgroundColor = .gray
        
        NSLayoutConstraint.activate([
            levelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            levelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            levelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
