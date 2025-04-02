//
//  AppIntent.swift
//  AwesomeWidgetExtension
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "刷新状态" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
    
//    func fetchStatusAndUpdateStorage() async -> (String, Date) {
//        let sharedDefaults = UserDefaults(suiteName: "group.com.awesomeapp.shared")
//        let status = await APIService.shared.fetchStatus()
//        let lastUpdated = Date()
//        sharedDefaults?.set(status, forKey: "widget_status")
//        sharedDefaults?.set(lastUpdated.timeIntervalSince1970, forKey: "widget_lastUpdated")
//        sharedDefaults?.synchronize()
//
//        return (status, lastUpdated)
//    }
}


struct RefreshStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "刷新状态"
    
    // ✅ 这里的参数必须用 @Parameter
    @Parameter(title: "新状态")
    var status: String

    func perform() async throws -> some IntentResult {
        // 执行刷新操作
        return .result()
    }
}
