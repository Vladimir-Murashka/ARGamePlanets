//
//  SettingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//


import UIKit

final class SettingsViewController: UIViewController {
    
     let defaultsStorage: DefaultsStoragable = DefaultsStorage()
    
    
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var quitSettingGameButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitSettingsButtonPressed), for: .touchUpInside)
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
    
    private lazy var infoVibrationLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Вибрация"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infoSoundEffectsLable: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Звуковые эффекты"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infoMusicLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Музыка"
        label.backgroundColor = .black
        return label
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
   
    private lazy var vibrationSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        switcher.addTarget(self, action:  #selector(vibrationSwitcherChange), for: .valueChanged)
        return switcher
    }()
    
     private lazy var soundEffectsSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        switcher.addTarget(self, action: #selector(soundEffectsSwitcherChenge), for: .valueChanged)
        return switcher
    }()
    
    private lazy var musicSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.layer.cornerRadius = 15
        switcher.layer.masksToBounds = true
        switcher.backgroundColor = .black
        switcher.isOn = true
        switcher.addTarget(self, action: #selector(musicSwitcherChange), for: .valueChanged)
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
    
    @objc func vibrationSwitcherChange(_ sender: UISwitch) {
        defaultsStorage.saveObject(sender.isOn, for: .isVibrationOn)
        
    }
    
    @objc func soundEffectsSwitcherChenge(_ sender: UISwitch) {
        defaultsStorage.saveObject(sender.isOn, for: .isSoundEffect)
    }
    
    @objc func musicSwitcherChange(_ sender: UISwitch) {
        defaultsStorage.saveObject(sender.isOn, for: .isMusicOn)
    }
        
    @objc func quitSettingsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "quitSettingsScreen", sender: nil)
    }
    
    @objc func levelStepperPressed(_ sender: UIButton) {
        levelLable.text = "\(Int(levelStepper.value))"
        defaultsStorage.saveObject(levelStepper.value, for: .levelStepper)
    }
    
    private func setupSettingsViewController() {
        addSubviews()
        setupLayout()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let valueVibrationSwitcher = defaultsStorage.fetchObject(type: Bool.self, for: .isVibrationOn) ?? true
        vibrationSwitcher.isOn = valueVibrationSwitcher
        
        let valueMusicSwitcher = defaultsStorage.fetchObject(type: Bool.self, for: .isMusicOn) ?? true
        musicSwitcher.isOn = valueMusicSwitcher
        
        let valueSoundEffectsSwitcher = defaultsStorage.fetchObject(type: Bool.self, for: .isSoundEffect) ?? true
        soundEffectsSwitcher.isOn = valueSoundEffectsSwitcher
        
        let valuelevelStepper = defaultsStorage.fetchObject(type: Int.self, for: .levelStepper)
        levelStepper.value = Double(valuelevelStepper ?? 0) 
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(levelStackView)
        view.addSubview(vibrationStackView)
        view.addSubview(soundEffectsStackView)
        view.addSubview(commonSettigStackView)
        view.addSubview(musicStackView)
        view.addSubview(quitSettingGameButton)
        
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
            infoLevelLable.widthAnchor.constraint(equalToConstant: 200),
            levelLable.widthAnchor.constraint(lessThanOrEqualToConstant: 30),
            infoVibrationLable.widthAnchor.constraint(equalToConstant: 200),
            infoSoundEffectsLable.widthAnchor.constraint(equalToConstant: 200),
            infoMusicLable.widthAnchor.constraint(equalToConstant: 200),
            
            commonSettigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            commonSettigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonSettigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            quitSettingGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitSettingGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            quitSettingGameButton.heightAnchor.constraint(equalToConstant: 40),
            quitSettingGameButton.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
