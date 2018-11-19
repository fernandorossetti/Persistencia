//
//  RegisterViewController.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var apellidosField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.sharedInstance.putColor(self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func register(sender: UIButton) {
        guard Utils.sharedInstance.checkParams([nameField, emailField, passwordField]) else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: "Necesitas llenar los campos nombre, email y password")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let data = API.sharedInstance.registerUser(nameField.text!, email: emailField.text!, password: passwordField.text!, date: dateField.text, last_name: apellidosField.text)
        if self.isValidEmail(String(self.emailField.text)){
        if data.sucess {
            let alert = Utils.sharedInstance.createAlert("Completado", message: "Registro exitoso", handler: { (alert) in
                self.performSegueWithIdentifier("backToLoginSegue", sender: self)
            })
            self.presentViewController(alert, animated: true, completion: nil)
            
            }
        }else
        {
            let alert = Utils.sharedInstance.createAlert("Error", message: "Campo Email invalido, recuerde usar @nombre.com")
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }

    
    
    
}
