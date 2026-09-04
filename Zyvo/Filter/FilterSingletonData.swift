//
//  FilterSingletonData.swift
//  Zyvo
//
//  Created by ravi on 6/03/25.
//

class FilterSavedData {
    // Shared instance (Singleton)
    static let shared = FilterSavedData()
    
    // Properties
    var allowsPets: String = ""
    var selfCheckIn: String = ""
    var activities: String = ""
    var amenities: String = ""
    var instantbooking: String = ""
   
    var arrSelectedActivity: [String] = []  // Updated to store multiple values
    var arrSelectedOtherActivity: [String] = []  // Updated to store multiple values
    var arrSelectedAmenties: [String] = []
    var arrSelectedLanguage: [String] = []
    
    var latitude: String = ""
    var longitude: String = ""
    
    var bathroom: String = ""
    var bedroom: String = ""
    var propertysize: String = ""
    var parkingSize: String = ""
    var peoplecount: String = ""
    var timess: Int = 0
    var datess: String = ""
    var locationss: String = ""
    var maximumprice: String = ""
    var minimumprice: String = ""
    var placetype: String = ""

    // Private initializer to prevent external instantiation
    private init() {}
    
}

extension FilterSavedData {
    func clearData() {
        isappliedField = false
        self.allowsPets = ""
        self.selfCheckIn = ""
        self.activities = ""
        self.amenities = ""
        self.instantbooking = ""
        self.bathroom = ""
        self.bedroom = ""
        self.propertysize = ""
        self.parkingSize = ""
        self.peoplecount = ""
        self.timess = 0
        self.datess = ""
        self.locationss = ""
        self.maximumprice = ""
        self.minimumprice = ""
        self.placetype = ""
        self.latitude = ""
        self.longitude = ""
        
        self.arrSelectedActivity = []  // Updated to store multiple values
        self.arrSelectedOtherActivity = []  // Updated to store multiple values
        self.arrSelectedAmenties = []
        self.arrSelectedLanguage = []
    }
}



class WhereSaveData {
    // Shared instance (Singleton)
    static let shared = WhereSaveData()
    
    // Properties
    
    var StartDatetime : String = ""
    var selectedDate : String = ""
    var lat : String = ""
    var long : String = ""
    var EndDatetime : String = ""
    var WhereLocation: String = ""
    var bookingHours : Int = 0
    var startTime : String = ""
    var endTime: String = ""
    var ActivityType: String = ""
    var selectedAmount : String = ""
    
    // Private initializer to prevent external instantiation
    private init() {}
    
}

extension WhereSaveData {
    func clearData() {
        isappliedField = false
        self.selectedDate = ""
        self.lat = ""
        self.long = ""
        self.WhereLocation = ""
        self.StartDatetime = ""
        self.EndDatetime = ""
        self.bookingHours = 0
        self.startTime = ""
        self.endTime = ""
        self.ActivityType = ""
        self.selectedAmount = ""
        
    }
}

