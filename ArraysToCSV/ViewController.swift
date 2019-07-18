//
//  ViewController.swift
//  ArraysToCSV
//
//  Created by Rohan Kevin Broach on 7/10/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
 
        
            
            let fileName = "\(currentCar.nickName).csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
            
            var csvText = "Make,Model,Nickname\n\(currentCar.make),\(currentCar.model),\(currentCar.nickName)\n\nDate,Mileage,Gallons,Price,Price per gallon,Miles between fillups,MPG\n"
            
            currentCar.fillups.sortInPlace({ $0.date.compare($1.date) == .OrderedDescending })
            
            let count = currentCar.fillups.count
            
            if count > 0 {
                
                for fillup in currentCar.fillups {
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                    let convertedDate = dateFormatter.stringFromDate(fillup.date)
                    
                    let newLine = "\(convertedDate),\(fillup.mileage),\(fillup.gallons),\(fillup.priceTotal),\(fillup.priceGallon),\(fillup.mileDelta),\(fillup.MPG)\n"
                    
                    csvText.appendContentsOf(newLine)
                }
                
                do {
                    try csvText.writeToURL(path, atomically: true, encoding: NSUTF8StringEncoding)
                    
                    if MFMailComposeViewController.canSendMail() {
                        let emailController = MFMailComposeViewController()
                        emailController.mailComposeDelegate = self
                        emailController.setToRecipients([])
                        emailController.setSubject("\(currentCar.nickName) data export")
                        emailController.setMessageBody("Hi,\n\nThe .csv data export is attached\n\n\nSent from the MPG app: http://www.justindoan.com/mpg-fuel-tracker", isHTML: false)
                        
                        emailController.addAttachmentData(NSData(contentsOfURL: path)!, mimeType: "text/csv", fileName: "\(currentCar.nickName).csv")
                        
                        presentViewController(emailController, animated: true, completion: nil)
                    }
                    
                } catch {
                    
                    print("Failed to create file")
                    print("\(error)")
                }
                
            } else {
                showErrorAlert("Error", msg: "There is no data to export")
            }
        }
        
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismissViewControllerAnimated(true, completion: nil)
}
