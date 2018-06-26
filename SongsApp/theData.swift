//
//  theData.swift
//  SongsApp
//
//  Created by Marc Jackson on 29/12/2017.
//  Copyright © 2017 Marc Jackson. All rights reserved.
//

//Airport Dictionary

//Swift can infer the type so this is not necessary
//let airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin", "LHR": "London Heathrow"]

//Shortcut
//let airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin", "LHR": "London Heathrow"]

//---------------------------------------------------------------------
//Not working
//let airports:[String:[String]] = ["London": ["LHR","STA","LUT","GTW"]]

//Not working
//let airports = ["Toronto":["YYZ": "Toronto Pearson"], "Dublin":["DUB": "Dublin Airport"], "London":["LHR": "London Heathrow","STA":"Standsted Airport","LUT":"London Luton Airport","GTW":"London Gatwick Airport"]]

//Working
let airports = ["Toronto":["YYZ"], "Dublin":["DUB"], "London":["LHR","STA","LUT","GTW"]]


