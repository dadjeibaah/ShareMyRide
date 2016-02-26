//
//  ViewController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/17/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import UIKit



class PlacesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating {

    var places:[Places]!
    var placesSearch :UISearchController!
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var topPlacesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topPlacesCollection.delegate = self
        topPlacesCollection.dataSource = self
        places = TopPlacesRepository.getTopPlaces()
        
        placesSearch = UISearchController(searchResultsController: nil)
        placesSearch.searchResultsUpdater = self
        placesSearch.dimsBackgroundDuringPresentation = false
        placesSearch.searchBar.sizeToFit()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("Place", forIndexPath: indexPath) as! PlacesCollectionCell
        collectionCell.backgroundColor = UIColor.blueColor()
        return collectionCell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView:UICollectionReusableView = UICollectionReusableView()
        if kind == "UICollectionElementKindSectionHeader"{
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PlacesHeader", forIndexPath: indexPath)
            headerView.addSubview(placesSearch.searchBar)
        }
        return headerView
        
    }
    
    
    
    

}

