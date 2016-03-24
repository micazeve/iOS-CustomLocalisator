//
//  ViewController.swift
//  Localisator_Demo-swift
//
//  Created by Michaël Azevedo on 10/02/2015.
//  Copyright (c) 2015 Michaël Azevedo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet var homeTitleLabel: UILabel!
    @IBOutlet var homeDescLabel: UILabel!
    @IBOutlet var languageButton: UIButton!
    
     // MARK: - Init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Localisator"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.receiveLanguageChangedNotification(_:)), name: kNotificationLanguageChanged, object: nil)
        
        configureViewFromLocalisation()
    }
    
    func configureViewFromLocalisation() {
    
        homeTitleLabel.text     = Localization("HomeTitleText")
        homeDescLabel.text      = Localization("HomeDescText")
        languageButton.setTitle(Localization("HomeButtonTitle"), forState: UIControlState.Normal)
        
    }

    // MARK: - Notification methods
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    // MARK: - Memory management
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationLanguageChanged, object: nil)
    }

}

