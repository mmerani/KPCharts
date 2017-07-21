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

        let titles = ["Kicks", "Punts", "Kickoffs"]
        segment.setSegmentItems(titles)
        segment.defaultTextColor = UIColor(red: 60/255, green: 174/255, blue: 85/255, alpha: 1)
        segment.highlightTextColor = UIColor.white
        segment.segmentsBackgroundColor = UIColor.white
        segment.sliderBackgroundColor = UIColor(red: 60/255, green: 174/255, blue: 85/255, alpha: 1)
        segment.isSliderShadowHidden = true
        segment.layer.cornerRadius = segment.frame.height/2
        
        butBegin.layer.cornerRadius = butBegin.frame.height/2
       // segment.delegate = self
    }

    //MARK: TwicketSegmentControl Delegate
    
    
    

    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedBegin(_ sender: Any) {
    }
}
