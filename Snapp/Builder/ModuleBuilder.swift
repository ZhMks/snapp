//
//  ModuleBuilder.swift
//  Snapp
//
//  Created by Максим Жуин on 02.04.2024.
//

import UIKit

protocol ModuleBuilderProtocol {
   static func createModule() -> UIViewController
}

final class ModuleBuilder: ModuleBuilderProtocol {

  static  func createModule() -> UIViewController {
        let controller = FirstBoardingVC()
        let presenter = Presenter(view: controller)
        controller.presener = presenter
        return controller
    }


}
