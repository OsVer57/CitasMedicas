//
//  RecordAppointmentViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class RecordAppointmentViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpecialism: UILabel!
    @IBOutlet weak var lblProfessionalID: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var pickAvailableSchedules: UIPickerView!
    @IBOutlet weak var btnRecordAppointment: UIButton!
    
    var selectedDoctor:Doctors?
    var dateFormatter = DateFormatter()
    var date:String = ""
    var time:String?
    let schedules:Set<String> = Constants.Strings.SCHEDULES
    var availableSchedules:Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        //self.time = Constants.Strings.SCHEDULES.sorted()[0]
        self.pickAvailableSchedules.delegate = self
        self.pickAvailableSchedules.dataSource = self
        
        guard let auxSelectedDoctor = selectedDoctor else { return }
        
        self.lblName.text = auxSelectedDoctor.name
        self.lblSpecialism.text = auxSelectedDoctor.specialism
        self.lblProfessionalID.text = auxSelectedDoctor.professionalID
        self.lblLocation.text = auxSelectedDoctor.location
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        print("today \(dateFormatter.string(from: self.calendar.today!))")
        //print("professionalID \(self.lblProfessionalID.text!)")
        self.date = "\(dateFormatter.string(from: self.calendar.today!))"
        
        self.downloadAvailableSchedules()
        btnRecordAppointment.roundButton()
    }
    
    // Función para obtener la lista de horarios disponibles de la base de datos.
    func downloadAvailableSchedules(){
        guard let professionalID = lblProfessionalID.text else { return }
        
        // Se muestra el indicador de actividades
        self.showActivityIndicatory(uiView: self.view)
        // Se ejecuta la función del consumo de sericio
        getAvailableSchedules(professionalID: professionalID, date: self.date , callback: { result, busySchedules in
            print(result)
            print(busySchedules)
            DispatchQueue.main.async {
                // Se detiene el indicador de actividades.
                self.hideActivityIndicator(uiView: self.view)
                if (result){
                    var busySchedulesString: Set<String> = []
                    for auxBusySchedules in busySchedules {
                        busySchedulesString.insert(auxBusySchedules.schedules)
                    }
                    print(busySchedulesString.count)
                    self.availableSchedules = self.schedules.subtracting(busySchedulesString)
                    
                    if (self.availableSchedules.count < 1){
                        self.time = ""
                        self.createAlert(title: "Sin horarios disponibles", message: "No quedan horarios disponibles para el \(self.date), intente seleccionar otro día.", messageBtn: "OK")
                        
                    }else{
                        self.time = self.availableSchedules.sorted().first
                    }
                    // Se cargan nuevamente los datos obtenidos de la consulta.
                    self.pickAvailableSchedules.reloadAllComponents()
                }else {
                    // Si no se devuelve verdadero se muestra el error.
                    self.createAlert(title: "ERROR", message: "No se pueden cargar los horarios disponibles para la fecha seleccionada.", messageBtn: "OK")
                }
            }
        })
        
    }
    
    @IBAction func recordAppointment(_ sender: Any) {
        guard let doctorName = lblName.text else { return }
        guard let doctorSpecialism = lblSpecialism.text else { return }
        guard let professionalID = lblProfessionalID.text else { return }
        
        guard let auxTime = time, auxTime != "" else {
            self.createAlert(title: "ERROR", message: "No se puede agendar la cita por que no hay horarios disponibles para la fecha seleccionada.", messageBtn: "OK")
            return
        }
       
        let obj = Appointment(date: date, time: auxTime, doctorName: doctorName, doctorSpecialism: doctorSpecialism, professionalID: professionalID)
        print(obj)
        
        //self.showActivityIndicatory(uiView: self.view)
        self.recordAppointmentCoreData()
        // Se ejecuta la función para el consumo del servicio de registro de citas.
        registryAppointment(appointment: obj, callback: { result, message in
            DispatchQueue.main.async {
                // Se detiene el indicador de actividades.
                self.hideActivityIndicator(uiView: self.view)
                // Se evalua si el resultado devuelto por el servicio fue exitoso (true).
                if result{
                    // Se muestra mensaje de éxito.
                    let alert = UIAlertController(title: "Cita agendada", message: "Los datos se han ingresado correctamente.", preferredStyle: .alert)
                    let guardar = UIAlertAction(title: "Ver Citas", style: .default, handler: {
                        (action:UIAlertAction) -> Void in
                                                    
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controlador = story.instantiateViewController(identifier: "TabBar")as! TabBarViewController
                        self.present(controlador,animated: true, completion: nil)
                    })
                    
                    let cancelar = UIAlertAction(title: "Agendar otra cita", style: .default)
                    {(action: UIAlertAction) -> Void in }
                    
                        alert.addAction(guardar)
                        alert.addAction(cancelar)
                        
                    self.present (alert, animated: true, completion: nil)

                } else {
                    // Si no se devuelve verdadero se muestra el error.
                    self.createAlert(title: "ERROR", message: message, messageBtn: "OK")
                }
            }
        })
    }
    
    func recordAppointmentCoreData(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MedicalAppointment", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        guard let doctorName = lblName.text else { return }
        guard let doctorSpecialism = lblSpecialism.text else { return }
        
        managedObject.setValue(doctorName, forKeyPath: "doctorName")
        managedObject.setValue(doctorSpecialism, forKeyPath: "doctorSpecialism")
        managedObject.setValue(date, forKeyPath: "date")
        managedObject.setValue(time, forKeyPath: "time")
        
        do{
            try managedContext.save()
            print("hecho")
        }catch let error as NSError{
            print("\(error.userInfo)")
        }
    }
}

extension RecordAppointmentViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("didSelect \(dateFormatter.string(from: date))")
        self.date = "\(dateFormatter.string(from: date))"
        self.downloadAvailableSchedules()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return calendar.today!

    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: calendar.today!)
        
        var maxDateComponents = DateComponents()
        maxDateComponents.day = calendarDate.day! + 13
        maxDateComponents.month = calendarDate.month!
        maxDateComponents.year = calendarDate.year!

        let maxDate = Calendar(identifier: Calendar.Identifier.gregorian).date(from: maxDateComponents)
        
        return maxDate!
    }
    
}

extension RecordAppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableSchedules.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.availableSchedules.sorted()[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.time = self.availableSchedules.sorted()[row] as String
    }
    
    
}
