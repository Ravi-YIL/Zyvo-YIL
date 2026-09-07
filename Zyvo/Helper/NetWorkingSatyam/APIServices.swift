//
//  AppDelegate.swift
//  RPG
//
//  Created by Satyam on 07/02/24.
//


import Alamofire
import Combine
import SwiftyJSON
import Lottie

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case encode
    case decode
    case invalidResponse
}

 let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController()
var animationContainerView: UIView?
 let savedTimeZoneID = UserDefaults.standard.string(forKey: "timeZone")
 let savedTimeZone = TimeZone(identifier: savedTimeZoneID ?? "")
   // print("Time Zone: \(savedTimeZone?.identifier ?? "Unknown")")

var timeZone = savedTimeZone?.identifier ?? "Unknown"
struct EmptyModel: Decodable {}
typealias DefaultAPIService = APIServices<EmptyModel>
protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?,costumUrl:String?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)?,loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
}

final class APIServices<T: Decodable>: APIServiceProtocol {
    
    func postModel< Parameter: Encodable>(
           endpoint: AppURL.Endpoint,
           parameters: Parameter,
           loader: Bool? = true
       ) -> AnyPublisher<BaseResponse<T>, Error> {
           return Future<BaseResponse<T>, Error> { promise in
               guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                   .windows.first?.rootViewController?.topmostViewController() else {
                   let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                   promise(.failure(error))
                   return
               }
               let timeZone = UserDefaults.standard.string(forKey: "timezone")
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                   "Content-Type": "application/json",
                   "Timezone": savedTimeZone?.identifier ?? "Unknown"
               ]
               
               if loader ?? false {
                   GameLoaderView.show(in: topViewController.view)
               }
               
               print("==========================URL=====================")
               print(endpoint.path)
               print("\n==========================Parameters=====================\n")
               let encoder = JSONEncoder()
               encoder.outputFormatting = .prettyPrinted
               
               do {
                   let jsonData = try encoder.encode(parameters)
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print(jsonString)
                       
                   }
               } catch {
                   print("Error encoding intervals to JSON: \(error)")
                   
               }
               
               print("\n==========================Header=====================\n")
               print(headers)
               AF.request(endpoint.path,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: BaseResponse<T>.self) { response in
                   GameLoaderView.hide(from: topViewController.view)
                   
                   print("\n==========================Response=======================\n")
                   
                   if let data = response.data {
                       print(JSON(data))
                   }
                   print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                   
                   if (response.response?.statusCode ?? 0) == 401 {
                       APIServices<T>.logout(request: response.request)
                   }
                   switch response.result {
                   case .success(let value):
                       promise(.success(value))
                   case .failure(let error):
                       print("==========================failure=====================")
                       print(error)
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
    
    func putModel<Parameter: Encodable>(
        endpoint: AppURL.Endpoint,
        parameters: Parameter,
        loader: Bool? = true
    ) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Content-Type": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
            ]

            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }

            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            do {
                let jsonData = try encoder.encode(parameters)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Error encoding parameters to JSON: \(error)")
            }

            print("\n==========================Header=====================\n")
            print(headers)

            AF.request(endpoint.path,
                       method: .put,  // Changed from .post to .put
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)

                print("\n==========================Response=======================\n")
                if let data = response.data {
                    print(JSON(data))
                }
                print(response.response?.statusCode ?? 0, "STATUS CODE ON API RUN")

                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout(request: response.request)
                }

                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool? = true,costumUrl:String? = "") -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
           
            
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json",
               "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
            if loader ?? false {
                // Call the extension method in another class
            
                GameLoaderView.show(in: topViewController.view)
            }
            
            
          var str =  ""
            if (costumUrl ?? "").isEmpty {
                str = endpoint.path
            }else{
                str = costumUrl ?? ""
            }
            
            AF.request(str, method: .get, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
                  //  LoaderHelper.stopLottieLoader(topViewController.view as! LottieAnimationView)
                  GameLoaderView.hide(from: topViewController.view)
                print("==========================URL=====================")
                    
                    print(str)
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout(request: response.request)
                    }
                    
                    if let data = response.data {
                        print(JSON(data))
                    }
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func postWithOutToken(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               //"Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               //"Accept": "application/json"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func postWithoutAutherizationToken(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json",
               "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
//            if loader ?? false {
//                GameLoaderView.show(in:  topViewController.view)
//            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                       // APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func postWithoutAutherization(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json",
               "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                       // APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func post1(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            if let savedTimeZoneID = UserDefaults.standard.string(forKey: "timeZone") {
                let savedTimeZone = TimeZone(identifier: savedTimeZoneID)
                print("Time Zone: \(savedTimeZone?.identifier ?? "Unknown")")
            }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
