//
//  MyProfileViewModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//

import Combine
import Foundation
import UIKit

class MyProfileViewModel:NSObject {
    
    @Published var imageEncoded:Data? = nil
    
    @Published var getMyProfileResult:Result<BaseResponse<MyProfileModel>,Error>? = nil
    @Published var verifyIdentityResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var getUpdateProfileImgResult:Result<BaseResponse<updateProfileImageModel>,Error>? = nil
    @Published var getProfileUpdate:Result<BaseResponse<CreateProfileModel>,Error>? = nil
    
    @Published var updateAbouMeResult:Result<BaseResponse<updateAbouMeModel>,Error>? = nil
    @Published var addPlaceResult:Result<BaseResponse<placeAddModel>,Error>? = nil
    @Published var deletePlaceResult:Result<BaseResponse<DeletePlaceMdodel>,Error>? = nil
    @Published var emailOrPhon: String = ""
    var first_name: String   = ""
    var last_name: String   = ""
    var about_me: String   = ""
    var identity_verify: Int = 0
    var where_live: [String]  = []
    var works: [String]  = []
    var languages: [String]  = []
    var hobbies: [String]  = []
    var pets: [String]  = []
    
    private var cancellables = Set<AnyCancellable>()
    override init() {
        super.init()
    }
    
    func encodeImageToStringCreateProfile(image: UIImage) {
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    topViewController?.showAlert(for: "Image could not be processed. Please select a smaller image.")
                    return
                }
                self.imageEncoded = imageData
                self.apiForUpdateProfileImage()
            }
        }
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
    
    func encodeImageToString(image: UIImage) {
//        image.resizeByByte(maxMB: 1.0) { imageData in
//            self.imageEncoded = imageData
//            self.uploadProfile()
//        }
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    topViewController?.showAlert(for: "Image could not be processed. Please select a smaller image.")
                    return
                }
                self.imageEncoded = imageData
                self.apiForUpdateProfileImage()
               // self.uploadProfile()
            }
        }
    }
}

extension MyProfileViewModel {
    func uploadProfile(){
        var para                      =      [String:Any]()
        var imagePara                 =      [String:Data]()
        para[APIKeys.userID]          =      UserDetail.shared.getUserId()
        para[APIKeys.firstname]            =      self.first_name
        para[APIKeys.lastname]           =      self.last_name
        para[APIKeys.where_live]             =      self.where_live
        para[APIKeys.works]             =      self.works
        para[APIKeys.languages]             =      self.languages
        para[APIKeys.hobbies]             =      self.hobbies
        para[APIKeys.pets]             =      self.pets
        
        para[APIKeys.aboutme]             =      self.about_me
        
        para[APIKeys.identityverify]             =      self.identity_verify
        
        
        imagePara[APIKeys.profileImg] = imageEncoded
        
        APIServices<CreateProfileModel>().SendAnyThing(endpoint: .completeprofile, parameters: para, images: imagePara)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getProfileUpdate = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getProfileUpdate = .success(response)
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
    
    
    func getProfile(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<MyProfileModel>().post(endpoint: .getProfile, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getMyProfileResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getMyProfileResult = .success(response)
                }else {
                   topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

    func apiForAddPlace(PlaceName: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.placename] = PlaceName
        
        APIServices<placeAddModel>().post(endpoint: .addliveplace, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.addPlaceResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.addPlaceResult = .success(response)
                } else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

    func apiForDeletePlace(index: Int) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.indexToDeletePlace] = index
        
        APIServices<DeletePlaceMdodel>().post(endpoint: .deleteliveplace, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.deletePlaceResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deletePlaceResult = .success(response)
                } else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
}
