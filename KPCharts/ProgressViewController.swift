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

    var kicksArray = [DataSnapshot]()
    var kickoffsArray = [DataSnapshot]()
    var puntsArray = [DataSnapshot]()
    
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LineChartCell", bundle: nil), forCellReuseIdentifier: "chartCell")
        tableView.allowsSelection = false
        //loadChartData()
        //createChart()
    }

 
    // MARK: - Actions
    
//    func loadChartData(){
//        if let uid = UserDefaults.standard.object(forKey: "uid") {
//            DataService.ds.findUserCharts(uid: uid as! String) { (snapshot, error) in
//                if snapshot.childrenCount > 0 {
//                    let chartList = snapshot.children.allObjects as! [FIRDataSnapshot]
//                    self.sortList(chartList: chartList)
//                    //self.createChart()
//                    
//                } else {
//                    print("No chart data")
//                }
//                
////                self.tableView.refreshControl?.endRefreshing()
////                self.tableView.reloadData()
//            }
//            
//            self.tableView.refreshControl?.endRefreshing()
//            self.tableView.reloadData()
//        }
//    }
    
//    func sortList(chartList: [FIRDataSnapshot]) {
//        for data in chartList {
//            if let chartType = data.childSnapshot(forPath: "chartType").value as? String {
//                if chartType == "Punts" {
//                    puntsArray.append(data)
//                } else if chartType == "Kicks" {
//                    kicksArray.append(data)
//                } else if chartType == "Kickoffs" {
//                    kickoffsArray.append(data)
//                }
//            }
//        }
//        print(puntsArray)
//        print(kicksArray)
//        print(kickoffsArray)
//    }
    
    func createChart() {//-> LineChartView {
     
       // let lineChart = LineChartView()
//        lineChart.delegate = self
//        lineChart.backgroundColor = UIColor.lightGray
//        lineChart.dragEnabled = false
//        lineChart.setScaleEnabled(false)
//        lineChart.chartDescription?.enabled = false
//        lineChart.drawGridBackgroundEnabled = false
//        lineChart.pinchZoomEnabled = false
//        lineChart.xAxis.enabled = true
//        
//        let yAxis = lineChart.leftAxis
//        yAxis.labelFont = UIFont.systemFont(ofSize: 12)
//        yAxis.setLabelCount(6, force: false)
//        yAxis.labelTextColor = UIColor.white
//        yAxis.labelPosition = .outsideChart
//        yAxis.drawGridLinesEnabled = false
//        yAxis.axisLineColor = UIColor.white
//        
//        lineChart.rightAxis.enabled = false
//        lineChart.legend.enabled = false
//        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        var values = [ChartDataEntry]()
        for i in 0 ..< puntsArray.count {
            let chart = puntsArray[i]
            print(chart)
            let val = ChartDataEntry(x: Double(i), y: (chart.childSnapshot(forPath: "avgDistance").value as? Double)!)
            values.append(val)
        }
        let set1 = LineChartDataSet(values: values, label: "test")
        var dataSets = [IChartDataSet]()
        dataSets.append(set1)
        let data = LineChartData(dataSets: dataSets)
        print(data)
        lineChart.data = data
        lineChart.setNeedsLayout()
        lineChart.setNeedsDisplay()
        lineChart.data?.notifyDataChanged()
        lineChart.notifyDataSetChanged()
       
    
        //return lineChart
    }
    
//    func setData(charts: [FIRDataSnapshot]) {
//        var values = [ChartDataEntry]()
//        for i in 0 ..< charts.count {
//            let chart = charts[i]
//            let val = ChartDataEntry(x: Double(i), y: (chart.childSnapshot(forPath: "avgDistance").value as? Double)!)
//            values.append(val)
//        }
//        let set1 = LineChartDataSet(values: values, label: "test")
//        var dataSets = [LineChartDataSet]()
//        dataSets.append(set1)
//        let data = LineChartData(dataSets: dataSets)
//        
//        
//    }

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

       // let cellChart = createChart()
        
       // cell.lineChart = lineChart
        cell.lineChart.delegate = self
        cell.lineChart.backgroundColor = UIColor.white
        cell.lineChart.dragEnabled = false
        cell.lineChart.setScaleEnabled(false)
        cell.lineChart.chartDescription?.enabled = false
        cell.lineChart.drawGridBackgroundEnabled = false
        cell.lineChart.pinchZoomEnabled = false
        cell.lineChart.xAxis.enabled = true
        
        let yAxis = cell.lineChart.leftAxis
        yAxis.labelFont = UIFont.systemFont(ofSize: 12)
        yAxis.axisLineColor = UIColor.black
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor.darkGray
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.axisLineColor = UIColor.darkGray
        
        let xAxis = cell.lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
       
        
        cell.lineChart.rightAxis.enabled = false
        cell.lineChart.legend.enabled = false
        cell.lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        var values = [ChartDataEntry]()
        values.append(ChartDataEntry(x: 0, y: 0))
        if indexPath.section == 0 {
            for i in 0 ..< puntsArray.count {
                let chart = puntsArray[i]
                print(chart)
                let val = ChartDataEntry(x: Double(i + 1), y: (chart.childSnapshot(forPath: "avgDistance").value as? Double)!)
                values.append(val)
            }
        } else if indexPath.section == 1 {
            // fix for kicks
            for i in 0 ..< kickoffsArray.count {
                let chart = kickoffsArray[i]
                print(chart)
                let val = ChartDataEntry(x: Double(i + 1), y: (chart.childSnapshot(forPath: "avgDistance").value as? Double)!)
                values.append(val)
            }
        } else if indexPath.section == 2 {
            for i in 0 ..< kickoffsArray.count {
                let chart = kickoffsArray[i]
                print(chart)
                let val = ChartDataEntry(x: Double(i + 1), y: (chart.childSnapshot(forPath: "avgDistance").value as? Double)!)
                values.append(val)
            }
        }
        let set1 = LineChartDataSet(values: values, label: "test")
        set1.drawValuesEnabled = false
        set1.circleColors = [UIColor.black]
        set1.setColor(UIColor.black)
        set1.drawCircleHoleEnabled = false
        set1.circleRadius = 3.0
        
        var dataSets = [IChartDataSet]()
        dataSets.append(set1)
        let data = LineChartData(dataSets: dataSets)
        print(data)
        cell.lineChart.data = data
        cell.lineChart.data?.highlightEnabled = false 
        
//        cell.lineChart.setNeedsLayout()
//        cell.lineChart.setNeedsDisplay()
//        cell.lineChart.data?.notifyDataChanged()
//        cell.lineChart.notifyDataSetChanged()
        
        return cell
    }
}
