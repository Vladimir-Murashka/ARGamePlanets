//
//  AlertServiсe.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 01.07.2022.
//

import UIKit

final class AlertManager {
    
    func showAlert(
        fromViewController viewController: UIViewController,
        title: String?,
        message: String?,
        firstButtonTitle: String?,
        firstActionBlock: (() -> Void)?,
        secondTitleButton: String?,
        secondActionBlock: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstButtonTitle, style: .default, handler: { _ in
            firstActionBlock?()
        })
        
        let secondAction = UIAlertAction(title: secondTitleButton, style: .default) { _ in
            secondActionBlock?()
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func showAlert(from viewController: UIViewController, alertModel: AlertModel) {
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: alertModel.preferredStyle
        )
        
        for actionModel in alertModel.actions {
            let action = UIAlertAction(title: actionModel.title, style: actionModel.style) { _ in
                actionModel.actionBlock?()
            }
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true)
    }
}

struct AlertModel {
    let title: String?
    let message: String?
    let preferredStyle: UIAlertController.Style
    let actions: [ActionModel]
}

struct ActionModel {
    let title: String?
    let style: UIAlertAction.Style
    let actionBlock: (() -> Void)?
}
