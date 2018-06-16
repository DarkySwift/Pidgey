//
//  Response.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/2/18.
//

import Foundation

public enum Response<T> {
    
    case success(T)
    case error(Error)
    
}
