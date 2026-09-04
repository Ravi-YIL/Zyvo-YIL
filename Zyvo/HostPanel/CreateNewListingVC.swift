//
//  CreateNewListingVC.swift
//  Zyvo
//
//  Created by ravi on 3/01/25.
//

import UIKit
import Fastis
import Combine

class CreateNewListingVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var view_Search: UIView!
    
    @IBOutlet weak var btnEditPlace: UIButton!
    @IBOutlet weak var btnPauseBooking: UIButton!
    @IBOutlet weak var viewMainDataS: UIView!
    @IBOutlet weak var lblRange: UILabel!
//    @IBOutlet weak var collV: UICollectionView!
    @IBOutlet weak var propertyNameLbl: UILabel!
    @IBOutlet weak var propertyImg: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var milesLbl: UILabel!
    @IBOutlet weak var bookingPauseResumeBtnO: UIButton!
    @IBOutlet weak var collBGView: UIView!
    
    var datesArray: [String] = []
    let calendar = Calendar.current
    var structuredBookings: [String: [String: BookingSlots?]] = [:]
    var sDate = ""
    var eDate = ""
    var SlotsArr = [SlotCustomDataModel]()
    private var viewModel = BookingSlotsViewModel()
    var propertyID : Int?
    var lat: Double?
    var lot: Double?
    
    private var selectedDates: [Date] = []
    private var collectionView: UICollectionView!
    private let timeSlots = (0...23).map { TimeSlot(hour: $0) }
    private var dates: [Date] = []
    private var bookings: [BookingNew] = []
    private var cancellables = Set<AnyCancellable>()
    var propertyData : DatewiseBookingDetailDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // updateStackView()
        
        self.propertyImg.layer.cornerRadius = 7
        
        bindVC()
        
        let startAndEndDate = getCurrentWeekDates()
        sDate = startAndEndDate.startDate
        eDate = startAndEndDate.endDate
        
        let rangeText = formatRangeString(start: sDate, end: eDate)
        self.lblRange.text = rangeText
        
        viewModel.apiforGetBookingsList(propertyID: self.propertyID ?? 0, startDate: sDate, endDate: eDate, lat: self.lat ?? 0.0, lot: self.lot ?? 0.0)
        btnPauseBooking.layer.cornerRadius = 10
        
        btnEditPlace.layer.borderWidth = 1
        btnEditPlace.layer.cornerRadius = 10
        btnEditPlace.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor

        viewMainDataS.layer.borderWidth = 1
        viewMainDataS.layer.cornerRadius = 20
        viewMainDataS.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Search.applyRoundedStyle()
        
        setupDates()
        setupCollectionView()
