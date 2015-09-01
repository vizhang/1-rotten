//
//  MoviesViewController.swift
//  1-rotten
//
//  Created by Victor Zhang on 8/30/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //var basicConfiguration: KVNProgressConfiguration?

    var movies: [NSDictionary]? //optional dictionary
    var errorView: UIView?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMoviesList()
        
        //Start HUD
        startHUD()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Setup UIRefresh Tool
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    
    }
    
    //API Call
    func getMoviesList() {
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data != nil {
                println("There's data!")
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json  = json {
                    self.movies  = json["movies"] as? [NSDictionary] //force casted (taking a chance)
                    self.tableView.reloadData()
                }
                
                self.stopHUD()
                self.hideNetworkErrorView()
            }
            else {
                
                println("displayNetworkError")
                self.displayNetworkErrorView()
                self.stopHUD()
            }
        }
    }
    
    //UIRefresh Functions
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        getMoviesList()
    }
    
    
    //HUD FUNCTIONS
    func startHUD() {
        //self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
        //[KVNProgress show];
        
        println("Starting HUD")

    }
    
    func stopHUD() {
        //[KVNProgress dismiss];
        println("Stopping HUD")
        self.refreshControl.endRefreshing()

    }
    
    func displayNetworkErrorView() {
        if let errorView = errorView {
            println("errorview already exists")
            self.errorView?.hidden = false;
        }
        else {
            let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
            
            println("no error view exists")
            var errorView2 = UIView(frame: CGRectMake(0, navigationBarHeight+20, 320, 50))
            errorView2.backgroundColor=UIColor.blackColor()
            errorView2.alpha = 0.5
            
            var errorLabel = UILabel(frame: CGRectMake(0, 5, 320, 40))
            errorLabel.text = "Network Error :("
            errorLabel.textAlignment = .Center;
            errorLabel.textColor = UIColor.whiteColor()
            errorView2.addSubview(errorLabel)
            
            self.errorView = errorView2
            self.view.addSubview(self.errorView!)

        }
        
        
    }
    
    func hideNetworkErrorView() {
        self.errorView?.hidden = true;

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url_lowres = movie.valueForKeyPath("posters.thumbnail") as! String
        var range = url_lowres.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        
        if let range = range {
            url_lowres = url_lowres.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            
            var url = NSURL(string:url_lowres )! //not in practice
            cell.posterView.setImageWithURL(url)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)! //why the exclamation mark?
        let movie = movies![indexPath.row]
        let movieDetailVC = segue.destinationViewController as! MovieDetailsViewController
        movieDetailVC.movie = movie
        
        
        println("about to segway!")
    }
    

}
