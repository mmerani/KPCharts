//
//  ProgressViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 8/14/17.
//
//

import UIKit
import Firebase
import Charts


class ProgressViewController: UITableViewController, ChartViewDelegate {

    var kicksArray = [FIRDataSnapshot]()
    var kickoffsArray = [FIRDataSnapshot]()
    var puntsArray = [FIRDataSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LineChartCell", bundle: nil), forCellReuseIdentifier: "chartCell")
        loadChartData()
    }

 
    // MARK: - Actions
    
    func loadChartData(){
        if let uid = UserDefaults.standard.object(forKey: "uid") {
            DataService.ds.findUserCharts(uid: uid as! String) { (snapshot, error) in
                if snapshot.childrenCount > 0 {
                    let chartList = snapshot.children.allObjects as! [FIRDataSnapshot]
                    self.sortList(chartList: chartList)
                    
                } else {
                    print("No chart data")
                }
                
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func sortList(chartList: [FIRDataSnapshot]) {
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
        print(puntsArray)
        print(kicksArray)
        print(kickoffsArray)
    }
    
    func createChart() -> LineChartView {
     
        let lineChart = LineChartView()
        lineChart.delegate = self
        lineChart.backgroundColor = UIColor.lightGray
        lineChart.dragEnabled = false
        lineChart.setScaleEnabled(false)
        lineChart.chartDescription?.enabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.xAxis.enabled = true
        
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = UIFont.systemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor.white
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.axisLineColor = UIColor.white
        
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        return lineChart
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell", for: indexPath) as! LineChartCell

        let cellChart = createChart()
        cell.lineChart = cellChart
        return cell
    }
    
    
    
}
