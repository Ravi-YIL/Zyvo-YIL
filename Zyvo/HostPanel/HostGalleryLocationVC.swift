//
//  HostGalleryLocationVC.swift
//  Zyvo
//
//  Created by ravi on 31/12/24.
//

import UIKit
import PhotosUI
import GoogleMaps
import GooglePlaces
import Combine
import DropDown

class HostGalleryLocationVC: UIViewController,GMSMapViewDelegate, UITextViewDelegate, GMSAutocompleteFetcherDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var viewMainMap: UIView!
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_city: UIView!
    @IBOutlet weak var view_zipcode: UIView!
    @IBOutlet weak var view_state: UIView!
    @IBOutlet weak var view_Country: UIView!
    @IBOutlet weak var imgCollV: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_DescTitle: UIView!
    @IBOutlet weak var view_ParkingRules: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var mainStackV: UIStackView!
    
    @IBOutlet weak var aboutSpaceTitleTF: UITextField!
    @IBOutlet weak var aboutSpaceDesTV: UITextView!
    @IBOutlet weak var parkingRuleDesTV: UITextView!
    @IBOutlet weak var hostRuleDesTV: UITextView!
    
    @IBOutlet weak var streeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var mapV: GMSMapView!
    let marker = GMSMarker()
    
    var selectedImages: [imageArray] = []
    var latitude = ""
    var longitude = ""
    var locationn = ""
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_hostRules: UILabel!
    @IBOutlet weak var lbl_parkingRules: UILabel!
    @IBOutlet weak var lbl_aboutSpace: UILabel!
    @IBOutlet weak var lbl_gallery: UILabel!
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    let dropDownLocation = DropDown()
    
    private var isSelectingLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streeTF.delegate = self
        aboutSpaceTitleTF.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let styleJSON = """
        [
          {
            "elementType": "labels",
            "stylers": [
              { "visibility": "off" }
            ]
          }
        ]
        """

        do {
            mapV.mapStyle = try GMSMapStyle(jsonString: styleJSON)
        } catch {
            print(error)
        }
        
        let filter = GMSAutocompleteFilter()
        
        filter.type = .noFilter //You can change this to .address, .establishment, etc.
        
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher.delegate = self
        
        aboutSpaceTitleTF.font = UIFont(name: "Poppins", size: 14)!
        aboutSpaceDesTV.font = UIFont(name: "Poppins", size: 14)!
        parkingRuleDesTV.font = UIFont(name: "Poppins", size: 14)!
        hostRuleDesTV.font = UIFont(name: "Poppins", size: 14)!
        streeTF.font = UIFont(name: "Poppins", size: 14)!
        cityTF.font = UIFont(name: "Poppins", size: 14)!
        zipcodeTF.font = UIFont(name: "Poppins", size: 14)!
        stateTF.font = UIFont(name: "Poppins", size: 14)!
        countryTF.font = UIFont(name: "Poppins", size: 14)!
        
        cityTF.isUserInteractionEnabled = true
        zipcodeTF.isUserInteractionEnabled = true
        countryTF.isUserInteractionEnabled = true
        
        cityTF.isEnabled = true
        zipcodeTF.isEnabled = true
        countryTF.isEnabled = true
        
      
        self.mapV.delegate = self
        //self.mapV.isUserInteractionEnabled = false
        aboutSpaceDesTV.textColor = .black
        aboutSpaceDesTV.delegate = self
        parkingRuleDesTV.textColor = .black
        parkingRuleDesTV.delegate = self
        hostRuleDesTV.textColor = .black
        hostRuleDesTV.delegate = self
        
        view_Country.applyRoundedStyle()
        view_state.applyRoundedStyle()
        view_zipcode.applyRoundedStyle()
        view_city.applyRoundedStyle()
        view_Street.applyRoundedStyle()
        view_Title.applyRoundedStyle()
        
        view_DescTitle.applyRoundedStyle(cornerRadius: 10)
        view_ParkingRules.applyRoundedStyle(cornerRadius: 10)
        view_HostRules.applyRoundedStyle(cornerRadius: 10)
        
        imgCollV.register(UINib(nibName: "ImgSelectionCollVCell", bundle: nil), forCellWithReuseIdentifier: "ImgSelectionCollVCell")
        
        imgCollV.delegate = self
        imgCollV.dataSource = self
        
        //streeTF.addTarget(self, action: #selector(openAutocomplete), for: .editingChanged)
        
        // Add target to the text field to observe changes
        aboutSpaceTitleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        streeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        zipcodeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stateTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countryTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.updatePropertyDetails()
        setupDropDown()
        
        print("Saved Lat =", SingltonClass.shared.latitude ?? 0.0)
        print("Saved Lng =", SingltonClass.shared.longitude ?? 0.0)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == streeTF {

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }
    }
    
    func setupDropDown() {
        dropDownLocation.anchorView = streeTF
        dropDownLocation.direction = .bottom
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: streeTF.bounds.height)
        
        dropDownLocation.width = UIScreen.main.bounds.width - 40
        dropDownLocation.cellHeight = 50
        
        // Multiline support
        dropDownLocation.customCellConfiguration = { index, item, cell in
            cell.optionLabel.numberOfLines = 2
            cell.optionLabel.lineBreakMode = .byWordWrapping
        }
        
        // Use the captured values inside the selection action
        dropDownLocation.selectionAction = { [weak self] (index, item) in
            
            guard let self = self else { return }
            
            let prediction = self.predictions[index]
            
            GMSPlacesClient.shared().fetchPlace(
                fromPlaceID: prediction.placeID,
                placeFields: [
                    .formattedAddress,
                    .addressComponents,
                    .coordinate,
                    .name
                ],
                sessionToken: nil
            ) { place, error in
                
                defer {
                           self.isSelectingLocation = false
                       }
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let place = place else { return }
                
                self.fillAddressFields(from: place)
                
                self.dropDownLocation.hide()
                self.streeTF.resignFirstResponder()
                self.view.endEditing(true)
            }
        }
        
    }
    
    
    func fillAddressFields(from place: GMSPlace) {
        
        dropDownLocation.hide()
        fetcher.sourceTextHasChanged("")
        
        var streetNumber = ""
        var route = ""
        var city = ""
        var state = ""
        var zip = ""
        var country = ""
        
        place.addressComponents?.forEach { component in
            
            let types = component.types
            
            // Street Number
            if types.contains("street_number") {
                streetNumber = component.name
            }
            
            // Street Name
            if types.contains("route") {
                route = component.name
            }
            
            // City
            if types.contains("locality") {
                city = component.name
            }
            
            // Backup city
            if city.isEmpty && types.contains("administrative_area_level_2") {
                city = component.name
            }
            
            // State
            if types.contains("administrative_area_level_1") {
                state = component.name
            }
            
            // Zip
            if types.contains("postal_code") {
                zip = component.name
            }
            
            // Country
            if types.contains("country") {
                country = component.name
            }
        }
        
        // Build street
        let street = "\(streetNumber) \(route)"
            .trimmingCharacters(in: .whitespaces)
        
        // Final Values
        streeTF.text = !street.isEmpty
        ? street
        : (place.name ?? place.formattedAddress ?? "")
        
        cityTF.text = city
        stateTF.text = state
        zipcodeTF.text = zip
        countryTF.text = country
        
        print("Street:", streeTF.text ?? "")
        print("City:", city)
        print("State:", state)
        print("Zip:", zip)
        print("Country:", country)
        
        SingltonClass.shared.street = self.streeTF.text
        SingltonClass.shared.city = self.cityTF.text
        SingltonClass.shared.zipcode = self.zipcodeTF.text
        SingltonClass.shared.state = self.stateTF.text
        SingltonClass.shared.country = self.countryTF.text
        
        // Save coordinates
        SingltonClass.shared.latitude = place.coordinate.latitude
        SingltonClass.shared.longitude = place.coordinate.longitude

        print("LAT =", place.coordinate.latitude)
        print("LNG =", place.coordinate.longitude)

        // Show marker
        showMarker(
            latitude: place.coordinate.latitude,
            longitude: place.coordinate.longitude
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustCollectionViewHeight()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField == aboutSpaceTitleTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }

        if textField == streeTF {
            DispatchQueue.main.async {
                self.openAutocomplete()
            }
        }
        return true
    }
    
    @objc func openAutocomplete() {
        
        if isSelectingLocation {
              return
          }
        
        guard let text = streeTF.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            // Hide dropdown
            dropDownLocation.hide()
            
            // Clear all fields
            streeTF.text = ""
            cityTF.text = ""
            stateTF.text = ""
            zipcodeTF.text = ""
            countryTF.text = ""
            SingltonClass.shared.street = ""
            SingltonClass.shared.city = ""
            SingltonClass.shared.state = ""
            SingltonClass.shared.zipcode = ""
            SingltonClass.shared.country = ""
            
            return
        }
        
        fetcher.sourceTextHasChanged(text)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Update the variable whenever the text changes
        if textField == aboutSpaceTitleTF{
            if let text = textField.text, text.count > 30 {
                textField.text = String(text.prefix(30))
            }
            SingltonClass.shared.title = aboutSpaceTitleTF.text ?? ""
            print("Text field value updated: \(aboutSpaceTitleTF.text ?? "")")
        }else if textField == streeTF{
            SingltonClass.shared.street = streeTF.text ?? ""
            print("Text field value updated: \(streeTF.text ?? "")")
        }else if textField == cityTF{
            SingltonClass.shared.city = cityTF.text ?? ""
            print("Text field value updated: \(cityTF.text ?? "")")
        }else if textField == zipcodeTF{
            SingltonClass.shared.zipcode = zipcodeTF.text ?? ""
            print("Text field value updated: \(zipcodeTF.text ?? "")")
        }else if textField == stateTF{
            SingltonClass.shared.state = stateTF.text ?? ""
            print("Text field value updated: \(stateTF.text ?? "")")
        }else if textField == countryTF{
            SingltonClass.shared.country = countryTF.text ?? ""
            print("Text field value updated: \(countryTF.text ?? "")")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            SingltonClass.shared.about = aboutSpaceDesTV.text
            print(SingltonClass.shared.about ?? "")
        }else if textView == parkingRuleDesTV{
            SingltonClass.shared.parkingRule = parkingRuleDesTV.text
            print(SingltonClass.shared.parkingRule ?? "")
        }else if textView == hostRuleDesTV{
            SingltonClass.shared.hostRules = hostRuleDesTV.text
            print(SingltonClass.shared.hostRules ?? "")
        }
    }
    
    func adjustCollectionViewHeight() {
        collectionViewHeightConstraint.constant = imgCollV.collectionViewLayout.collectionViewContentSize.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            if aboutSpaceDesTV.text == "Optional"{
                self.aboutSpaceDesTV.text = ""
                SingltonClass.shared.about = ""
            }
        }else if textView == parkingRuleDesTV{
            if parkingRuleDesTV.text == "Optional"{
                self.parkingRuleDesTV.text = ""
                SingltonClass.shared.parkingRule = ""
            }
        }else{
            if hostRuleDesTV.text == "Optional"{
                self.hostRuleDesTV.text = ""
                SingltonClass.shared.hostRules = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            if aboutSpaceDesTV.text == ""{
                self.aboutSpaceDesTV.text = "Optional"
                SingltonClass.shared.about = self.aboutSpaceDesTV.text ?? ""
            }
        }else if textView == parkingRuleDesTV{
            if parkingRuleDesTV.text == ""{
                self.parkingRuleDesTV.text = "Optional"
                SingltonClass.shared.parkingRule = self.parkingRuleDesTV.text ?? ""
            }
        }else{
            if hostRuleDesTV.text == ""{
                self.hostRuleDesTV.text = "Optional"
                SingltonClass.shared.hostRules = self.hostRuleDesTV.text ?? ""
            }
        }
    }
    
    
    @IBAction func addLocation (sender: UIButton) {
        print(sender.tag)
        // self.autocompleteClicked()
    }
    

    func updatePropertyDetails() {

        self.selectedImages = SingltonClass.shared.Imgs
        self.imgCollV.reloadData()

        self.aboutSpaceTitleTF.text = SingltonClass.shared.title
        self.aboutSpaceDesTV.text = SingltonClass.shared.about
        self.parkingRuleDesTV.text = SingltonClass.shared.parkingRule
        self.hostRuleDesTV.text = SingltonClass.shared.hostRules

        self.streeTF.text = SingltonClass.shared.street
        self.cityTF.text = SingltonClass.shared.city
        self.zipcodeTF.text = SingltonClass.shared.zipcode
        self.stateTF.text = SingltonClass.shared.state
        self.countryTF.text = SingltonClass.shared.country

        let lat = SingltonClass.shared.latitude ?? 0.0
        let lng = SingltonClass.shared.longitude ?? 0.0

        if lat != 0.0 && lng != 0.0 {
            showMarker(latitude: lat, longitude: lng)
        }
    }

 
    func showMarker(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            self.viewMainMap.isHidden = false
            let position = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
            self.mapV.clear()
            let marker = GMSMarker(position: position)
            // Custom marker image
            marker.icon = UIImage(named: "path0 8")
            marker.map = self.mapV
            let camera = GMSCameraUpdate.setTarget(position, zoom: 16)
            self.mapV.animate(with: camera)
        }
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        self.predictions = predictions
        
        let predictionTexts = predictions.map {
            $0.attributedFullText.string
        }
        
        dropDownLocation.dataSource = predictionTexts
        
        // Long address support
        dropDownLocation.width = UIScreen.main.bounds.width - 40
        
        dropDownLocation.customCellConfiguration = { index, item, cell in
            cell.optionLabel.numberOfLines = 2
            cell.optionLabel.lineBreakMode = .byWordWrapping
            cell.optionLabel.font = UIFont.systemFont(ofSize: 14)
        }
        
        DispatchQueue.main.async {
            self.dropDownLocation.show()
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }

}

