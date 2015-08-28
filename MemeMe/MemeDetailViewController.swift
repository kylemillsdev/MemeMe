//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kyle Mills on 8/26/15.
//  Copyright (c) 2015 Kyle Mills Dev. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    var meme : MemeMe!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailImageView.contentMode = UIViewContentMode.ScaleAspectFit
        detailImageView.image = meme.memedImage

        
        tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
}
