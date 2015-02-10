//
//  LocalisatorViewController.swift
//  Localisator_Demo-swift
//
//  Created by Michaël Azevedo on 10/02/2015.
//  Copyright (c) 2015 Michaël Azevedo. All rights reserved.
//

import UIKit

class LocalisatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

     // MARK: - Outlets
    @IBOutlet var tableViewLanguages: UITableView!
    @IBOutlet var imageViewFlag: UIImageView!
    @IBOutlet var labelCurrentLanguage: UILabel!
    @IBOutlet var labelChooseLanguage: UILabel!
    @IBOutlet var labelSaveLanguage: UILabel!
    @IBOutlet var switchSaveLanguage: UISwitch!
    
    let arrayLanguages = Localisator.sharedInstance.getArrayAvailableLanguages()
    
    // MARK: - Init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receiveLanguageChangedNotification:"), name: kNotificationLanguageChanged, object: nil)
        
        switchSaveLanguage.setOn(Localisator.sharedInstance.saveInUserDefaults, animated:false)
        configureViewFromLocalisation()
    }
    
    func configureViewFromLocalisation() {
        title                           = Localization("LocalisatorViewTitle")        
        labelCurrentLanguage.text       = Localization("LocalisatorViewCurrentLanguageText")
        labelChooseLanguage.text        = Localization("LocalisatorViewTitle")
        labelSaveLanguage.text          = Localization("LocalisatorViewSaveText")
        tableViewLanguages.reloadData()
        imageViewFlag.image = UIImage(named:Localisator.sharedInstance.currentLanguage)
    }
    
    // MARK: - Notification methods
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender == switchSaveLanguage {
            Localisator.sharedInstance.saveInUserDefaults = switchSaveLanguage.on
        }
    }
    
    // MARK: - UITableViewDataSource protocol conformance

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLanguages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MyIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MyIdentifier")
        }
        cell!.selectionStyle    = UITableViewCellSelectionStyle.Gray
        cell!.imageView.image   = UIImage(named:arrayLanguages[indexPath.row])
        cell!.textLabel.text    = Localization(arrayLanguages[indexPath.row])
        return cell!
    }
    
    // MARK: - UITableViewDelegateprotocol conformance
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if SetLanguage(arrayLanguages[indexPath.row]) {
            let alert = UIAlertView(title: nil, message: Localization("languageChangedWarningMessage"), delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // MARK: - Memory management
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationLanguageChanged, object: nil)
    }
    
}
