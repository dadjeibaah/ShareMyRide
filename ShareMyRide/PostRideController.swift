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

class PostRideController:UIViewController{
    
    let locationManager = CLLocationManager()
    
    var datepicker:UIDatePicker!
    var endDatePicker:UIDatePicker!
    var communitySelectionView:UIPickerView!
    var newPost:Ride!
    var destinationSearchController:DestinationSearchController!
    var locationSearch:UISearchController! = nil
    var communityList:[Communities] = []
    var alertController:UIAlertController!
    var cancelAlertAction:UIAlertAction!
    var destinationSearch:UISearchController!
    var destinationSearchResults:DestinationResultsController!
    
    
    
    @IBOutlet weak var community: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var departureTime: UITextField!
    @IBOutlet weak var availableSeats: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBarPlaceholder: UIView!
    
    override func viewDidLoad() {
        setupDatePickers()
        setupAlertController()
        setupSearchBar()
        askLocationPermission()
        setupLocationServices()
        communitySelectionView = UIPickerView()
        communitySelectionView.delegate = self
        communitySelectionView.dataSource = self
        map.delegate = self
        duration.delegate = self
        departureTime.delegate = self
        
        
        
        duration.keyboardType = .NumberPad
        availableSeats.keyboardType = .NumberPad
        departureTime.inputView = datepicker
        duration.inputView = endDatePicker
        community.inputView = communitySelectionView
        newPost = Ride(
            id:nil,
            rideSharer: "577070f01e9f5d2614de1eb4",
            destinationName: "",
            departureTime: "",
            duration: "",
            availableSeats: 0,
            location: [0,0, 0.0],
            community: "5772980faa11dd235fc0c9e1",
            rideAlongs: []
            
        )
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupSearchBar(){
        destinationSearchResults = DestinationResultsController()
        destinationSearchResults.mapView = map
        destinationSearch = UISearchController(searchResultsController: destinationSearchResults)
        destinationSearch.searchResultsUpdater = destinationSearchResults
        destinationSearchResults.showLocationDelegate = self
        self.searchBarPlaceholder.addSubview(destinationSearch.searchBar)
    }
    
    
    

    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
        }
    
    func loadData(){
        Alamofire.request(.GET, "http:localhost:8000/users/577070f01e9f5d2614de1eb4").responseDecodable(completionHandler: {
            (response:Response<Users, NSError>) in
            switch response.result{
            case .Success(let user):
                self.communityList = user.communities
            case .Failure(let error):
                print(error)
            }
        })
    }
    
    func refreshUI(){
        let todaysDate = NSDate()
        duration.text = ""
        duration.text = ""
        departureTime.text = ""
        duration.text = ""
        availableSeats.text = ""
        community.text = ""
        datepicker.date = todaysDate
        endDatePicker.date = todaysDate.dateByAddingHours(1)

    }
    
    func setupAlertController(){
       alertController = UIAlertController(title: "Failed to Post", message: "We were unable to post your ride to the world, Please try again", preferredStyle: .Alert)
        cancelAlertAction = UIAlertAction(title: "Cancel", style: .Default, handler: {(action) in })
        alertController.addAction(cancelAlertAction)
    }
    
    func selectedDate(){
        let serverFormatter = NSDateFormatter()
        let textboxFormatter = NSDateFormatter()
        serverFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZ";
        textboxFormatter.dateStyle = .LongStyle
        textboxFormatter.timeStyle = .LongStyle
        let selectedDate = datepicker.date
        newPost.departureTime = serverFormatter.stringFromDate(selectedDate)
        print(newPost.departureTime)
        departureTime.text = textboxFormatter.stringFromDate(selectedDate)
        
    }
    
    func selectedEndDate(){
        let serverFormatter = NSDateFormatter()
        let textboxFormatter = NSDateFormatter()
        serverFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZ";
        textboxFormatter.dateStyle = .LongStyle
        textboxFormatter.timeStyle = .LongStyle
        let selectedDate = endDatePicker.date
        print(selectedDate)
        newPost.duration = serverFormatter.stringFromDate(selectedDate)
        duration.text = textboxFormatter.stringFromDate(selectedDate)
    }
    
