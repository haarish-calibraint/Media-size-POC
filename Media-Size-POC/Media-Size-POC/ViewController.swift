//
//  ViewController.swift
//  Media-Size-POC
//
//  Created by Haarish Kannan KG on 01/08/22.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    var mediaPickerController: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaPickerController = UIImagePickerController()
        mediaPickerController.delegate = self
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        getGalleryAccess()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            
            // Approach 1
            do {
                let attribute = try FileManager.default.attributesOfItem(atPath: imageUrl.path)
                    if let size = attribute[FileAttributeKey.size] as? NSNumber {
                        let sizeInMb = size.doubleValue / 1000000.0
                        sizeLabel.text = "Size (MB) - \(sizeInMb)"
                        print(sizeInMb)
                    }
                } catch {
                    print("Error: \(error)")
            }
            
            // Approach 2
            do {
                let resources = try imageUrl.resourceValues(forKeys:[.fileSizeKey])
                if let size = resources.fileSize {
                    let sizeInMb = Double(size) / 1000000.0
                    sizeLabel.text = "Size (MB) - \(sizeInMb)"
                    print (sizeInMb)
                }
            } catch {
                print("Error: \(error)")
            }
            
            imageView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func getGalleryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.showImagePickerView()
            }
        case .denied:
            print("denied")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.showImagePickerView()
                    }
                case .denied:
                   print("denied")
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    func showImagePickerView() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        mediaPickerController.sourceType = .photoLibrary
        self.present(mediaPickerController, animated: true, completion: nil)
    }

}

