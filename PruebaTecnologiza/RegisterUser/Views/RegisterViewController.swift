//
//  RegisterViewController.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//
protocol RegisterViewControllerDelegate: AnyObject {
    func reloadData()
}

import UIKit
import CoreLocation

class RegisterViewController: UIViewController {
    
    var imageSelected: UIImage?
    var dataImage: Data?
    var presenter = RegisterPresenter()
    weak var delegate: RegisterViewControllerDelegate?
    let managerLocation = CLLocationManager()
    var locationUser: CLLocation?
    let validityType: String.ValidateType = .email
    
    var nameUser = ""
    var lastNameUser = ""
    var cellPhoneUser = ""
    var emailUser = ""
    var coordinatesUser = ""
    var latitudeUser: Double?
    var longitudeUser: Double?
    
    @IBOutlet private weak var name: UITextField!
    @IBOutlet private weak var lastName: UITextField!
    @IBOutlet private weak var cellPhone: UITextField!
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var coordinates: UITextField!
    @IBOutlet private weak var imageUser: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCustom()
        configureUI()
    }
    
    func getLocationPhoto(){
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest
        managerLocation.delegate = self
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
    }
    
    func handleTextChange(textValid: UITextField) -> Bool {
        guard let text = textValid.text else { return false }
        if text.isValida(validityType) {
            return false
        } else {
            return true
        }
    }
    
    func validateTextFields() -> Bool{
        var validation = false
        guard let safeTextCell = cellPhone.text else { return false }
        if name.text == "" ||  lastName.text == "" || safeTextCell.count < 10 || handleTextChange(textValid: email) || imageUser.image == UIImage(named: "add-friend"){
            validation = false
        } else {
            validation = true
        }
        return validation
    }
    
    func configureUI(){
        imageUser.layer.cornerRadius = 7
        imageUser.clipsToBounds = true
        saveButton.layer.cornerRadius = 16
        coordinates.isEnabled = false
        name.delegate = self
        lastName.delegate = self
        cellPhone.delegate = self
        cellPhone.keyboardType = .numberPad
        email.delegate = self
    }
    
    func configCustom() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToCamera))
        imageUser.isUserInteractionEnabled = true
        imageUser.addGestureRecognizer(tap)
        if nameUser != ""  {
            name.isEnabled = false
            lastName.isEnabled = false
            cellPhone.isEnabled = false
            email.isEnabled = false
            imageUser.isUserInteractionEnabled = false
            saveButton.isHidden = true
            let button = UIBarButtonItem(image: UIImage(systemName: "map.fill")?.withTintColor(.white), style: .plain, target: self, action: #selector(goToMap))
            self.navigationItem.rightBarButtonItem = button
        }
        name.text = nameUser
        lastName.text = lastNameUser
        cellPhone.text = cellPhoneUser
        email.text = emailUser
        coordinates.text = coordinatesUser.description
        imageUser.image = nameUser == "" ? UIImage(named: "add-friend") : imageSelected
    }
    
    @objc func goToMap(){
        let vc = MapPhotoViewController()
        guard let safeLatitude = latitudeUser,
              let safeLongitude = longitudeUser else { return }
        let safeLocation = CLLocation(latitude: safeLatitude, longitude: safeLongitude)
        vc.renderMap(safeLocation)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
    }
    
    func configureViewWithData(data: RegisterRealm){
        nameUser = data.name
        lastNameUser = data.lastName
        cellPhoneUser = data.cellPhone
        emailUser = data.mail
        coordinatesUser = data.latitude.description + ", " + data.longitude.description
        latitudeUser = data.latitude
        longitudeUser = data.longitude
        guard let dataImage = data.image else { return }
        let imageUserData = UIImage(data: dataImage)
        imageSelected = imageUserData
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Datos incorretos", message: "Favor de llenar todos los datos correctamente", preferredStyle: .alert)
        let AlertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(AlertAction)
        present(alert, animated: true)
    }
    
    @IBAction func onClickRegisterUser(_ sender: Any) {
        
        if validateTextFields() {
            presenter.saveUser(name: name.text ?? "",
                               lastName: lastName.text ?? "",
                               cellPhone: cellPhone.text ?? "",
                               email: email.text ?? "",
                               image: dataImage ?? Data(),
                               latitude: latitudeUser ?? .zero,
                               longitude: longitudeUser ?? .zero)
            delegate?.reloadData()
            navigationController?.popViewController(animated: true)
        } else {
            showErrorAlert()
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.getLocationPhoto()
        self.imageSelected = image
        dataImage = image.pngData()
        imageUser.image = self.imageSelected
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            locationUser = location
            latitudeUser = locationUser?.coordinate.latitude
            longitudeUser = locationUser?.coordinate.longitude
            DispatchQueue.main.async {
                self.coordinates.text = (self.locationUser?.coordinate.latitude.debugDescription ?? "") + ", " + (self.locationUser?.coordinate.longitude.debugDescription ?? "")
            }
        }
    }
}
