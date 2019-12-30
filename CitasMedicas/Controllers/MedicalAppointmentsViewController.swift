//
//  MedicalAppointmentsViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit

class MedicalAppointmentsViewController: UIViewController {

    @IBOutlet weak var tblAppointments: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblAppointments.delegate = self
        self.tblAppointments.dataSource = self
        self.tblAppointments.addSubview(refreshControl)

        
        let obj = Appointment(date: "24/12/2019", time: "13:00", nameDoctor: "Oscar", specialism: "Cirujano")
        appointments.append(obj)
    }
    var appointments:Array<Appointment> = []
    
    let search = UISearchController(searchResultsController: nil)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl .addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        return refreshControl
    }()

    @objc func refresh(){
        self.refreshControl.endRefreshing()
        let obj = Appointment(date: "25/12/2019", time: "15:00", nameDoctor: "Mariana", specialism: "Pediatria")
        appointments.append(obj)
        self.refreshTable()
    }
    
    func refreshTable (){
        DispatchQueue.main.async {
            self.tblAppointments.reloadData()
        }
        
    }

    
    
}

extension MedicalAppointmentsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppintmentsTableViewCell
        
        let objAppontiment:Appointment = self.appointments[indexPath.row]
        cell.lblDateAppointments.text = "Fecha: \(objAppontiment.date)"
        cell.lblTime.text = "Hora: \(objAppontiment.time)"
        cell.lblDoctor.text = "Médico: \(objAppontiment.nameDoctor) - \(objAppontiment.specialism)"
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .normal, title: "Eliminar", handler: { (_, action) -> Void in
            
            let ac = UIAlertController(title: "Eliminar", message: "¿Realmente desea eliminar este campo? Las citas eliminadas no se pueden recuperar", preferredStyle: .alert)
            
            let accion = UIAlertAction(title: "Eliminar", style: .default){ [unowned ac] _ in
                self.appointments.remove(at: indexPath.row)
                self.refreshTable()
            }
            
            let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            ac.addAction(accion)
            ac.addAction(btnCancelar)
            self.present(ac,animated: true)
            
        })
        eliminar.backgroundColor = UIColor.red
        
        return [eliminar]
    }
        
    
    
}
