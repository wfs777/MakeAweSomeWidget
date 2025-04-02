//
//  TriggerRequestIntent.swift
//  AwesomeWidgetExtensionExtension
//
//  Created by zhuruiqi6 on 2025/4/14.
//

import AppIntents
import WidgetKit

struct TriggerRequestIntent: AppIntent {
    static var title: LocalizedStringResource = "触发请求"

    func perform() async throws -> some IntentResult {
        // 设置状态为“请求中...”
        WidgetState.shared.status = "请求中..."
        WidgetCenter.shared.reloadAllTimelines()

        // 异步执行耗时请求
        Task.detached {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let result = Bool.random()
            WidgetState.shared.status = result ? "✅ 成功" : "❌ 失败"
            WidgetCenter.shared.reloadAllTimelines()
        }

        return .result()
    }
}

class WidgetState {
    static let shared = WidgetState()
    private let statusKey = "WidgetStatusKey"

    var status: String {
        get {
            UserDefaults.standard.string(forKey: statusKey) ?? "点击按钮开始"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: statusKey)
        }
    }
}
