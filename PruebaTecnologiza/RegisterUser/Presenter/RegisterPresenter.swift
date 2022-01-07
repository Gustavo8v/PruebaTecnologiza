//
//  RegisterPresenter.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import Foundation
import RealmSwift

class RegisterPresenter{
    
    let realm = try! Realm()
    var dataUser: RegisterRealm?
    
    func saveUser(name: String, lastName: String, cellPhone: String, email: String, coordinates: String, image: Data){
        try! realm.write{
            let newUser = RegisterRealm()
            newUser.name = name
            newUser.lastName = lastName
            newUser.cellPhone = cellPhone
            newUser.mail = email
            newUser.coordinates = coordinates
            newUser.image = image
            realm.add(newUser)
            dataUser = newUser
        }
    }
}
