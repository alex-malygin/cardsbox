//
//  GradientLayer.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/14/22.
//

import UIKit

func getGradientLayer(bounds: CGRect, colors: [CGColor]) -> CAGradientLayer{
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    gradient.colors = colors
    
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    return gradient
}

func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return UIColor(patternImage: image!)
}
