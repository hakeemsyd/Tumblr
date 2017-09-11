//
//  FullScreenPhotoViewController.swift
//  Tumblr
//
//  Created by Syed Hakeem Abbas on 9/10/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var modelPhoto: UIImageView!
    var image: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        modelPhoto.image = self.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return modelPhoto
    }

    @IBAction func onClose() {
        dismiss(animated: true, completion: nil)
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
