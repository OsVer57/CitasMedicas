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
        static let SCHEDULES:Set<String> = Set(["10", "12", "15"])
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
        let textRegex = "(\\S[A-ZÑÁÉÍÓÚÜ\\sa-zñáéíóúü\\S]{3,50})"
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

//Contrucción de Activity Indicator para mostrar progresos
var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

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
    // Función para redimencionar las imagenes para almacenar en la base de datos.
    func resize (_ image:UIImage) -> UIImage {
        let ancho:CGFloat = image.size.width
        let alto:CGFloat = image.size.height
        let imgRelacion:CGFloat = ancho/alto
        let maximoAncho:CGFloat = 720
        let nuevoAlto:CGFloat = maximoAncho/imgRelacion
        let constanteCompresion:CGFloat = 0.5
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: maximoAncho, height: nuevoAlto)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imgData: Data = img.jpegData(compressionQuality: constanteCompresion)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imgData)!
    }
    
    // Función para mostrar indicador de actividad mientras se ejecuta un proceso tardado
    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(white: 0xffffff, alpha: 0.3)

        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    // Oculta el indicador de actividades
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
}
