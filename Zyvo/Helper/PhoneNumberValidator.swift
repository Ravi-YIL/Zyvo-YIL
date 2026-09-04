//
//  PhoneNumberValidator.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/06/25.
//


import Foundation
import PhoneNumberKit

final class PhoneNumberValidator {

    private let phoneNumberKit = PhoneNumberKit()

    // MARK: - Main Validation

    func isValidMobileNumber(
        countryCode: String,
        number: String
    ) -> Bool {

        let cleanCode = countryCode
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        let cleanNumber = number
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        guard !cleanNumber.isEmpty else {
            return false
        }

        // MARK: - US Special Handling

        if cleanCode == "1" {
            var usNumber = cleanNumber
            if usNumber.count == 11 && usNumber.hasPrefix("1") {
                usNumber = String(usNumber.dropFirst())
            }
            return isValidUSPhoneFormat(usNumber)
        }

        // MARK: - Other Countries → PhoneNumberKit

        guard let codeInt = UInt64(cleanCode) else {
            print("Invalid country code")
            return false
        }

        guard let region = phoneNumberKit.mainCountry(forCode: codeInt) else {
            print("Invalid region")
            return false
        }

        if cleanNumber.hasPrefix(cleanCode) && cleanNumber.count > cleanCode.count {
            let strippedNumber = String(cleanNumber.dropFirst(cleanCode.count))
            if let parsed = try? phoneNumberKit.parse(
                strippedNumber,
                withRegion: region,
                ignoreType: true
            ), parsed.countryCode == codeInt {
                return true
            }
        }

        do {

            let parsed = try phoneNumberKit.parse(
                cleanNumber,
                withRegion: region,
                ignoreType: true
            )

            return parsed.countryCode == codeInt

        } catch {

            print("Parse failed:", error)
            return false
        }
    }

    // MARK: - US Regex Validation

    private func isValidUSPhoneFormat(_ number: String) -> Bool {

        // NANP format:
        // First digit cannot be 0 or 1

        let regex = "^[2-9][0-9]{9}$"

        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: number)
    }
}
