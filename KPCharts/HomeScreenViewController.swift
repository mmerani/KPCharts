//
//  HomeScreenViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 4/11/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    let loadingView = UIView()
    let indicatorView = UIActivityIndicatorView()
    
    // test varibles
    
    var kicksArray = [DataSnapshot]()
    var kickoffsArray = [DataSnapshot]()
    var puntsArray = [DataSnapshot]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(selectedSignOut))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(revealToggle:))
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // view to show loading indicator
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = UIColor.white
        loadingView.bringSubview(toFront: self.view)
        self.view.addSubview(loadingView)
        indicatorView.center = CGPoint(x: loadingView.center.x, y: loadingView.center.y - (navigationController?.navigationBar.frame.height)! - 15)//loadingView.center
        indicatorView.activityIndicatorViewStyle = .gray
        self.loadingView.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        let background = UIImageView(image:UIImage(named: "mainbackground"))
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        background.alpha = 0.75
        myTableView.backgroundView = background
        
        myTableView.separatorStyle = .none
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
      
        myTableView.tableFooterView = UIView()
        
        loadChartData()
    }
    
    // MARK: - Actions

    func loadChartData(){
        if let uid = UserDefaults.standard.object(forKey: "uid") {
            DataService.ds.findUserCharts(uid: uid as! String) { (snapshot, error) in
                if snapshot.childrenCount > 0 {
                    let chartList = snapshot.children.allObjects as! [DataSnapshot]
                    self.sortList(chartList: chartList)
                    //self.createChart()

                } else {
                    print("No chart data")
                }

                self.indicatorView.stopAnimating()
                self.loadingView.removeFromSuperview()
//                self.tableView.refreshControl?.endRefreshing()
//                self.tableView.reloadData()
            }
        }
    }

    func sortList(chartList: [DataSnapshot]) {
        for data in chartList {
            if let chartType = data.childSnapshot(forPath: "chartType").value as? String {
                if chartType == "Punts" {
                    puntsArray.append(data)
                } else if chartType == "Kicks" {
                    kicksArray.append(data)
                } else if chartType == "Kickoffs" {
                    kickoffsArray.append(data)
                }
            }
        }
    }
    
    func openChartSetup() {
        print("It worked bitch")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let setupChart = storyBoard.instantiateViewController(withIdentifier: "setupVC") as! ChartSetupController
        setupChart.providesPresentationContextTransitionStyle = true
        setupChart.definesPresentationContext = true
        setupChart.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        self.present(setupChart, animated:false, completion:nil)
    }
    
    func openSavedCharts() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let savedCharts = storyBoard.instantiateViewController(withIdentifier: "savedChartsVC") as! SavedChartsController
        self.navigationController?.pushViewController(savedCharts, animated: true)
    }
    
    func openGraphs() {
        let progressVC = ProgressViewController(style: .grouped)
        progressVC.puntsArray = self.puntsArray
        progressVC.kickoffsArray = self.kickoffsArray
        progressVC.kicksArray = self.kickoffsArray
        self.navigationController?.pushViewController(progressVC, animated: true)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        if indexPath.row == 0 {
            cell.lblTitle.text = "Create a new chart"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openChartSetup))
            tapGesture.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tapGesture)
        } else if indexPath.row == 1 {
            cell.lblTitle.text = "View saved charts"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSavedCharts))
            tapGesture.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tapGesture)
        } else if indexPath.row == 2 {
            cell.lblTitle.text = "See progress"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGraphs))
            tapGesture.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tapGesture)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
