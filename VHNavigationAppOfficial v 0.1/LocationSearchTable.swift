//
//  LocationSearchTable.swift
//  VHNavigationAppOfficial v 0.1
//
//  Created by Derek Vandermark on 7/22/18.
//  Copyright © 2018 Derek. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil

    
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as!
        ResultsDisplayCell
        
        let selectedIndex = self.matchingItems[indexPath.row]
        
    
        cell.titleLabel?.text = selectedIndex.placemark.title
        cell.detailTextLabel?.text = selectedIndex.name
        //cell.detailTextLabel?.text = selectedIndex.placemark.subThoroughfare
        //cell.detailTextLabel?.text = selectedIndex.name
        //cell.detailTextLabel?.text = selectedIndex.placemark.subtitle
        return cell
    }
    
}




extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView,
                let searchBarText = searchController.searchBar.text else { return }
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                
                for mapItems in response.mapItems{
                    self.matchingItems.append(mapItems as MKMapItem)
                    print("thisisthearray:\(self.matchingItems)")
                
                
                
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            
    }
    
    
    
    }
}

}

extension LocationSearchTable {
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
            dismiss(animated: true, completion: nil)
            tableView.resignFirstResponder()
    }
    
    
    
}





