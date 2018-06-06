//
//  ProfileViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 3/31/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var name: String = ""
    var birthday: Date? = nil
    var gender = 0
    var memo : String = ""
    
    let dateOfBirthPicker = UIDatePicker()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextView!
    @IBOutlet weak var genderSelect: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDateOfBirthPicker()
        
        
     
        
   

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        
        // load name field
        if let nameTextFieldContents = defaults.string(forKey: name) {
            nameTextField.text = nameTextFieldContents
        } else {
            nameTextField.becomeFirstResponder()
        }
        
        // load gender
        if let genderValue = defaults.value(forKey: "gender") {
            let genderSelectedIndex = genderValue as! Int
            genderSelect.selectedSegmentIndex = genderSelectedIndex
        } else {
            genderSelect.becomeFirstResponder()
        }
        
        // load birthday
        if let birthdayTextFieldContents = defaults.string(forKey: "birthday") {
            dateOfBirthTextField.text = birthdayTextFieldContents
        } else {
            dateOfBirthTextField.becomeFirstResponder()
        }
        
        // load memo
        if let memoTextFieldContents = defaults.string(forKey: "memo") {
            memoTextField.text = memoTextFieldContents
        } else {
            memoTextField.becomeFirstResponder()
        }
        
//        // profile photo
//        let data = UserDefaults.standard.object(forKey: "profileImageData") as! NSData
//        profilePicture.image = UIImage(data: data as Data)
        
        

    }
    
    
    @IBAction func choosePhotoButtonClicked(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
     
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        // for Camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            // if Camera is available, then run Camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "No Camera", message: "Camera is not available!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }))
        
        // for Photo Library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePicture.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func createDateOfBirthPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([done], animated: false)
        
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = dateOfBirthPicker
        
        // format picker for date
        dateOfBirthPicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        
        birthday = dateOfBirthPicker.date
        
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: birthday!)
        
        dateOfBirthTextField.text = "\(dateString)"
        
        self.view.endEditing(true)
    }
    
    @IBAction func genderSelectClicked(_ sender: Any) {
        
        switch genderSelect.selectedSegmentIndex {
        case 0:
            gender = 0
        case 1:
            gender = 1
        default:
            break
        }
    }
    



    
    @IBAction func saveClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(nameTextField.text, forKey: name)
    
        userDefaults.set(genderSelect.selectedSegmentIndex, forKey: "gender")
        
        userDefaults.set(dateOfBirthTextField.text, forKey: "birthday")
        
        userDefaults.set(memoTextField.text, forKey: "memo")

        
//        // profile photo save
//        let image = profilePicture.image
//        let imageData:NSData = UIImagePNGRepresentation(image!)! as NSData
//        UserDefaults.standard.set(UIImagePNGRepresentation(image!)! as NSData, forKey: "profileImageData")

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
