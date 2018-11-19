//
//  ViewController.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MomentSavedProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var moments = [Moment]()
    var currentMoment: Moment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getMoments() {
        let options = API.sharedInstance.getMoments()
        if options.success {
            let dataMoments = options.data!
            moments.appendContentsOf(dataMoments)
            tableView.reloadData()
        } else {
            let alert = Utils.sharedInstance.createAlert("Alerta", message: options.error)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func didCreateMoment(data: Moment) {
        moments.append(data)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createMoment(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("createSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentMoment = moments[indexPath.row]
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("momentCell", forIndexPath: indexPath)
        let currentMoment = moments[indexPath.row]
        cell.textLabel?.text = Utils.sharedInstance.dateToString(currentMoment.date!)
        cell.detailTextLabel?.text = currentMoment.subject
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DetailViewController
        if segue.identifier == "detailSegue" {
            vc.creating = false
            vc.moment = currentMoment
            
        } else if segue.identifier == "createSegue" {
            vc.creating = true
            vc.delegate = self
        }
    }
    
    
    @IBAction func unwindToMoments(segue: UIStoryboardSegue) {}
}

