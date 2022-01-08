//
//  RegisterPresenter.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import Foundation
import RealmSwift
import CoreLocation

class RegisterPresenter{
    
    let realm = try! Realm()
    var dataUser: RegisterRealm?
    
    func saveUser(name: String, lastName: String, cellPhone: String, email: String, image: Data, latitude: Double, longitude: Double){
        try! realm.write{
            let newUser = RegisterRealm()
            newUser.name = name
            newUser.lastName = lastName
            newUser.cellPhone = cellPhone
            newUser.mail = email
            newUser.latitude = latitude
            newUser.longitude = longitude
            newUser.image = image
            realm.add(newUser)
            dataUser = newUser
        }
    }
}
