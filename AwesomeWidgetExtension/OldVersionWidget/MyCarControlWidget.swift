//
//  MyCarControlWidget.swift
//  AwesomeWidgetExtensionExtension
//
//  Created by zhuruiqi6 on 2025/4/23.
//

import WidgetKit
import SwiftUI
import Intents


struct CarControlEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetConfigIntent
    let carControls: [CarControl]?
}

struct carControlProvider: IntentTimelineProvider {
    
    typealias Intent = WidgetConfigIntent
    
    func placeholder(in context: Context) -> CarControlEntry {
        CarControlEntry(date: Date(), configuration: WidgetConfigIntent(), carControls: [])
    }

    func getSnapshot(for configuration: WidgetConfigIntent, in context: Context, completion: @escaping (CarControlEntry) -> ()) {
        let entry = CarControlEntry(date: Date(), configuration: configuration, carControls: [])
        completion(entry)
    }

    func getTimeline(for configuration: WidgetConfigIntent, in context: Context, completion: @escaping (Timeline<CarControlEntry>) -> ()) {
        let entry = CarControlEntry(date: Date(), configuration: configuration, carControls: configuration.carControls)
//        print("🚀 Widget Timeline 正在请求 timeline(for intent:)：\(configuration)")
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(20 * 60))))
    }
}

struct MyCarControlWidgetEntryView: View {
    var entry: carControlProvider.Entry

    var body: some View {
        VStack {
            Text("车控测试")
            Text(entry.date, style: .time)
            Spacer()
            HStack {
                ForEach(entry.carControls ?? [], id: \.identifier) { carcontrol in
                    Text(carcontrol.displayString)
                }
            }
        }
    }
}

struct MyCarControlWidget: Widget {
    let kind: String = "MyCarControlWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WidgetConfigIntent.self, provider: carControlProvider()) { entry in
            if #available(iOS 17.0, *) {
                MyCarControlWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyCarControlWidgetEntryView(entry: entry)
                    .padding()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

