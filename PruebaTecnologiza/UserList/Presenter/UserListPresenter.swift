//
//  UserListPresenter.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 07/01/22.
//

import Foundation
import RealmSwift
import UIKit

class UserListPresenter {
    
    var UserData = try! Realm().objects(RegisterRealm.self)
    let realm = try! Realm()
    
    func deleteUser(user: RegisterRealm, table: UITableView){
        try! realm.write{
            realm.delete(user)
        }
        table.reloadData()
    }
}
