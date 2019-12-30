//
//  RecordAppointmentViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 23/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit
import FSCalendar

class RecordAppointmentViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpecialism: UILabel!
    @IBOutlet weak var lblProfessionalID: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var pickAvailableSchedules: UIPickerView!
    @IBOutlet weak var btnRecordAppointment: UIButton!
    
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        btnRecordAppointment.roundButton()
    }
    
    @IBAction func recordAppointment(_ sender: Any) {
       
    }
    

}

extension RecordAppointmentViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        print("didSelect \(dateFormatter.string(from: date))")
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
