//
//  settingsViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//


import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var backToFirstScreenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func settingsButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupSettingsViewController()
    }
    
    private func setupSettingsViewController() {
        view.addSubview(backToFirstScreenButton)
        
        NSLayoutConstraint.activate([
            backToFirstScreenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToFirstScreenButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            
        ])
        
    }
    
    
}
