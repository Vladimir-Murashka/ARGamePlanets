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

    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "quitARGameSegue" else {
            return
        }
        
        guard segue.identifier == "quitSettingsScreen" else {
            return
        }
    }
    
    private var videoplayer: AVPlayer?
    var musicPlayer: AVAudioPlayer?
    
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
    
    lazy var infolevelLableText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Текущий уровень"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        return label
    }()
    
    lazy var infolevelLableValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(Int(SettingsViewController().levelStepper.value))"
        label.backgroundColor = .black
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsScreen", sender: nil)
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGameSegue", sender: nil)
    }
    
    private func setupViewController() {
        addSubviews()
        setupLayout()
        makePlayerLayer()
        videoplayer?.play()
       // playSound()
        //musicPlayer?.play()
    }
    
    private func makePlayerLayer() {
        guard let path = Bundle.main.path(forResource: "Earth", ofType: "mp4") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.videoplayer = player
        
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        videoLayer.layer.addSublayer(playerLayer)
        videoLayer.layer.repeatCount = 2
        //videoLayer.bringSubviewToFront(startButton)
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
        view.addSubview(startButton)
        view.addSubview(settingsButton)
        view.addSubview(infolevelStackView)
        
        infolevelStackView.addArrangedSubview(infolevelLableText)
        infolevelStackView.addArrangedSubview(infolevelLableValue)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            infolevelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infolevelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infolevelStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            infolevelStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
    
