//
//  UploadMediaViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class UploadMediaViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    var mediaID : NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func uploadMediaSwift(_ sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate=self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
         let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("documentsPath: \(documentsPath)")

        let image:UIImage = (editingInfo![UIImagePickerControllerOriginalImage] as? UIImage)!
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)

        let localPath         = photoURL.appendingPathComponent("profileimage")
        let data              = UIImageJPEGRepresentation(image, 0.9)

        do
        {
            try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
        }
        catch
        {
            // Catch exception here and act accordingly
        }

        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        do {
            mediaID = try sdk.uploadMediaFile(localPath?.absoluteString) as NSString?
        }
        catch{
            print("Upload Media Media Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        print("Uploaded media ID is \(mediaID)" )
        self.dismiss(animated: true, completion: nil);
        self.showAlert()
    }

    func showAlert()
    {
        if(self.mediaID==nil)
        {
            let alertController = UIAlertController(title: "OPGSDKv1.5", message: "Media upload failed", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "OPGSDKv1.5", message: "Uploaded media ID is \(self.mediaID!)", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

}
