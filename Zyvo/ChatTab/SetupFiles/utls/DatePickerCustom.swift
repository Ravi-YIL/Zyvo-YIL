//
//  DatePickerCustom.swift
//  Globe
//
//  Created by YATIN  KALRA on 27/09/20.
//  Copyright © 2020 Dhakar. All rights reserved.
//

import UIKit
public protocol DatePickerDelegate: class {
    func didSelect(date: Date?,tag:Int)
}
open class DatePickerCustom: NSObject {
    
    private weak var presentationController: UIViewController?
    private weak var delegate: DatePickerDelegate?
    private var dateFormatStr = "MM/dd/yyyy"
    private var tag  = 0
    private var dateRangeType : dateRange = .any
    private var currentDateType = Date()
    public init(presentationController: UIViewController,dateFormat : String = "MM/dd/yyyy", delegate: DatePickerDelegate) {
        
        super.init()
        
        self.dateFormatStr = dateFormat
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    public func showCalendar(titleStr:String,optionIdentifier : Int,currentDate:String?, Range: dateRange,showTime:Bool) {
        self.tag = optionIdentifier
        self.dateRangeType = Range
        
        var singleDate: Date = Date()
        
        if currentDate != nil &&  currentDate != "" && currentDate != "From" && currentDate != "To" {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            if let now = df.date(from: currentDate!) {
                singleDate = now
            }
        }
        currentDateType = singleDate
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionButtonShowCancel = true
        selector.optionIdentifier = optionIdentifier as AnyObject
        selector.optionTopPanelTitle = titleStr
        
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 5, to: singleDate)!
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDateRange.setStartDate(singleDate)
        selector.optionCurrentDateRange.setEndDate(modifiedDate)
        
        if showTime != true {
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(true)
            selector.optionStyles.showTime(false)
        }else{
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(false)
            selector.optionStyles.showTime(true)
        }
        let colorsCus = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selector.optionSelectorPanelBackgroundColor = colorsCus
        selector.optionTopPanelBackgroundColor = colorsCus
        selector.optionButtonFontColorCancel = colorsCus
        selector.optionButtonFontColorDone = colorsCus
        selector.optionSelectorPanelBackgroundColor = colorsCus
        selector.optionCalendarBackgroundColorTodayHighlight = colorsCus
        selector.optionCalendarBackgroundColorPastDatesHighlight = colorsCus
        selector.optionCalendarBackgroundColorFutureDatesHighlight = colorsCus
        selector.optionButtonFontColorDone = colorsCus
        selector.optionLayoutHeightRatio = 0.89
        self.presentationController?.present(selector, animated: true, completion: nil)
    }
}

extension DatePickerCustom : WWCalendarTimeSelectorProtocol {
    public func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let df = DateFormatter()
        df.dateFormat = dateFormatStr
        let now = df.string(from: date)
        print(now)
        self.delegate?.didSelect(date: date,tag: tag)
    }
    public func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        switch self.dateRangeType {
        
        case .lower:
            let oneDayFromNow = Calendar.current.date(byAdding: .day, value: -1, to: currentDateType)!
            if date > oneDayFromNow {
                return false
            }
        case .lower_current:
            
            if date > currentDateType {
                return false
            }
        case .uper:
            if date < currentDateType {
                return false
            }
        case .uper_current:
//            let oneDayFromNow = Calendar.current.date(byAdding: .day, value: -1, to: currentDateType)!
            let oneDayFromNow = Calendar.current.date(byAdding: .hour, value: -5, to: currentDateType)!
            
            if date < oneDayFromNow {
                return false
            }
        case .any:
            return true
        }
//        if self.dateRangeType == .any {
//           return true
//        }
//        if self.dateRangeType == .lower {
//           if date > currentDateType {
//               return false
//           }
//        }
//        if self.dateRangeType == .uper {
//           if date < currentDateType {
//               return false
//           }
//        }
        return true
    }
}

public enum dateRange {
    case lower
    case lower_current
    case uper
    case uper_current
    case any
}
