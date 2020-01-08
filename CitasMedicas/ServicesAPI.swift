//
//  ServicesAPI.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation

let baseUrl:String = "http://10.95.71.11:8080/agendaMedica/"
let urlPruebaLogin = "http://www.maggrupo.com/users/wsLogin"
let urlPruebaRegistro = "http://www.maggrupo.com/users/wsadd"
let urlPruebaRegistroImagen = "http://www.maggrupoempresarial.com/mygalery/insertarimg.php"

var config = URLSessionConfiguration.default
let session = URLSession(configuration: config)

// Registrar un nuevo usuario
func registryUser(user:User,callback: @escaping (Bool,String) -> ()){
    guard let url = URL(string: "\(baseUrl)registry") else { print("no se puede acceder al endpoint")
        return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let def = ""
    let params:[String:String] = ["email":"\(user.email)",
        "password":"\(user.password)",
        "name":"\(user.name)",
        "firstLastName":"\(user.firstLastName)",
        "secondLastName":"\(user.secondLastName ?? def )",
        "birthday":"\(user.birthday)",
        "birthEntity":"\(user.birthEntity)",
        "identification":"\(user.identification)",
        "userphotoFront": "\(user.photoFront)",
        "userphotoBack": "\(user.photoBack)"]
 
    //let params[String:String] = ["username":"osver57@gmail.com","nombre":"Oscar","apellidos":"Vera Ortiz","password":"1holagg1","cumple":"25/12/1994","genero":"1","busca":"2","perfil":"1"]
    
    //let params:[String:String] = ["nombre": "\(user.name)", "images": "\(user.name)", "imagebase": "\(user.photoFront)"]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil  else {
            print("Error : \(String(describing: error))")
            callback(false, "Tiempo de respuesta terminado.")
            
            return
        }
                
        guard let content = data else {
            
            print("No data")
            callback(false, "No data")
            return
        }
        
        if let datos = String(data: content, encoding: .utf8) {
            print(datos)
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String : Any] else {
            callback(false, "Error JSON Type")
            print("Error JSON Type")
            return
        }
        
        print("Registro User -> \(json)")
        
        
        guard let operationCode = json["operationCode"] as? String else {
            callback(false, "Operation code no recuperable")
            return
            
        }
        guard let message = json["message"] as? String else {
            callback(false, "Message no recuperable")
            return
            
        }
        if operationCode == "1" {
            callback(true, message)
            print("Exito en la operación")
            
        }
        else {
            callback(false, message)
            print("Error operation code != 1")
        }
        
        
        
    }

    task.resume()
}


// Inicio de sesión
func loginUser(email:String, pass:String ,callback: @escaping (Bool,String) -> ()){
    guard let url = URL(string: "\(baseUrl)login") else { print("no se puede acceder al endpoint")
        return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let params:[String:String] = ["email":"\(email)",
        "password":"\(pass)"]
    
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil  else {
            print("Error : \(String(describing: error))")
            callback(false, "Tiempo de respuesta terminado.")
            
            return
        }
        
        guard let content = data else {
            
            print("No data")
            callback(false, "No data")
            return
        }
        
        if let datos = String(data: content, encoding: .utf8) {
            print(datos)
        }
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String : Any] else {
            callback(false, "Error JSON Type")
            print("Error JSON Type")
            return
        }
        
        print("Login User -> \(json["operationCode"])")
        
        guard let operationCode = json["operationCode"] as? String else {
            callback(false, "Operation code no recuperable")
            return
            
        }
        guard let message = json["message"] as? String else {
            callback(false, "Mensaje de respuesta no recuperable")
            return
            
        }
        if operationCode == "1" {
            callback(true, message)
            print("Exito en la operación")
            
        }
        else {
            callback(false, message)
            print("Error operation code != 1")
        }
    }
    task.resume()
}


// Obtener listado de doctores
func getDoctors(callback: @escaping (Bool,[Doctors]) -> ()){
    var code = false
    var result = [Doctors]()
    guard let url = URL(string: "\(baseUrl)selection") else { print("no se puede entrar a la url")
        return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let params:[String:String] = [:]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print ("error: \(error)")
            callback(code, result)
            return
        }
        guard let content = data else{
            print("no data")
            callback(code, result)
            return
        }
        if let datos = String(data: content, encoding: .utf8) {
            print(datos)
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String : Any] else {
            print("Error JSON Type")
            callback(code, result)
            return
        }
        code = true
        for doctor in (json["doctorList"] as? [Dictionary<String,Any>])! {
            result.append(Doctors(dictionary: doctor))
        }
        callback(code, result)
                
    }
    task.resume()
}

// Registrar una cita nueva
func registryAppointment(appointment:Appointment,callback: @escaping (Bool,String) -> ()){
    guard let url = URL(string: "\(baseUrl)registry") else { print("no se puede acceder al endpoint")
        return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let def = ""
    let params:[String:String] = ["date":"\(appointment.date)",
        "time":"\(appointment.time)",
        "nameDoctor":"\(appointment.doctorName)",
        "specialism":"\(appointment.doctorSpecialism)"]
 
    //let params[String:String] = ["username":"osver57@gmail.com","nombre":"Oscar","apellidos":"Vera Ortiz","password":"1holagg1","cumple":"25/12/1994","genero":"1","busca":"2","perfil":"1"]
    
    //let params:[String:String] = ["nombre": "\(user.name)", "images": "\(user.name)", "imagebase": "\(user.photoFront)"]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil  else {
            print("Error : \(String(describing: error))")
            callback(false, "Tiempo de respuesta terminado.")
            
            return
        }
                
        guard let content = data else {
            
            print("No data")
            callback(false, "No data")
            return
        }
        
        if let datos = String(data: content, encoding: .utf8) {
            print(datos)
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String : Any] else {
            callback(false, "Error JSON Type")
            print("Error JSON Type")
            return
        }
        
        print("Registro User -> \(json)")
        
        
        guard let operationCode = json["operationCode"] as? String else {
            callback(false, "Operation code no recuperable")
            return
            
        }
        guard let message = json["message"] as? String else {
            callback(false, "Message no recuperable")
            return
            
        }
        if operationCode == "1" {
            callback(true, message)
            print("Exito en la operación")
            
        }
        else {
            callback(false, message)
            print("Error operation code != 1")
        }
        
        
        
    }

    task.resume()
}
