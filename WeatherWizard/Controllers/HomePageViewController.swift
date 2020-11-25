//
//  HomePageViewController.swift
//  WeatherWizard
//


import UIKit

class HomePageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        proxy.currentPageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
