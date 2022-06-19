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

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var earthUIImage: UIImageView!
    
    
    let planets = [
        UIImage(named: "earth.jpg")!,
        UIImage(named: "jupiter.jpg")!,
        UIImage(named: "mars.jpg")!,
        UIImage(named: "mercury.jpg")!,
        UIImage(named: "moon.jpg")!,
        UIImage(named: "neptune.jpg")!,
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        earthUIImage.layer.borderWidth = 1
//        earthUIImage.layer.masksToBounds = false
//        earthUIImage.layer.borderColor = UIColor.blue.cgColor
//        earthUIImage.layer.cornerRadius = earthUIImage.frame.height / 2
//        earthUIImage.clipsToBounds = true
        
        
        
    
        sceneView.delegate = self
        //sceneView.showsStatistics = true
    
        
        //let scene = SCNScene()
        addPlanets()
        //sceneView.scene = scene
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
        //Создание планеты
        func addPlanet(planet: UIImage, xPos: Float, yPos: Float, zPos: Float) {
            
            let sphere = SCNSphere(radius: 0.1)
            let planetNode = SCNNode()
            
            planetNode.geometry = sphere
            planetNode.position = SCNVector3(xPos, yPos, -1.5)
            
//            switch planet {
//            case planets[0]:
//                planetNode.name = "earth"
//            case planets[1]:
//                planetNode.name = "jupiter"
//            case planets[2]:
//                planetNode.name = "mars"
//            case planets[3]:
//                planetNode.name = "mercury"
//            case planets[4]:
//                planetNode.name = "moon"
//            default:
//                planetNode.name = "neptune"
//            }
            
            let material = SCNMaterial()
            material.diffuse.contents = planet
            material.locksAmbientWithDiffuse = true
            planetNode.geometry?.materials = [material]
            
            sceneView.scene.rootNode.addChildNode(planetNode)
        }
        
        //Рандомайзер
        func randomPosition(from: Float, to: Float) -> Float{
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
        // Добавление по 16 планет каждого типа.
            
            func addPlanets() {
                for i in planets {
                    addRandomPisitionPlanet(number: 5, planet: i)
                }
            }


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
