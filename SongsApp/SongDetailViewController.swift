//
//  SongDetailViewController.swift
//  SongsApp
//
//  Created by Marc Jackson on 28/12/2017.
//  Copyright © 2017 Marc Jackson. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var song:Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView() //Setss the text properties of our outles to values from our song property

        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        titleLabel.text = song?.title
        artistLabel.text = song?.artist
        //ratingLabel.text = "\(song!.rating) /5 Stars"
        
        /*
        if let theRating = song?.rating {
            ratingLabel.text = "\(theRating) /5 Stars"
        } else {
            ratingLabel.text = "Song not rated"
        }
        positionLabel.text = "Chart position # \(song!.chartPosition)"
        */
    }
    
}

