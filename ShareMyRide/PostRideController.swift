//
//  PostRideController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 4/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//


import UIKit
import AlamoArgo
import Alamofire

class PostRideController:UIViewController {
    
    var datepicker:UIDatePicker!
    var postRideViewModel:[String:AnyObject]!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var timeLeaving: UITextField!
    
    override func viewDidLoad() {
        setupDatePicker()
        duration.keyboardType = .NumberPad
        timeLeaving.inputView = datepicker
        postRideViewModel = ["destination":"", "duration":"", "timeLeaving":""]
        
    }
    
    func selectedDate(){
        let serverFormatter = NSDateFormatter()
        let textboxFormatter = NSDateFormatter()
        serverFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz";
        textboxFormatter.dateStyle = .MediumStyle
        let selectedDate = datepicker.date
        postRideViewModel["timeLeaving"] = serverFormatter.stringFromDate(selectedDate)
        timeLeaving.text = textboxFormatter.stringFromDate(selectedDate)
        
    }
    
    func setupDatePicker(){
        let todaysDate = NSDate()
        datepicker = UIDatePicker()
        datepicker.setDate(todaysDate, animated: true)
        datepicker.minimumDate = todaysDate
        datepicker.datePickerMode = .DateAndTime
        datepicker.locale = NSLocale.currentLocale()
        datepicker.addTarget(self, action: #selector(selectedDate), forControlEvents: .ValueChanged)
    }
    
    @IBAction func updateDestination(sender: AnyObject) {
        postRideViewModel["destination"] = destination.text!
    }
    @IBAction func updateDuration(sender: AnyObject) {
        postRideViewModel["duration"] = Int(duration.text!)
    }
    
    @IBAction func postRide(sender: AnyObject) {
        dismissFocusOnAllTextFields()
        print(postRideViewModel)
        var ridePost = Ride(
            id:0,
            rideSharer: 0,
            destination: "",
            timeLeaving: "",
            duration: 0,
            availableSeats:0,
            longitude:0.0,
            latitude:0.0
        )
        getPostValues(ridePost)
        ridePost.post(){
            (response:Response<Ride, NSError>) in
            if let ride:Ride = response.result.value{
                print(ridePost)
                ridePost = ride.copyWithZone(nil) as! Ride
                print(ridePost)
            }else{
                print(response.result.error)
            }
        }

    }
    
    func dismissFocusOnAllTextFields(){
        if duration.isFirstResponder(){
            duration.resignFirstResponder()
        }else if destination.isFirstResponder(){
            destination.resignFirstResponder()
        }
        else if timeLeaving.isFirstResponder(){
            timeLeaving.resignFirstResponder()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchedViews = touches.map{(touch: UITouch) -> UIView in return touch.view! }
       
        if !touchedViews.contains(duration) && duration.isFirstResponder(){
            duration.resignFirstResponder()
        }else if !touchedViews.contains(destination) && destination.isFirstResponder(){
            destination.resignFirstResponder()
        }
        else if !touchedViews.contains(timeLeaving) && timeLeaving.isFirstResponder(){
            timeLeaving.resignFirstResponder()
        }
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    func getPostValues(postRide:Ride){
        postRide.destination = destination.text!
        postRide.duration = Int(duration.text!)!
        postRide.timeLeaving = postRideViewModel["timeLeaving"]! as! String
    }
    
}