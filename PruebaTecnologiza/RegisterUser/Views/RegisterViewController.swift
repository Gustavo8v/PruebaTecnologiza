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
    
    func configureUI(){
        imageUser.layer.cornerRadius = 7
        imageUser.clipsToBounds = true
        saveButton.layer.cornerRadius = 16
        coordinates.isEnabled = false
        name.delegate = self
        lastName.delegate = self
        cellPhone.delegate = self
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
        imageUser.image = nameUser == "" ? UIImage(systemName: "person.fill") : imageSelected
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
    
    @IBAction func onClickRegisterUser(_ sender: Any) {
        presenter.saveUser(name: name.text ?? "",
                           lastName: lastName.text ?? "",
                           cellPhone: cellPhone.text ?? "",
                           email: email.text ?? "",
                           image: dataImage ?? Data(),
                           latitude: latitudeUser ?? .zero,
                           longitude: longitudeUser ?? .zero)
        delegate?.reloadData()
        navigationController?.popViewController(animated: true)
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
