import UIKit
import Combine

final class CalendarViewController: UIViewController,
                                    UICollectionViewDataSource, UICollectionViewDelegate {

    private var collectionView: UICollectionView!
    private var viewModel = BookingSlotsViewModel()
    private let timeSlots = (0...23).map { TimeSlot(hour: $0) }
       private var dates: [Date] = []
       private var bookings: [BookingNew] = []
    private var cancellables = Set<AnyCancellable>()
    var propertyData : DatewiseBookingDetailDataModel?
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .black
//           bindVC()
//           setupDates()
//           setupCollectionView()
//           loadFromAPI()
//           ["start_date": "2025-08-01", "user_id": "78", "end_date": "2025-09-30", "longitude": 77.39988477465819, "property_id": 80, "latitude": 28.54289711234272]
           
//           viewModel.apiforGetBookingsList(propertyID: 80, startDate: "2025-08-01", endDate: "2025-09-30", lat: 28.54289711234272, lot: 77.39988477465819)
       }

       private func setupDates() {
           let f = DateFormatter()
           f.dateFormat = "yyyy-MM-dd"

           let start = f.date(from: "2025-08-01")!
           let end = f.date(from: "2025-09-30")!

           var d = start
           while d <= end {
               dates.append(d)
               d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
           }
       }

       private func setupCollectionView() {
           let layout = CalendarGridLayout()
           collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

           collectionView.backgroundColor = .black
           collectionView.dataSource = self
           collectionView.delegate = self

           collectionView.register(CalendarTimeCell.self, forCellWithReuseIdentifier: CalendarTimeCell.id)
           collectionView.register(CalendarDateHeaderCell.self, forCellWithReuseIdentifier: CalendarDateHeaderCell.id)
           collectionView.register(CalendarBookingCell.self, forCellWithReuseIdentifier: CalendarBookingCell.id)
           collectionView.register(CalendarEmptyCell.self, forCellWithReuseIdentifier: CalendarEmptyCell.id)

           collectionView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(collectionView)
           collectionView.alwaysBounceHorizontal = true
           collectionView.alwaysBounceVertical = true
           collectionView.showsHorizontalScrollIndicator = true
           collectionView.showsVerticalScrollIndicator = true
           collectionView.isDirectionalLockEnabled = false
           NSLayoutConstraint.activate([
               collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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


    
//       private func loadFromAPI() {
//           // API se parse karke bookings array fill kar
//           // SAME parseBooking logic jo pehle diya tha
//           let apiBookings: [BookingAPIModel] = [
//                      BookingAPIModel(
//                          booking_start_end: "21:55 - 00:55",
//                          booking_status: "finished",
//                          guest_name: "Alis Olsen",
//                          booking_id: 72,
//                          booking_date: "2025-09-04"
//                      ),
//                      BookingAPIModel(
//                          booking_start_end: "12:49 - 18:49",
//                          booking_status: "finished",
//                          guest_name: "Niks Argents",
//                          booking_id: 373,
//                          booking_date: "2025-08-11"
//                      )
//                  ]
//           self.bookings = apiBookings as! [BookingNew]
////                  handleAPIResponse(apiBookings)
//       }
}
extension CalendarViewController {

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
extension CalendarViewController {

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
extension CalendarViewController {
    func bindVC() {
            viewModel.$getBookingsSlotsResult
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let self = self else { return }
                    result?.handle(success: { response in
                        if response.success == true {
                            self.propertyData = response.data
                            
//                            self.SlotsArr.removeAll()
                            
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

                            self.collectionView.reloadData()   // 🔥 YE LINE MISS THI


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
    
    func createSlotData(from bookings: [BookingSlots], startDate: String, endDate: String) -> [SlotCustomDataModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var slotDataArray: [SlotCustomDataModel] = []
        
        // Convert string dates to Date objects
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return []
        }

        var currentDate = start
        while currentDate <= end {
            let dateString = dateFormatter.string(from: currentDate)
            
            let timeSlots: [String] = (0..<24).map {
                let hour = $0 % 12 == 0 ? 12 : $0 % 12
                let period = $0 < 12 ? "AM" : "PM"
                return String(format: "%02d:00 %@", hour, period)
            }

            var slotsArray: [slots] = []

            for slotTime in timeSlots {
                // Find a matching booking for this date and time slot
                if let matchedBooking = bookings.first(where: { booking in
                    booking.bookingDate == dateString &&
                    (booking.bookingStartEnd?.contains(slotTime) ?? false)
                }) {
                    let newSlot = slots(
                        bookingID: matchedBooking.bookingID,
                        guestName: matchedBooking.guestName ?? "Unknown",
                        bookingStatus: matchedBooking.bookingStatus ?? "Unknown",
                        bookingStart_EndTime: matchedBooking.bookingStartEnd
                    )
                    slotsArray.append(newSlot)
                } else {
                    let emptySlot = slots(bookingID: nil, guestName: nil, bookingStatus: nil, bookingStart_EndTime: slotTime)
                    slotsArray.append(emptySlot)
                }
            }

            slotDataArray.append(SlotCustomDataModel(date: dateString, slots: slotsArray))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            
        }
        print(slotDataArray , "<<<<< SlotsData")
        return slotDataArray
    }
}
