//
//  lertMSGList.swift
//  Roam
//
//  Created by YES IT Labs on 16/02/24.
//

import Foundation
import UIKit

class messageString {
    static let mNameValidation = "Please enter name."
    static let mEmailValidation = "Please enter email address."
    static let mValidEmail = "Please enter valid email."
    static let mInvalidEmail = "Invalid email address"
    static let mBirthDateValidation = "Please select date of birth."
    static let mGenderValidation = "Please select gender."
    static let mDanceCategoryValidation = "Please select dance categories."
    static let mPasswordValidation = "Please enter password."
    static let mConfirmPasswordValidation = "Please enter confirm password."
    static let mPaaswordmatch = "Password does not match with the confirm password."
    static let mPasPasswordswordMessage = "Password should be a combination of one upper case character, one lowercase character, one special character, one number, and should be at least 8 characters long"
    static let mAddProfilePhoto = "Please add profile photo."
    static let mAddress = "Please enter address."
    static let mRegSelect = "Please select registry."
    
    static let mRegistryTitle = "Please select registry title."
    static let mRegistryDesc = "Please enter registry description."
    static let mEndDate = "Please enter end date."
    static let mAddCover = "Please add cover image of registry."
    static let mAccountName = "Please enter account holder name."
    static let mAmountSuccess = "Please enter success amount."
    static let mObligationTitle = "Please select obligation title."
    static let mBankAccount = "Please enter bank account no."
    static let mConfirmBankAccount = "Please enter confirm bank account no."
    static let mRoutingNumber = "Please enter routing number."
    static let mValidRoutingNumber = "Please enter a valid routing number."
    static let mEmptyField = "Field can't be empty"
    static let mProofofbank = "Please select proof of  bank account."
    static let mAccountmatch = "Account number does not match with the confirm account number."
    
    static let mFirstName = "Enter first name"
    static let mLastName = "Enter last name"
    static let mEmail = "Enter email"
    static let mPhoneNumber = "Enter phone number"
    static let mDob = "Enter date of birth"
    static let mPIN = "Enter personal identification number"
    static let mCountry = "Select country"
    static let mState = "Select state"
    static let mCity = "Select city"
    static let mPostalCode = "Enter postal code"
    static let mFrontID = "Please upload front image of document."
    static let mBackID = "Please upload back image of document."
    static let mBankProofDoc = "Please upload proof of  bank account image/document."
    static let mPhoneNumberValidation = "Please Enter Phone Number."
    static let mEmptyOTP = "Please Enter OTP."
    static let mCorrectOTP = "Please enter correct OTP."
    static let mValidOTP = "Please Enter Valid OTP 111111."
    static let mNoGifter = "No gifters available"
    
}

extension UIViewController {
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func pavan_changeDateFoprmate(YourDate:String,FormatteFrom:String,FormatteTo:String) -> String {
        var valL = YourDate
        if YourDate != "" {
            let dateFormatte = DateFormatter()
            dateFormatte.dateFormat = FormatteFrom
            let dateNeweSE = dateFormatte.date(from: valL)
            dateFormatte.dateFormat = FormatteTo
            valL = dateFormatte.string(from: dateNeweSE!)
        }
        return valL
    }
    
    func AlertControllerCuston(title:String?,message:String?,BtnTitle:[String]?,completion: @escaping (_ dict:String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if BtnTitle != nil {
            
            for tickMark in stride(from: 0, to: BtnTitle!.count, by: 1) {
                let name :String = BtnTitle![tickMark]
                let tit : UIAlertAction = UIAlertAction(title: name, style: UIAlertAction.Style.default) { (result) in
                    print(result.title!)
                    completion(result.title!)
                }
                alert.addAction(tit)
                
            }
            self.present(alert, animated: true
                         , completion:   nil)
        }
    }
//    func AlertControllerOnr(title:String?,message:String?,BtnTitle:String = "OK") {
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let tit : UIAlertAction = UIAlertAction(title: BtnTitle, style: UIAlertAction.Style.default) { (result) in
//            print(result.title!)
//        }
//        alert.addAction(tit)
//        self.present(alert, animated: true, completion:   nil)
//    }
//    func format(with mask: String, phone: String) -> String {
//           let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
//           var result = ""
//           var index = numbers.startIndex // numbers iterator
//           for ch in mask where index < numbers.endIndex {
//               if ch == "X" {
//                   result.append(numbers[index])
//                   index = numbers.index(after: index)
//
//               } else if ch == "x" {
//                   result.append("1") // just append a mask character
//               }else{
//                   result.append(ch)
//               }
//           }
//           return result
//       }
    func format1(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for (i, ch) in mask.enumerated() where index < numbers.endIndex {
            if ch == "X" {
                if i == 0 {
                    result.append("+1")
                }
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    func formatPhoneNumber(_ phoneNumber: String) -> String {
           let numbersOnly = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

           var formattedNumber = ""
           var index = numbersOnly.startIndex

           // US phone number format: (XXX) XXX-XXXX
           let formatMask = "(XXX) XXX-XXXX"

           for char in formatMask {
               if char == "X" && index < numbersOnly.endIndex {
                   formattedNumber.append(numbersOnly[index])
                   index = numbersOnly.index(after: index)
               } else {
                   formattedNumber.append(char)
               }
           }

           return formattedNumber
       }

}
