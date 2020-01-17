//
//  UserProfileViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFirstLastName: UITextField!
    @IBOutlet weak var txtSecondLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtbirthEntity: UITextField!
    
    @IBOutlet weak var imgIdentification: UIImageView!
    var manageObjects:[NSManagedObject] = []
    var password:String? = "12345678"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserCore")
       
        do{
            manageObjects = try managedContext.fetch(fetchRequest)
            for manageObject in manageObjects {
                self.password = manageObject.value(forKey: "password") as? String
                self.txtDate.text = manageObject.value(forKeyPath: "birthday") as? String
                self.txtbirthEntity.text = manageObject.value(forKeyPath: "birthEntity") as? String
                self.txtEmail.text = manageObject.value(forKeyPath: "email") as? String
                self.txtFirstLastName.text = manageObject.value(forKeyPath: "firstLastName") as? String
                self.txtSecondLastName.text = manageObject.value(forKeyPath: "secondLastName") as? String
                self.txtName.text = manageObject.value(forKeyPath: "name") as? String
                self.imgIdentification.image = self.convertStringBase64ToImage(imageString: manageObject.value(forKeyPath: "identification") as! String)
                
                
            }
            
        }catch let error as NSError{
            print("\(error.userInfo)")
        }
        
        

        
    }
    func validateExistentUser(){
        guard let email = self.txtEmail.text else { return }
        guard let pass = password else { return }
        
        // Se crea una alerta para notificar al usuario de la acción que se realizará.
        let alert = UIAlertController(title: "Guardar Cuenta", message: "¿Deseas guardar tu información para poder iniciar sesión más rapidamente?", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Si", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            self.clearUserCore()
            self.clearAccessCredentials()
            // Si se confirma la acción por el usuario ejecuta las sig. acciones.
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "AccessCredentials", in: managedContext)!
            let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            
            managedObject.setValue(email, forKeyPath: "email")
            managedObject.setValue(pass, forKeyPath: "password")
            
            do{
                try managedContext.save()
                
            }catch let error as NSError{
                print("\(error.userInfo)")
            }
                                        
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controlador = story.instantiateViewController(identifier: "Login")as! ViewController
            self.present(controlador,animated: true, completion: nil)
            
        })
        
        // Se establece el botón para no guardar
        let doNotSave = UIAlertAction(title: "No", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            self.clearUserCore()
            self.clearAccessCredentials()
                                        
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controlador = story.instantiateViewController(identifier: "Login")as! ViewController
            self.present(controlador,animated: true, completion: nil)
            
        })
        let c = UIAlertAction(title: "No Guardar", style: .default) { [unowned alert] _ in
            self.clearUserCore()
            self.clearAccessCredentials()
        }
        // Se establece el botón para cancelar la acción
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        // Se agregan las acciones a la alerta.
        alert.addAction(save)
        alert.addAction(doNotSave)
        alert.addAction(cancel)
        // Se presenta la alerta
        self.present(alert,animated: true)
    }
    func clearUserCore(){
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
         let managedContext = appDelegate!.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<UserCore>(entityName: "UserCore")
         
         do{
             self.manageObjects = try managedContext.fetch(fetchRequest)
             for manageObject in self.manageObjects {
                 managedContext.delete(manageObject)
             }
            try managedContext.save()
             
         }catch let error as NSError{
             print("\(error.userInfo)")
         }
    }
    func clearAccessCredentials(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<AccessCredentials>(entityName: "AccessCredentials")
        
        do{
            self.manageObjects = try managedContext.fetch(fetchRequest)
            for manageObject in self.manageObjects {
                managedContext.delete(manageObject)
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("\(error.userInfo)")
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        validateExistentUser()
    }
}
