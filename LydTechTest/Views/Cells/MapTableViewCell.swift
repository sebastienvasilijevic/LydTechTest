//
//  MapTableViewCell.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 01/11/2021.
//

import MapKit
import UIKit

class MapTableViewCell: UITableViewCell {

    static let identifier = "MapTableViewCell"
    
    static let cellHeight: CGFloat = 300
    
    private var mapView: MKMapView = {
        let view: MKMapView = .init()
        view.layer.cornerRadius = 8
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetFields()
    }
    
    private func configure() {
        self.clipsToBounds = true
        
        self.contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.margins/2)
        }
    }
    
    public func configure(address: String, latitude: String, longitude: String) {
        if let latitudeDouble = CLLocationDegrees(latitude),
           let longitudeDouble = CLLocationDegrees(longitude) {
            let annotation: MKPointAnnotation = .init()
            annotation.title = address
            annotation.coordinate = .init(latitude: latitudeDouble, longitude: longitudeDouble)
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    private func resetFields() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
}
