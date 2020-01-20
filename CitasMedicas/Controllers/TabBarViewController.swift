//
//  TabBarViewController.swift
//  CitasMedicas
//
//  Created by Macbook Pro on 27/12/19.
//  Copyright © 2019 Macbook Pro Oscar. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var action:Int?
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let showView = action else { return }
        print("tab bar selected index \(showView)")
        guard let tabBarControllerSelected = tabBarController else { return }
        print("\(tabBarControllerSelected.selectedIndex)")
        if showView  == 1{
            tabBarControllerSelected.selectedIndex = 1
        }else if showView == 2 {
            tabBarControllerSelected.selectedIndex = 2
        }else{
            tabBarControllerSelected.selectedIndex = 0
        }
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
