//
//  ViewController.swift
//  Rolee
//
//  Created by simon vadée on 01/10/2016.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit
import CloudKit

class SettingsViewController: UIViewController {
	
	var audioController: AudioPlayer! = nil
	
	@IBOutlet weak var changeUsernameButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
		if (!userHasICloud) {
			changeUsernameButton.setTitle("iCloud needed to change username", for: .disabled)
			changeUsernameButton.isEnabled = false
		}
	// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func changeUsername(_ sender: UIButton) {
		let alertController = UIAlertController(title: "Greetings \(username!)!", message: "Please input your new username:", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let confirmAction = UIAlertAction(title: "Change my name!", style: .default) { [unowned self] action in
			let field = alertController.textFields![0] as UITextField
			if field.text != "" {
				DispatchQueue.main.async {
					alertController.message = "Checking if name already exists..."
				}
				self.checkIfUsernameExists(field.text!) { usernameExists in
					if usernameExists {
						DispatchQueue.main.async {
							alertController.title = "Sorry"
							alertController.message = "This name is already taken..."
							self.present(alertController, animated: true, completion: nil)
						}
					}
					else {
						let usernameRecord = CKRecord(recordType: "Username")
						usernameRecord.setObject(field.text! as CKRecordValue?, forKey: "name")
						userPrivateRecord.setObject(field.text! as CKRecordValue?, forKey: "name")
						publicDB.save(usernameRecord) { (_, _) in }
						publicDB.save(userPrivateRecord) { record, error in
							username = field.text as! CKRecordValue
						}
					}
				}
			}
			else {
				DispatchQueue.main.async {
					alertController.title = "Nice try."
					alertController.message = "Don't get too smart with me"
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
		alertController.addTextField { (textField) in
			textField.placeholder = "Name"
		}
		alertController.addAction(cancelAction)
		alertController.addAction(confirmAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func checkIfUsernameExists(_ name: String, _ completionHandler: @escaping (Bool) -> Void) {
		let query = CKQuery(recordType: "Username", predicate: NSPredicate(value: true))
		publicDB.perform(query, inZoneWith: nil) { records, error in
			if error == nil && records != nil {
				for record in records! {
					if record.object(forKey: "name") as? String == name {
						completionHandler(true)
						return
					}
				}
				completionHandler(false)
			}
		}
	}

	@IBAction func switchMusic(_ sender: UISwitch) {
		if sender.isOn {
			audioController.playSound()
		}
		else {
			audioController.stopSoundAndMusic()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

