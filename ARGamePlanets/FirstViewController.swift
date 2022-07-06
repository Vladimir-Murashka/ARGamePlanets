//
//  FirstViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 19.06.2022.
//

import UIKit
import AVFoundation

final class FirstViewController: UIViewController {

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

    @IBOutlet weak var videoLayer: UIView!
    
    @objc func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startARGame", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        setupViewController()
    }
    
    private func setupViewController() {
        view.addSubview(startButton)
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16)
        ])
    }
    
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "settings", sender: nil)
        let settingsViewController = SettingsViewController()

        navigationController?.pushViewController(settingsViewController, animated: true)
        //navigationController?.popViewController(animated: true)
        
    }

    func playVideo() {
        
        guard let path = Bundle.main.path(forResource: "Earth", ofType: "mp4") else { return }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoLayer.bringSubviewToFront(startButton)
    }
}
