//
//  RegistryViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import CoreData

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
    var birthEntitypick:String = ""
    var activeField: UITextField?
    var today:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.registerForKeyboardNotification()
        
        self.birthEntitypick = Constants.Strings.BIRTH_ENTITY[0]
        self.pickEntity.delegate = self
        self.pickEntity.dataSource = self
        
        self.image.delegate = self
        
        self.imgFront.image?.accessibilityIdentifier = "defaultIdentificacion"
        self.imgBack.image?.accessibilityIdentifier = "defaultIdentificacion"
        
        // Se define el formato de fecha a utilizar.
        self.dateFormatter.calendar = pickDate.calendar
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
                
        today = self.dateFormatter.string(from: pickDate.date)
        
        self.btnRegistry.roundButton()
        
    }
    
    // Se agregan los observadores correspondientes para desplazar el contenido de un formulario cuando el teclado se muestra y para ocultarlo.
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Función para ajustar contenido cuando se oculta el teclado.
    @objc func willHideKeyboard(notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // Función para ajustar contenido cuando se muestra el teclado y este está por encima del campo de texto.
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
    
    // Función para validar que los campos de texto definidos no estén vacios.
    func validateEmpty() {
        guard let name = txtName.text, name != "" else {
            self.createAlert(title: "ERROR", message: "El nombre no puede estar vacio.", messageBtn: "OK")
            return
        }
        guard let firstLastName = txtFirstLastName.text, firstLastName != "" else {
            self.createAlert(title: "ERROR", message: "El apellido paterno no puede estar vacio.", messageBtn: "OK")
            return
        }
        guard let email = txtEmail.text, email != "" else {
            self.createAlert(title: "ERROR", message: "El correo electrónico no puede estar vacio.", messageBtn: "OK")
            return
        }
        guard let password = txtPassword.text, password != "" else {
            self.createAlert(title: "ERROR", message: "La contraseña no puede estar vacia.", messageBtn: "OK")
            return
        }
        guard let password2 = txtPassword2.text, password2 != "" else {
            self.createAlert(title: "ERROR", message: "La confirmación de contraseña no puede estar vacia.", messageBtn: "OK")
            return
        }
        guard let identification = sgmIdentification, identification.selectedSegmentIndex != -1 else {
            self.createAlert(title: "ERROR", message: "Debes seleccionar un tipo de identificación.", messageBtn: "OK")
            return
        }
        guard let photoFront = imgFront.image, photoFront.accessibilityIdentifier != "defaultIdentificacion" else {
            self.createAlert(title: "ERROR", message: "Debes agregar una foto frontal de tu identificación.", messageBtn: "OK")
            return
        }
        guard let photoBack = imgBack.image, photoBack.accessibilityIdentifier != "defaultIdentificacion" else {
            self.createAlert(title: "ERROR", message: "Debes agregar una foto trasera de tu identificación.", messageBtn: "OK")
            return
        }
        guard today !=  dateFormatter.string(from: pickDate.date) else {
            self.createAlert(title: "ERROR", message: "Debes seleccionar una fecha de nacimineto.", messageBtn: "OK")
            return
        }
        guard birthEntitypick != "Selecciona una opción" else {
            self.createAlert(title: "ERROR", message: "Debes seleccionar una entidad de nacimineto.", messageBtn: "OK")
            return
        }
        
    }
    
    // Función para saber el tipo de identificación que fue selecionada.
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
    
    // Funciones para mostrar el contenido de un campo de texto de tipo password.
    @IBAction func showPassword(_ sender: UIButton) {
        if (txtPassword.isSecureTextEntry){
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            txtPassword.isSecureTextEntry = false
        }else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBAction func showPassword2(_ sender: UIButton) {
        if (txtPassword2.isSecureTextEntry){
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            txtPassword2.isSecureTextEntry = false
        }else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txtPassword2.isSecureTextEntry = true
        }
    }
    
    // Función para registra un nuevo usuario.
    @IBAction func registerUser(_ sender: Any) {
        // Se valida que los campos obligatorios no se encuantren vacios.
        self.validateEmpty()
        
        // Se validad el formato de texto para cada campo de texto en el formulario
        guard let name = txtName.text, name.validText else {
            self.createAlert(title: "ERROR", message: "El nombre no puede contener caracteres especiales y debe tener una longitud de entre 3 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard let firstLastName = txtFirstLastName.text, firstLastName.validText else {
            self.createAlert(title: "ERROR", message: "El apellido paterno no puede contener caracteres especiales y debe tener una longitud de entre 3 y dsa50 caracteres.", messageBtn: "OK")
            return
        }
        guard let secondLastName = txtSecondLastName.text, secondLastName.validOptionalText else {
            self.createAlert(title: "ERROR", message: "El apellido materno no puede contener caracteres especiales y debe tener una longitud máxima de 50 caracteres.", messageBtn: "OK")
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
            self.createAlert(title: "ERROR", message: "La confirmación de contraseña debe tener una longitud de entre 8 y 50 caracteres.", messageBtn: "OK")
            return
        }
        guard password == password2 else {
            self.createAlert(title: "ERROR", message: "Las contraseñas deben coincidir.", messageBtn: "OK")
            return
        }
        guard let identification = identification else { return }
        guard let imageFront = imgFront.image else { return }
        guard let imageBack = imgBack.image else { return }
        
        let resizeImageFront = self.resize(imageFront)
        let resizeImageBack = self.resize(imageBack)
        
        // Se instancia el objeto de tipo 'User' para enviar por parametro a la función que ejecuta el consumo de servicio.
        let obj = User(Name: name, FirstLastName: firstLastName, SecondLastName: secondLastName, Birthday: dateFormatter.string(from: pickDate.date), BirthEntity: birthEntitypick, Identification: identification, Email: email, Password: self.encryptPassword(password: password), PhotoFront: self.convertImageToStringBase64(img: resizeImageFront), PhotoBack: self.convertImageToStringBase64(img: resizeImageBack))
        
        // Se muestra el indicador de actividades.
        self.showActivityIndicatory(uiView: self.view)
        
        // Se ejecuta la función para el consumo del servicio de registro de usuarios.
        registryUser(user: obj, callback: { result, message in
            DispatchQueue.main.async {
                // Se detien el indicador de actividades.
                self.hideActivityIndicator(uiView: self.view)
                
                // Se evalua si el resultado devuelto por el servicio fue exitoso (true).
                if result{
                    // Se muestra mensaje de éxito.
                    let alert = UIAlertController(title: "Usuario registrado", message: "\(message)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler:{ action in
                        
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controlador = story.instantiateViewController(identifier: "Login")as! ViewController
                        self.present(controlador,animated: true, completion: nil)
                        
                    } ))
                    self.present(alert,animated: true)
                } else {
                    // Si no se devuelve verdadero se muestra el error.
                    self.createAlert(title: "ERROR", message: message, messageBtn: "OK")
                }
            }
        })
    }
    
    // Funciónes para agregar una imagen de identificación desde la cámara
    @IBAction func takePhoto1(_ sender: Any) {
        bandera = false
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            image.allowsEditing = true
            image.sourceType = .camera
            image.cameraCaptureMode = .photo
            
            present(image, animated: true, completion: nil )
            
            
        }else{
            self.createAlert(title: "Cámara no disponible", message: "La cámara no se pudo iniciar, pruebe selecionando una imagen de la galería.", messageBtn: "OK")
        }
    }
    @IBAction func takePhoto2(_ sender: Any) {
        bandera = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            image.allowsEditing = true
            image.sourceType = .camera
            image.cameraCaptureMode = .photo
            
            present(image, animated: true, completion: nil )
            
            
        }else{
            self.createAlert(title: "Cámara no disponible", message: "La cámara no se pudo iniciar, pruebe selecionando una imagen de la galería.", messageBtn: "OK")
        }
    }
    
    // Funciónes para agregar una imagen de identificación desde la galería de imagenes.
    @IBAction func selectPhoto(_ sender: Any) {
        bandera = false
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            image.allowsEditing = true
            image.sourceType = .photoLibrary
                       
            present(image, animated: true, completion: nil )
        }
    }
    @IBAction func selectPhoto2(_ sender: Any) {
        bandera = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            image.allowsEditing = true
            image.sourceType = .photoLibrary
              
            present(image, animated: true, completion: nil )
        }
    }
    
    // Función que permite cargar el elemento seleccionado por la cámara o de la galería.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let imagenSeleccionada: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if image.sourceType == .camera && bandera {
                imgBack.image = imagenSeleccionada
                imgBack.image?.accessibilityIdentifier = "photoBack"
            }else if image.sourceType == .camera && bandera == false {
                imgFront.image = imagenSeleccionada
                imgFront.image?.accessibilityIdentifier = "photoFront"
            }else if image.sourceType == .photoLibrary && bandera {
                imgBack.image = imagenSeleccionada
                imgBack.image?.accessibilityIdentifier = "photoBack"
            }else if image.sourceType == .photoLibrary && bandera == false {
                imgFront.image = imagenSeleccionada
                imgFront.image?.accessibilityIdentifier = "photoFront"
            }
             
         }
        image.dismiss(animated: true, completion: nil)
    }
    
}

// Extensión del Controller para agregar los protocolos de UIPicker UIImagePicker y UINavigation
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
