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

        
        let obj = Doctors(Name: "Mariana Tenorio", Specialism: "Pediatria", ProfessionalID: "ASWQ1234", Location: "Algún lugar")
        doctors.append(obj)

    }
    
    func downloadDoctors(){
        getDoctors(callback: { listDoctors in
            self.doctors = listDoctors
            DispatchQueue.main.async {
                self.tblDoctors.reloadData()
            }
        })
        
    }
    
    
    let search = UISearchController(searchResultsController: nil)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl .addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        return refreshControl
    }()

    @objc func refresh(){
        self.refreshControl.endRefreshing()
        let obj = Doctors(Name: "Pedro Díaz", Specialism: "Cirujano", ProfessionalID: "1223ASD", Location: "Otro lugar")
        doctors.append(obj)
        self.refreshTable()
    }
    
    func refreshTable (){
        DispatchQueue.main.async {
            self.tblDoctors.reloadData()
        }
        
    }
}

extension DoctorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorsTableViewCell
        
        let objDoc:Doctors = doctors[indexPath.row]
        cell.lblName.text = objDoc.name
        cell.lblSpecialism.text = objDoc.specialism
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controlador = story.instantiateViewController(identifier: "RecordAppointment")as! RecordAppointmentViewController
        self.present(controlador,animated: true, completion: nil)
        
        let doctor:Doctors = doctors[indexPath.row]

        controlador.lblName.text = doctor.name
        controlador.lblProfessionalID.text = doctor.professionalID
        controlador.lblSpecialism.text = doctor.specialism
        controlador.lblLocation.text = doctor.location
        
        
    }
    
    
}