//            if loader ?? false {
//                GameLoaderView.show(in:  topViewController.view)
//            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                  //  GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func postwithou(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            if let savedTimeZoneID = UserDefaults.standard.string(forKey: "timeZone") {
                let savedTimeZone = TimeZone(identifier: savedTimeZoneID)
                print("Time Zone: \(savedTimeZone?.identifier ?? "Unknown")")
            }
            let headers: HTTPHeaders = [
                
                "Accept": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func post(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            if let savedTimeZoneID = UserDefaults.standard.string(forKey: "timeZone") {
                let savedTimeZone = TimeZone(identifier: savedTimeZoneID)
                print("Time Zone: \(savedTimeZone?.identifier ?? "Unknown")")
            }
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout(request: response.request)
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in

            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json",
               "Timezone": savedTimeZone?.identifier ?? "Unknown"
                    ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                // Add parameters
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                // Add images
                let name = Date.getCurrentDateForName()
                var i = 0
                if let images = images {
        print("==========================ImageParameters=====================")
                    for (key, imageData) in images {
                        multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                        print("data ==>", imageData, "withName ==>", key, "fileName==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
                        i += 1
                    }
                }
            }, to: endpoint.path, headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
               
                progressHandler?(progress.fractionCompleted)
            }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
             
                print("\n==========================Parameters=====================\n")
                print(parameters)
                print("\n==========================Header=====================\n")
                print(headers)
                print("\n==========================Response=======================\n")
                
                print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                
                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout(request: response.request)
                }
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func SendAnyThing(endpoint: AppURL.Endpoint, parameters: [String: Any],images: [String: Data]?,progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
         return Future<BaseResponse<T>, Error> { promise in
             guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                 let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                 promise(.failure(error))
                 return
             }
             let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
            ]
             if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
             }
             AF.upload(multipartFormData: { multipartFormData in
                 for (key, value) in parameters {
                     if let arrayValue = value as? [Any] {
                         arrayValue.forEach { value in
                             if let data = "\(value)".data(using: .utf8) {
                                 multipartFormData.append(data, withName: key)
                             }
                         }
                     } else if let stringValue = "\(value)".data(using: .utf8) {
                         multipartFormData.append(stringValue, withName: key)
                     }
                 }
                 // Add images
                 let name = Date.getCurrentDateForName()
                 var i = 0
                 if let images = images {
         print("==========================ImageParameters=====================")
                     for (key, imageData) in images {
                             multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                      
         print("data ==>",imageData,"withName ==>",key,"fileName==>","\(name)\(i).jpeg","mimeType ==>" ,"image/jpeg")
                         i += 1
                     }
                 }
             }, to: endpoint.path,headers: headers)
             .uploadProgress { progress in
             print("Upload Progress: \(progress.fractionCompleted)")
                 progressHandler?(progress.fractionCompleted)
              }
             .validate(statusCode: 200..<300)
             .responseDecodable(of: BaseResponse<T>.self) { response in
                 GameLoaderView.hide(from: topViewController.view)
                 print("==========================URL=====================")
                 print(endpoint.path)
                print("\n==========================Parameters=====================\n")
                 for (key, value) in parameters {
                     print("\(key): \(value)")
                 }
                 print("\n==========================Header=====================\n")
                             print(headers )
                print("\n==========================Response=======================\n")
        
                 print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                 
                 if (response.response?.statusCode ?? 0) == 401 {
                     APIServices<T>.logout(request: response.request)
                 }
                 if let data = response.data {
                     print(JSON(data))
                 }

                 switch response.result {
                 case .success(let value):
                     promise(.success(value))
                 case .failure(let error):
                     print("==========================failure=====================")
                     print(error.localizedDescription)
                     promise(.failure(error))
                 }
             }
         }
         .eraseToAnyPublisher()
     }
    
    func postMultipart(
        endpoint: AppURL.Endpoint,
        parameters: [String: Any],
        files: [(data: Data, fileName: String, mimeType: String, key: String)],
        loader: Bool? = true
    ) -> AnyPublisher<BaseResponse<T>, Error> {
        
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json",
                "Timezone": savedTimeZone?.identifier ?? "Unknown"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.upload(multipartFormData: { multipartFormData in
                // Add parameters
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(Data(stringValue.utf8), withName: key)
                    } else if let intValue = value as? Int {
                        multipartFormData.append(Data("\(intValue)".utf8), withName: key)
                    } else if let boolValue = value as? Bool {
                        multipartFormData.append(Data("\(boolValue)".utf8), withName: key)
                    } else if let arrayValue = value as? [String] {
                        for item in arrayValue {
                            multipartFormData.append(Data(item.utf8), withName: "\(key)[]") // ✅ Handles array parameters (like dob[])
                        }
                    }
                }

                
                // Add files (images, PDFs, etc.)
                for file in files {
                    multipartFormData.append(file.data, withName: file.key, fileName: file.fileName, mimeType: file.mimeType)
                }
                
            }, to: endpoint.path, method: .post, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
                
                print("\n==========================Parameters=====================\n")
                print(parameters)
                print("\n==========================Headers=====================\n")
                print(headers)
                print("\n==========================Response=======================\n")
                print(response.response?.statusCode ?? 0, "STATUS CODE ON API RUN")
                
                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout(request: response.request)
                }
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================Failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static private func logout(request: URLRequest?) {
        let authorization = request?.value(forHTTPHeaderField: "Authorization") ?? ""
        let token = UserDetail.shared.getTokenWith()
        let endpoint = request?.url?.lastPathComponent ?? "unknown"
        print("[Session] HTTP 401 from endpoint: \(endpoint)")
        guard !token.isEmpty, authorization == "Bearer \(token)" else {
            print("[Session] Ignoring unauthorized response from an anonymous or outdated request.")
            return
        }
        APISessionManager.shared.handleUnauthorized(expectedToken: token)
    }
}

