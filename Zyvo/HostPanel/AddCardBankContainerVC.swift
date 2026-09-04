//
//  AddCardBankContainerVC.swift
//  Myka App
//
//  Created by YES IT Labs on 19/12/24.
//

import UIKit

var isCardAdded:Bool = false

class AddCardBankContainerVC: UIViewController {
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var AddBankAccO: UIButton!
    @IBOutlet weak var AddCardO: UIButton!
    @IBOutlet weak var btnsBgView:UIView!
    @IBOutlet weak var ContainerV: UIView!
    
    @IBOutlet weak var BgV: UIView!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    
    var addCardVC:HostAddCardVC! = nil
    var AddbankVC:AddBankVC! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 0
        createPageViewController()
        self.btnClicked(btn: self.AddBankAccO)
        
        AddBankAccO.layer.cornerRadius = AddBankAccO.layer.frame.height / 2
        AddCardO.layer.cornerRadius = AddCardO.layer.frame.height / 2
        //
        viewButton.layer.cornerRadius = viewButton.layer.frame.height / 2
//        viewButton.layer.borderWidth = 1
//        viewButton.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        
        AddCardO.layer.backgroundColor = UIColor.clear.cgColor
        AddCardO.setTitleColor(UIColor.black, for: .normal)
        
        AddBankAccO.layer.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        AddBankAccO.setTitleColor(UIColor.black, for: .normal)
        
        // Add shadow to containerV
//        BgV.layer.shadowColor = UIColor.black.cgColor // Shadow color
//        BgV.layer.shadowOpacity = 0.3 // Shadow transparency (0 = transparent, 1 = opaque)
//        BgV.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
//        BgV.layer.shadowRadius = 4 // Shadow blur radius
//        BgV.layer.masksToBounds = false // Allows the shadow to extend beyond the bounds
        
        BgV.layer.cornerRadius = 15
        // Round top-left and top-right corners only
      //  BgV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func BankBtn(_ sender: UIButton) {
        
        
        AddCardO.layer.backgroundColor = UIColor.clear.cgColor
//        AddCardO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
        AddCardO.setTitleColor(UIColor.black, for: .normal)
        AddBankAccO.layer.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        AddBankAccO.setTitleColor(UIColor.black, for: .normal)
        btnClicked(btn: sender)
    }
    
    @IBAction func CardBtn(_ sender: UIButton) {
        
        AddBankAccO.layer.backgroundColor = UIColor.clear.cgColor
//        AddBankAccO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
        AddBankAccO.setTitleColor(UIColor.black, for: .normal)
        AddCardO.layer.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        AddCardO.setTitleColor(UIColor.black, for: .normal)
        btnClicked(btn: sender)
    }
    
    
    @IBAction private func btnClicked(btn: UIButton) {
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in })
    }
}

extension AddCardBankContainerVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate{
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
        AddbankVC = self.storyboard?.instantiateViewController(withIdentifier: "AddBankVC") as? AddBankVC
        addCardVC = self.storyboard?.instantiateViewController(withIdentifier: "HostAddCardVC") as? HostAddCardVC
        
        arrVC = [AddbankVC, addCardVC]
        
        // Set initial view controller for the pageController
        pageController.setViewControllers([AddbankVC!], direction: .forward, animated: false, completion: nil)
        
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
//                    AddCardO.setBackgroundImage(UIImage(named: ""), for: .normal)
//                    AddBankAccO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
                    AddBankAccO.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
                    AddBankAccO.setTitleColor(UIColor.black, for: .normal)
                    AddCardO.backgroundColor = UIColor.clear
//                    AddCardO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    AddCardO.setTitleColor(UIColor.black, for: .normal)
                    
                }else{
                    AddCardO.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
                    AddCardO.setTitleColor(UIColor.black, for: .normal)
                    AddBankAccO.backgroundColor = UIColor.clear
//                    AddBankAccO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    AddBankAccO.setTitleColor(UIColor.black, for: .normal)
                }
            }
        }
        
    }
}
