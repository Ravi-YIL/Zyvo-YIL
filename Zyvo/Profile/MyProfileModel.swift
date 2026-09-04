//
//  MyProfileModel.swift
//  Zyvo
//
//  Created by ravi on 27/01/25.
//

// MARK: - DataClass
struct MyProfileModel: Codable {
    let firstName, lastName, profileImage: String?
    let emailVerified, phoneVerified, identityVerified: Int?
    let aboutMe: String?
    let whereLive,myWork, languages, hobbies, pets: [String]?
    let email: String?
    let phoneNumber, street, city, state: String?
    let zipCode: String?
    let paymentMethods: [String]?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case identityVerified = "identity_verified"
        case aboutMe = "about_me"
        case whereLive = "where_live"
        case myWork = "my_work"
        case languages, hobbies, pets, email
        case phoneNumber = "phone_number"
        case street, city, state
        case zipCode = "zip_code"
        case paymentMethods = "payment_methods"
    }
}
//
// MARK: - AddWorkd
struct WorkAddModel: Codable {
    let userID: Int?
    let addedWork: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedWork = "added_work"
    }
}

// MARK: - DeleteWork
struct DeleteWorkModel: Codable {
    let userID: Int?
    let deletedWork: String?
    let remainingWorks: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case deletedWork = "deleted_work"
        case remainingWorks = "remaining_works"
    }
}

// MARK: - DataClass
struct placeAddModel: Codable {
    let userID: Int?
    let addedLocation: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedLocation = "added_location"
    }
}

// MARK: - DeletePlace
struct DeletePlaceMdodel: Codable {
    let userID: Int?
    let deletedAddress: String?
    let remainingAddresses: [String]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case deletedAddress = "deleted_address"
        case remainingAddresses = "remaining_addresses"
    }
}

// MARK: - DataClass
struct HobbyAddModel: Codable {
    let userID: Int?
     let   addedHobby: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedHobby = "added_hobby"
    }
}

// MARK: - DataClass
struct DeleteHobbyMdodel: Codable {
    let userID: Int?
    let deletedHobby: String?
    let remainingHobbies: [String]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case deletedHobby = "deleted_hobby"
        case remainingHobbies = "remaining_hobbies"
    }
}


// MARK: - AddPet
struct PetAddModel: Codable {
    let userID: Int?
     let   addedPet: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedPet = "added_pet"
    }
}


// MARK: - DeletePet
struct DeletePetMdodel: Codable {
    let userID: Int?
    let deletedPet: String?
    let remainingPets: [String]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case deletedPet = "deleted_pet"
        case remainingPets = "remaining_pets"
    }
}

// MARK: - AddPet
struct LanguageAddModel: Codable {
    let userID: Int?
     let   addedlanguage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedlanguage = "added_language"
    }
}




// MARK: - DeleteLanguage
struct DeleteLanguageMdodel: Codable {
    let userID: Int?
    let deletedLanguage: String?
    let remainingLanguages: [String]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case deletedLanguage = "deleted_language"
        case remainingLanguages = "remaining_languages"
    }
}

// MARK: - DataClass
struct updateProfileImageModel: Codable {
    let userID: Int?
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case profileImageURL = "profile_image_url"
    }
}

// MARK: - DataClass
struct updateAbouMeModel: Codable {
    let userID: Int?
    let addedAboutMe: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedAboutMe = "added_about_me"
    }
}

// MARK: - DataClass
struct updateStreetModel: Codable {
    let userID: Int?
    let addedStreetAddress: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedStreetAddress = "added_street_address"
    }
}

// MARK: - DataClass
struct updateCityModel: Codable {
    let userID: Int?
    let addedCity: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedCity = "added_city"
    }
}


// MARK: - DataClass
struct updateStateModel: Codable {
    let userID: Int?
    let addedstate: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedstate = "added_state"
    }
}

// MARK: - DataClass
struct updateZipCodeModel: Codable {
    let userID: Int?
    let addedzipcode: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case addedzipcode = "added_zip_code"
    }
}