extension HostGalleryLocationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func openCameraOrGallery() {
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openImagePicker(sourceType: .camera)
            }))
        }
        
        // Gallery option
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openPHPicker()
        }))
        
        // Cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            openCameraWithPermissionCheck(delegate: self, allowsEditing: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    func openPHPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 6 - selectedImages.count
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // Handle selected image from Camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
        
        // Convert UIImage to Data
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            let newImageEntry = imageArray(image: selectedImage, data: imageData, url: "", image_id: "", thumbNail: selectedImage)
            
            selectedImages.append(newImageEntry) // Append to your struct array
            SingltonClass.shared.Imgs.append(newImageEntry) // Append raw UIImage if needed
            print(SingltonClass.shared.Imgs, "IMG Singlton")
            
            imgCollV.reloadData()
            adjustCollectionViewHeight()
            print("Selected Image: \(selectedImage ?? UIImage())")
        } else {
            print("Failed to convert image to Data.")
        }
    }
    
    // Handle cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension HostGalleryLocationVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard !results.isEmpty else { return }
        
        let dispatchGroup = DispatchGroup()
        var loadedImages: [Int: imageArray] = [:]
        
        for (index, result) in results.enumerated() {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                provider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            let newImageEntry = imageArray(image: image, data: imageData, url: "", image_id: "", thumbNail: image)
                            DispatchQueue.main.async {
                                loadedImages[index] = newImageEntry
                                dispatchGroup.leave()
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            let sortedImages = loadedImages.keys.sorted().compactMap { loadedImages[$0] }
            
            let spaceLeft = 6 - self.selectedImages.count
            let imagesToAdd = Array(sortedImages.prefix(spaceLeft))
            
            self.selectedImages.append(contentsOf: imagesToAdd)
            SingltonClass.shared.Imgs.append(contentsOf: imagesToAdd)
            
            self.imgCollV.reloadData()
            self.adjustCollectionViewHeight()
            print("Successfully loaded \(imagesToAdd.count) images.")
        }
    }
}

