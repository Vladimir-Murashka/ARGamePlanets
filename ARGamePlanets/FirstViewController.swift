//
//  FirstViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 19.06.2022.
//

import UIKit
import AVFoundation
import FirebaseCore
import FirebaseAuth

final class FirstViewController: UIViewController {
    
    @IBOutlet private weak var videoLayer: UIView!

    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
//        guard segue.identifier == "quitARGameSegue" else {
//            return
//        }
//
//        guard segue.identifier == "quitSettingsScreen" else {
//            return
//        }
    }
    
    private var videoPlayer: AVPlayer?
    private var musicPlayer: AVAudioPlayer?
    private let valueMusicSwitcher = SettingsViewController().defaultsStorage.fetchObject(type: Bool.self, for: .isMusicOn) ?? true
    
    private lazy var quitLoginButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "house.circle")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitLoginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var startQuickGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Быстрая игра", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startQuickGameButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var missionStartGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Миссия", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        //button.alpha = 0.5
        button.addTarget(self, action: #selector(missionStartGameButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Настройки", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var infolevelLableText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Текущий уровень"
        label.backgroundColor = .black
        return label
    }()
    
    //TODO - Наблюдатель или что-то подобное. Настройки label.text принимаются после перезапуска View что логично...
    lazy var infolevelLableValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(Int(SettingsViewController().levelStepper.value))"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infolevelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var commonButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsScreen", sender: nil)
        
    }
    
    @objc func startQuickGameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGameSegue", sender: nil)
    }
    
    @objc func quitLoginButtonPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            AlertManager().showAlert(fromViewController: self,
                                     title: "Внимание",
                                     message: "Выйти из аккаунта?",
                                     firstButtonTitle: "Выйти",
                                     firstActionBlock: {
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
                self.performSegue(withIdentifier: "quitToStartViewController", sender: nil)
            },
                                     secondTitleButton: "Продолжить") {
            }
        } else {
            self.performSegue(withIdentifier: "quitToStartViewController", sender: nil)
        }
    }
    
    @objc func missionStartGameButtonPressed(_ sender: UIButton) {
        
    }

    private func setupViewController() {
        addSubviews()
        setupLayout()
        makePlayerLayer()
        videoPlayer?.play()
        playSound()
        changeBackgroundColorQuitLoginButton()
        
        //TODO - Наблюдатель или что-то подобное. Настройки музыки принимаются после перезапуска View что логично...
        if valueMusicSwitcher == true {
            musicPlayer?.play()
        } else {
            musicPlayer?.pause()
        }
    }
    
    private func changeBackgroundColorQuitLoginButton() {
        if Auth.auth().currentUser != nil {
            missionStartGameButton.alpha = 1
            quitLoginButton.backgroundColor = .green
        } else {
            missionStartGameButton.alpha = 0.5
            quitLoginButton.backgroundColor = .white
        }
    }
    
    private func makePlayerLayer() {
        guard let path = Bundle.main.path(forResource: "Earth", ofType: "mp4") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
    
        self.videoPlayer = player
        
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        videoLayer.layer.addSublayer(playerLayer)
        videoLayer.layer.repeatCount = 2
        
        
        videoPlayer?.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem)
    }
    
    @objc
    func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "FirstViewControllerMusic", withExtension: "mp3") else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = musicPlayer else {
                return
            }
            player.play()
        } catch {
            fatalError()
        }
    }
    
    private func addSubviews() {
        view.addSubview(startQuickGameButton)
        view.addSubview(missionStartGameButton)
        view.addSubview(settingsButton)
        view.addSubview(infolevelStackView)
        view.addSubview(quitLoginButton)
        view.addSubview(commonButtonsStackView)
        
        commonButtonsStackView.addArrangedSubview(missionStartGameButton)
        commonButtonsStackView.addArrangedSubview(startQuickGameButton)
        
        infolevelStackView.addArrangedSubview(infolevelLableText)
        infolevelStackView.addArrangedSubview(infolevelLableValue)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            infolevelLableText.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            infolevelLableValue.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            commonButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commonButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commonButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            infolevelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infolevelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infolevelStackView.bottomAnchor.constraint(equalTo: commonButtonsStackView.topAnchor, constant: -20),
            infolevelStackView.heightAnchor.constraint(equalToConstant: 30),
            
            quitLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitLoginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            quitLoginButton.heightAnchor.constraint(equalToConstant: 30),
            quitLoginButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
    
