//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unFavoriteButton: UIButton!

    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var movie: Movie?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        print("viewWillAppear (MovieDetailViewController): implement me!")
        
        if let movie = movie {
            
            /* Setting some defaults ... */
            posterImageView.image = UIImage(named: "film342.png")
            titleLabel.text = movie.title
            unFavoriteButton.hidden = true
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if let userFavorites = appDelegate.userFavorites {
                enableFavoritesButton(userFavorites)
            }else{
                /* TASK A: Get favorite movies, then update the favorite buttons */
                /* 1A. Set the parameters */
                /* 2A. Build the URL */
                /* 3A. Configure the request */
                /* 4A. Make the request */
                /* 5A. Parse the data */
                /* 6A. Use the data! */
                /* 7A. Start the request */
                /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
                let apiKey = appDelegate.apiKey
                let sessionId = appDelegate.sessionID
                let userId = appDelegate.userID
                let baseURLString = appDelegate.baseURLSecureString
                /* 1. Set the parameters */
                let methodParameters = [
                    "api_key": apiKey,
                    "session_id": sessionId!
                ]
                
                /* 2. Build the URL */
                let urlString = baseURLString + "account/\(userId!)/favorite/movies" + appDelegate.escapedParameters(methodParameters)
                let url = NSURL(string: urlString)!
                
                /* 3. Configure the request */
                let request = NSMutableURLRequest(URL: url)
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                /* 4. Make the request */
                let task = self.session.dataTaskWithRequest(request) { (data, response, error) in
                    
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        print("getRequestToken: Print an error message")
                        return
                    }
                    
                    /* GUARD: Did we get a successful 2XX response? */
                    guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                        if let response = response as? NSHTTPURLResponse {
                            print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                        } else if let response = response {
                            print("Your request returned an invalid response! Response: \(response)!")
                        } else {
                            print("Your request returned an invalid response!")
                        }
                        return
                    }
                    
                    /* GUARD: Was there any data returned? */
                    guard let data = data else {
                        print("No data was returned by the request!")
                        return
                    }
                    
                    /* 5. Parse the data */
                    print("getRequestToken: Parse the data \(data)")
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                    
                    /* 6. Use the data! */
                    print("getRequestToken: Use the data")
                    let results = dictionary["results"] as! [[String: AnyObject]]
                    (UIApplication.sharedApplication().delegate as! AppDelegate).userFavorites = Movie.moviesFromResults(results)
                    self.enableFavoritesButton((UIApplication.sharedApplication().delegate as! AppDelegate).userFavorites!)
                }
                /* 7. Start the request */
                task.resume()
            }
            
            
            /* TASK B: Get the poster image, then populate the image view */
            if let posterPath = movie.posterPath {
                
                /* 1B. Set the parameters */
                // There are none...
                
                /* 2B. Build the URL */
                let baseURL = NSURL(string: appDelegate.config.baseImageURLString)!
                let url = baseURL.URLByAppendingPathComponent("w342").URLByAppendingPathComponent(posterPath)
                
                /* 3B. Configure the request */
                let request = NSURLRequest(URL: url)
                
                /* 4B. Make the request */
                let task = session.dataTaskWithRequest(request) { (data, response, error) in
                    
                    /* GUARD: Was there an error? */
                    guard (error == nil) else {
                        print("There was an error with your request: \(error)")
                        return
                    }
                    
                    /* GUARD: Did we get a successful 2XX response? */
                    guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                        if let response = response as? NSHTTPURLResponse {
                            print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                        } else if let response = response {
                            print("Your request returned an invalid response! Response: \(response)!")
                        } else {
                            print("Your request returned an invalid response!")
                        }
                        return
                    }
                    
                    /* GUARD: Was there any data returned? */
                    guard let data = data else {
                        print("No data was returned by the request!")
                        return
                    }
                    
                    /* 5B. Parse the data */
                    // No need, the data is already raw image data.
                    
                    /* 6B. Use the data! */
                    if let image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.posterImageView!.image = image
                        }
                    } else {
                        print("Could not create image from \(data)")
                    }
                }
                
                /* 7B. Start the request */
                task.resume()
            }
        }
    }
    
    func enableFavoritesButton(favorites: [Movie]){
        var isFavorite = false
        if let movie = movie {
            for m in favorites {
                if m.id == movie.id {
                    isFavorite = true
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            if isFavorite {
                self.favoriteButton.hidden = true
                self.unFavoriteButton.hidden = false
            }else{
                self.favoriteButton.hidden = false
                self.unFavoriteButton.hidden = true
            }
        });
    }
    
    // MARK: Favorite Actions
    
    @IBAction func unFavoriteButtonTouchUpInside(sender: AnyObject) {
        
        /* TASK: Remove movie as favorite, then update favorite buttons */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
    
    @IBAction func favoriteButtonTouchUpInside(sender: AnyObject) {
        
        /* TASK: Add movie as favorite, then update favorite buttons */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
}
