//
//  ViewController.swift
//  PhotoUpload
//
//  Created by Rebecca on 2019/11/13.
//  Copyright © 2019 Jasmine. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import AVKit
import Alamofire
import MediaPlayer
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let uploadURL = "http://ioscloud.tk/upload.php"
    private var sessionManager: SessionManager?
    
    @IBAction func uploadImage(_ sender: Any) {
        photoLib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    func photoLib(){
        // 判斷相簿存取權限
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //顯示介面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
            print("Success to load photo library")
        }else{
            print("Photo Library Error")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        guard let jpegData = pickedImage.jpegData(compressionQuality: 1) else {
            return
        }
        // Upload
        self.uploadImg(imageData: jpegData)
        // 退出相簿
        self.dismiss(animated: true, completion:nil)
        print("Select" , pickedImage)
    }
    
    func uploadImg(imageData : Data){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // 参数解释：
                //withName:與伺服器一致 fileName:自定義
                multipartFormData.append(imageData, withName: "file", fileName: "photo1.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo2.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo3.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo4.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo5.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo6.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo7.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: "file", fileName: "photo8.jpg", mimeType: "image/jpeg")
                },
            to: uploadURL,
            encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                // 成功連接伺服器後對JSON處理
                upload.responseJSON { (response) in
                    guard let result = response.result.value else { return }
                    print("\(result)")
                    let success = JSON(result)["success"].int ?? -1
                    if success == 1 {
                        print("Upload Success")
                        let alert = UIAlertController(title:"Alert",message:"Upload Success", preferredStyle: .alert)
                        let action2 = UIAlertAction(title: "Close", style: .default, handler: nil)
                        alert.addAction(action2)
                        self.present(alert , animated: true , completion: nil)
                    }else{
                        print("Upload Failed")
                        let alert = UIAlertController(title:"Alert",message:"Upload Failed", preferredStyle: .alert)
                        let action2 = UIAlertAction(title: "Close", style: .default, handler: nil)
                        alert.addAction(action2)
                        self.present(alert , animated: true , completion: nil)
                    }
                }
                // 取得上傳進度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                // print failed results
                print(encodingError)
            }
        })
    }
    
    

}

