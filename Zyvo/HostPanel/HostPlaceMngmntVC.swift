//
//  HostPlaceMngmntVC.swift
//  Zyvo
//
//  Created by ravi on 31/12/24.
//

import UIKit
import Combine

class HostPlaceMngmntVC: UIViewController {
    
    @IBOutlet weak var lbl_setupplaces: UILabel!
    @IBOutlet weak var lbl_manageYourPlace: UILabel!
    @IBOutlet weak var btnSaveContinueWidth: NSLayoutConstraint!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnHomeSetup: UIButton!
    @IBOutlet weak var btnGalleryLocation: UIButton!
    @IBOutlet weak var btnavailibity: UIButton!
    @IBOutlet weak var btnsBgView:UIView!
    @IBOutlet weak var ContainerV: UIView!
    
    @IBOutlet weak var btnSaveContinue: UIButton!
    @IBOutlet weak var BgV: UIView!
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    var comesFrom = ""
    
    var HomeSetupVC:HomeSetupVC! = nil
    var HostGalleryLocationVC:HostGalleryLocationVC! = nil
    var HostAvailibilityVC:HostAvailibilityVC! = nil
    
    var PlceMngmtViewModel = PlaceMngmt_ViewModel()
    private var cancellables = Set<AnyCancellable>()
    var UpdateViewModel = UpdatePropertyViewModel()
    var EditPlceMngmtViewModel = GetPropertyDetailViewModel()
    var propertyDetailArr : GetPropertyModel?
    var propertyId = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSaveContinueWidth.constant = 170
        
        btnSaveContinue.titleLabel?.font = UIFont(name: "Poppins", size: 17)!
        btnGalleryLocation.titleLabel?.font = UIFont(name: "Poppins", size: 13.0)!
        btnHomeSetup.titleLabel?.font = UIFont(name: "Poppins", size: 13.0)!
        btnavailibity.titleLabel?.font = UIFont(name: "Poppins", size: 13.0)!
        
        lbl_setupplaces.numberOfLines = 2
        lbl_setupplaces.lineBreakMode = .byWordWrapping
        
