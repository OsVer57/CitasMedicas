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
    var auxDate:Bool = false
    var time:String?
    let schedules:Set<String> = Constants.Strings.SCHEDULES
    var availableSchedules:Set<String> = []
    var folio:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.pickAvailableSchedules.delegate = self
        self.pickAvailableSchedules.dataSource = self
        
        guard let auxSelectedDoctor = selectedDoctor else { return }
        
        self.lblName.text = "Doctor: \(auxSelectedDoctor.name)"
        self.lblSpecialism.text = "Especialidad: \(auxSelectedDoctor.specialism)"
        self.lblProfessionalID.text = "Cédula: \(auxSelectedDoctor.professionalID)"
        self.lblLocation.text = "Ubicación: \(auxSelectedDoctor.location)"
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        print("today \(dateFormatter.string(from: self.calendar.today!))")
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
                    self.availableSchedules.insert("Selecciona una opción")
                    for i in self.schedules.subtracting(busySchedulesString) {
                        self.availableSchedules.insert(i)
                    }
                    //self.availableSchedules = self.schedules.subtracting(busySchedulesString)
                    
                    if (self.availableSchedules.count < 2){
                        self.time = ""
                        self.createAlert(title: "Sin horarios disponibles", message: "No quedan horarios disponibles para el \(self.date), intente seleccionar otro día.", messageBtn: "OK")
                        
                    }else{
                        self.time = self.availableSchedules.sorted(by: >).first
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
        guard let auxSelectedDoctor = selectedDoctor else { return }
        
        guard auxDate != false else {
            self.createAlert(title: "ERROR", message: "Por favor seleccione una fecha en el calendario para poder agendar la cita.", messageBtn: "OK")
            return
        }
        
        guard let auxTime = time, auxTime != "Selecciona una opción" else {
            self.createAlert(title: "ERROR", message: "Por favor seleccione un horario para poder agendar la cita.", messageBtn: "OK")
            return
        }
        guard time != "" else {
            self.createAlert(title: "ERROR", message: "No se puede agendar la cita por que no quedan horarios disponibles para la fecha selcionada.", messageBtn: "OK")
            return
        }
        
       
        let obj = Appointment(date: date, time: auxTime, doctorName: auxSelectedDoctor.name, doctorSpecialism: auxSelectedDoctor.specialism, professionalID: auxSelectedDoctor.professionalID)
        print(obj)
        
        self.showActivityIndicatory(uiView: self.view)
        // Se ejecuta la función para el consumo del servicio de registro de citas.
        registryAppointment(appointment: obj, callback: { result, folio, message in
            DispatchQueue.main.async {
                // Se detiene el indicador de actividades.
                self.hideActivityIndicator(uiView: self.view)
                // Se evalua si el resultado devuelto por el servicio fue exitoso (true).
                if result{
                    // Se muestra mensaje de éxito.
                    self.folio = folio
                    self.recordAppointmentCoreData()
                    let alert = UIAlertController(title: "Cita Registrada", message: "\(message). El numero de folio de su cita es: \(folio)", preferredStyle: .alert)
                    let guardar = UIAlertAction(title: "Ver Citas", style: .default, handler: {
                        (action:UIAlertAction) -> Void in
                                                    
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controlador = story.instantiateViewController(identifier: "TabBar")as! TabBarViewController
                        self.present(controlador,animated: true, completion: nil)
                        
                        controlador.action = 1
                    })
                    
                        alert.addAction(guardar)
                        
                        
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
        
        guard let auxSelectedDoctor = selectedDoctor else { return }
        
        managedObject.setValue(folio, forKeyPath: "folio")
        managedObject.setValue(auxSelectedDoctor.name, forKeyPath: "doctorName")
        managedObject.setValue(auxSelectedDoctor.specialism, forKeyPath: "doctorSpecialism")
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
        self.date = "\(dateFormatter.string(from: date))"
        self.auxDate = true
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
    func maxHour(for calendar: FSCalendar) -> Date {
        let calendarDate = Calendar.current.dateComponents([.hour], from: calendar.today!)
        
        var maxAppointmentHour = DateComponents()
        maxAppointmentHour.hour = calendarDate.hour!

        let maxDate = Calendar(identifier: Calendar.Identifier.gregorian).date(from: maxAppointmentHour)
        
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
        var auxMsg:String = ""
        if self.availableSchedules.sorted(by: >)[row] == "Selecciona una opción" {
            auxMsg = ""
        }else{
            auxMsg = ":00 hrs"
        }
        return "\(self.availableSchedules.sorted(by: >)[row])\(auxMsg)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = self.availableSchedules.sorted(by: >)[row] as String
        let index:String.Index = str.index(str.startIndex, offsetBy: 2)
        self.time = str.substring(to: index)
    }
    
    
}
