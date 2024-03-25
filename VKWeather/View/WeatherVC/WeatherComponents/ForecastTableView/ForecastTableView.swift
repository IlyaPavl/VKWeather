//
//  ForecastTableView.swift
//  VKWeather
//
//  Created by ily.pavlov on 23.03.2024.
//

import UIKit

final class ForecastTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var forecasts = [List]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableUI()
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableUI() {
        self.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        self.separatorStyle = .singleLine
        self.separatorColor = .systemGray5
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return forecasts.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        let forecast = forecasts[indexPath.row]
        cell.configureCell(weekdayText: "\(forecast.dt.toDateFormatted(withDayOfWeek: true))",
                           conditionCode: forecast.weather[0].id,
                           minTempText: "min: \(Int(forecast.temp.min))°",
                           maxTempText: "max: \(Int(forecast.temp.max))°")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 47 }
}
