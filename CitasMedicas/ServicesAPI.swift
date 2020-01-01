//
//  ServicesAPI.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 24/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import Foundation

let baseUrl:String = "http://10.95.71.10:8086/agendaMedica/"
let urlPruebaLogin = "http://www.maggrupo.com/users/wsLogin"
let urlPruebaRegistro = "http://www.maggrupo.com/users/wsadd"
var config = URLSessionConfiguration.default
let session = URLSession(configuration: config)


func registryUser(user:User,callback: @escaping (Bool,String) -> ()){
    guard let url = URL(string: "\(baseUrl)registry") else { print("no se puede entrar a la url")
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

    //let params = ["username":"osver57@gmail.com","nombre":"Oscar","apellidos":"Vera Ortiz","password":"1holagg1","cumple":"25/12/1994","genero":"1","busca":"2","perfil":"1"]
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

func loginUser(email:String, pass:String ,callback: @escaping (Bool,String) -> ()){
    guard let url = URL(string: "\(baseUrl)login") else {return}
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
            return
        }
        guard let message = json["message"] as? String else { return }
        if operationCode == "1" {
            callback(true, message)
            print("Exito")
            
        }
        else {
            callback(false, message)
            print("Error")
        }
    }
    task.resume()
}

func getDoctors(callback: @escaping ([Doctors]) -> ()){
    guard let url = URL(string: "\(baseUrl)doctors") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let params:[String:String] = ["":""]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
    request.httpBody = httpBody
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil else {
            print ("error: \(error)")
            return
        }
        guard let content = data else{
            print("no data")
            return
        }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? [Dictionary<String,Any>]
            {
                var result = [Doctors]()
                for doctor in jsonArray {
                    result.append(Doctors(dictionary: doctor))
                }
                callback(result)
            }else {
                print ("bad json")
            }
        }catch let error as NSError {
            print(error)
        }
    }
    task.resume()
}
