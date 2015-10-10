//
//  ViewController.swift
//  Flick Finder
//
//  Created by Luis Antonio Rodriguez on 10/10/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchByPhraseButton: UIButton!
    @IBOutlet weak var searchByPhraseTextField: UITextField!
    @IBOutlet weak var searchByCoordinatesButton: UIButton!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longitudeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchByPhrase(sender: AnyObject) {
    }

    @IBAction func searchByCoordinates(sender: AnyObject) {
    }
}

