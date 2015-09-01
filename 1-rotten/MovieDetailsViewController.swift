//
//  MovieDetailsViewController.swift
//  1-rotten
//
//  Created by Victor Zhang on 8/30/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var posterView: UIImageView!

    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        var url_lowres = movie.valueForKeyPath("posters.thumbnail") as! String
        var range = url_lowres.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        
        if let range = range {
            url_lowres = url_lowres.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            
            var url = NSURL(string:url_lowres )! //not in practice
            posterView.setImageWithURL(url)
        }
        
        //Blurred Background
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.insertSubview(blurEffectView, aboveSubview: self.posterView)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
