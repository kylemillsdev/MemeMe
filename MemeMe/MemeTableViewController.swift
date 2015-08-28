//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Kyle Mills on 8/25/15.
//  Copyright (c) 2015 Kyle Mills Dev. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    
    @IBOutlet var memeTableView: UITableView!
    
    var memes: [MemeMe]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        memeTableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UITableViewCell

        let meme = memes[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = meme.topText! + "   " + meme.bottomText!
        cell.imageView?.image = meme.originalImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")!
        let detailController = object as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }

}
