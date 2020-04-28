//
//  ViewController.swift
//  Twittermenti
//
//  Created by Imanol Bernal on 28/04/2020.
//  Copyright © 2020 Imanol Bernal. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    private var apiKey = API()
    private var swifter = Swifter (consumerKey: "", consumerSecret: "")
    private let sentimentClassifier = TweetSentimentClasiffier()
    private let tweetCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAPI()
        swifter = Swifter(consumerKey: apiKey.Key, consumerSecret: apiKey.Secret)
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets(textField.text)
    
    }
    
    func loadAPI() {
        
        let path = Bundle.main.url(forResource: "Secrets", withExtension: "plist")
        if let data = try? Data(contentsOf: path!) {
            let decoder = PropertyListDecoder()
            do {
                apiKey = try decoder.decode(API.self, from: data)
            } catch {
                print("Error dencoding API. \(error)")
            }
        }
    }
    
    func fetchTweets(_ textField: String?) {
        
        if let searchField = textField {
            
            swifter.searchTweet(using: searchField, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [TweetSentimentClasiffierInput]()
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClasiffierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePrediction(with: tweets)
                
            }) { (error) in
                print("There was a error with the Twitter API Request, \(error)")
            }
        }
    }
    
    func makePrediction(with tweets: [TweetSentimentClasiffierInput]) {
        
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for prediction in predictions {
                if prediction.label == "Pos"{
                    sentimentScore += 1
                } else if prediction.label == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(with: sentimentScore)
            
        } catch {
            print(error)
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😃"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😟"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        
    }
        
        
    
}

