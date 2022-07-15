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
        button.backgroundColor = UIColor.clear
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        
        //performSegue(withIdentifier: "settings", sender: nil)
        let settingsViewController = SettingsViewController()
    
        navigationController?.pushViewController(settingsViewController, animated: true)
        //navigationController?.popViewController(animated: true)
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGame", sender: nil)
//        let startGameViewController = ViewController()
//        navigationController?.pushViewController(startGameViewController, animated: true)
    }
    
    private func setupViewController() {
        makePlayerLayer()
        addSubviews()
        setupLayout()
        player?.play()
    }
    
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

    private func addSubviews() {
        view.addSubview(startButton)
        view.addSubview(settingsButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16)
        ])
    }
}
    
