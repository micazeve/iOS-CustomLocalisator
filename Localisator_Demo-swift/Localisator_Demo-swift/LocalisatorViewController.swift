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

        NotificationCenter.default.addObserver(self, selector: #selector(LocalisatorViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        
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
            Localisator.sharedInstance.saveInUserDefaults = switchSaveLanguage.isOn
        }
    }
    
    // MARK: - UITableViewDataSource protocol conformance

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLanguages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MyIdentifier")
        }
        cell!.selectionStyle        = UITableViewCellSelectionStyle.gray
        cell!.imageView?.image      = UIImage(named:arrayLanguages[indexPath.row])
        cell!.textLabel?.text       = Localization(arrayLanguages[indexPath.row])
        return cell!
    }
    
    // MARK: - UITableViewDelegateprotocol conformance
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if SetLanguage(arrayLanguages[indexPath.row]) {
            let alert = UIAlertView(title: nil, message: Localization("languageChangedWarningMessage"), delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // MARK: - Memory management
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotificationLanguageChanged, object: nil)
    }
    
}
