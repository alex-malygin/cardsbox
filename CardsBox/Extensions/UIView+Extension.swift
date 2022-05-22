//
//  UIView+Extension.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

extension UIView {
    func downloadIndicator(show: Bool, centerOffset: CGPoint = .zero) {
        DispatchQueue.main.async {
            if show {
                if self.subviews.contains(where: { $0 is UIActivityIndicatorView }) {
                    return
                }
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.color = .black
                activityIndicator.startAnimating()
                self.addSubview(activityIndicator)
                NSLayoutConstraint.activate([
                    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerOffset.y),
                    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset.x)
                ])
            } else {
                let indicator = self.subviews.first(where: { $0 is UIActivityIndicatorView })
                indicator?.removeFromSuperview()
            }
        }
    }
}

extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    var nibName: String {
        return Self.description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }

    // swiftlint:disable force_cast
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}
