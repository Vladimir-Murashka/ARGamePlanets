//
//  FirstViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 19.06.2022.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var videoLayer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
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
