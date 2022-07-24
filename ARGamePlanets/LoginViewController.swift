//
//  LoginViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 24.07.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    //MARK: SubViews
    private lazy var imageViewBackgroundScreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "registerBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var quitButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Email"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Введите email адрес"
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "Пароль"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Введите пароль"
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        return textField
    }()
   
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var commonLoginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: @objcFunc
    
    @objc
    func loginButtonPressed() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "gameAfterLogin", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Ошибка", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc
    func quitButtonPressed() {
        performSegue(withIdentifier: "quitLogin", sender: nil)
    }
    
    //MARK: PrivateFunc
    private func setupViewController() {
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubview(imageViewBackgroundScreen)
        view.addSubview(emailStackView)
        view.addSubview(passwordStackView)
        view.addSubview(commonLoginStackView)
        view.addSubview(loginButton)
        view.addSubview(quitButton)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        commonLoginStackView.addArrangedSubview(emailStackView)
        commonLoginStackView.addArrangedSubview(passwordStackView)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            imageViewBackgroundScreen.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageViewBackgroundScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageViewBackgroundScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageViewBackgroundScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 25),
            passwordTextField.heightAnchor.constraint(equalToConstant: 25),
            
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            commonLoginStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            commonLoginStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonLoginStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            quitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            quitButton.heightAnchor.constraint(equalToConstant: 30),
            quitButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
