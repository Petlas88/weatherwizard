//
//  ForecastCell.swift
//  WeatherWizard
//


import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var forecastBackground: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        forecastBackground.layer.cornerRadius = 10
        // Configure the view for the selected state
    }
    
}
