//
//  QuickGameSettingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 09.08.2022.
//

import Foundation
import UIKit

final class QuickGameSettingsViewController: UIViewController {

    //MARK: SubViews
    lazy var timeLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = defaultsStorage.fetchObject(type: String.self, for: .timeLabelText)
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infoTimeLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Время раунда"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var startQuickGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startQuickGameButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var quitQuickSettingGameButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitQuickSettingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var levelLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(Int(levelStepper.value))"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infoLevelLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Уровень сложности"
        label.backgroundColor = .black
        return label
    }()
    
    lazy var timeStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 190
        stepper.minimumValue = 10
        stepper.value = Double(defaultsStorage.fetchObject(type: Int.self, for: .timeStepperValue) ?? 0)
        stepper.stepValue = 10
        stepper.backgroundColor = .black
        stepper.layer.cornerRadius = 8
        stepper.addTarget(self, action: #selector(timeStepperPressed), for: .valueChanged)
        return stepper
    }()
    
    lazy var levelStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 20
        stepper.minimumValue = 1
        stepper.value = Double(defaultsStorage.fetchObject(type: Int.self, for: .levelStepper) ?? 0)
        stepper.stepValue = 1
        stepper.backgroundColor = .black
        stepper.layer.cornerRadius = 8
        stepper.addTarget(self, action: #selector(levelStepperPressed), for: .valueChanged)
        return stepper
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var commonSettigStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    //MARK: PublicProperties
    let defaultsStorage: DefaultsStoragable = DefaultsStorage()

    //MARK: PrivateProperties

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsViewController()
        
    }
    
    //MARK: OverrideMethods

    //MARK: @objcFunc
    @objc func quitQuickSettingsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "quitStartQuickARGameSegue", sender: nil)
    }
    
    @objc func startQuickGameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGameSegue", sender: nil)
    }
    
    @objc func timeStepperPressed(_ sender: UIStepper) {
        //TODO: Работает но что то мне не нравится...)
        let timeStepperValue = Int(timeStepper.value)
        let seconds = timeStepperValue % 60
        let minutes = (timeStepperValue / 60) % 60
        let result = String(format: "%02d:%02d", minutes, seconds)
        timeLable.text = result
        defaultsStorage.saveObject(timeStepper.value, for: .timeStepperValue)
        defaultsStorage.saveObject(timeLable.text ?? "", for: .timeLabelText)
    }
    
    @objc func levelStepperPressed(_ sender: UIStepper) {
        levelLable.text = "\(Int(levelStepper.value))"
        defaultsStorage.saveObject(levelStepper.value, for: .levelStepper)
    }

    //MARK: PrivateFunc
    private func setupSettingsViewController() {
        addSubviews()
        setupLayout()
        //self.navigationItem.setHidesBackButton(true, animated: true)
        let valuelevelStepper = defaultsStorage.fetchObject(type: Int.self, for: .levelStepper)
        levelStepper.value = Double(valuelevelStepper ?? 0)
        
        let valueTimeStepper = defaultsStorage.fetchObject(type: Int.self, for: .timeStepperValue) ?? 0
        timeStepper.value = Double(valueTimeStepper)
        
        let timeLabelText = defaultsStorage.fetchObject(type: String.self, for: .timeLabelText)
        timeLable.text = timeLabelText
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(startQuickGameButton)
        view.addSubview(quitQuickSettingGameButton)
        view.addSubview(timeStackView)
        view.addSubview(levelStackView)
        view.addSubview(commonSettigStackView)
        
        timeStackView.addArrangedSubview(infoTimeLable)
        timeStackView.addArrangedSubview(timeLable)
        timeStackView.addArrangedSubview(timeStepper)
        
        levelStackView.addArrangedSubview(infoLevelLable)
        levelStackView.addArrangedSubview(levelLable)
        levelStackView.addArrangedSubview(levelStepper)
        
        commonSettigStackView.addArrangedSubview(timeStackView)
        commonSettigStackView.addArrangedSubview(levelStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            quitQuickSettingGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitQuickSettingGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            quitQuickSettingGameButton.heightAnchor.constraint(equalToConstant: 30),
            quitQuickSettingGameButton.widthAnchor.constraint(equalToConstant: 30),
            
            startQuickGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startQuickGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startQuickGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            infoTimeLable.widthAnchor.constraint(equalToConstant: 170),
            timeLable.widthAnchor.constraint(equalToConstant: 70),
            
            infoLevelLable.widthAnchor.constraint(equalToConstant: 170),
            levelLable.widthAnchor.constraint(equalToConstant: 30),
            
            commonSettigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            commonSettigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonSettigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

