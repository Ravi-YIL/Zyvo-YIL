//
//  GetMyProfileViewModel.swift
//  Zyvo
//
//  Created by ravi on 27/01/25.
//

import Combine
import Foundation
import UIKit

class GetMyProfileViewModel:NSObject {
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var dob: String = ""
    @Published var number: String = ""
    @Published var emailVeri: String = ""
    @Published var numberVeri: String = ""
    @Published var location: String = ""
    @Published var imageEncoded:Data? = nil
    @Published var emailStatus: String = ""
    @Published var numberStatus: String = ""
    @Published var comeFrom: String = ""
    @Published var isNameValid: Bool = true
    @Published var isEmailValid: Bool = true
    @Published var isNumberValid: Bool = true
    @Published var isProfileValid: Bool = false
    
    @Published var deleteSavedCardResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var setPreferredResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var getCardResult:Result<BaseResponse<SavedCardModelData>,Error>? = nil
   
    @Published var getMyProfileResult:Result<BaseResponse<MyProfileModel>,Error>? = nil
    
    @Published var addWorkResult:Result<BaseResponse<WorkAddModel>,Error>? = nil
    
    @Published var addPlaceResult:Result<BaseResponse<placeAddModel>,Error>? = nil
    
    @Published var addHobbyResult:Result<BaseResponse<HobbyAddModel>,Error>? = nil
    
    @Published var addPetResult:Result<BaseResponse<PetAddModel>,Error>? = nil
    
    @Published var addLanguageResult:Result<BaseResponse<LanguageAddModel>,Error>? = nil
    
    @Published var deleteLanguageResult:Result<BaseResponse<DeleteLanguageMdodel>,Error>? = nil
    
    @Published var deletePetResult:Result<BaseResponse<DeletePetMdodel>,Error>? = nil
    
    @Published var verifyIdentityResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var deleteWorkResult:Result<BaseResponse<DeleteWorkModel>,Error>? = nil
    
    @Published var deletePlaceResult:Result<BaseResponse<DeletePlaceMdodel>,Error>? = nil
    @Published var deleteHobbyResult:Result<BaseResponse<DeleteHobbyMdodel>,Error>? = nil
    
    @Published var getProfileUpdate:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var updateAbouMeResult:Result<BaseResponse<updateAbouMeModel>,Error>? = nil
    @Published var updateStreetResult:Result<BaseResponse<updateStreetModel>,Error>? = nil
    @Published var updateCityResult:Result<BaseResponse<updateCityModel>,Error>? = nil
    @Published var updateStateResult:Result<BaseResponse<updateStateModel>,Error>? = nil
    @Published var updateZipCodeResult:Result<BaseResponse<updateZipCodeModel>,Error>? = nil
    
    @Published var getUpdateProfileImgResult:Result<BaseResponse<updateProfileImageModel>,Error>? = nil
    @Published var emailOrPhon: String = ""
    var isEmailVerified: String   = ""
    var isPhonVerified: String   = ""
    var lat: String   = ""
    var long: String  = ""
    var city: String  = ""
    var state: String = ""
    var zip: String   = ""
    
    //@Published var isPasswordValid: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        self.setupValidation()
    }
    private func setupValidation() {
        Publishers.CombineLatest4($name, $email, $number, $dob)
            .map { name, email, number, dob in
                print(name, email, number, dob,"dob")
                return self.validate(name: name, email: email, phone: number, dob: dob)
            }.assign(to: \.isProfileValid, on: self)
            .store(in: &cancellables)
    }
    
    func encodeImageToString(image: UIImage) {
       image.resizeByByte(maxMB: 1.0) { imageData in
            self.imageEncoded = imageData
           self.apiForUpdateProfileImage()
        }
        
    }
  
    private func validate(name: String, email: String, phone: String, dob: String) -> Bool {
        if name.isEmpty {
            errorMessage = "Please enter your name"
            return false
        }
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        
        guard validateEmail(email) else{return false}
        if phone.isEmpty {
            errorMessage = "Please enter your phone number"
            return false
        }
        
        guard validatePhone(phone) else{return false}
        if dob.isEmpty {
            errorMessage = "Please enter your date of birth"
            return false
        }
        errorMessage = nil
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        } else if !email.isValidEmail() {
            errorMessage = "Please enter a valid email address."
            return false
        }
        return true
    }
    
    func validatePhone(_ phone: String) -> Bool {
        if number.isEmpty {
            errorMessage = "Please enter your phone number"
            return false
        } else if !formatPhoneNumberToNormal(phone).isValidPhone() {
            errorMessage = "Please enter a valid phone."
            return false
        }
        return true
    }
 }
 
