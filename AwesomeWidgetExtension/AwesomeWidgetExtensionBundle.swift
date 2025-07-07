//
//  AwesomeWidgetExtensionBundle.swift
//  AwesomeWidgetExtension
//
//  Created by zhuruiqi6 on 2025/4/2.
//

import WidgetKit
import SwiftUI

@main
struct AwesomeWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        AwesomeWidgetExtension()
        TestTheTimelineWidget()
        MultiConfigWidget()
        MyCarControlWidget()
        FlashWidget()
    }
}