        if comesFrom == "edit"{
            self.bindVC_ForEdit()
            EditPlceMngmtViewModel.HostGetPropertyDetail(propertyId: self.propertyId)
            self.bindVC_ForUpdatePrperty()
        }
        self.bindVC()
        currentPage = 0
        createPageViewController()
        self.btnClicked(btn: self.btnHomeSetup)
        makeCircular(btnSaveContinue, btnHomeSetup, btnGalleryLocation, btnavailibity, viewButton)

       
    }
    
    func makeCircular(_ views: UIView...) {
        views.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.clipsToBounds = true
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        if currentPage == 0{
            self.navigationController?.popViewController(animated: true)
        }else{
            if currentPage < arrVC.count + 1 {
                currentPage -= 1
                pageController.setViewControllers(
                    [arrVC[currentPage]],direction: .reverse,animated: true,completion: nil
                )
                // Update button backgrounds to reflect the active tab
                updateButtonSelection(for: currentPage)
            }
        }
        btnSaveContinueWidth.constant = 170
        btnSaveContinue.setTitle("Save & Continue", for: .normal)
    }
    
    @IBAction func btnHomeSetup(_ sender: UIButton) {
        self.currentPage = 0
        btnSaveContinueWidth.constant = 170
        btnHomeSetup.layer.backgroundColor = UIColor.white.cgColor
        btnGalleryLocation.layer.backgroundColor = UIColor.clear.cgColor
        btnavailibity.layer.backgroundColor = UIColor.clear.cgColor
        btnSaveContinue.setTitle("Save & Continue", for: .normal)
        btnClicked(btn: sender)
    }
    
    @IBAction func btnGalleryLocation(_ sender: UIButton) {
        self.currentPage = 1
        btnavailibity.layer.backgroundColor = UIColor.clear.cgColor
        btnGalleryLocation.layer.backgroundColor = UIColor.white.cgColor
        btnHomeSetup.layer.backgroundColor = UIColor.clear.cgColor
        btnSaveContinue.setTitle("Save & Continue", for: .normal)
        btnSaveContinueWidth.constant = 170
        btnClicked(btn: sender)
    }
    
    @IBAction func btnAvailibility(_ sender: UIButton) {
        self.currentPage = 2
        btnSaveContinueWidth.constant = 150
        btnavailibity.layer.backgroundColor = UIColor.white.cgColor
        btnGalleryLocation.layer.backgroundColor = UIColor.clear.cgColor
        btnHomeSetup.layer.backgroundColor = UIColor.clear.cgColor
        btnSaveContinue.setTitle("Publish Now", for: .normal)
        btnClicked(btn: sender)
    }
    @IBAction private func btnClicked(btn: UIButton) {
        
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in })
    }
    
    @IBAction func saveBtn(_ sender: UIButton){
        if currentPage == 2{
//            self.navigationController?.popToRootViewController(animated: true)
            guard validation() else {
                return
            }
            if comesFrom == "edit"{
                self.UpdateViewModel.UpdateApi(PropertyID: self.propertyId)
            }else{
                self.PlceMngmtViewModel.postApi()
            }
        }else{
            if currentPage < arrVC.count - 1 {
                currentPage += 1
                pageController.setViewControllers(
                    [arrVC[currentPage]],direction: .forward,animated: true,completion: nil
                )
                // Update button backgrounds to reflect the active tab
                updateButtonSelection(for: currentPage)
            }
            if currentPage == 2{
                btnSaveContinueWidth.constant = 150
                sender.setTitle("Publish Now", for: .normal)
                //Api
            }else{
                btnSaveContinueWidth.constant = 170
                sender.setTitle("Save & Continue", for: .normal)
            }
        }
//        }else{
//            let nextVC = self.navigationController?.popToRootViewController(animated: true)
//        }
    }
    
    private func updateButtonSelection(for index: Int) {
        btnHomeSetup.layer.backgroundColor = index == 0 ? UIColor.white.cgColor : UIColor.clear.cgColor
        btnGalleryLocation.layer.backgroundColor = index == 1 ? UIColor.white.cgColor : UIColor.clear.cgColor
        btnavailibity.layer.backgroundColor = index == 2 ? UIColor.white.cgColor : UIColor.clear.cgColor
    }

}

extension HostPlaceMngmntVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate{
    private func createPageViewController() {
        // Initialize the page view controller
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        // Set UIScrollView delegate for pageController's scroll view
        for subview in pageController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        // Instantiate view controllers
        HomeSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeSetupVC") as? HomeSetupVC
        
        HostGalleryLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "HostGalleryLocationVC") as? HostGalleryLocationVC
        
        HostAvailibilityVC = self.storyboard?.instantiateViewController(withIdentifier: "HostAvailibilityVC") as? HostAvailibilityVC
        
        arrVC = [HomeSetupVC,HostGalleryLocationVC,HostAvailibilityVC]
        
        // Set initial view controller for the pageController
        pageController.setViewControllers([HomeSetupVC!], direction: .forward, animated: false, completion: nil)
        
        // Add pageController as a child view controller
        self.addChild(pageController)
        ContainerV.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        // Use Auto Layout to match the frame of ContainerV
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: ContainerV.topAnchor ),
            pageController.view.bottomAnchor.constraint(equalTo: ContainerV.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: ContainerV.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: ContainerV.trailingAnchor)
        ])
    }
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.firstIndex(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
            
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        if index == 0 {
            
        }else{
            
        }
        if(index != -1) {
            index = index + 1
            
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.firstIndex(of: (pageViewController1.viewControllers?.last)!)
            if let cur = currentPage {
                if cur == 0 {
                    btnHomeSetup.layer.backgroundColor = UIColor.white.cgColor
                    btnGalleryLocation.layer.backgroundColor = UIColor.clear.cgColor
                    btnavailibity.layer.backgroundColor = UIColor.clear.cgColor
                    btnSaveContinue.setTitle("Save & Continue", for: .normal)
//                    btnClicked(btn: sender)
                }else if cur == 1{
                    btnavailibity.layer.backgroundColor = UIColor.clear.cgColor
                    btnGalleryLocation.layer.backgroundColor = UIColor.white.cgColor
                    btnHomeSetup.layer.backgroundColor = UIColor.clear.cgColor
                    btnSaveContinue.setTitle("Save & Continue", for: .normal)
                }else{
                    btnavailibity.layer.backgroundColor = UIColor.white.cgColor
                    btnGalleryLocation.layer.backgroundColor = UIColor.clear.cgColor
                    btnHomeSetup.layer.backgroundColor = UIColor.clear.cgColor
                    btnSaveContinue.setTitle("Publish Now", for: .normal)
                }
            }
        }
        
    }
}

