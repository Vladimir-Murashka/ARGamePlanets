//
//  AlertServise.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//

import Foundation
import UIKit

class MyAlert: UIViewController {
    

        
    
    
    
    func showAlert(with title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        return alert
    }
    
    func okAction() {
        
    }
    
    
    
    func dismissAlert() {
        
    }
    
}
