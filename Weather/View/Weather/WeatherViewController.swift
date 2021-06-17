//
//  ViewController.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/5.
//

import UIKit

class WeatherViewController: UIViewController, StoryboardInstantiable, Alertable {

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var tempMinMaxLbl: UILabel!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    var viewModel: WeatherViewModel!
    
    private var weather: WeatherInfo?
        
    private var bCelsius: Bool = true
    
    private var times = [Int]()
    
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: WeatherViewModel) -> WeatherViewController {
        let view = WeatherViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindViewModel()
        
        configureUI()
    }
    
    private func configureUI() {
        dayCollectionView.register(UINib.init(nibName: DayCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
        
        timeTableView.register(UINib(nibName: String(describing: TimeTableViewCell.reuseIdentifier), bundle: nil), forCellReuseIdentifier: TimeTableViewCell.reuseIdentifier)
        
        // Background Color
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
        showSearch()
    }
    
    @IBAction func displayModeBtnClick(_ sender: Any) {
        showDisplayMode()
    }

}

// MARK: - Time TableView Delegate and DataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimeTableViewCell", for: indexPath as IndexPath) as? TimeTableViewCell else {
            fatalError("TimeTableViewCell cell is not found")
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(times[indexPath.row]))
        
        cell.time = date
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedTime = indexPath.row
    }
}


// MARK: Day Collection View Delegate and DataSource

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as? DayCollectionViewCell else {
            fatalError("DayCollectionViewCell cell is not found")
        }
                
        guard let date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date()) else {
            return cell
        }
        
        cell.date = date
                        
        cell.isCurrent = indexPath.row == viewModel.selectedDay
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedDay = indexPath.row
        dayCollectionView.reloadData()
    }
}

// MARK: ViewModel

extension WeatherViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 5
        let height = collectionView.bounds.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

// MARK: Location

extension WeatherViewController {
    
    private func showSearch() {
        let vc = AppDIContainer.instance.makeSearchCitiesViewController(delegate: viewModel)
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: Display Mode

extension WeatherViewController {
    private func showDisplayMode() {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        let celsiusAction = UIAlertAction(title: "Celsius", style: .default, handler: { action in
            self.bCelsius = true
            self.fillUI()
        })
        let fahrenheitAction = UIAlertAction(title: "Fahrenheit", style: .default, handler: { action in
            self.bCelsius = false
            self.fillUI()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        optionMenu.addAction(celsiusAction)
        optionMenu.addAction(fahrenheitAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: ViewModel

extension WeatherViewController {
    private func bindViewModel() {
        viewModel = WeatherViewModel()
    
        viewModel.load(latitude: WeatherConfiguration.DefaultLocation.latitude, longitude: WeatherConfiguration.DefaultLocation.longitude)
        
        // Error
        viewModel.error.observe(on: self) { [weak self] error in
            guard let message = error else {
                return
            }
            self?.showError(message: message)
        }
        
        // Waiting
        viewModel.loading.observe(on: self) { [weak self] isLoading in
            if (isLoading) {
                if let parentView = self?.view {
                    ProgressHUD.instance.show(parentView: parentView)
                }                
            } else {
                ProgressHUD.instance.dismiss()
            }
        }
                
        // Weather Change
        viewModel.weather.observe(on: self) { [weak self] data in
            self?.weather = data
            self?.fillUI()
        }
        
        // City Name Change
        viewModel.city.observe(on: self) { [weak self] data in
            self?.cityLbl.text = data?.name
        }
        
        // Time Table Change
        viewModel.times.observe(on: self) { [weak self] data in
            self?.times = data
            self?.timeTableView.reloadData()
            
            if self?.times.count ?? 0 > 0 {
                self?.timeTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
        
    }
    
    private func fillUI() {
        guard let weather = self.weather else {
            return
        }
        
        // Set Temperature
        let tempAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 42)
        ]
        let descAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        let attributedString = NSMutableAttributedString()
        
        let temperature = weather.main.temp - 273.15
        
        if bCelsius {
            attributedString.append(NSAttributedString(string: String(format: "%.0f℃\n", temperature), attributes: tempAttributes))
        } else {
            attributedString.append(NSAttributedString(string: String(format: "%.0f°F\n", temperature * 9 / 5 + 32), attributes: tempAttributes))
        }
        
        guard let detail = weather.weather.first else {
            self.tempLbl.attributedText = attributedString
            return
        }
        
        attributedString.append(NSAttributedString(string: detail.main.uppercased(), attributes: descAttributes))
        self.tempLbl.attributedText = attributedString
        
        // Set Background Image / Icon
        var weatherImage: UIImage?
        
        switch detail.main {
        case WeatherCondition.clear.rawValue, WeatherCondition.sunny.rawValue:
            weatherImage = WeatherConfiguration.Images.Sunny
        case WeatherCondition.clouds.rawValue:
            weatherImage = WeatherConfiguration.Images.Clouds
        case WeatherCondition.snow.rawValue:
            weatherImage = WeatherConfiguration.Images.Snow
        case WeatherCondition.rain.rawValue:
            weatherImage = WeatherConfiguration.Images.Rain
        case WeatherCondition.thunderstorm.rawValue:
            weatherImage = WeatherConfiguration.Images.Thunder
        default:
            weatherImage = WeatherConfiguration.Images.Clouds
        }
        
        self.bgView.image = weatherImage?.alpha(0.1)
        
        self.weatherIcon.image = weatherImage?.tinted(with: UIColor.white)
                
        // Background Color

        switch detail.main {
        case WeatherCondition.clear.rawValue, WeatherCondition.sunny.rawValue:
            gradientLayer.colors = [WeatherConfiguration.Colors.SunnyTopColor.cgColor, WeatherConfiguration.Colors.SunnyBottomColor.cgColor]
        case WeatherCondition.clouds.rawValue:
            gradientLayer.colors = [WeatherConfiguration.Colors.CloudsTopColor.cgColor, WeatherConfiguration.Colors.CloudsBottomColor.cgColor]
        case WeatherCondition.snow.rawValue:
            gradientLayer.colors = [WeatherConfiguration.Colors.SnowTopColor.cgColor, WeatherConfiguration.Colors.SnowBottomColor.cgColor]
        case WeatherCondition.rain.rawValue:
            gradientLayer.colors = [WeatherConfiguration.Colors.RainTopColor.cgColor, WeatherConfiguration.Colors.RainBottomColor.cgColor]
        case WeatherCondition.thunderstorm.rawValue:
            gradientLayer.colors = [WeatherConfiguration.Colors.ThunderTopColor.cgColor, WeatherConfiguration.Colors.ThunderBottomColor.cgColor]
        default:
            gradientLayer.colors = [WeatherConfiguration.Colors.CloudsTopColor.cgColor, WeatherConfiguration.Colors.CloudsBottomColor.cgColor]
        }
                
    }
    
}
