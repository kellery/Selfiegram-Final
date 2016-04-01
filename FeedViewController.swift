//
//  FeedViewController.swift
//  Selfiegram
//
//  Created by Kim Ellery on 2016-03-24.
//  Copyright © 2016 Kim Ellery. All rights reserved.
//

import UIKit


class FeedViewController: UITableViewController {
    
var words = ["Hello", "my", "name", "is","Selfigram"]
let me = User(aUsername: "kim", aProfileImage: UIImage(named: "Grumpy-Cat")!)
    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=63850519b7a722e7600c2fd3578319aa&tags=goats")!) { (data, response, error) -> Void in
            
            // convert NSData to JSON
            if let jsonUnformatted = try? NSJSONSerialization.JSONObjectWithData(data!, options: []),
                let json = jsonUnformatted as? [String : AnyObject],
                let photosDictionary = json["photos"] as? [String : AnyObject],
                let photosArray = photosDictionary["photo"] as? [[String : AnyObject]]
            {
                
                for photo in photosArray {
                    
                    if let farmID = photo["farm"] as? Int,
                        let serverID = photo["server"] as? String,
                        let photoID = photo["id"] as? String,
                        let secret = photo["secret"] as? String {
                        
                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                        if let photoURL = NSURL(string: photoURLString){
                            let me = User(aUsername: "Goatman", aProfileImage: UIImage(named: "Grumpy-Cat")!)
                            let post = Post(imageURL: photoURL, user: me, comment: "More Goats")
                            self.posts.append(post)
                    }
                }
      
            }
                
                // We use dispatch_async because we need update all UI elements on the main thread.
                // This is a rule and you will see this again whenever you are updating UI.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }else{
                print("error with response data")
            }
            
        }
        
        task.resume()
        
        // UIImage has an initializer where you can pass in the name of an image in your project to create an UIImage
        // UIImage(named: "grumpy-cat") can return nil if there is no image called "grumpy-cat" in your project
        // Our definition of Post did not include the possibility of a nil UIImage
        // so, therefore we have to add a ! at the end of it
//        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
//        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")
//        
//        posts = [post0, post1, post2, post3, post4]

    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! SelfieCell
        
        let post = self.posts[indexPath.row]
        
        
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everything we layout a cell
        // Because we are reusing "postCell" cells, a reused cell might have an image already set on it.
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url,
                let imageData = NSData(contentsOfURL: imageURL){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    cell.selfieImageView.image = UIImage(data: imageData)
                    
                })
            }
        }
        
        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
