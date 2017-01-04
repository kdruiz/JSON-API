//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movieList:JSON?
    var linkToMovie: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //exerciseOne()
        //exerciseTwo()
        //exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    self.movieList = json["feed"]["entry"]
                    self.selectRandomMovie()
                                        
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        if self.linkToMovie != nil {
            UIApplication.shared.openURL(URL(string: self.linkToMovie!)!)
        } else {
            UIApplication.shared.openURL(URL(string: "https://www.apple.com")!)
        }
        
    }
    @IBAction func refereshMovie(_ sender: UIButton) {
        self.selectRandomMovie()
    }
    
    func selectRandomMovie() {
        if let myMovieList = movieList {
            let movieCount = UInt32(myMovieList.count)
            let movieIndex = Int(arc4random_uniform(movieCount))
            
            
            let selectedMovieData = myMovieList[movieIndex]
            let selectedMovie = Movie(json: selectedMovieData)
            
            self.movieTitleLabel.text = "\(movieIndex). \(selectedMovie.name)"
            self.rightsOwnerLabel.text = selectedMovie.rightsOwner
            self.releaseDateLabel.text = selectedMovie.releaseDate
            self.priceLabel.text = "$\(selectedMovie.price)"
            self.loadPoster(urlString: selectedMovie.imageLink)
            print("\(selectedMovie.imageLink)")
            
            self.linkToMovie = selectedMovie.link
        }
        
    }
    
}

