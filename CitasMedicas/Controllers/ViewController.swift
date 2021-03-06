//
//  ViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 17/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPass: UIButton!
    
    @IBOutlet weak var lblBiometric: UILabel!
    @IBOutlet weak var btnBiometric: UIButton!
    
    var manageObjects:[NSManagedObject] = []
    let context = LAContext()
    var error:NSError?
    var strAlertMessage = String()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.btnLogin.roundButton()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AccessCredentials")
        
        fetchRequest.predicate = NSPredicate(format: "email != nil")
        let cantidad = try! managedContext.count(for: fetchRequest)
        
        if cantidad > 0 {
            do{
                print("\(cantidad)")
                manageObjects = try managedContext.fetch(fetchRequest)
                guard let email = manageObjects.first?.value(forKey: "email") as? String else { return }
                guard let password = manageObjects.first?.value(forKey: "password") as? String else { return }
                txtEmail.text = email
                txtPassword.text = password
                
            }catch let error as NSError{
                print("\(error.userInfo)")
            }
            
            //Verificación de sistemas biometricos en el dispositivo
            if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)){
                
                switch context.biometryType {
                case .faceID:
                    btnBiometric.setImage(UIImage(named: "faceID"), for: UIControl.State.normal)
                    self.strAlertMessage = "Desea Identificarse con Face ID."
                    self.lblBiometric.text = "Pulsa para autentificarte con Face ID."
                    break
                case .touchID:
                    btnBiometric.setImage(UIImage(named: "fingerID"), for: UIControl.State.normal)
                    self.strAlertMessage = "Desea Identificarse con Touch ID."
                    self.lblBiometric.text = "Pulsa para autentificarte con Touch ID."
                    
                    break
                case .none:
                    print("No hay nada")
                    break
                
                }
                
            }else {
                if let err = error {
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.notifiUser("ERROR", err: strMessage)
                }
            }
            
        }
        
        
    }
    //Función de verificación de Errores originados en la autentificación biometrica
    func errorMessage(errorCode: Int) -> String {
        var strMessage = ""
        switch errorCode {
        case LAError.authenticationFailed.rawValue :
            strMessage = "Authentication Failed"
            break
        case LAError.userCancel.rawValue :
            strMessage = "User Cancel"
            break
        case LAError.userFallback.rawValue :
            strMessage = "User Fallback"
            break
        case LAError.systemCancel.rawValue :
            strMessage = "System Cancel"
            break
        case LAError.passcodeNotSet.rawValue :
            strMessage = "Passcode not set"
            break
        case LAError.biometryNotAvailable.rawValue :
            strMessage = "Touch ID not available"
            break
        case LAError.appCancel.rawValue :
            strMessage = "Touch ID cancal by App"
            break
        case LAError.biometryLockout.rawValue :
            strMessage = "Lockout"
            break
        default:
            strMessage = "No biometric sensor"
                
        }
        return strMessage
    }
    
    
    //Función para la creación de alerta de Errores originados en la autentificación biometrica
    func notifiUser(_ msg:String , err:String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //Función para validar campos te texto vacios
    func validateEmpty() {
        guard let email = txtEmail.text, email != "",
            let password = txtPassword.text, password != "" else {
            self.createAlert(title: "ERROR", message: "Los campos no pueden estar vacios", messageBtn: "OK")
            return
        }
    }
    
    func recordUserCoreData(user:User){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserCore", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let password = txtPassword.text else { return }
        
        managedObject.setValue(user.photoFront, forKeyPath: "identification")
        managedObject.setValue(user.name, forKeyPath: "name")
        managedObject.setValue(user.firstLastName, forKeyPath: "firstLastName")
        managedObject.setValue(user.secondLastName, forKeyPath: "secondLastName")
        managedObject.setValue(user.birthday, forKeyPath: "birthday")
        managedObject.setValue(user.birthEntity, forKeyPath: "birthEntity")
        managedObject.setValue(user.email, forKeyPath: "email")
        managedObject.setValue(password, forKeyPath: "password")
        
        do{
            try managedContext.save()
            print("hecho")
        }catch let error as NSError{
            print("\(error.userInfo)")
        }
    }
    
    func sendToLogin(){
        //Validación de campos vacios
        self.validateEmpty()
       
        //Validación de campos de texto validos mediante RegEx
        guard let email = txtEmail.text, email.validEmail else {
            self.createAlert(title: "ERROR", message: "El correo electronico no puede ser de longitud mayor a 100 y debe contener @ y un dominio seguido de .com  ej. correo@mail.com", messageBtn: "OK")
            return
        }
        guard let password = txtPassword.text, password.validPassword else {
            self.createAlert(title: "ERROR", message: "La contraseña debe tener una longitud de entre 8 y 50 caracteres", messageBtn: "OK")
            return
        }
        //Se ejecuta función para consumo de servicio
        self.showActivityIndicatory(uiView: self.view)
        loginUser(email:email, pass: self.encryptPassword(password: password), callback: { result, message ,user in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if result{
                    self.users = user
                    self.recordUserCoreData(user: self.users.first!)
                   
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let controlador = story.instantiateViewController(identifier: "TabBar")as! TabBarViewController
                    controlador.action = 1
                    self.present(controlador,animated: true, completion: nil)
                } else {
                   self.createAlert(title: "ERROR", message: message, messageBtn: "OK")
                }
            }
        })
    }
    
    //Función de botón
    @IBAction func login(_ sender: Any) {
        self.sendToLogin()
    }
    
    //Función para mostrar contenido del campo contraseña
    @IBAction func showPassword(_ sender: UIButton) {
        if (txtPassword.isSecureTextEntry){
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            txtPassword.isSecureTextEntry = false
        }else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    
    //Función para autentificar al usuario mediante sistema biometrico
    @IBAction func identificar(_ sender: Any) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.strAlertMessage, reply: { [unowned self] (success, error) -> Void in
            DispatchQueue.main.async {
                if (success){
                    self.sendToLogin()
                }else{
                    if let error = error {
                        let strMessage = self.errorMessage(errorCode: error._code)
                        self.notifiUser("ERROR", err: strMessage)
                    }
                }
            }
        })
    }
    
}

