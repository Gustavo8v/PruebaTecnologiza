//
//  RegisterRealm.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import Foundation
import RealmSwift
import CoreLocation

class RegisterRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""
    @objc dynamic var cellPhone = ""
    @objc dynamic var mail = ""
    //@objc dynamic var coordinates: CLLocation?
    @objc dynamic var latitude = Double()
    @objc dynamic var longitude = Double()
    @objc dynamic var image: Data?
}
