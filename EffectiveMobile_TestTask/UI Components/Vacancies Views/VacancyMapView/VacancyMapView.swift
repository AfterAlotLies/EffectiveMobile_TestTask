//
//  VacancyMapView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 02.04.2024.
//

import UIKit
import MapKit

// MARK: - VacancyMapView
class VacancyMapView: UIView {
    
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("VacancyMapView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }

    // MARK: - Public methods
    func setCompanyNameLabel(name: String) {
        companyNameLabel.text = name
    }
    
    func setAddressLabel(town: String, street: String, house: String) {
        addressLabel.text = "\(town), \(street), \(house)"
    }
    
    func showLocationOnMap(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                self.addAnnotationToMap(placemark: placemark)
            }
        }
    }

    // MARK: - Private methods
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.clear.cgColor
        mapView.layer.cornerRadius = 10
    }
    
    private func addAnnotationToMap(placemark: CLPlacemark) {
        let coordinate = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = placemark.name
        mapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 10000
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}
