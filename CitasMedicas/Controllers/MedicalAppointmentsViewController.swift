//
//  MedicalAppointmentsViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import CoreData

class MedicalAppointmentsViewController: UIViewController {
    @IBOutlet weak var tblAppointments: UITableView!
    var manageObjects:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblAppointments.delegate = self
        self.tblAppointments.dataSource = self
        self.tblAppointments.addSubview(refreshControl)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MedicalAppointment")
        
        do{
            manageObjects = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("\(error.userInfo)")
        }
        
    }
    
    let search = UISearchController(searchResultsController: nil)
    
    // Closure que permite definir una acción al hacer un deslizamiento de una tabla desde la vista superior.
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl .addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        return refreshControl
    }()
    // Función que ejecuta las acciones indicadas al hacer un deslizamiento de una tabla desde la vista superior.
    @objc func refresh(){
        // Termina el refresh de la tabla.
        self.refreshControl.endRefreshing()
        // Se carga nuevamente el contenido de datos en la tabla.
        self.refreshTable()
    }
    // Función para recargar los datos de la tabla.
    func refreshTable (){
        DispatchQueue.main.async {
            self.tblAppointments.reloadData()
        }
    }
    
}
// Extensión del Controller para agregar los protocolos de UITable.
extension MedicalAppointmentsViewController: UITableViewDataSource, UITableViewDelegate{
    // Función para establecer el número de celdas de la tabla.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.manageObjects.count
    }
     // Función donde se agregan los datos obtenidos del servicio en las celdas de la tabla.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppintmentsTableViewCell
        
        let obj = self.manageObjects[indexPath.row]
        guard let date = obj.value(forKey: "date")! as? String else {return cell}
        guard let time = obj.value(forKey: "time")! as? String else { return cell }
        guard let doctorName = obj.value(forKey: "doctorName")! as? String else { return cell }
        guard let doctorSpecialism = obj.value(forKey: "doctorSpecialism")! as? String else { return cell }
        
        cell.lblDateAppointments.text = "Fecha: \(date)"
        cell.lblTime.text = "Hora: \(time)"
        cell.lblDoctor.text = "Médico: \(doctorName) - \(doctorSpecialism)"
        return cell
    }
    // Función para agregar funciones especificas al deslizar una celda desde el lado derecho.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Se definen las caracteristicas de la acción que se quiere agregar.
        let eliminar = UITableViewRowAction(style: .normal, title: "Eliminar", handler: { (_, action) -> Void in
            
            // Se crea una alerta para notificar al usuario de la acción que se realizará.
            let ac = UIAlertController(title: "Eliminar", message: "¿Realmente desea eliminar este campo? Las citas eliminadas no se pueden recuperar", preferredStyle: .alert)
            let accion = UIAlertAction(title: "Eliminar", style: .default){ [unowned ac] _ in
                // Si se confirma la acción por el usuario qjecuta las sig. acciones.
                let obj = self.manageObjects[indexPath.row]
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedContext = appDelegate!.persistentContainer.viewContext
                managedContext.delete(obj)
                self.manageObjects.remove(at: indexPath.row)

                self.refreshTable()
            }
            // Se establece el botón para cancelar la acción
            let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            // Se agregan las acciones a la alerta.
            ac.addAction(accion)
            ac.addAction(btnCancelar)
            // Se presenta la alerta
            self.present(ac,animated: true)
            
        })
        // Se establece un color para la acción al deslizar la celda.
        eliminar.backgroundColor = UIColor.red
        
        // Se devuelve la acción creada para agregar a las celdas de la tabla.
        return [eliminar]
    }
}