//        collV.delegate = self
//        collV.dataSource = self
//        collV.register(UINib(nibName: "HeaderCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCell")
        
        
    }
    
    @IBAction func btnSelectDateRange_Tap(_ sender: Any) {
        
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
//        fastisController.minimumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek]
//        fastisController.doneHandler = { resultRange in
//           print(resultRange,"resultRange")
//            self.formatDateRange(range: resultRange ?? default value )
//        }
        fastisController.doneHandler = { resultRange in
            print(resultRange ?? "No range selected", "resultRange")
            
            if let range = resultRange {
                 let FromData = resultRange?.fromDate
                let toData = resultRange?.toDate
                print("end Date after selected =>", resultRange?.toDate)
                self.getDatesWithWeekdays(from: FromData ?? Date(), to: toData ?? Date())
                
                let formattedRange = self.formatFastisRange(fromDate: FromData ?? Date(), toDate: toData ?? Date())
                self.lblRange.text = formattedRange
//                let formattedRange = formatFastisRange(fromDate: resultRange?.fromDate ?? "", toDate: toData ?? "")
//                print(formattedRange)
                
                let dateForApi = self.parseDateRange(dateString: formattedRange)
                
                self.viewModel.apiforGetBookingsList(propertyID: self.propertyID ?? 0, startDate: dateForApi.StartDate ?? "", endDate: dateForApi.EndDate ?? "", lat: self.lat ?? 0.0, lot: self.lot ?? 0.0)
                self.setupDates()
                self.setupCollectionView()
//                self.collV.reloadData()
            } else {
                // Handle nil case if needed, e.g., pass a default range or show a message
            }
        }
        fastisController.present(above: self)

    }
    
    func formatRangeString(start: String, end: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // <-- change format based on your string format

        guard let startDate = inputFormatter.date(from: start),
              let endDate = inputFormatter.date(from: end) else {
            return ""
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd"

        let startStr = displayFormatter.string(from: startDate)

        let endDayFormatter = DateFormatter()
        endDayFormatter.dateFormat = "dd"
        let endDayStr = endDayFormatter.string(from: endDate)

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearStr = yearFormatter.string(from: endDate)

        return "\(startStr) - \(endDayStr) \(yearStr)"
    }

    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func newPlace_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostPlaceMngmntVC") as! HostPlaceMngmntVC
        vc.comesFrom = "edit"
        vc.propertyId = self.propertyID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func PauseResumeBtn_Tap(_ sender: UIButton) {
        viewModel.apiforPauseResumeBooking(propertyID: self.propertyID ?? 0)
    }
    
    func formatFastisRange(fromDate: Date, toDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Format for the month and day
        dateFormatter.dateFormat = "MMM dd"
        let fromDateString = dateFormatter.string(from: fromDate)
        
        // Format for the day (for the end date)
        dateFormatter.dateFormat = "dd yyyy"
        let toDateString = dateFormatter.string(from: toDate)
        print("end Date after Fromate Fastis =>", toDateString)
        return "\(fromDateString) - \(toDateString)"
       
    }
    
    //Formating date to send into API
    func parseDateRange(dateString: String) -> (StartDate: String?, EndDate: String?) {
        let dateComponents = dateString.components(separatedBy: " - ")
        
        guard dateComponents.count == 2 else { return (nil, nil) }
        
        let firstPart = dateComponents[0].components(separatedBy: " ")
        let secondPart = dateComponents[1].components(separatedBy: " ")
        
        guard firstPart.count == 2, secondPart.count == 2 else { return (nil, nil) }
        
        let monthString = firstPart[0]  // "Feb"
        let startDay = firstPart[1]     // "26"
        let endDay = secondPart[0]      // "09"
        let year = secondPart[1]        // "2025"

        // Convert month abbreviation to month number
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        if let date = dateFormatter.date(from: monthString) {
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: date)
            
            // Get next month for the end date
            let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            let nextMonth = dateFormatter.string(from: nextMonthDate)
            
            // Format output
            let StartDate = "\(year)-\(month)-\(startDay)"
            let EndDate = "\(year)-\(month)-\(endDay)"
            self.sDate = StartDate
            self.eDate = EndDate
            print("end Date after parsing =>", self.eDate)
            return (StartDate, EndDate)
        }
        
        return (nil, nil)
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return datesArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
//        
////        cell.dateLbl.text = datesArray[indexPath.item]
////        
////        let dateKey = datesArray[indexPath.section]  // Get the date
////            let timeSlot = timeSlots[indexPath.row]      // Get the time slot
////            var slotIndex = 0 // Index for multiple slots in a single cell
//////        if let bookings = propertyData?.bookings?.filter({ $0.bookingDate == dateKey }) {
////            
////            print(bookings,"yahi hai hai ")
//////               for booking in bookings {
//////                   if let bookingSlot = booking.bookingStartEnd {
//////                       let matchingSlots = getMatchingTimeSlots(bookingSlot: bookingSlot, timeSlots: timeSlots)
//////
//////                       for slot in matchingSlots {
//////                           if let slotIndex = timeSlots.firstIndex(of: slot) {
//////                               cell.configureSlot(at: slotIndex, with: booking)
//////                           }else{
//////                               cell.clearSlot(at: slotIndex)
//////                           }
//////                       }
//////                   }
//////               }
////           }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.layer.frame.width / 2, height: 2500)
//    }
    
    func getDatesWithWeekdays(from startDate: Date, to endDate: Date) -> [String] {
//        var datesArray: [String] = []
//        let calendar = Calendar.current
        var currentDate = startDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - EEE" // Format: "25 - Tue"
        datesArray.removeAll()
        while currentDate <= endDate {
            let formattedDate = dateFormatter.string(from: currentDate)
            
            datesArray.append(formattedDate)
            SlotsArr.append(SlotCustomDataModel(date: formattedDate,slots: []))
//            print(SlotsArr, "SlotsArray yhi hai...")
            // Move to the next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return datesArray
    }

    func formatDateFromApiToSlot(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd - EEE"
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    //GEt current week Dates For View DidLoad
    func getCurrentWeekDates() -> (startDate: String, endDate: String) {
        let calendar = Calendar.current
        let today = Date()
        
        // Find the weekday (1 = Sunday, 2 = Monday, ...)
        let weekday = calendar.component(.weekday, from: today)
        
        // Calculate start of the week (Sunday)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!

        // End of week (Saturday)
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let startString = formatter.string(from: startOfWeek)
        let endString = formatter.string(from: endOfWeek)
        
        return (startString, endString)
    }
    
}

//MARK: - Calender Collection

extension CreateNewListingVC{
    private func setupDates() {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            print("Start Date =>", sDate)
            print("End Date =>", eDate)

            guard let start = f.date(from: sDate), let end = f.date(from: eDate) else {
                dates.removeAll()
                return
            }

            dates.removeAll()
            var current = start
            let cal = Calendar.current
            while current <= end {
                dates.append(current)
                guard let next = cal.date(byAdding: .day, value: 1, to: current) else { break }
                current = next
            }
    }
    private func setupCollectionView() {
        let layout = CalendarGridLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CalendarTimeCell.self, forCellWithReuseIdentifier: CalendarTimeCell.id)
        collectionView.register(CalendarDateHeaderCell.self, forCellWithReuseIdentifier: CalendarDateHeaderCell.id)
        collectionView.register(CalendarBookingCell.self, forCellWithReuseIdentifier: CalendarBookingCell.id)
        collectionView.register(CalendarEmptyCell.self, forCellWithReuseIdentifier: CalendarEmptyCell.id)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.isDirectionalLockEnabled = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        collBGView.backgroundColor = .white
        collBGView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: collBGView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collBGView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: collBGView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collBGView.trailingAnchor)
        ])
    }


 private func bookingFor(date: Date, hour: Int) -> BookingNew? {
     bookings.first { booking in
         guard Calendar.current.isDate(booking.date, inSameDayAs: date) else {
             return false
         }

         let startHourFloat = Double(booking.startHour) + 0.0  // optionally include minutes
         let endHourFloat = Double(booking.endHour) + 0.0

         return Double(hour) >= floor(startHourFloat) && Double(hour) < ceil(endHourFloat)
     }
 }
}

