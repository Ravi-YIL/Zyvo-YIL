//
//  SinglTonClass.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/01/25.
//

import Foundation
import UIKit

class SingltonClass{
    
    // Shared instance
    static let shared = SingltonClass()
    
    var parkingSpace = "parking_space"
    var typeOfSpace = "entire_home"
    var propertySize = "0"
    var no_Of_Ppl = "0"
    var bedrooms = "0"
    var bathrooms = "0"
    var activies = [String]()
    var other_Activities = [String]()
    var aminities = [String]()
    var instantBooking = "0"
    var selfCheck_in = "0"
    var allowPets = "0"
    var cancellationDays: String?
    
    var Imgs = [imageArray]()
    var title: String?
    var about: String?
    var parkingRule: String?
    var hostRules: String?
    var street: String?
    var city: String?
    var zipcode: String?
    var state: String?
    var country: String?
    
    var miniHrsPric_HrsMini = "2"
    var miniHrsPric_perHrs = "10"
    var bulkDis_HrsMini = "2"
    var bulkDis_Discount = "0"
//    var addOns: String?
    var addCleaningFees: String?
   // var avilabilityMonth = "00"
    var avilabilityMonth: [String] = []
    var avilabilityDays = "all"
    var avilabilityHrsFrom: String?
    var avilabilityHrsTo: String?
    var addOns: [addonsData] = []
    
    var latitude: Double?
    var longitude: Double?
    
    var deletedImg = [Int]()
}

struct addonsData:Codable{
    var name: String?
    var price: String?
}

