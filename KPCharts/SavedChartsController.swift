//
//  SavedChartsController.swift
//  KPCharts
//
//  Created by Michael Merani on 8/5/17.
//
//

import UIKit
import Firebase


class SavedChartsController: UITableViewController {

    var chartList = [DataSnapshot]()
    var kicksArray = [DataSnapshot]()
    var kickoffsArray = [DataSnapshot]()
    var puntsArray = [DataSnapshot]()
    let activityView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleLbl.font = UIFont(name: "HelveticaNeue", size: 17)
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        titleLbl.text = "My Saved Charts"
        self.navigationItem.titleView = titleLbl
        
        activityView.frame = CGRect(x: view.frame.width/2 - 25 , y: view.frame.height/2 - 25 - (navigationController?.navigationBar.frame.height)!, width: 50, height: 50)
        activityView.activityIndicatorViewStyle = .gray
        view.addSubview(activityView)
        view.bringSubview(toFront: activityView)
        activityView.startAnimating()
        
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadChartData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        loadChartData()

    }
    

    func loadChartData(){
        chartList.removeAll()
        kicksArray.removeAll()
        kickoffsArray.removeAll()
        puntsArray.removeAll()
        if let uid = UserDefaults.standard.object(forKey: "uid") {
            DataService.ds.findUserCharts(uid: uid as! String) { (snapshot, error) in
                if snapshot.childrenCount > 0 {
                    self.chartList = snapshot.children.allObjects as! [DataSnapshot]
                    
                    self.sortList(chartList: self.chartList)
                } else {
                    print("No chart data")
                }
                self.activityView.stopAnimating()
                self.tableView.separatorStyle = .singleLine
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return chartList.count
        if section == 0 {
            return puntsArray.count
        } else if section == 1 {
            return kicksArray.count
        } else if section == 2 {
            return kickoffsArray.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Punts"
        } else if section == 1 {
            return "Kicks"
        } else if section == 2 {
            return "Kickoffs"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedChartsCell", for: indexPath) as! SavedChartsCell

        if indexPath.section == 0 {
            let data = puntsArray[indexPath.row]
            cell.lblChartTitle.text =  data.childSnapshot(forPath: "title").value as? String
            cell.lblChartType.text = data.childSnapshot(forPath: "chartType").value as? String
            cell.lblDataTitle.text = "Avg Distance"
            cell.lblData.text = "\(data.childSnapshot(forPath: "avgDistance").value ?? 0)"
        } else if indexPath.section == 1 {
            let data = kicksArray[indexPath.row]
            cell.lblChartTitle.text =  data.childSnapshot(forPath: "title").value as? String
            cell.lblChartType.text = data.childSnapshot(forPath: "chartType").value as? String
            cell.lblDataTitle.text = "FGs Made"
            cell.lblData.text = data.childSnapshot(forPath: "completion").value as? String
        } else if indexPath.section == 2 {
            let data = kickoffsArray[indexPath.row]
            cell.lblChartTitle.text =  data.childSnapshot(forPath: "title").value as? String
            cell.lblChartType.text = data.childSnapshot(forPath: "chartType").value as? String
            cell.lblDataTitle.text = "Avg Distance"
            cell.lblData.text = "\(data.childSnapshot(forPath: "avgDistance").value ?? 0)"
        }
        
//
//        let data = chartList[indexPath.row]
//
//        cell.lblChartTitle.text =  data.childSnapshot(forPath: "title").value as? String
//        cell.lblChartType.text = data.childSnapshot(forPath: "chartType").value as? String
//
//        let checkType = data.childSnapshot(forPath: "chartType").value as? String
//        if checkType == "Kicks"{
//            cell.lblDataTitle.text = "FGs Made"
//            cell.lblData.text = data.childSnapshot(forPath: "completion").value as? String
//        } else {
//            cell.lblDataTitle.text = "Avg Distance"
//            cell.lblData.text = "\(data.childSnapshot(forPath: "avgDistance").value ?? 0)"
//        }
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            if editActionsForRowAt.section == 0 {
                let data = self.puntsArray[editActionsForRowAt.row]
                data.ref.removeValue()
                self.puntsArray.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .automatic)
            } else if editActionsForRowAt.section == 1 {
                let data = self.kicksArray[editActionsForRowAt.row]
                data.ref.removeValue()
                self.kicksArray.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .automatic)
            } else  if editActionsForRowAt.section == 2 {
                let data = self.kickoffsArray[editActionsForRowAt.row]
                data.ref.removeValue()
                self.kickoffsArray.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .automatic)
            }
            //self.loadChartData()
            //self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
 
}
