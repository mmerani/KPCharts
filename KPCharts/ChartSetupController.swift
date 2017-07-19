//
//  ChartSetupController.swift
//  KPCharts
//
//  Created by Michael Merani on 7/18/17.
//
//

import UIKit

class ChartSetupController: UIViewController {

    @IBOutlet weak var butClose: UIButton!
    @IBOutlet weak var segment: TwicketSegmentedControl!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var butBegin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedClose(_ sender: Any) {
    }
    
    @IBAction func tappedBegin(_ sender: Any) {
    }
}
