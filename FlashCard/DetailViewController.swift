//
//  ViewController.swift
//  FlashCard
//
//  Created by Yi Feng Ye on 8/21/17.
//  Copyright © 2017 Yi Feng Ye. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var translationTextView: UITextView!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var cardData: FlashCardData?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        wordTextField.delegate = self
        translationTextView.delegate = self
        
        if let cardData = cardData {
            wordTextField.text = cardData.word
            translationTextView.text = cardData.translation
            if cardData.photo !== nil {
                descriptionImage.image = cardData.photo
            }
        }
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return;
        }
        
        let word = wordTextField.text ?? ""
        let translation = translationTextView.text ?? ""
        let photo = descriptionImage.image;
        
        cardData = FlashCardData(word: word, translation: translation, photo: photo)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        wordTextField.resignFirstResponder()
        translationTextView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if (isPresentingInAddMode) {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The DetailViewController is not inside a navigation controller.")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        descriptionImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let word = wordTextField.text ?? ""
        let translation = translationTextView.text ?? ""
        saveButton.isEnabled = !word.isEmpty && !translation.isEmpty
    }
}