extension CreateNewListingVC {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return timeSlots.count + 1   // +1 for top date row
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dates.count + 1       // +1 for left time column
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Top-left empty cell
        if indexPath.section == 0 && indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarEmptyCell.id,
                for: indexPath
            ) as! CalendarEmptyCell
            
            return cell
        }
        // Top date header
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarDateHeaderCell.id,
                for: indexPath
            ) as! CalendarDateHeaderCell

            cell.configure(dates[indexPath.item - 1])
            return cell
        }

        // Left time column
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarTimeCell.id,
                for: indexPath
            ) as! CalendarTimeCell

            cell.configure(timeSlots[indexPath.section - 1].display)
            return cell
        }

        // Booking cell
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarBookingCell.id,
            for: indexPath
        ) as! CalendarBookingCell

        let date = dates[indexPath.item - 1]
        let hour = timeSlots[indexPath.section - 1].hour

        if let booking = bookingFor(date: date, hour: hour) {
            cell.configure(booking, forHour: hour)
        } else {
            cell.empty()
        }

        return cell
    }
}

extension CreateNewListingVC {
    func bindVC() {
            viewModel.$getBookingsSlotsResult
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let self = self else { return }
                    result?.handle(success: { response in
                        if response.success == true {
                            self.propertyData = response.data
                            
//                            self.SlotsArr.removeAll()
                            
//                            guard let bookings = self.propertyData?.bookings else { return }
                            
                            self.propertyNameLbl.text = self.propertyData?.propertyTitle
                            
                          //  self.ratingLbl.text = self.propertyData?.reviewsTotalRating
                            
                            
                            let ratingString = self.propertyData?.reviewsTotalRating

                            if let rating = Double(ratingString ?? "0.0") {
                                let formatted = String(format: "%.1f", rating)  // rounds to one decimal place
                                self.ratingLbl.text = formatted
                            }
                      
                            self.ratingCountLbl.text = "(\(self.formatCount(Int(self.propertyData?.reviewsTotalCount ?? "") ?? 0)))"
                            self.milesLbl.text = "\(self.propertyData?.distanceMiles ?? "") miles away"
                            let img = self.propertyData?.propertyImage
                            self.propertyImg.loadImage(from: AppURL.imageURL + (img ?? ""),placeholder: UIImage(named: "NoIMg"))
                            if self.propertyData?.propertyStatus == "active"{
                                self.bookingPauseResumeBtnO.setTitle("Pause Booking", for: .normal)
                            }else{
                                self.bookingPauseResumeBtnO.setTitle("Resume Booking", for: .normal)
                            }
                            
                            guard let apiBookings = self.propertyData?.bookings else { return }

                            self.bookings = apiBookings.compactMap { booking in
                                let date = self.parseDate(booking.booking_date)
                                let (start, end) = self.parseHours(booking.booking_start_end)

                                return BookingNew(
                                    date: date,
                                    startHour: start,
                                    endHour: end,
                                    guestName: booking.guest_name,
                                    status: booking.booking_status
                                )
                            }

                            self.collectionView.reloadData()
                            
//                            }
//                            let formattedData = self.createSlotData(from: bookings, startDate: self.sDate, endDate: self.eDate)
                            
//                            for i in 0..<self.SlotsArr.count {
//                                let slotDate = self.SlotsArr[i].date
//                                
//                                for _ in 0..<24 {  // Run loop 24 times (for 24 hours)
//                                    
//                                    for booking in bookings {
//                                        let formattedDate = self.formatDateFromApiToSlot(booking.bookingDate ?? "")
//                                        
//                                        if slotDate == formattedDate {
//                                            self.SlotsArr[i].slots?.append(slots(
//                                                bookingID: booking.bookingID,
//                                                guestName: booking.guestName ?? "",
//                                                bookingStatus: booking.bookingStatus ?? "",
//                                                bookingDate: booking.bookingDate ?? "",
//                                                bookingStart_EndTime: booking.bookingStartEnd ?? ""
//                                            ))
//                                        }else{
//                                            self.SlotsArr[i].slots?.append(slots(
//                                                bookingID: nil,
//                                                guestName: "",
//                                                bookingStatus: "",
//                                                bookingDate: "",
//                                                bookingStart_EndTime: ""
//                                            ))
//                                        }
//                                    }
//                                    
//                                }
//                            }
                            print(self.SlotsArr, "Updated SlotsArr Data")
//                            self.collV.reloadData()
                        }
                    })
                }.store(in: &cancellables)
        
