//
//  MatchResultController.swift
//  Roshambo
//
//  Created by Luis Antonio Rodriguez on 8/22/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class MatchResultController: UIViewController {
    var result = (RoshamboResults.itsATie, "It's a tie!")
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        switch (result.0){
        case .rockCrushesScissors:
            theImage.image = UIImage(named: "RockCrushesScissors")
            break
        case .paperCoversRock:
            theImage.image = UIImage(named: "PaperCoversRock")
            break
        case .scissorsCutPaper:
            theImage.image = UIImage(named: "ScissorsCutPaper")
            break
        case .itsATie:
            theImage.image = UIImage(named: "itsATie")
            break
        }
        theLabel.text = String(result.1)
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
