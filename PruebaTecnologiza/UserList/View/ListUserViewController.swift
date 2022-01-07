//
//  ListUserViewController.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import UIKit

class ListUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
    }
    
    func prepareNavBar(){
        self.navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Usuarios"
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddRegister))
    }
    
    @objc func goToAddRegister(){
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
