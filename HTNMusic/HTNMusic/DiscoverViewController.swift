//
//  SecondViewController.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Darwin
import CoreLocation

class DiscoverViewController: UIViewController {
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    @IBOutlet fileprivate weak var mapView: UIView!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var listView: UIView!
    @IBOutlet fileprivate weak var nearbyTableView: UITableView!
    
    lazy var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
    
    fileprivate let viewModel = DiscoverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearbyTableView.delegate = self
        
        bindViewModel()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension DiscoverViewController {
    func inject(user: User) {
        viewModel.user = user
    }
}

fileprivate extension DiscoverViewController {
    func bindViewModel() {
        viewModel.isMapViewHidden.bind(to: mapView.reactive.isHidden)
        viewModel.isMapViewHidden
            .map { !$0 }
            .bind(to: listView.reactive.isHidden)
    }
}

// MARK: - UISegmentedControl 

extension DiscoverViewController {
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listView.isHidden = true
        case 1:
            mapView.isHidden = true
            listView.isHidden = false
        default:
            break;
        }
    }
}

extension DiscoverViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue = manager.location?.coordinate else { print("No location value"); return }
        
        let locationCoordinates = Coordinate2D(longitude: Double(locationValue.longitude), latitude: Double(locationValue.latitude))
        getNearbyUsers(coords: locationCoordinates)
    }
}

extension DiscoverViewController: UITableViewDelegate {
    
}

extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyCell") as! DiscoverTableViewCell
        let nearbyInfo: User
        
        if indexPath.row < viewModel.smallProximityUsers.count {
            nearbyInfo = viewModel.smallProximityUsers[indexPath.row]
        } else if indexPath.row < viewModel.mediumProximityUsers.count + viewModel.smallProximityUsers.count {
            nearbyInfo = viewModel.mediumProximityUsers[indexPath.row - viewModel.smallProximityUsers.count] // super bad way to do this don't do this
        } else {
            nearbyInfo = viewModel.largeProximityUsers[indexPath.row - viewModel.smallProximityUsers.count - viewModel.mediumProximityUsers.count]
        }
        
        cell.mediaTitleLabel.text = nearbyInfo.currentListening?.title
        cell.mediaArtistLabel.text = nearbyInfo.currentListening?.artist
        cell.userImageView.image = UIImage(named: "profile_ic")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.largeProximityUsers.count + viewModel.mediumProximityUsers.count + viewModel.smallProximityUsers.count
    }
}
    
// MARK: - Helpers

extension DiscoverViewController {
    func getNearbyUsers(coords: Coordinate2D) {
        viewModel.updateLocation(coords: coords, completion: { _ in
            if viewModel.isMapViewHidden.value {
                nearbyTableView.reloadData()
            } else {
                redrawUsersOnMap()
            }
        })
    }
    
    func redrawUsersOnMap() {
        let origin = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5)
        var counter = 1
        for _ in viewModel.smallProximityUsers {
            let radius = 25.0
            let smallCount = Double(viewModel.smallProximityUsers.count)
            let x = Int(floor(Double(origin.x) + radius*cos(Double(counter*2)*Double.pi/smallCount)))
            let y = Int(floor(Double(origin.y) + radius*sin(Double(counter*2)*Double.pi/smallCount)))
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: x,y: y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.red.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 3.0
            
            view.layer.addSublayer(shapeLayer)
            
            counter += 1
            viewModel.userMapCoordinates["\(x) \(y)"] = viewModel.smallProximityUsers[counter - 1] // TODO: make this 0!!!
            // do something add to dictionary
        }
        
        for user in viewModel.mediumProximityUsers {
            let radius = 45.0
            let mediumCount = Double(viewModel.mediumProximityUsers.count)
            let x = floor(Double(origin.x) + radius*cos(Double(counter*2)*Double.pi/mediumCount))
            let y = floor(Double(origin.y) + radius*sin(Double(counter*2)*Double.pi/mediumCount))
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: x,y: y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.purple.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.purple.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 3.0
            
            view.layer.addSublayer(shapeLayer)
            
            counter += 1
            viewModel.userMapCoordinates["\(x) \(y)"] = viewModel.mediumProximityUsers[counter - viewModel.smallProximityUsers.count - 1]
        }
        
        for user in viewModel.largeProximityUsers {
            let radius = 65.0
            let mediumCount = Double(viewModel.mediumProximityUsers.count)
            let x = floor(Double(origin.x) + radius*cos(Double(counter*2)*Double.pi/mediumCount))
            let y = floor(Double(origin.y) + radius*sin(Double(counter*2)*Double.pi/mediumCount))
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: x,y: y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.purple.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.purple.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 3.0
            
            view.layer.addSublayer(shapeLayer)
            
            counter += 1
            viewModel.userMapCoordinates["\(x) \(y)"] = viewModel.mediumProximityUsers[counter - viewModel.mediumProximityUsers.count - viewModel.smallProximityUsers.count - 1]
        }
    }
}



