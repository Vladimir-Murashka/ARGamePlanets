//
//  StartViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 23.07.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

final class StartViewController: UIViewController {
    
    //MARK: SubViews
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "registerBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var startButtonWithoutRegister: UIButton = {
        let button = UIButton()
        button.setTitle("Играть без регистрации", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startButtonWithoutRegisterPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var singUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(singUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var commonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startGameCurrentUser", sender: nil)
        }
    }
    
    //MARK: @IBAction
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        
    }

    //MARK: @objcFunc
    
    @objc
    func startButtonWithoutRegisterPressed() {
        performSegue(withIdentifier: "startGameWithoutRegister", sender: nil)
    }
    
    @objc
    func loginButtonPressed() {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    @objc
    func singUpButtonPressed() {
        performSegue(withIdentifier: "singUp", sender: nil)
    }
    
    //MARK: PrivateFunc
    private func setupViewController() {
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(commonStackView)
        
        commonStackView.addArrangedSubview(startButtonWithoutRegister)
        commonStackView.addArrangedSubview(loginButton)
        commonStackView.addArrangedSubview(singUpButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            imageViewBackgroundScreen.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageViewBackgroundScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageViewBackgroundScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageViewBackgroundScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            commonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-16),
            commonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
