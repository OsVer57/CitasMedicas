//
//  DoctorsViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit

class DoctorsViewController: UIViewController {

    @IBOutlet weak var tblDoctors: UITableView!
    var doctors:[Doctors] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblDoctors.delegate = self
        self.tblDoctors.dataSource = self
        self.tblDoctors.addSubview(refreshControl)
        self.downloadDoctors()
        
    }
    
    // Función para obtener la lista de doctores de la base de datos.
    func downloadDoctors(){
        // Se muestra el indicador de actividades
        self.showActivityIndicatory(uiView: self.view)
        // Se ejecuta la función del consumo de sericio
        getDoctors(callback: { result, listDoctors in
            DispatchQueue.main.async {
                // Se detiene el indicador de actividades.
                self.hideActivityIndicator(uiView: self.view)
                if (result){
                    self.doctors = listDoctors
                    // Se cargan nuevamente los datos obtenidos de la consulta.
                    self.tblDoctors.reloadData()
                }else {
                    // Si no se devuelve verdadero se muestra el error.
                    self.createAlert(title: "ERROR", message: "No se puede cargar el listado de doctores en este momento", messageBtn: "OK")
                }
            }
        })
        
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
        // Se ejecuta nuevamente la función downloadDoctors
        self.downloadDoctors()
        // Se carga nuevamente el contenido de datos en la tabla.
        self.refreshTable()
        
    }
    
    // Función para recargar los datos de la tabla.
    func refreshTable (){
        DispatchQueue.main.async {
            self.tblDoctors.reloadData()
        }
        
    }
}
// Extensión del Controller para agregar los protocolos de UITable.
extension DoctorsViewController: UITableViewDelegate, UITableViewDataSource {
    // Función para establecer el número de celdas de la tabla.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    // Función donde se agregan los datos obtenidos del servicio en las celdas de la tabla.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorsTableViewCell
        
        let objDoc:Doctors = doctors[indexPath.row]
        cell.lblName.text = objDoc.name
        cell.lblSpecialism.text = objDoc.specialism
        
        return cell
    }
    // Función que permite seleccionar una celda y enviar a la vista de 'agendar cita' con sus datos correspondientes.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controlador = story.instantiateViewController(identifier: "RecordAppointment")as! RecordAppointmentViewController
        //controlador.doc
        let doctor:Doctors = doctors[indexPath.row]
        controlador.selectedDoctor = doctor
        self.present(controlador,animated: true, completion: nil)
        
    }
}
