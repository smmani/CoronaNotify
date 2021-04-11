//
//  HomeViewModel.swift
//  CoronaNotify
//
//  Created by Selvakumar Murugan on 11/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import Foundation

class HomeViewModel {
    var allEvents : [RegionEvent] = []
    var uiRefreshBlock : (() -> ())?
    func fetchAllEvents() {
        self.allEvents = CoreDataManager.shared.fetchAllRegionEvents()
        if uiRefreshBlock != nil {
            self.uiRefreshBlock!()
        }
    }
}
