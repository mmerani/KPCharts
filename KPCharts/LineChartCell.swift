//
//  LineChartCell.swift
//  KPCharts
//
//  Created by Michael Merani on 8/20/17.
//
//

import UIKit
import Charts

class LineChartCell: UITableViewCell, ChartViewDelegate {
    @IBOutlet weak var lineChart: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
