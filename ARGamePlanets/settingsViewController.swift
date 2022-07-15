//
//  SettingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//


import UIKit

final class SettingsViewController: UIViewController {
    
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var levelLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(Int(levelStepper.value))"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 30)
        ])
        return label
    }()
    
    private lazy var infoLevelLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Уровень сложности"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        return label
    }()
    
    private lazy var infoVibrationLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Вибрация"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        return label
    }()
    
    private lazy var infoSoundEffectsLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Звуковые эффекты"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        return label
    }()
    
    private lazy var infoMusicLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Музыка"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        return label
    }()
    
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
   
    private lazy var vibrationSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        return switcher
    }()
    
    private lazy var soundEffectsSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        return switcher
    }()
    
    private lazy var musicSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        return switcher
    }()
    
    private lazy var musicStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var soundEffectsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var vibrationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        view.addSubview(vibrationStackView)
        view.addSubview(soundEffectsStackView)
        view.addSubview(commonSettigStackView)
        view.addSubview(musicStackView)
        
        
        levelStackView.addArrangedSubview(infoLevelLable)
        levelStackView.addArrangedSubview(levelLable)
        levelStackView.addArrangedSubview(levelStepper)
        
        vibrationStackView.addArrangedSubview(infoVibrationLable)
        vibrationStackView.addArrangedSubview(vibrationSwitcher)
        
        soundEffectsStackView.addArrangedSubview(infoSoundEffectsLable)
        soundEffectsStackView.addArrangedSubview(soundEffectsSwitcher)
        
        musicStackView.addArrangedSubview(infoMusicLable)
        musicStackView.addArrangedSubview(musicSwitcher)
        
        commonSettigStackView.addArrangedSubview(levelStackView)
        commonSettigStackView.addArrangedSubview(vibrationStackView)
        commonSettigStackView.addArrangedSubview(soundEffectsStackView)
        commonSettigStackView.addArrangedSubview(musicStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            commonSettigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            commonSettigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonSettigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
