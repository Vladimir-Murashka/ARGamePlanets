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
    
    private lazy var quitGameButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitGameButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var selectPlanet: Planet = .earth
    
    // Базовые функции
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
    
    @objc func quitGameButtonPressed(_ sender: UIButton) {
        sceneView.session.pause()

        AlertManager().showAlert(
            fromViewController: self,
            title: "Вы хотите выйти?",
            message: "Прогресс не будет сохранен!",
            firstButtonTitle: "Покинуть игру",
            firstActionBlock: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            secondTitleButton: "Продолжить") { [weak self] in
                let configuration = ARWorldTrackingConfiguration()
                self?.sceneView.session.run(configuration)
            }
    }
    
    private func setupViewController() {
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        addPlanets()
        
        view.addSubview(quitGameButton)
        
        NSLayoutConstraint.activate([
            quitGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            quitGameButton.heightAnchor.constraint(equalToConstant: 40),
            quitGameButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    // Добавление планет каждого типа.
    private func addPlanets() {
        let planets = Planet.allCases
        for planet in planets {
            addRandomPisitionPlanet(number: 5, planet: planet)
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
    // запуск при косании к экрану
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire(planet: selectPlanet)
    }
}

// обработка столкновений
extension ViewController: SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.name == contact.nodeB.name {
            DispatchQueue.main.async {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
            }
        }
    }
}

