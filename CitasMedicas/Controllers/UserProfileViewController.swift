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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserCore")
       
        do{
            manageObjects = try managedContext.fetch(fetchRequest)
            for manageObject in manageObjects {
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
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
