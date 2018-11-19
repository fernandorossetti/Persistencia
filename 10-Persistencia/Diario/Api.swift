//
//  Api.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import CoreData
import UIKit

typealias handlerAlert = (alert: UIAlertAction) -> ()

struct API {
    
    static let sharedInstance = API()
    
    let context: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
    }
    
    func loginUser(email: String, password: String) -> (sucess: Bool, error: String?) {
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "email LIKE %@", email)
        
        let posibleError = "No existe el usuario o el password es incorrecto"
        
        do {
            let user = try context.executeFetchRequest(request) as! [User]
            guard user.count > 0 else {
                return (sucess: false, error: posibleError)
            }
            guard user[0].password! == password else {
                return (sucess: false, error: posibleError)
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(email, forKey: "Email")
            return (sucess: true, error: nil)
            
        } catch {
            return (sucess: false, error: "Hubo un error imprevisto")
        }
    }
    
    func registerUser(name: String, email: String, password: String, date: String?, last_name: String?) -> (sucess: Bool, error: String?) {
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "email LIKE %@", email)
        
        do {
            let user = try context.executeFetchRequest(request) as! [User]
            if user.count > 0 {
                return (sucess: false, error: "Este correo ya ha sido registrado")
            }
        } catch {
            return (sucess: false, error: "Hubo un error imprevisto")
        }
        
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        let user = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: context) as! User
        
        if let currentDate = date {
            let options = Utils.sharedInstance.stringToDate(currentDate)
            if options.success {
                user.birth_date = options.date!
            }
        }
        
        user.name = name
        user.email = email
        user.password = password
        user.last_name = last_name
        
        do {
            try context.save()
            return (sucess: true, error: nil)
        } catch {
            return (sucess: false, error: "No se pudo registrar el usuario")
        }
    }
    
    func createMoment(subject: String, about: String) -> (sucess: Bool, data: Moment?, error: String?){
        let defaults = NSUserDefaults.standardUserDefaults()
        let email = defaults.stringForKey("Email")!
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "email LIKE %@", email)
        let user: User
        
        do {
            let users = try context.executeFetchRequest(request) as! [User]
            guard users.count > 0 else {
                return (sucess: false, data: nil, error: "El usuario guardado ya no existe")
            }
            user = users.first!
        } catch {
            return (sucess: false, data: nil, error: "Hubo un error imprevisto")
        }
        
        let momentEntity = NSEntityDescription.entityForName("Momento", inManagedObjectContext: context)
        let moment = NSManagedObject(entity: momentEntity!, insertIntoManagedObjectContext: context) as! Moment
        
        moment.subject = subject
        moment.date = NSDate()
        moment.about = about
        moment.user = user
        
        do {
            try context.save()
            let moments = user.mutableSetValueForKey("momentos")
            moments.addObject(moment)
            return (sucess: true, data: moment, error: nil)
        } catch {
            return (sucess: false, data: nil, error: "Hubo un error imprevisto")
        }
    }
    
    func getMoments() -> (success: Bool, data: [Moment]?, error: String?) {
    let request = NSFetchRequest(entityName: "Momento")
        
        do {
            let data = try context.executeFetchRequest(request) as! [Moment]
            return (success: true, data: data, error: nil)
        } catch {
            return (success: false, data: nil, error: "No se pudieron obtener los datos")
        }
    }
}