extension HostGalleryLocationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count < 6 ? selectedImages.count + 1 : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgSelectionCollVCell", for: indexPath) as! ImgSelectionCollVCell
        
        if indexPath.item == selectedImages.count && selectedImages.count < 6 {
            cell.bgDotImg.image = UIImage(named: "addmoreiconsh") // Default "Add More" image
            cell.deleteBtn.isHidden = true
        } else {
            let img = selectedImages[indexPath.item].image
            if img != nil{
                cell.bgDotImg.image = selectedImages[indexPath.item].image
            }else{
                cell.bgDotImg.loadImage(from: AppURL.imageURL + (selectedImages[indexPath.row].url ?? ""),placeholder: UIImage(named: "NoIMg"))
            }
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedImages.count < 6 {
            openCameraOrGallery()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10, height: 100)
    }
    
    
    @objc func deleteImage(_ sender: UIButton) {
        
        if SingltonClass.shared.Imgs[sender.tag].image_id != ""{
            SingltonClass.shared.deletedImg.append(Int(SingltonClass.shared.Imgs[sender.tag].image_id ?? "") ?? 0)
            print(SingltonClass.shared.deletedImg, "<<<<Delete Img ID>>>")
        }
        self.selectedImages.remove(at: sender.tag)
        SingltonClass.shared.Imgs.remove(at: sender.tag)
        self.imgCollV.reloadData()
        self.adjustCollectionViewHeight()
        }
    }

extension GMSMapView {
    // Configures the map with the given latitude, longitude, and zoom level.
    func configureMap(latitude: Double, longitude: Double, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        self.camera = camera
    }
    
    // Adds a marker to the map at the specified coordinates with a title and snippet.
    func addMarker(latitude: Double, longitude: Double, title: String, snippet: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = self
    }
}

extension UIView {
    func applyRoundedStyle(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 1.5, borderColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)) {
        self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
}
