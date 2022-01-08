//
//  ListUserViewController.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import UIKit

class ListUserViewController: UIViewController {
    
    @IBOutlet weak var listUserTableView: UITableView!
    
    var presenter = UserListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
        registerCell()
    }
    
    func registerCell(){
        listUserTableView.delegate = self
        listUserTableView.dataSource = self
        listUserTableView.register(UINib(nibName: DataUsersTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DataUsersTableViewCell.identifier)
    }
    
    func prepareNavBar(){
        self.navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Registros"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddRegister))
    }
    
    @objc func goToAddRegister(){
        let vc = RegisterViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.UserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: DataUsersTableViewCell.identifier, for: indexPath) as? DataUsersTableViewCell else { return UITableViewCell() }
        userCell.prepareCells(data: presenter.UserData[indexPath.row], index: indexPath.row + 1)
        userCell.selectionStyle = .none
        return userCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deleteIndex = presenter.UserData[indexPath.row]
        self.presenter.deleteUser(user: deleteIndex, table: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.configureViewWithData(data: presenter.UserData[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListUserViewController: RegisterViewControllerDelegate {
    func reloadData() {
        listUserTableView.reloadData()
    }
}
