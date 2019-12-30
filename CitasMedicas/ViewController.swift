//
//  ViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 17/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPass: UIButton!
    
    @IBOutlet weak var lblBiometric: UILabel!
    @IBOutlet weak var btnBiometric: UIButton!
    
    let context = LAContext()
    var error:NSError?
    var strAlertMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.roundButton()
        
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)){
            
            switch context.biometryType {
            case .faceID:
                btnBiometric.setImage(UIImage(named: "faceID"), for: UIControl.State.normal)
                self.strAlertMessage = "Desea Identificarse con Face ID"
                self.lblBiometric.text = "Pulsa para autentificarte con Face ID"
                break
            case .touchID:
                btnBiometric.setImage(UIImage(named: "fingerID"), for: UIControl.State.normal)
                self.strAlertMessage = "Desea Identificarse con Touch ID"
                self.lblBiometric.text = "Pulsa para autentificarte con Touch ID"
                
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
    
    func notifiUser(_ msg:String , err:String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func validateEmpty() {
        guard let email = txtEmail.text, email != "",
            let password = txtPassword.text, password != "" else {
            self.createAlert(title: "ERROR", message: "Los campos no pueden estar vacios", messageBtn: "OK")
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueRegistro"{
            let controller = segue.destination 
        }
    }
    @IBAction func login(_ sender: Any) {
        
        self.validateEmpty()
        guard let email = txtEmail.text, email.validEmail else {
            self.createAlert(title: "ERROR", message: "El correo electronico no puede ser de longitud mayor a 100 y debe contener @ y un dominio seguido de .com  ej. correo@mail.com", messageBtn: "OK")
            return
        }
        guard let password = txtPassword.text, password.validPassword else {
            self.createAlert(title: "ERROR", message: "La contraseña debe tener una longitud de entre 8 y 50 caracteres", messageBtn: "OK")
            return
        }
        
        loginUser(email:email, pass:password, callback: { result, message in
            
            DispatchQueue.main.async {
                if result{
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controlador = story.instantiateViewController(identifier: "Doctors")
                        self.present(controlador,animated: true, completion: nil)
                } else {
                    self.createAlert(title: "ERROR", message: message, messageBtn: "OK")
                }
            }
        })
        
        
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
    
    @IBAction func identificar(_ sender: Any) {
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.strAlertMessage, reply: { [unowned self] (success, error) -> Void in
            DispatchQueue.main.async {
                if (success){
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let controlador = story.instantiateViewController(identifier: "TabBar")as! TabBarViewController
                    self.present(controlador,animated: true, completion: nil)
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

