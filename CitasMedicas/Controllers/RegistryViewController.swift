//
//  RegistryViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import CryptoKit

class RegistryViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFirstLastName: UITextField!
    @IBOutlet weak var txtSecondLastName: UITextField!
    @IBOutlet weak var pickDate: UIDatePicker!
    @IBOutlet weak var pickEntity: UIPickerView!
    @IBOutlet weak var sgmIdentification: UISegmentedControl!
    @IBOutlet weak var imgFront: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPassword2: UITextField!
    
    
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnShowPassword2: UIButton!
    @IBOutlet weak var btnRegistry: UIButton!
    

    @IBOutlet weak var photo1: UIButton!
    @IBOutlet weak var photo2: UIButton!
    
    @IBOutlet weak var galery1: UIButton!
    @IBOutlet weak var galery2: UIButton!
    
    let image: UIImagePickerController = UIImagePickerController()
    var bandera: Bool = false
    
    var identification:String?
    var dateFormatter = DateFormatter()
    var birthEntitypick:String?
    var activeField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.registerForKeyboardNotification()
        
        self.pickEntity.delegate = self
        self.pickEntity.dataSource = self
        
        self.image.delegate = self
        
        self.btnRegistry.roundButton()
        
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func willHideKeyboard(notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo else { return }

        let kbSize: CGSize = ((info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size)!
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if activeField != nil {
            if !aRect.contains((activeField?.frame.origin)!) {
                 self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    
    func validateEmpty() {
        guard let name = txtName.text, name != "",
            let firstLastName = txtFirstLastName.text, firstLastName != "",
            let secondLastName = txtSecondLastName.text, secondLastName != "",
            let email = txtEmail.text, email != "",
            let password = txtPassword.text, password != "" else {
            self.createAlert(title: "ERROR", message: "Los campos no pueden estar vacios.", messageBtn: "OK")
            return
        }
        guard let identification = sgmIdentification, identification.selectedSegmentIndex != -1 else {
            self.createAlert(title: "ERROR", message: "Debes seleccionar un tipo de identificación.", messageBtn: "OK")
            return
        }
    }
    
    @IBAction func selectIdentification(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.identification = "IFE"
            break
        case 1:
        self.identification = "INE"
            break
        default:
            self.identification = ""
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if (txtPassword.isSecureTextEntry){
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txtPassword.isSecureTextEntry = false
        }else {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func showPassword2(_ sender: UIButton) {
        if (txtPassword2.isSecureTextEntry){
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txtPassword2.isSecureTextEntry = false
        }else {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            txtPassword2.isSecureTextEntry = true
        }
    }
    
    @IBAction func registerUser(_ sender: Any) {
        self.dateFormatter.calendar = pickDate.calendar
        self.dateFormatter.dateFormat = "dd/MM/yyyy"

        self.validateEmpty()
        
        
        guard let name = txtName.text, name.validText else {
            self.createAlert(title: "ERROR", message: "El nombre no puede contener caracteres especiales y debe tener una longitud de entre 3 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard let firstLastName = txtFirstLastName.text, firstLastName.validText else {
            self.createAlert(title: "ERROR", message: "El apellido no puede contener caracteres especiales y debe tener una longitud de entre 3 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard let secondLastName = txtSecondLastName.text, secondLastName.validText else {
            self.createAlert(title: "ERROR", message: "El apellido no puede contener caracteres especiales y debe tener una longitud de entre 3 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard let email = txtEmail.text, email.validEmail else {
                  self.createAlert(title: "ERROR", message: "El correo electronico no puede ser de longitud mayor a 100 y debe contener @ y un dominio seguido de .com  ej. correo@mail.com", messageBtn: "OK")
                  return
              }
        
        guard let password = txtPassword.text, password.validPassword else {
            self.createAlert(title: "ERROR", message: "La contraseña debe tener una longitud de entre 8 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard let password2 = txtPassword2.text, password2.validPassword else {
            self.createAlert(title: "ERROR", message: "La contraseña debe tener una longitud de entre 8 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard password == password2 else {
            self.createAlert(title: "ERROR", message: "Las contraseñas deben coincidir.", messageBtn: "OK")
            return
        }
        guard let birthEntity = birthEntitypick else{ return }
        guard let identification = identification else { return }
        guard let imageFront = imgFront.image else { return }
        guard let imageBack = imgBack.image else { return }
        
        
        
        let obj = User(name: name, firstLastName: firstLastName, secondLastName: secondLastName, birthday: dateFormatter.string(from: pickDate.date), birthEntity: birthEntity, identification: identification, email: email, password: encryptPassword(password: password), photoFront: convertImageToStringBase64(img: imageFront), photoBack: convertImageToStringBase64(img: imageBack))
        //print(obj)
        registryUser(user: obj, callback: { result, message in
            DispatchQueue.main.async {
                if result{
                    let alert = UIAlertController(title: "Usuario registrado", message: "Los datos se han ingresado correctamente.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler:{ action in
                        
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controlador = story.instantiateViewController(identifier: "Login")as! ViewController
                        self.present(controlador,animated: true, completion: nil)
                        
                    } ))
                    self.present(alert,animated: true)
                } else {
                    self.createAlert(title: "ERROR", message: message, messageBtn: "OK")
                }
            }
        })
    }
    
    @IBAction func takePhoto1(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                image.allowsEditing = false
                image.sourceType = .camera
                image.cameraCaptureMode = .photo
                
                present(image, animated: true, completion: nil )
            }
        }else{
            self.createAlert(title: "Cámara no disponible", message: "La cámara no se pudo iniciar, pruebe selecionando una imagen de la galería.", messageBtn: "OK")
        }
        
        
    }
    @IBAction func takePhoto2(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                image.allowsEditing = false
                image.sourceType = .camera
                image.cameraCaptureMode = .photo
                
                present(image, animated: true, completion: nil )
            }
        }else{
            self.createAlert(title: "Cámara no disponible", message: "La cámara no se pudo iniciar, pruebe selecionando una imagen de la galería.", messageBtn: "OK")
        }
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        bandera = false
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            image.allowsEditing = false
            image.sourceType = .photoLibrary
                       
            present(image, animated: true, completion: nil )
        }
    }
    
    @IBAction func selectPhoto2(_ sender: Any) {
        bandera = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            image.allowsEditing = false
            image.sourceType = .photoLibrary
              
            present(image, animated: true, completion: nil )
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let imagenSeleccionada: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if bandera {
                imgBack.image = imagenSeleccionada
            }else if bandera == false {
                imgFront.image = imagenSeleccionada
            }
             if image.sourceType == .camera {
                 UIImageWriteToSavedPhotosAlbum(imagenSeleccionada, nil,nil,nil)
             }
         }
        image.dismiss(animated: true, completion: nil)
    }
    func convertImageToStringBase64 (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertStringBase64ToImage (imageString:String) -> UIImage{
        let imageData = Data.init(base64Encoded: imageString, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func encryptPassword(password:String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap {
            String(format: "%02x",$0)
        }.joined()
    }
    
}

extension RegistryViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Strings.BIRTH_ENTITY.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.Strings.BIRTH_ENTITY[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.birthEntitypick = Constants.Strings.BIRTH_ENTITY[row] as String
    }
    
    
}
