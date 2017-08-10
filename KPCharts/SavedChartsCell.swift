//
//  SavedChartsCell.swift
//  KPCharts
//
//  Created by Michael Merani on 7/31/17.
//
//

import UIKit

class SavedChartsCell: UITableViewCell {
    @IBOutlet weak var lblChartTitle: UILabel!
    @IBOutlet weak var lblChartType: UILabel!
    @IBOutlet weak var lblDataTitle: UILabel!
    @IBOutlet weak var lblData: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
