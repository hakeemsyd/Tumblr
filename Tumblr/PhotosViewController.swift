//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Syed Hakeem Abbas on 9/9/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = []
    var isMoreDataLoading = false
    var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 240;
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchData(offset: 0, handler: { (data, response, error) in
            self.posts = self.parsePosts(data: data)
            self.tableView.reloadData()
        });
        
        
        // Set up Infinite Scroll loading indicator
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.tableView.tableFooterView = tableFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        destinationViewController.image = getImageUrl(postIndex: indexPath.section, photoIndex: indexPath.row)
    }
    
    // data loading
    func fetchData(offset: Int, handler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let fullUrl = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?limit=5&offset=\(offset)&api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string: fullUrl)
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: handler);
        task.resume()
    }
    
    func parsePosts(data: Data? ) -> [NSDictionary]{
        if let data = data {
            if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data, options:[]) as? NSDictionary {
                let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                let parsedPosts = responseFieldDictionary["posts"] as! [NSDictionary]
                return parsedPosts;
            }
        }
        return [];
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData(offset: 0, handler: { (data, response, error) in
            self.posts =  self.parsePosts(data: data);
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        });
    }
    
    func getPhotosForPost(postIndex: Int) -> [NSDictionary]{
        let post = self.posts[postIndex]
        if let photos = post.value(forKey: "photos") as? [NSDictionary]{
            return photos;
        }
        
        return [];
    }
    
    func getImageUrl(postIndex: Int, photoIndex: Int) -> String{
        let post = self.posts[postIndex];
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[photoIndex].value(forKeyPath: "original_size.url") as? String
            return imageUrlString!
        }
        
        
        let photos = getPhotosForPost(postIndex: postIndex)
        if photos.count > 0{
            return (photos[photoIndex].value(forKey: "original_size.url") as? String)!
        }
        
        return ""
    }
    
    func getAvatarUrl(postIndex: Int) -> String {
        let post = self.posts[postIndex]
        if let postname = post.value(forKeyPath: "blog_name") as? String {
            return "https://api.tumblr.com/v2/blog/\(postname).tumblr.com/avatar"
        }
        
        return ""
    }
    
    // tableView protocole
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPhotosForPost(postIndex: section).count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // set the avatar
        profileView.setImageWith(NSURL(string:getAvatarUrl(postIndex: section))! as URL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(posts.count - indexPath.section <= 4 && !self.isMoreDataLoading){
            self.isMoreDataLoading = true;
            loadingView.startAnimating()
            
            // ... Code to load more results ...
            self.fetchData(offset: posts.count,handler: {(data, response, error) in
                self.isMoreDataLoading = false;
                self.loadingView.stopAnimating()
                self.posts += self.parsePosts(data: data)
                self.tableView.reloadData()
            });
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell") as! PhotoTableCell
        let strUrl = getImageUrl(postIndex: indexPath.section, photoIndex: indexPath.row)
        if let url = URL(string: strUrl){
            cell.cellImage.setImageWith(url)
        }
        return cell
    }
    
}
