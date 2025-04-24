//
//  IntentHandler.swift
//  AwesomeWidgetIntents
//
//  Created by zhuruiqi6 on 2025/4/23.
//

import Intents


enum CarControlType: String, CaseIterable {
    case lock
    case findCar
    case trunk
    case window
    case airCondition
    case ventilate
    case skylight
}

extension CarControlType {
    var name: String {
        switch self {
        case .lock:
            return "车锁"
        case .findCar:
            return "寻车"
        case .trunk:
            return "后备箱"
        case .window:
            return "车窗"
        case .airCondition:
            return "空调"
        case .ventilate:
            return "透气"
        case .skylight:
            return "天窗"
        }
    }
}

class IntentHandler: INExtension, WidgetConfigIntentHandling {
    override func handler(for intent: INIntent) -> Any {
        print("IntentHandler 初始化了 ✅")
        return self
    }
    
    /// 动态提供可选的车控功能（每次时间线刷新都会执行）
    /// 勾选`Intent handler provides search results are the user types`后才会有searchTerm参数
    func provideCarControlsOptionsCollection(
        for intent: WidgetConfigIntent,
        searchTerm: String?,
        with completion: @escaping (INObjectCollection<CarControl>?, Error?) -> Void
    ) {
        var carControlTypes = CarControlType
            .allCases
            .filter { carControlType in
                !(intent.carControls ?? []).contains { $0.identifier == carControlType.rawValue }
            } // 过滤掉编辑页面已经存在的车控功能

        // 匹配搜索关键字
        if let searchTerm {
            carControlTypes = carControlTypes.filter { $0.name.contains(searchTerm) }
        }

        let carControls = carControlTypes.map { CarControl(identifier: $0.rawValue, display: $0.name) }
        completion(INObjectCollection(items: carControls), nil)
    }
    

    /// 提供默认4个车控功能（小组件生命周期内只会执行一次）
    func defaultCarControls(for intent: WidgetConfigIntent) -> [CarControl]? {
        CarControlType
            .allCases
            .prefix(4)
            .map { CarControl(identifier: $0.rawValue, display: $0.name) }
    }
}

