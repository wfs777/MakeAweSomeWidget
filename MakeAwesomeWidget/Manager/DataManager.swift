//
//  DataManager.swift
//  MakeAwesomeWidget
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import Foundation
import SwiftUI
import WidgetKit

class DataManager: ObservableObject {
    @Published var status: String = "⏳ 加载中..."
    private let sharedDefaults = UserDefaults(suiteName: "group.com.awesomeapp.shared")

    init() {
        loadStatus()
    }

    func fetchNewStatus() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // 模拟网络延迟
            let newStatus = ["✅ 任务完成", "❌ 任务失败", "⚡️ 进行中"].randomElement()!
            
            DispatchQueue.main.async {
                self.status = newStatus
                self.sharedDefaults?.set(newStatus, forKey: "widget_status")
                self.sharedDefaults?.synchronize()

                // 让小组件更新
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    private func loadStatus() {
        if let savedStatus = sharedDefaults?.string(forKey: "widget_status") {
            self.status = savedStatus
        }
    }
}

