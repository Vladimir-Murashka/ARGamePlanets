//
//  ViewController.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 18.06.2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    private lazy var quitGameButton: UIButton = {
        let button = UIButton()
        let imageQuitGameButton = UIImage.init(systemName: "arrowshape.turn.up.left.circle.fill")
        button.setBackgroundImage(imageQuitGameButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quitGameButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func quitGameButtonPressed(_ sender: UIButton) {
        //sceneView.session.pause()
        let quitAlert = UIAlertController(title: "Вы хотите выйти?", message: "Прогресс не будет сохранен!", preferredStyle: .alert)
        quitAlert.addAction(UIAlertAction(title: "Покинуть игру", style: .cancel, handler: { (Action) in
            self.dismiss(animated: true, completion: nil)
        }))
        quitAlert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { (Action) in
            //let configuration = ARWorldTrackingConfiguration()
            //self.sceneView.session.run(configuration)
        }))
        self.present(quitAlert, animated: true, completion: nil)
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var aimVert: UIView!
    @IBOutlet weak var aimHor: UIView!
    @IBOutlet weak var changeFlag: UIImageView!
    
    @IBOutlet weak var earthButton: UIButton!
    @IBOutlet weak var jupiterButton: UIButton!
    @IBOutlet weak var marsButton: UIButton!
    @IBOutlet weak var mercuryButton: UIButton!
    @IBOutlet weak var moonButton: UIButton!
    @IBOutlet weak var neptuneButton: UIButton!
    
    
    private let planets = [
        UIImage(named: "earth.jpg")!,
        UIImage(named: "jupiter.jpg")!,
        UIImage(named: "mars.jpg")!,
        UIImage(named: "mercury.jpg")!,
        UIImage(named: "moon.jpg")!,
        UIImage(named: "neptune.jpg")!,
    ]
    
    private lazy var planetButtonsArray = [
        earthButton,
        jupiterButton,
        marsButton,
        mercuryButton,
        moonButton,
        neptuneButton
    ]

    
    @IBAction func earthButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    @IBAction func jupiterButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    @IBAction func marsButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    @IBAction func merceryButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    @IBAction func moonButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    @IBAction func neptuneButtonPressed(_ sender: UIButton) {
        method(sender)
    }
    
    // Базовые функции
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        addPlanets()
        setupViewController()
    }
    
    private func method(_ sender: UIButton) {
        for planetButton in planetButtonsArray {
            planetButton?.alpha = 0.5
        }
        sender.alpha = 1
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
    
    private func setupViewController() {
        view.addSubview(quitGameButton)
        
        NSLayoutConstraint.activate([
            quitGameButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quitGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            quitGameButton.heightAnchor.constraint(equalToConstant: 40),
            quitGameButton.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    //Создание планеты
    private func addPlanet(planet: UIImage, xPos: Float, yPos: Float, zPos: Float) {
        
        let sphere = SCNSphere(radius: 0.1)
        let planetNode = SCNNode()
        
        planetNode.geometry = sphere
        planetNode.position = SCNVector3(xPos, yPos, -1.5)
        
        switch planet {
        case planets[0]:
            planetNode.name = "earth"
        case planets[1]:
            planetNode.name = "jupiter"
        case planets[2]:
            planetNode.name = "mars"
        case planets[3]:
            planetNode.name = "mercury"
        case planets[4]:
            planetNode.name = "moon"
        default:
            planetNode.name = "neptune"
        }
        
        let material = SCNMaterial()
        material.diffuse.contents = planet
        material.locksAmbientWithDiffuse = true
        planetNode.geometry?.materials = [material]
        
        planetNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planetNode.physicsBody?.isAffectedByGravity = false
        planetNode.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
        planetNode.physicsBody?.contactTestBitMask = CollisionCategory.missleCategory.rawValue
        
        sceneView.scene.rootNode.addChildNode(planetNode)
    }
    
    //Рандомайзер
    private func randomPosition(from: Float, to: Float) -> Float{
        return Float(arc4random()) / Float(UInt32.max) * (from - to) + to
    }
    
    //Рандомное размещение планет (мешеней)
    func addRandomPisitionPlanet(number: Int, planet: UIImage) {
        for _ in 1...number {
            let xPos = randomPosition(from: -1.5, to: 1.5)
            let yPos = randomPosition(from: -1.5, to: 1.5)
            let zPos = randomPosition(from: -4, to: 0)
            
            addPlanet(planet: planet, xPos: xPos, yPos: yPos, zPos: zPos)
        }
    }
    // Добавление планет каждого типа.
    private func addPlanets() {
        for i in planets {
            addRandomPisitionPlanet(number: 5, planet: i)
        }
    }
    
    // Создание снаряда/пули
    private func createShot(materialShot: UIImage) -> SCNNode {
        let shot = SCNSphere(radius: 0.03)
        let shotNode = SCNNode()
        shotNode.geometry = shot
        shotNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shotNode.physicsBody?.isAffectedByGravity = false
        
        let material = SCNMaterial()
        material.diffuse.contents = materialShot
        material.locksAmbientWithDiffuse = true
        shotNode.geometry?.materials = [material]
        
        switch materialShot {
        case planets[0]:
            shotNode.name = "earth"
        case planets[1]:
            shotNode.name = "jupiter"
        case planets[2]:
            shotNode.name = "mars"
        case planets[3]:
            shotNode.name = "mercury"
        case planets[4]:
            shotNode.name = "moon"
        default:
            shotNode.name = "neptune"
        }
        
        shotNode.physicsBody?.categoryBitMask = CollisionCategory.missleCategory.rawValue
        shotNode.physicsBody?.contactTestBitMask = CollisionCategory.targetCategory.rawValue
        
        return shotNode
    }
    
    // Огонь
    private func fire(materalShot: UIImage) {
        let node = createShot(materialShot: materalShot)
        let (direction, position) = getUserVector()
        node.position = position
        let nodeDirection = SCNVector3(direction.x*4, direction.y*4, direction.z*4)
        node.physicsBody?.applyForce(nodeDirection, at: SCNVector3(0.1, 0, 0), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(node)
    }
    // поиск позиции и вектора устройства в прострвнстве
    private func getUserVector() -> (SCNVector3, SCNVector3){
        if let frame = self.sceneView.session.currentFrame{
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    // запуск при косании к экрану
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire(materalShot: changeFlag.image!)
    }
}

// обработка столкновений
extension ViewController: SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeA.name == contact.nodeB.name{
            DispatchQueue.main.async {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
            }
        }
    }
}

