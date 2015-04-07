//
//  ViewController.swift
//  Autolayout
//
//  Created by chenjs on 15/4/7.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    var secure: Bool = false { didSet { updateUI() } }
    
    var loggedInUser: User? { didSet { updateUI() } }
    
    private func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secured Password" : "Password"
        nameLabel?.text = loggedInUser?.name
        companyLabel?.text = loggedInUser?.company
        image = loggedInUser?.image
    }
    
    @IBAction func toggleSecurity(sender: UIButton) {
        secure = !secure
    }
    
    @IBAction func login(sender: UIButton) {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            
            if let constrainedView = imageView {
                if let newImage = newValue {
                    
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: NSLayoutAttribute.Width,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: constrainedView,
                        attribute: NSLayoutAttribute.Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }
    
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioConstraint {
                imageView.removeConstraint(existingConstraint)
            }
        }
        didSet {
            if let newConstraint = aspectRatioConstraint {
                imageView.addConstraint(newConstraint)
            }
        }
    }
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        let ratio = size.height != 0 ? size.width / size.height : 0
        return ratio
    }
}