extension GetMyProfileViewModel {
    func getProfile(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<MyProfileModel>().post(endpoint: .getProfile, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getMyProfileResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getMyProfileResult = .success(response)
                }else {
                   //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        }
    
    func apiForUpdateZipcode(zip:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.zipcode] = zip
        APIServices<updateZipCodeModel>().post(endpoint: .add_zip_code, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.updateZipCodeResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateZipCodeResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForUpdateState(State:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.state] = State
        APIServices<updateStateModel>().post(endpoint: .add_state, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.updateStateResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateStateResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForUpdateCity(City:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.city] = City
        APIServices<updateCityModel>().post(endpoint: .add_city, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.updateCityResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateCityResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForUpdateStreet(StreetAddress:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.street_address] = StreetAddress
        APIServices<updateStreetModel>().post(endpoint: .add_street_address, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.updateStreetResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateStreetResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForUpdateAboutMe(AboutMe:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.about_me] = AboutMe
        APIServices<updateAbouMeModel>().post(endpoint: .addaboutme, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.updateAbouMeResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateAbouMeResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForAddWork(workName:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.workName] = workName
        
        APIServices<WorkAddModel>().post(endpoint: .addmywork, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.addWorkResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addWorkResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    func apiForDeleteWork(index:Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.workindex] = index
        
        APIServices<DeleteWorkModel>().post(endpoint: .deletemywork, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteWorkResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteWorkResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForAddPlace(PlaceName:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.placename] = PlaceName
        
        APIServices<placeAddModel>().post(endpoint: .addliveplace, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.addPlaceResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addPlaceResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    func apiForDeletePlace(index:Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.indexToDeletePlace] = index
        
        APIServices<DeletePlaceMdodel>().post(endpoint: .deleteliveplace, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deletePlaceResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deletePlaceResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }

    func apiForAddHobbies(HobbyName:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.hobbyname] = HobbyName
        
        APIServices<HobbyAddModel>().post(endpoint: .addhobby, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.addHobbyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addHobbyResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    func apiForDeleteHobby(index:Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.indexToDeletePlace] = index
        
        APIServices<DeleteHobbyMdodel>().post(endpoint: .deletehobby, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteHobbyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteHobbyResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    //
    func apiForAddPet(PetName:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.petname] = PetName
        
        APIServices<PetAddModel>().post(endpoint: .addpet, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.addPetResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addPetResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    func apiForDeletePet(index:Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.indexToDeletePlace] = index
        
        APIServices<DeletePetMdodel>().post(endpoint: .deletepet, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deletePetResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deletePetResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiForVerifyIdentity(identityverify : Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.identityverify] = identityverify
        
        APIServices<EmptyModel>().post(endpoint: .verifyIdentity, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.verifyIdentityResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.verifyIdentityResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    func apiForAddLanguage(languageName:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.languagename] = languageName
        
        APIServices<LanguageAddModel>().post(endpoint: .addlanguage, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.addLanguageResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addLanguageResult = .success(response)
                }else {
                    self.addLanguageResult = .success(response)
                   // topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
      }
    
    func apiForDeleteLanguage(index:Int){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.indexToDeletePlace] = index
        
        APIServices<DeleteLanguageMdodel>().post(endpoint: .deletelanguage, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteLanguageResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteLanguageResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    func apiForUpdateProfileImage(){
        var imagePara   =   [String:Data]()
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        imagePara[APIKeys.profileImg] = imageEncoded
        
        APIServices<updateProfileImageModel>().SendAnyThing(endpoint: .upload_profile_image, parameters: para, images: imagePara,loader:  true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getUpdateProfileImgResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getUpdateProfileImgResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
      }
    
    func apiForGetSavedCard(){
        var para : [String:Any] = [:]
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<SavedCardModelData>().post(endpoint: .getusercards, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getCardResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getCardResult = .success(response)
                } else {
                   //self.bookingPropertyResult = .success(response)
                    self.getCardResult = nil
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        }
    
    func apiForSetPreferredCard(cardID : String){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
            para[APIKeys.cardID] = cardID
           APIServices<EmptyModel>().post(endpoint: .setPreferredCard, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.setPreferredResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.setPreferredResult = .success(response)
                   }else {
                       topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
       }
    
    func apiForDeleteSavedCard(cardID : String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.payment_method_id] = cardID
        APIServices<EmptyModel>().post(endpoint: .deleteCardStripe, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteSavedCardResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteSavedCardResult = .success(response)
                   
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
       }
   }
