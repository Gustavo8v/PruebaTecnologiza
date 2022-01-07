//
//  RegisterViewController.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 06/01/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var imageSelected: UIImage?
    var dataImage: Data?
    var presenter = RegisterPresenter()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var cellPhone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var coordinates: UITextField!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCustom()
        configureUI()
    }
    
    func configureUI(){
        imageUser.layer.cornerRadius = 7
        imageUser.clipsToBounds = true
        saveButton.layer.cornerRadius = 16
        coordinates.isEnabled = false
    }
    
    func configCustom() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToCamera))
        imageUser.isUserInteractionEnabled = true
        imageUser.addGestureRecognizer(tap)
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
    
    @IBAction func onClickRegisterUser(_ sender: Any) {
        presenter.saveUser(name: name.text ?? "",
                           lastName: lastName.text ?? "",
                           cellPhone: cellPhone.text ?? "",
                           email: email.text ?? "",
                           coordinates: "prueba",
                           image: dataImage ?? Data())
    }
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.imageSelected = image
        dataImage = image.pngData()
        imageUser.image = self.imageSelected
    }
}
