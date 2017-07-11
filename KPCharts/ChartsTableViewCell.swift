//
//  ChartsTableViewCell.swift
//  KPCharts
//
//  Created by Michael Merani on 6/26/17.
//
//

import UIKit

class ChartsTableViewCell: UITableViewCell {
    @IBOutlet weak var txtFieldYards: UITextField!

    @IBOutlet weak var txtFieldHangtime: UITextField!
    
    @IBOutlet weak var txtFieldKickYards: UITextField!
    @IBOutlet weak var makeOrMiss: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
