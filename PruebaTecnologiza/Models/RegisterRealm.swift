//
//  RegisterRealm.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import Foundation
import RealmSwift

class RegisterRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""
    @objc dynamic var cellPhone = ""
    @objc dynamic var mail = ""
    @objc dynamic var coordinates = ""
    @objc dynamic var image: Data?
}