final class APISessionManager {
    static let shared = APISessionManager()
    private init() {}
    
    private(set) var isUnauthorizedAlertShowing = false
    
    func handleUnauthorized(expectedToken: String? = nil) {
        let rejectedToken = expectedToken ?? UserDetail.shared.getTokenWith()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard !rejectedToken.isEmpty, UserDetail.shared.getTokenWith() == rejectedToken else { return }
            guard !self.isUnauthorizedAlertShowing else { return }
            self.isUnauthorizedAlertShowing = true
            
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                self.isUnauthorizedAlertShowing = false
                return
            }
            
            var targetVC = topViewController
            if let alertVC = targetVC as? UIAlertController {
                if alertVC.message == "Unauthorized" {
                    return
                }
                if let presenting = alertVC.presentingViewController {
                    targetVC = presenting
                }
            }
            
            targetVC.showOkAlertWithHandler("Unauthorized") { [weak self] in
                self?.isUnauthorizedAlertShowing = false
                
                // A delayed alert must never clear a newly authenticated session.
                guard UserDetail.shared.getTokenWith() == rejectedToken else { return }
                FirebaseChatManager.shared.cleanupFirebase()
                // Clear user session data
                UserDetail.shared.setUserId("")
                UserDetail.shared.removeTokenWith()
                UserDetail.shared.removeUserId()
                UserDetail.shared.removeChatToken()
                UserDetail.shared.removeKeepMeLogin()
                UserDetail.shared.removeUserType()
                UserDetail.shared.removeisTimeExtend()
                UserDetail.shared.removeisCompleteProfile()
                CurrentDateTimer.shared.stopTimer()
                UserDetail.shared.removeProfileimg()
                UserDetail.shared.removeName()
                WhereSaveData.shared.clearData()
                FilterSavedData.shared.clearData()
                isappliedField = false
                
                // Load HomeVCWithoutLoginVC
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
                
                let nav = UINavigationController(rootViewController: homeVC)
                nav.isNavigationBarHidden = true
                
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                } else if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}


extension UIViewController {
    
    func topmostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topmostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topmostViewController() ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topmostViewController() ?? tabBarController
        }
        return self
    }

func safePresent(alertController: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
       let topVC = topmostViewController()

      // Check if an alert is already presented
      if topVC is UIAlertController {
          print("An alert is already being presented.")
          return
      }

      topVC.present(alertController, animated: animated, completion: completion)
  }
}

extension Result {
    func handle(success: @escaping (Success) -> Void) {
        switch self {
        case .success(let value):
            success(value)
        case .failure(let error):
            if APISessionManager.shared.isUnauthorizedAlertShowing {
                return
            }
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                return
            }
            topViewController.AlertControllerOnr(title: "", message: "\(error.localizedDescription)")
        }
    }
}


