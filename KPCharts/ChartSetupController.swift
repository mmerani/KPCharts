//
//  ChartSetupController.swift
//  KPCharts
//
//  Created by Michael Merani on 7/18/17.
//
//

import UIKit

class ChartSetupController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var butClose: UIButton!
    @IBOutlet weak var segment: TwicketSegmentedControl!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var butBegin: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["Kicks", "Punts", "Kickoffs"]
        
        // change close button tint
        butClose.setImage(UIImage(named: "iconDelete")?.tintWithColor(color: UIColor.white), for: .normal)

        
        //set segment UI
        segment.setSegmentItems(titles)
        segment.defaultTextColor = COLOR_APP
        segment.highlightTextColor = UIColor.white
        segment.segmentsBackgroundColor = UIColor.white
        segment.sliderBackgroundColor = COLOR_APP
        segment.isSliderShadowHidden = true
        segment.layer.cornerRadius = segment.frame.height/2
        
        //textfield delegate
        txtFieldTitle.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        // begin button
        butBegin.layer.cornerRadius = butBegin.frame.height/2
    }
    
    // MARK: Actions

    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedBegin(_ sender: Any) {
        var chartType = ""
        if segment.selectedSegmentIndex == 0 {
            chartType = "Kicks"
        } else if segment.selectedSegmentIndex == 1 {
            chartType = "Punts"
        } else {
            chartType = "Kickoffs"
        }
        if isTextLengthAcceptable() {
            self.dismiss(animated: true, completion: {
                if let chartsVC = self.storyboard?.instantiateViewController(withIdentifier: "chartsVC") as? ChartsViewController {
                    chartsVC.chartType = chartType
                    chartsVC.chartTitle = self.txtFieldTitle.text
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController!.present(chartsVC, animated: true, completion: nil)
                }
            })
        } else {
            textLengthAlert()
        }
    }
    
    func closeKeyboard() {
        txtFieldTitle.resignFirstResponder()
    }
    
    func isTextLengthAcceptable() -> Bool {
        if (txtFieldTitle.text?.characters.count)! >= 50 {
           return false
        }
        return true
    }
    
    func textLengthAlert(){
        let alert = UIAlertController(title: "Title is too long", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.txtFieldTitle.becomeFirstResponder()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.removeGestureRecognizer(tapGesture)
        textField.resignFirstResponder()
        return true
    }
}
