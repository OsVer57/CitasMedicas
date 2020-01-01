//
//  Constants.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit

// Estructuras
struct Constants {
    struct Colors {
        static let defaultColor = UIColor(red: 79/255, green: 195/255, blue: 247/255, alpha: 1)
    }
    struct Strings {
        static let URL_BASE:String = "una url"
        static let BIRTH_ENTITY:[String] = ["Aguascalientes",
        "Baja California",
        "Baja California Sur",
        "Campeche",
        "Chiapas",
        "Chihuahua",
        "Coahuila",
        "Colima",
        "Ciudad de México",
        "Durango",
        "Estado de México",
        "Guanajuato",
        "Guerrero",
        "Hidalgo",
        "Jalisco",
        "Michoacán",
        "Morelos",
        "Nayarit",
        "Nuevo León",
        "Oaxaca",
        "Puebla",
        "Querétaro",
        "Quintana Roo",
        "San Luis Potosí",
        "Sinaloa",
        "Sonora",
        "Tabasco",
        "Tamaulipas",
        "Tlaxcala",
        "Veracruz",
        "Yucatán",
        "Zacatecas"]
    }
    
}


// Extensiones


// Extensión de String para definir Expresiones Regulares en la validación de TextField según su tipo de entrada.
extension String {
    var validEmail:Bool{
        let emailRegex = "[A-Za-z0-9\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:self)
    }
    var validPassword:Bool{
        let passwordRegex = "[A-Za-z0-9\\!$%&/()=?¿¡+*ç,;.:-_{}]{8,50}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    var validText:Bool{
        let textRegex = "(\\S[A-ZÑÁÉÍÓÚÜ\\sa-zñáéíóúü\\s]{3,50}[\\S])"
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegex)
        return textTest.evaluate(with: self)
        
    }
    var validOptionalText:Bool{
        let textRegex = "([A-ZÑÁÉÍÓÚÜ\\sa-zñáéíóúü\\s]{0,50})"
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegex)
        return textTest.evaluate(with: self)
        
    }
    var validNumber:Bool{
        let numRegex = "([0-9\\s]*)"
        let numTest = NSPredicate(format: "SELF MATCHES %@", numRegex)
        return numTest.evaluate(with: self)
        
    }
    
}

// Extensión UIButton.
extension UIButton{
    // Redondea los botones y cambia el color.
    func roundButton (){
        layer.cornerRadius = bounds.height / 2
        backgroundColor = Constants.Colors.defaultColor
        clipsToBounds = true
    }
}


// Extensión UIViewController
extension UIViewController{
    
    //Función que permite crear una alerta personalizada para mostrar mensajes de exito y error
    func createAlert (title:String , message:String, messageBtn:String) {
        let alert = UIAlertController (title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: messageBtn, style: .default, handler: nil))
        self.present(alert , animated: true , completion: nil)
    }
    
    //Función para agregar el gesto de tap y ocultar el teclado
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    // Función que oculta el teclado mediante
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Función para convertir imagenes a string base 64
    func convertImageToStringBase64 (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    // Función para convertir string base 64 en imagenes
    func convertStringBase64ToImage (imageString:String) -> UIImage{
        let imageData = Data.init(base64Encoded: imageString, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    // Función para encriptar contraseña con método SHA 256
    func encryptPassword(password:String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap {
            String(format: "%02x",$0)
        }.joined()
    }
    
}
