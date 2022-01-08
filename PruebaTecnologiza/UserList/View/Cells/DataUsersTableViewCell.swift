//
//  DataUsersTableViewCell.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 07/01/22.
//

import UIKit

class DataUsersTableViewCell: UITableViewCell {
    
    static let identifier = "DataUsersTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var registerIndexLabel: UILabel!
    @IBOutlet weak var cellPhoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareCells(data: RegisterRealm, index: Int){
        nameLabel.text = data.name + " " + data.lastName
        registerIndexLabel.text = "Registro \(index.description)"
        cellPhoneLabel.text = data.cellPhone
        emailLabel.text = data.mail
        latitudeLabel.text = data.latitude.description
        longitudeLabel.text = data.longitude.description
    }
}
