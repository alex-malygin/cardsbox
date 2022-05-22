//
//  ViewModelType.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
