//
//  ViewController.swift
//  KFCNotify
//
//  Created by Mani on 10/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel : HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModelSetup()
        RegionMonitor.shared.enableLocationServices()
        self.title = "Checked-In Corona Zones"
        self.startLocationMonitoring()
        self.viewModel.fetchAllEvents()
    }
    
    
    func viewModelSetup() {
        self.viewModel.uiRefreshBlock = {[unowned self] in
            self.reloadTableview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(rawValue: RegionMonitor.onEntryOrExit), object: nil)
    }
    
    @objc func refreshData() {
        self.viewModel.fetchAllEvents()
    }
    
    func reloadTableview() {
        self.tableView.reloadData()
    }
    
    func startLocationMonitoring() {
        RegionMonitor.shared.startLocationMonitoring()
    }


}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionLogCell", for: indexPath) as!  RegionLogCell
        let logEvent = self.viewModel.allEvents[indexPath.row]
        cell.eventTimeLbl.text = logEvent.eventTime
        cell.eventDescription.text = "You have " + (logEvent.eventType == RegionEvent.EventType.onEntry ? "Entered into Coronoa zone" : "crossed Corona zone") + " at \(logEvent.identifier)."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
}
