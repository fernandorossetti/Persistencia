//
//  Utils.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

struct Utils {
    static let sharedInstance = Utils()
    private let formater = NSDateFormatter()
    
    func createAlert(title: String, message: String?, handler: handlerAlert? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Aceptar", style: .Default, handler: handler)
        alert.addAction(action)
        return alert
    }
    
    func checkParams(fields: [UITextField]) -> Bool {
        for field in fields {
            if (field.text?.isEmpty)! {
                return false
            }
        }
        return true
    }
    
    func stringToDate(time: String) -> (success: Bool, date: NSDate?, error: String?) {
        formater.dateFormat = "yyyy-MM-dd"
        let date = formater.dateFromString(time)
        if date != nil {
            return (success: true, date: date!, error: nil)
        } else {
            return (success: false, date: nil, error: "Escribe una fecha correcta")
        }
    }
    
    func dateToString(time: NSDate) -> String {
        formater.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
        return formater.stringFromDate(time)
    }
    
    func getColor(name: String) -> UIColor {
        switch name {
        case "Amarillo":
            return UIColor.yellowColor()
        case "Azul":
            return UIColor.blueColor()
        case "Rojo":
            return UIColor.redColor()
        case "Magenta":
            return UIColor.magentaColor()
        case "Marron":
            return UIColor.brownColor()
        case "Naranja":
            return UIColor.orangeColor()
        case "Morado":
            return UIColor.purpleColor()
        case "":
            return UIColor.whiteColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    func putColor(view: UIView) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let savedColor = defaults.valueForKey("Color") as? String
        if savedColor != nil {
            view.backgroundColor = getColor(savedColor!)
        }
    }
}