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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receiveLanguageChangedNotification:"), name: kNotificationLanguageChanged, object: nil)
        
        configureViewFromLocalisation()
    }
    
    func configureViewFromLocalisation() {
    
        homeTitleLabel.text     = Localisator.sharedInstance.localizedStringForKey("HomeTitleText")
        homeDescLabel.text      = Localisator.sharedInstance.localizedStringForKey("HomeDescText")
        languageButton.setTitle(Localisator.sharedInstance.localizedStringForKey("HomeButtonTitle"), forState: UIControlState.Normal)
        
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

