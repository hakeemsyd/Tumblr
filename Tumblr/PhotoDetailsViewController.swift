//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Syed Hakeem Abbas on 9/9/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {


    @IBOutlet weak var detailsPhoto: UIImageView!
    var image: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: image){
            detailsPhoto.setImageWith(url)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPhotoClicked(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "photoModelSegue", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController =  segue.destination as! FullScreenPhotoViewController
        destinationViewController.image = self.detailsPhoto.image
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