extension HostPlaceMngmntVC{
    func validation() -> Bool {
        
        let propertySizeVal = Int(SingltonClass.shared.propertySize) ?? 0
        if propertySizeVal < 1 {
            self.popupAlert(title: "Alert!", message: "Please select the property size", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        let noOfPplVal = Int(SingltonClass.shared.no_Of_Ppl) ?? 0
        if noOfPplVal < 1 {
            self.popupAlert(title: "Alert!", message: "Please select number of people", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        let noOfBathrooms = Int(SingltonClass.shared.bathrooms) ?? 0
        if noOfBathrooms < 1 {
            self.popupAlert(title: "Alert!", message: "Please select count of bathrooms", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        let JoinedActivities = SingltonClass.shared.activies + SingltonClass.shared.other_Activities
        if JoinedActivities.isEmpty {
            AlertControllerOnr(title: "Alert", message: "Please select atleast one activities.")
            return false
        } else if SingltonClass.shared.aminities.count == 0{
                self.popupAlert(title: "Alert!", message: "Please selecte aminities.", actionTitles: ["OK"], actions:[{action1 in}])
                return false
        } else if SingltonClass.shared.cancellationDays == ""  {
                self.popupAlert(title: "Alert!", message: "Please select the cancellation duration.", actionTitles: ["OK"], actions:[{action1 in}])
                return false
        } else if SingltonClass.shared.Imgs.count == 0 {
            self.popupAlert(title: "Alert!", message: "Please upload atleast 1 image.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        else if SingltonClass.shared.title == ""{
            self.popupAlert(title: "Alert!", message: "Please enter title.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }else if SingltonClass.shared.street == ""{
            self.popupAlert(title: "Alert!", message: "Please enter street address.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }else if SingltonClass.shared.city == ""{
            self.popupAlert(title: "Alert!", message: "Please enter city.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        else if SingltonClass.shared.zipcode == ""{
            self.popupAlert(title: "Alert!", message: "Please enter zipcode.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        else if SingltonClass.shared.state == ""{
            self.popupAlert(title: "Alert!", message: "Please enter state.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        else if SingltonClass.shared.country == ""{
            self.popupAlert(title: "Alert!", message: "Please enter country.", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        else if SingltonClass.shared.avilabilityHrsFrom == ""{
            self.popupAlert(title: "Alert!", message: "Please select avilabilty from", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
        
        else if SingltonClass.shared.avilabilityHrsTo == ""{
            self.popupAlert(title: "Alert!", message: "Please select avilabilty to", actionTitles: ["OK"], actions:[{action1 in}])
            return false
        }
//        else if imageArrayList.isEmpty {
//            self.popupAlert(title: "Alert!", message: "Please select the images.", actionTitles: ["Okay!"], actions:[{action1 in}])
//            return false
//        }
        
        return true
    }
    
}


extension HostPlaceMngmntVC {
    func bindVC(){
        PlceMngmtViewModel.$createPlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.navigationController?.popViewController(animated: true)
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_ForUpdatePrperty(){
        UpdateViewModel.$UpdatePlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_ForEdit(){
        EditPlceMngmtViewModel.$getPropertyResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
//                    self.propertyDetailArr = ""
                    self.propertyDetailArr = response.data
                    
                    SingltonClass.shared.typeOfSpace = self.propertyDetailArr?.spaceType ?? ""
                    SingltonClass.shared.propertySize = "\(self.propertyDetailArr?.propertySize ?? 0)"
                    SingltonClass.shared.no_Of_Ppl = "\(self.propertyDetailArr?.maxGuestCount ?? 0)"
                    SingltonClass.shared.bedrooms = "\(self.propertyDetailArr?.bedroomCount ?? 0)"
                    SingltonClass.shared.bathrooms = "\(self.propertyDetailArr?.bathroomCount ?? 0)"
                    SingltonClass.shared.activies = self.propertyDetailArr?.activities ?? []
                    SingltonClass.shared.aminities = self.propertyDetailArr?.amenities ?? []
                    SingltonClass.shared.instantBooking = "\(self.propertyDetailArr?.isInstantBook ?? 0)"
                    SingltonClass.shared.selfCheck_in = "\(self.propertyDetailArr?.hasSelfCheckin ?? 0)"
                    SingltonClass.shared.allowPets = "\(self.propertyDetailArr?.allowsPets ?? 0)"
                    SingltonClass.shared.cancellationDays = "\(self.propertyDetailArr?.cancellationDuration ?? 0)"
                    SingltonClass.shared.Imgs.removeAll()
                    if let propertyImages = self.propertyDetailArr?.propertyImages {
                        for i in propertyImages {
                            SingltonClass.shared.Imgs.append(imageArray(image: nil,data: nil,url: i.image_url,image_id: "\(i.id ?? 0)",thumbNail: nil))
                        }
                    }
                    print( SingltonClass.shared.Imgs)
                    SingltonClass.shared.title = self.propertyDetailArr?.title ?? ""
                    SingltonClass.shared.about = self.propertyDetailArr?.propertyDescription ?? ""
                    SingltonClass.shared.parkingRule = self.propertyDetailArr?.parkingRules ?? ""
                    SingltonClass.shared.hostRules = self.propertyDetailArr?.hostRules ?? ""
                    SingltonClass.shared.street = self.propertyDetailArr?.streetAddress ?? ""
                    SingltonClass.shared.city = self.propertyDetailArr?.city ?? ""
                    SingltonClass.shared.zipcode = self.propertyDetailArr?.zipCode ?? ""
                    SingltonClass.shared.state = self.propertyDetailArr?.state ?? ""
                    SingltonClass.shared.country = self.propertyDetailArr?.country ?? ""
                    SingltonClass.shared.latitude = Double(self.propertyDetailArr?.latitude ?? "")
                    SingltonClass.shared.longitude = Double(self.propertyDetailArr?.longitude ?? "")
                    SingltonClass.shared.miniHrsPric_HrsMini = self.propertyDetailArr?.minBookingHours ?? ""
                    SingltonClass.shared.miniHrsPric_perHrs = self.propertyDetailArr?.hourlyRate ?? ""
                    SingltonClass.shared.bulkDis_HrsMini = String(self.propertyDetailArr?.bulkDiscountHour ?? 0)
                    SingltonClass.shared.bulkDis_Discount = self.propertyDetailArr?.bulkDiscountRate ?? ""
                    SingltonClass.shared.addOns.removeAll()
                    for i in self.propertyDetailArr?.addOns ?? []{
                        SingltonClass.shared.addOns.append(addonsData(name: i.name,price: i.price))
                    }
                    
                    SingltonClass.shared.addCleaningFees = self.propertyDetailArr?.cleaningFee
                    SingltonClass.shared.avilabilityDays = self.propertyDetailArr?.availableDay ?? ""
                   // SingltonClass.shared.avilabilityMonth = self.propertyDetailArr?.availableMonth ?? ""
                    
                    SingltonClass.shared.avilabilityMonth =
                        self.propertyDetailArr?.availableMonth?
                            .split(separator: ",")
                            .map { String($0) } ?? []
                    SingltonClass.shared.avilabilityHrsFrom = self.propertyDetailArr?.availableFrom ?? ""
                    SingltonClass.shared.avilabilityHrsTo = self.propertyDetailArr?.availableTo ?? ""
                    NotificationCenter.default.post(name: NSNotification.Name("NotificationForEdit"), object: nil)
                })
            }.store(in: &cancellables)
    }
    
}