        viewModel.$pauseResumeBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        self.viewModel.apiforGetBookingsList(propertyID: self.propertyID ?? 0, startDate: self.sDate, endDate: self.eDate, lat: self.lat ?? 0.0, lot: self.lot ?? 0.0)

                    }
                })
            }.store(in: &cancellables)
        }

    func formatCount(_ count: Int) -> String {
        let num = Double(count)
        let thousand = num / 1_000
        let million = num / 1_000_000
        let billion = num / 1_000_000_000

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0

        if billion >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: billion)) ?? "0")B"
        } else if million >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: million)) ?? "0")M"
        } else if thousand >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: thousand)) ?? "0")K"
        } else {
            return "\(count)"
        }
    }
    
//    func createSlotData(from bookings: [BookingSlots], startDate: String, endDate: String) -> [SlotCustomDataModel] {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        var slotDataArray: [SlotCustomDataModel] = []
//        
//        // Convert string dates to Date objects
//        guard let start = dateFormatter.date(from: startDate),
//              let end = dateFormatter.date(from: endDate) else {
//            return []
//        }
//
//        var currentDate = start
//        while currentDate <= end {
//            let dateString = dateFormatter.string(from: currentDate)
//            
//            let timeSlots: [String] = (0..<24).map {
//                let hour = $0 % 12 == 0 ? 12 : $0 % 12
//                let period = $0 < 12 ? "AM" : "PM"
//                return String(format: "%02d:00 %@", hour, period)
//            }
//
//            var slotsArray: [slots] = []
//
//            for slotTime in timeSlots {
//                // Find a matching booking for this date and time slot
//                if let matchedBooking = bookings.first(where: { booking in
//                    booking.bookingDate == dateString &&
//                    (booking.bookingStartEnd?.contains(slotTime) ?? false)
//                }) {
//                    let newSlot = slots(
//                        bookingID: matchedBooking.bookingID,
//                        guestName: matchedBooking.guestName ?? "Unknown",
//                        bookingStatus: matchedBooking.bookingStatus ?? "Unknown",
//                        bookingStart_EndTime: matchedBooking.bookingStartEnd
//                    )
//                    slotsArray.append(newSlot)
//                } else {
//                    let emptySlot = slots(bookingID: nil, guestName: nil, bookingStatus: nil, bookingStart_EndTime: slotTime)
//                    slotsArray.append(emptySlot)
//                }
//            }
//
//            slotDataArray.append(SlotCustomDataModel(date: dateString, slots: slotsArray))
//            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
//            
//        }
//        print(slotDataArray , "<<<<< SlotsData")
//        return slotDataArray
//    }
}
extension CreateNewListingVC {

    func parseDate(_ str: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: str) ?? Date()
    }

    func parseHours(_ time: String) -> (Int, Int) {
        // "21:55 - 00:55"
        let parts = time.components(separatedBy: "-")
        let start = parts.first?.trimmingCharacters(in: .whitespaces) ?? "00:00"
        let end = parts.last?.trimmingCharacters(in: .whitespaces) ?? "00:00"

        let sf = start.split(separator: ":")
        let ef = end.split(separator: ":")

        return (Int(sf[0]) ?? 0, Int(ef[0]) ?? 0)
    }
}
