//
//  DayViewController.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 05/11/2020.
//

import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var drop1Image: UIImageView!
    @IBOutlet weak var drop2Image: UIImageView!
    @IBOutlet weak var drop3Image: UIImageView!
    @IBOutlet weak var drop4Image: UIImageView!
    @IBOutlet weak var drop5Image: UIImageView!
    @IBOutlet weak var drop6Image: UIImageView!
    
    var dayName: String?
    var message: String?
    var iconName: String?
    var updateTime: String?
    var index: Int?
    var iconHasSpun = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayNameLabel.text = dayName
        messageLabel.text = message
        conditionImage.image = UIImage(systemName: iconName!)
        lastUpdatedLabel.text = updateTime
        
        drop1Image.isHidden = true
        drop2Image.isHidden = true
        drop3Image.isHidden = true
        drop4Image.isHidden = true
        drop5Image.isHidden = true
        drop6Image.isHidden = true
        
        
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        conditionImage.addGestureRecognizer(tapRecognizer)
        conditionImage.isUserInteractionEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimating()
    }
    
    @objc func iconTapped() {
        self.conditionImage.layer.removeAllAnimations()
        if !iconHasSpun {
            rotateIcon()
        } else {
            scaleIcon()
        }
    }
    
    //MARK: - Animations
    
    func startAnimating() {
        if iconName == "sun.max.fill" {
            UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .curveLinear, .allowUserInteraction], animations: { () -> Void in
                self.conditionImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.conditionImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
            UIView.animate(withDuration: 6, delay: 0, options: .allowUserInteraction, animations: { () -> Void in
                self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            }, completion: {_ in
                UIView.animate(withDuration: 2, delay: 0 ,options: [.autoreverse, .repeat, .allowUserInteraction], animations: { () -> Void in
                    self.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                })
            })
        }
        if iconName == "umbrella.fill" {
            drop1Image.isHidden = false
            drop2Image.isHidden = false
            drop3Image.isHidden = false
            drop4Image.isHidden = false
            drop5Image.isHidden = false
            drop6Image.isHidden = false
            
            UIView.animate(withDuration: 5, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                self.view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            })
            
            UIView.animate(withDuration: 0.6, delay: 1, animations: {
                self.drop1Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
                    self.drop1Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
           
            UIView.animate(withDuration: 0.2, delay: 0.5, animations: {
                self.drop2Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 1, delay: 0.8, options: [.repeat, .curveLinear], animations: {
                    self.drop2Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
            
            UIView.animate(withDuration: 0, delay: 0.2, animations: {
                self.drop3Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .curveLinear], animations: {
                    self.drop3Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
            
            UIView.animate(withDuration: 0.2, delay: 1, animations: {
                self.drop4Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 1.4, delay: 0, options: [.repeat, .curveLinear], animations: {
                    self.drop4Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
            
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.drop5Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 1.3, delay: 0, options: [.repeat, .curveLinear], animations: {
                    self.drop5Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
            
            UIView.animate(withDuration: 0.1, delay: 0.6, animations: {
                self.drop6Image.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .curveLinear], animations: {
                    self.drop6Image.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                })
            })
        }
    }
    
    func rotateIcon() {
        UIView.animate(withDuration: 3, delay: 0 , options: .autoreverse, animations: { () -> Void in
            self.conditionImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.conditionImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: {_ in
            self.iconHasSpun = true
            self.startAnimating()
        })
    }
    
    func scaleIcon() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {() -> Void in
            self.conditionImage.transform = CGAffineTransform(scaleX: 3, y: 3)
        })
        UIView.animate(withDuration: 2, delay: 2, animations: { () -> Void in
            self.conditionImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {_ in
            self.iconHasSpun = false
            self.startAnimating()
        })
    }
}



