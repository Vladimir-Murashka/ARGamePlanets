//
//  ViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 18.06.2022.
//

import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var aimVert: UIView!
    @IBOutlet private weak var aimHor: UIView!
    @IBOutlet private weak var changeFlag: UIImageView!
    
    @IBOutlet private weak var earthButton: UIButton!
    @IBOutlet private weak var jupiterButton: UIButton!
    @IBOutlet private weak var marsButton: UIButton!
    @IBOutlet private weak var mercuryButton: UIButton!
    @IBOutlet private weak var moonButton: UIButton!
    @IBOutlet private weak var neptuneButton: UIButton!
    
    //MARK: SubViews
    private lazy var timerLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = SettingsViewController().timeLable.text
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberOfPlanetsOflabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(counter)"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var totalNumberOfPlanetsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "\(numberOfPlanets * numberOfPlanetsTypes)"
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var separatorNumbersOfPlanetsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "/"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var numbersOfPlanetsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var commonTopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var quitGameButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitGameButtonPressed), for: .touchUpInside)
        return button
    }()

    //MARK: PrivateProperties
    private let valueSoundEffectsSwitcher = SettingsViewController().defaultsStorage.fetchObject(type: Bool.self, for: .isSoundEffect) ?? true
    private let valueVibrationSwitcher = SettingsViewController().defaultsStorage.fetchObject(type: Bool.self, for: .isVibrationOn) ?? true
    private var audioPlayer = AVAudioPlayer()
    private var selectPlanet: Planet = .earth
    private var numberOfPlanets = Int(SettingsViewController().levelStepper.value)
    private let numberOfPlanetsTypes = 6
    private var counter = 0
    private var timer = Timer()
    private var count = SettingsViewController().timeStepper.value
    private var timerCounting = false

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: OverrideMethods
    // запуск при косании к экрану
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire(planet: selectPlanet)
    }
    
    //MARK: IBActions
    @IBAction func didTapPlanetButton(_ sender: UIButton) {
        let planetButtons = [
            earthButton,
            jupiterButton,
            marsButton,
            mercuryButton,
            moonButton,
            neptuneButton
        ]
        
        for planetButton in planetButtons {
            planetButton?.alpha = 0.5
        }
        sender.alpha = 1
        //TODO: - Работает но выглядит так себе...
        if sender == earthButton {
            selectPlanet = .earth
        } else if sender == jupiterButton {
            selectPlanet = .jupiter
        } else if sender == marsButton {
            selectPlanet = .mars
        } else if sender == mercuryButton {
            selectPlanet = .mercury
        } else if sender == moonButton {
            selectPlanet = .moon
        } else {
            selectPlanet = .neptune
        }
    }
    
    //MARK: @objcFunc
    @objc func quitGameButtonPressed(_ sender: UIButton) {
        sceneView.session.pause()
        startStopTimer()
        AlertManager().showAlert(
            fromViewController: self,
            title: "Вы хотите выйти?",
            message: "Прогресс не будет сохранен!",
            firstButtonTitle: "Покинуть игру",
            firstActionBlock: {
                self.performSegue(withIdentifier: "quitARGameSegue", sender: nil)
                
            },
            secondTitleButton: "Продолжить") { [weak self] in
                let configuration = ARWorldTrackingConfiguration()
                self?.sceneView.session.run(configuration)
                self?.startStopTimer()
            }
    }
    
    @objc func timerCounter() {
        count -=  1
        let time = secondsToHoursMinutesSeconds(seconds: Int(count))
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        timerLable.text = timeString
        
        if count == 0 {
            timer.invalidate()
            delayedAction()
        }
    }
    
    //MARK: PrivateFunc
    private func delayedAction() {
        AlertManager().showAlert(
            fromViewController: self,
            title: "Ай яй яй",
            message: "Время истекло",
            firstButtonTitle: "Попробовать еще раз",
            firstActionBlock: {
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode() }
                self.addPlanets()
                self.timerLable.text = SettingsViewController().timeLable.text
                self.reloadTimer()
                self.startStopTimer()
                self.startStopTimer()
                self.counter = 0
                self.numberOfPlanetsOflabel.text = "\(self.counter)"
            },
            secondTitleButton: "Выйти") {
                self.performSegue(withIdentifier: "quitARGameSegue", sender: nil)
            }
    }

    // Добавление планет каждого типа.
    private func addPlanets() {
        let planets = Planet.allCases
        for planet in planets {
            addRandomPisitionPlanet(number: numberOfPlanets, planet: planet)
        }
    }
    //Рандомное размещение планет (мешеней)
    private func addRandomPisitionPlanet(number: Int, planet: Planet) {
        for _ in 1...number {
            let xPos = randomPosition(from: -1.5, to: 1.5)
            let yPos = randomPosition(from: -1.5, to: 1.5)
            let zPos = randomPosition(from: -4, to: 0)
            
            addPlanet(planet: planet, xPos: xPos, yPos: yPos, zPos: zPos)
        }
    }
    //Рандомайзер
    private func randomPosition(from: Float, to: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (from - to) + to
    }
    //Создание планеты
    private func addPlanet(planet: Planet, xPos: Float, yPos: Float, zPos: Float) {
        let sphere = SCNSphere(radius: 0.1)
        let planetNode = SCNNode()
        
        planetNode.geometry = sphere
        planetNode.position = SCNVector3(xPos, yPos, -1.5)
        planetNode.name = planet.rawValue
        
        let material = SCNMaterial()
        material.diffuse.contents = planet.image
        material.locksAmbientWithDiffuse = true
        planetNode.geometry?.materials = [material]
        
        planetNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planetNode.physicsBody?.isAffectedByGravity = false
        planetNode.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
        planetNode.physicsBody?.contactTestBitMask = CollisionCategory.missleCategory.rawValue
        
        sceneView.scene.rootNode.addChildNode(planetNode)
    }
    // Выстрел
    private func fire(planet: Planet) {
        let node = createShot(planet: planet)
        let (direction, position) = getUserVector()
        node.position = position
        let nodeDirection = SCNVector3(direction.x*4, direction.y*4, direction.z*4)
        node.physicsBody?.applyForce(nodeDirection, at: SCNVector3(0.1, 0, 0), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(node)
    }
    // Создание снаряда/пули
    private func createShot(planet: Planet) -> SCNNode {
        let shot = SCNSphere(radius: 0.03)
        let shotNode = SCNNode()
        shotNode.geometry = shot
        shotNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shotNode.physicsBody?.isAffectedByGravity = false
        
        let material = SCNMaterial()
        material.diffuse.contents = planet.image
        material.locksAmbientWithDiffuse = true
        shotNode.geometry?.materials = [material]
        shotNode.name = planet.rawValue
        shotNode.physicsBody?.categoryBitMask = CollisionCategory.missleCategory.rawValue
        shotNode.physicsBody?.contactTestBitMask = CollisionCategory.targetCategory.rawValue
        
        return shotNode
    }
    // поиск позиции и вектора устройства в прострвнстве
    private func getUserVector() -> (SCNVector3, SCNVector3) {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    private func playEffects(named: String) {
        //TODO: Извлечение опционала, с упорством идиота не пойму.
        let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: named, ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
            audioPlayer.play()
        } catch {
        }
    }
    
    private func winLevel() {
        AlertManager().showAlert(
            fromViewController: self,
            title: "Поздравляем",
            message: "Уровень пройден",
            firstButtonTitle: "Следующий уровень",
            firstActionBlock: {
                //TODO: - обновить ViewConroller с новыми настройками numberOfPlanets
            },
            secondTitleButton: "Выйти") {
                self.performSegue(withIdentifier: "quitARGameSegue", sender: nil)
            }
    }
    
    // TODO: - Таймер вынести в менеджер, пока не пойму как передать label в @objc метод.
    private func reloadTimer() {
        count = SettingsViewController().timeStepper.value
    }
    
    private func startStopTimer() {
        if(timerCounting)
        {
            timerCounting = false
            timer.invalidate()
        }
        else
        {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }

    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    private func makeTimeString(minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }

    private func setupViewController() {
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        addSubviews()
        setupLayout()
        startStopTimer()
        addPlanets()
    }
    
    private func addSubviews() {
        view.addSubview(commonTopStackView)
        view.addSubview(timerLable)
        view.addSubview(quitGameButton)
        view.addSubview(numbersOfPlanetsStackView)
        
        numbersOfPlanetsStackView.addArrangedSubview(numberOfPlanetsOflabel)
        numbersOfPlanetsStackView.addArrangedSubview(separatorNumbersOfPlanetsLabel)
        numbersOfPlanetsStackView.addArrangedSubview(totalNumberOfPlanetsLabel)
        
        commonTopStackView.addArrangedSubview(quitGameButton)
        commonTopStackView.addArrangedSubview(timerLable)
        commonTopStackView.addArrangedSubview(numbersOfPlanetsStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            quitGameButton.heightAnchor.constraint(equalToConstant: 30),
            quitGameButton.widthAnchor.constraint(equalToConstant: 30),
            
            numbersOfPlanetsStackView.heightAnchor.constraint(equalToConstant: 30),
            numberOfPlanetsOflabel.widthAnchor.constraint(equalToConstant: 30),
            totalNumberOfPlanetsLabel.widthAnchor.constraint(equalToConstant: 30),
    
            timerLable.widthAnchor.constraint(equalToConstant: 80),
            timerLable.heightAnchor.constraint(equalToConstant: 30),
            
            commonTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            commonTopStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commonTopStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
}

// обработка столкновений
extension ViewController: SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.name == contact.nodeB.name {
            DispatchQueue.main.async {
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
                //TODO: - переодически счетчик +2... как то связано с муз. эффектами, без них работает исправно.
                self.counter += 1
                self.numberOfPlanetsOflabel.text = "\(self.counter)"
                if self.counter == self.numberOfPlanets * self.numberOfPlanetsTypes {
                    self.timer.invalidate()
                    self.winLevel()
                }
                if self.valueVibrationSwitcher == true {
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                }
                if self.valueSoundEffectsSwitcher == true {
                    self.playEffects(named: "contactPlanetSound")
                }
            }
        }
    }
}














