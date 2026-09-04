//
//  FaqVC.swift
//  Zyvo
//
//  Created by ravi on 06/05/2025.
//

import UIKit
import Combine
class FaqVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblV: UITableView!
    
    private var viewModel = FAQViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getFaqArr = [FAQModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblV.delegate = self
        tblV.dataSource = self
        viewModel.apiforGetFAQ()
        bindVC()
        
        
        let nib = UINib(nibName: "FaqCell", bundle: nil)
        tblV.register(nib, forCellReuseIdentifier: "FaqCell")
        tblV.estimatedRowHeight = 120
        tblV.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getFaqArr.count//items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblV.dequeueReusableCell(withIdentifier: "FaqCell", for: indexPath) as? FaqCell else {
            return UITableViewCell()
        }
        
        let item = getFaqArr[indexPath.row]
        
        cell.configure(with: item)
        
        // Use the renamed closure
        cell.toggleAction = { [weak self] in
            guard let self = self else { return }
            
            self.getFaqArr[indexPath.row].isExpanded?.toggle()
            
            self.tblV.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        return cell
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FaqVC {
    func bindVC() {
        viewModel.$getFAQResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getFaqArr = (response.data ?? []).map {
                        var item = $0
                        item.isExpanded = false
                        return item
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
    }
}


