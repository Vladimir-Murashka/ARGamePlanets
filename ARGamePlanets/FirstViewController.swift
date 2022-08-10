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
    
    //MARK: IBOutlets
    @IBOutlet private weak var videoLayer: UIView!
    
    //MARK: SubViews
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
        button.setTitle("Компания", for: .normal)
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
    
    private lazy var timeLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = QuickGameSettingsViewController().timeLable.text
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infolevelLableText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Текущий уровень"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infolevelLableValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(Int(QuickGameSettingsViewController().levelStepper.value))"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var infolevelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var commonInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
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
    
    //MARK: PrivateProperties
    private var videoPlayer: AVPlayer?
    private var musicPlayer: AVAudioPlayer?
    private let valueMusicSwitcher = SettingsViewController().defaultsStorage.fetchObject(type: Bool.self, for: .isMusicOn) ?? true
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    //MARK: IBActions
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard let sourseFirstViewController = segue.source as? QuickGameSettingsViewController else {
            return
        }
        self.infolevelLableValue.text = sourseFirstViewController.levelLable.text
        self.timeLable.text = sourseFirstViewController.timeLable.text
    }
    
    //MARK: @objcFunc
    @objc func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsScreen", sender: nil)
        
    }
    
    @objc func startQuickGameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startQuickARGameSegue", sender: nil)
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
    
    @objc
    func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }

    //MARK: PrivateFunc
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
        view.addSubview(infoTimeLable)
        view.addSubview(timeLable)
        view.addSubview(timeStackView)
        view.addSubview(commonInfoStackView)
        
        timeStackView.addArrangedSubview(infoTimeLable)
        timeStackView.addArrangedSubview(timeLable)
        
        infolevelStackView.addArrangedSubview(infolevelLableText)
        infolevelStackView.addArrangedSubview(infolevelLableValue)
        
        commonInfoStackView.addArrangedSubview(timeStackView)
        commonInfoStackView.addArrangedSubview(infolevelStackView)
        
        commonButtonsStackView.addArrangedSubview(missionStartGameButton)
        commonButtonsStackView.addArrangedSubview(startQuickGameButton)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            infolevelLableText.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            infolevelLableValue.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            infoTimeLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            timeLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            commonButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commonButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commonButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        
            timeStackView.heightAnchor.constraint(equalToConstant: 30),
            infolevelStackView.heightAnchor.constraint(equalToConstant: 30),
            
            commonInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commonInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commonInfoStackView.bottomAnchor.constraint(equalTo: commonButtonsStackView.topAnchor, constant: -20),
            
            
            quitLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitLoginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            quitLoginButton.heightAnchor.constraint(equalToConstant: 30),
            quitLoginButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
    
