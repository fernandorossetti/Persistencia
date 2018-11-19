//
//  LoginViewController.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let colors =  ["", "Amarillo", "Azul", "Rojo", "Magenta", "Marron", "Naranja", "Morado"]
    var nameColor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.sharedInstance.putColor(self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: UIButton) {
        guard Utils.sharedInstance.checkParams([passwordField, emailField]) else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: "Necesitas llenar todos los campos")
             self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let data = API.sharedInstance.loginUser(emailField.text!, password: passwordField.text!)
        if self.isValidEmail(String(self.emailField.text)){
        if data.sucess {
            let alert = Utils.sharedInstance.createAlert("Completado", message: "Sesion iniciada", handler: { (alert) in
                self.performSegueWithIdentifier("toMomentsSegue", sender: self)
            })
            self.presentViewController(alert, animated: true, completion: nil)
            }
            }else
        {
            let alert = Utils.sharedInstance.createAlert("Error", message: "Campo Email invalido, recuerde usar @nombre.com")
            self.presentViewController(alert, animated: true, completion: nil)
            emailField.text = ""
            passwordField.text = ""
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.backgroundColor = Utils.sharedInstance.getColor(colors[row])
        nameColor = colors[row]
    }
    
    @IBAction func showColors(sender: UIBarButtonItem) {
        pickerView.hidden = false
        toolbar.hidden = false
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    @IBAction func donePickerColor(sender: UIBarButtonItem) {
        pickerView.hidden = true
        toolbar.hidden = true
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(nameColor, forKey: "Color")
    }
    
    @IBAction func goToRegister(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showRegisterSegue", sender: self)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}