    func setupDatePickers(){
        let todaysDate = NSDate()
        datepicker = UIDatePicker()
        datepicker.setDate(todaysDate, animated: true)
        datepicker.minimumDate = todaysDate
        datepicker.datePickerMode = .DateAndTime
        datepicker.locale = NSLocale.currentLocale()
        datepicker.addTarget(self, action: #selector(selectedDate), forControlEvents: .ValueChanged)
        
        endDatePicker = UIDatePicker()
        endDatePicker.setDate(datepicker.date, animated: true)
        endDatePicker.minimumDate = (datepicker.date.dateByAddingMinutes(30))
        endDatePicker.datePickerMode = .Time
        endDatePicker.locale = NSLocale.currentLocale()
        endDatePicker.addTarget(self, action: #selector(selectedEndDate), forControlEvents: .ValueChanged)
        
        
    }
    
    @IBAction func updateDestinationName(sender: AnyObject) {
        newPost.destinationName = "Test"
        newPost.loc = [Double](arrayLiteral: 23.600800037384033,46.76758746952729)
    }
    
    @IBAction func updateDuration(sender: AnyObject) {
        
    }
    @IBAction func updateAvailableSeats(sender: AnyObject) {
        newPost.availableSeats = Int(availableSeats.text!)!
    }
    @IBAction func didEditDuration(sender: AnyObject) {
        
    }
    
    @IBAction func postRide(sender: AnyObject) {
        dismissFocusOnAllTextFields()
        
        guard let seats = Int(availableSeats.text!)else{
            newPost.availableSeats = 0
            return
        }
        newPost.availableSeats = seats
        print(newPost)
        newPost.post(
                      { (ride:Ride) in
                        
                        self.tabBarController?.selectedIndex = 0
            },
                      onFailure: {(error:NSError) in
                        print(error)
                        if error.code == 401{
                            self.transitionToLoginViewController()
                        }else{
                            self.presentViewController(self.alertController, animated:true, completion: nil)
                        }
                        
                        
                        
        })
        refreshUI()
    }
    
    func dismissFocusOnAllTextFields(){
        if duration.isFirstResponder(){
            duration.resignFirstResponder()
        }
        else if departureTime.isFirstResponder(){
            departureTime.resignFirstResponder()
        }
    }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        weak var mapController = segue.destinationViewController as? DestinationSearchController
        mapController!.receiveAnnotationDelegate = self
    }
    
}

extension PostRideController:ReceiveAnnotationDelegate{
    func populateAnnotation(annotation: MKAnnotation) {
        if let place = annotation.title{
            newPost.destinationName = place ?? "Unknown"
           
        }
        newPost.loc = [annotation.coordinate.longitude, annotation.coordinate.latitude]
    }
}

extension PostRideController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.communityList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return communityList[row].communityName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard  let _id = communityList[row].id else {
            print("no id found")
            return
        }
        guard let name = communityList[row].communityName else{
            print("no name")
            return
        }
        newPost.community = _id
        community.text = name
        pickerView.resignFirstResponder()
    }
}

extension PostRideController:CLLocationManagerDelegate, MKMapViewDelegate{
    func setupLocationServices(){
         locationManager.delegate = self
    }
    
    func askLocationPermission(){
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else{
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let locationSpan = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: locationSpan)
            map.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}

extension PostRideController:DisplayMapSearchResult{
    func showPlaceMarkPin(map:MKMapView, placemark: MKPlacemark) {
        let annotation: MKDestination
        var cityState:String = ""
        
        map.removeAnnotations(map.annotations)
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            cityState = "\(city) \(state)"
        }
        
        newPost.destinationName = placemark.name!
        destinationSearch.searchBar.text = placemark.name!
        annotation = MKDestination(title: placemark.name!, subtitle:cityState, coordinate: placemark.coordinate)
        map.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        map.setRegion(region, animated: true)
    }

}

extension PostRideController:UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == departureTime{
              let todaysDate = NSDate()
            datepicker.setDate(todaysDate, animated: true)
            datepicker.minimumDate = todaysDate

        } else if(textField == duration){
            let endDuration = datepicker.date.dateByAddingHours(1)
            endDatePicker.setDate(endDuration, animated: true)
            endDatePicker.minimumDate = endDuration
        }
    }
}

