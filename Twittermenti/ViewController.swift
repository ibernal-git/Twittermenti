//
//  ViewController.swift
//  Twittermenti
//
//  Created by Imanol Bernal on 28/04/2020.
//  Copyright © 2020 Imanol Bernal. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    private var apiKey = API()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAPI()
        let swifter = Swifter(consumerKey: apiKey.Key, consumerSecret: apiKey.Secret)
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
    func loadAPI() {
        
        let path = Bundle.main.url(forResource: "Secrets", withExtension: "plist")
        if let data = try? Data(contentsOf: path!) {
            let decoder = PropertyListDecoder()
            do {
                apiKey = try decoder.decode(API.self, from: data)
                //print(apiKey.Key)
            } catch {
                print("Error dencoding API. \(error)")
            }
        }
        
    }
    
}

