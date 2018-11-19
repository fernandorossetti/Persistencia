//
//  DetailViewController.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

protocol MomentSavedProtocol {
    func didCreateMoment(data: Moment)
}

class DetailViewController: UIViewController{

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var subjectField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var creating: Bool = false
    var moment: Moment?
    
    var delegate: MomentSavedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.sharedInstance.putColor(self.view)
        createOrSee()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createMomento(sender: UIButton) {
        guard Utils.sharedInstance.checkParams([subjectField]) && textView.text != "" else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: "Necesitas llenar todos los campos")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let options = API.sharedInstance.createMoment(subjectField.text!, about: textView.text)
        if options.sucess {
            let alert = Utils.sharedInstance.createAlert("Completado", message: "Momento creado", handler: { (alert) in
                self.delegate?.didCreateMoment(options.data!)
                self.performSegueWithIdentifier("backToMoments", sender: self)
            })
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: options.error)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createOrSee() {
        createButton.enabled = creating
        createButton.hidden = !creating
        subjectField.enabled = creating
        textView.editable = creating
        
        if let momentObject = moment {
            textView.text = momentObject.about
            dateField.text = Utils.sharedInstance.dateToString(momentObject.date!)
            subjectField.text = momentObject.subject
        } else {
            dateField.text = Utils.sharedInstance.dateToString(NSDate())
        }
    }
}
