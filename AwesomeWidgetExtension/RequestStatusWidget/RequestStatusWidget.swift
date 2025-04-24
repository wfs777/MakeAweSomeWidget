//
//  RequestStatusWidget.swift
//  AwesomeWidgetExtensionExtension
//
//  Created by zhuruiqi6 on 2025/4/14.
//

import WidgetKit
import SwiftUI

struct RequestStatusProvider: TimelineProvider {
    func placeholder(in context: Context) -> RequestStatusEntry {
        RequestStatusEntry(date: Date(), status: "加载中...")
    }

    func getSnapshot(in context: Context, completion: @escaping (RequestStatusEntry) -> ()) {
        let entry = RequestStatusEntry(date: Date(), status: WidgetState.shared.status)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RequestStatusEntry>) -> ()) {
        let entry = RequestStatusEntry(date: Date(), status: WidgetState.shared.status)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct RequestStatusEntry: TimelineEntry {
    let date: Date
    let status: String
}

struct RequestStatusWidgetEntryView: View {
    var entry: RequestStatusProvider.Entry

    var body: some View {
        VStack(spacing: 10) {
            Text(entry.status)
                .font(.headline)
            Button(intent: TriggerRequestIntent()) {
                Text("开始请求")
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}


struct RequestStatusWidget: Widget {
    let kind: String = "RequestStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RequestStatusProvider()) { entry in
            RequestStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("请求状态小组件")
        .description("点击按钮发起请求并更新状态")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
