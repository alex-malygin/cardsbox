//
//  AuthService.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/10/22.
//

import Foundation

protocol AuthService {
    func login(with model: RegisterModel, completion: ResponseClosure<Void?>?)
}
