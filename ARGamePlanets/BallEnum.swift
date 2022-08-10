//
//  BallEnum.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 10.08.2022.
//

import UIKit

enum Ball: String, CaseIterable {
    case earth
    case jupiter
    case mars
    case mercury
    case moon
    case neptune
    
    var image: UIImage? {
        switch self {
        case .earth:
            return UIImage(named: "basketballBall.jpg")
        case .jupiter:
            return UIImage(named: "bBall.jpg")
        case .mars:
            return UIImage(named: "cBall.jpg")
        case .mercury:
            return UIImage(named: "soccerBall.jpg")
        case .moon:
            return UIImage(named: "tennisBall.jpg")
        case .neptune:
            return UIImage(named: "vBall.jpg")
        }
    }
}
