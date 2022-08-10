//
//  SettingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//


import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: IBOutlets

    //MARK: SubViews
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
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitSettingsButtonPressed), for: .touchUpInside)
        return button
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

    //MARK: @objcFunc
    
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
    

    //MARK: PrivateFunc
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
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(vibrationStackView)
        view.addSubview(soundEffectsStackView)
        view.addSubview(commonSettigStackView)
        view.addSubview(musicStackView)
        view.addSubview(quitSettingGameButton)
        
        vibrationStackView.addArrangedSubview(infoVibrationLable)
        vibrationStackView.addArrangedSubview(vibrationSwitcher)
        
        soundEffectsStackView.addArrangedSubview(infoSoundEffectsLable)
        soundEffectsStackView.addArrangedSubview(soundEffectsSwitcher)
        
        musicStackView.addArrangedSubview(infoMusicLable)
        musicStackView.addArrangedSubview(musicSwitcher)
        
        commonSettigStackView.addArrangedSubview(vibrationStackView)
        commonSettigStackView.addArrangedSubview(soundEffectsStackView)
        commonSettigStackView.addArrangedSubview(musicStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            infoVibrationLable.widthAnchor.constraint(equalToConstant: 170),
            infoSoundEffectsLable.widthAnchor.constraint(equalToConstant: 170),
            infoMusicLable.widthAnchor.constraint(equalToConstant: 170),

            
            commonSettigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            commonSettigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonSettigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            quitSettingGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitSettingGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            quitSettingGameButton.heightAnchor.constraint(equalToConstant: 30),
            quitSettingGameButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
