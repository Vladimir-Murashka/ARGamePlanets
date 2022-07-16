//
//  FirstViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 19.06.2022.
//

import UIKit
import AVFoundation

final class FirstViewController: UIViewController {
    
    @IBOutlet private weak var videoLayer: UIView!

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    let userDefaults = UserDefaults.standard
    
//    override func viewDidAppear(_ animated: Bool) {
//        soundEffectsSwitcher.isOn = userDefaults.bool(forKey: "soundEffectsSwitcher")
//        }
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGame", sender: nil)
        musicPlayer?.pause()
//        let startGameViewController = ViewController()
//        navigationController?.pushViewController(startGameViewController, animated: true)
    }
    
    private func setupViewController() {
        addSubviews()
        setupLayout()
        makePlayerLayer()
        player?.play()
        playSound()
        musicPlayer?.play()
    }
    
    private var player: AVPlayer?
    
    private func makePlayerLayer() {
        guard let path = Bundle.main.path(forResource: "Earth", ofType: "mp4") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.player = player
        
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        videoLayer.layer.addSublayer(playerLayer)
        videoLayer.layer.repeatCount = 2
        //videoLayer.bringSubviewToFront(startButton)
    }
    
     var musicPlayer: AVAudioPlayer?
    
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
        view.addSubview(startButton)
        view.addSubview(settingsButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20)
        ])
    }
}
    
