//
//  NavViewController.swift
//  fiveminutes
//
//  Created by Guillem Pérez on 1/20/19.
//  Copyright © 2019 Guillem Pérez. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set logo for NavBar
            let logo = UIImage(named: "Image")
            
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            navigationBar.addSubview(imageView)
            
            navigationBar.addConstraint (navigationBar.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 0))
            navigationBar.addConstraint (navigationBar.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 0))
            navigationBar.addConstraint (navigationBar.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0))
            navigationBar.addConstraint (navigationBar.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
