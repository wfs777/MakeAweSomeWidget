import AppIntents

struct SortableWidgetConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "多功能小组件"
    static var description = IntentDescription("可配置的多功能小组件")
    
    // 可排序的操作项
    @Parameter(
        title: "功能项",
        description: "选择并排序要显示的功能",
        requestValueDialog: .init("选择并排序要显示的功能"),
        optionsProvider: SortableItemOptionsProvider()
    )
    var items: [SortableItem]?
    
    
    @Parameter(
        title: "选择城市",
        description: "从省份中选择一个城市"
//        requestValueDialog: .init("选择城市"),
//        inputConnectionBehavior: .connectToPreviousIntentResult,
//        optionsProvider: GroupedCityOptionsProvider()
    )
    var city: CityOption?
    
    // 背景样式
    @Parameter(title: "背景样式", default: .system)
    var background: WidgetBackground
    
    // 是否显示标题
    @Parameter(title: "显示标题", default: true)
    var showTitle: Bool
    
    // 刷新间隔
    @Parameter(
        title: "刷新间隔(分钟)",
        description: "设置自动刷新时间间隔",
        default: 60,
        controlStyle: .field,
        inclusiveRange: (1, 1440)
    )
    var refreshInterval: Int
    
    init() {
        self.items = SortableItem.defaultItems
        self.city = CityOption.defaultCities.first!
        self.background = .system
        self.showTitle = true
        self.refreshInterval = 60
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$items
            \.$city
            \.$background
            \.$showTitle
            \.$refreshInterval
        }
    }
}

// 选项提供者
struct SortableItemOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [SortableItem] {
        SortableItem.allItems
    }
    
    func suggestedResults() async throws -> [SortableItem] {
        SortableItem.defaultItems
    }
}


struct GroupedCityOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [CityOption] {
        CityOption.allCities
    }
    
    func defaultResult() async throws -> CityOption? {
        CityOption.defaultCities.first
    }

    func grouping(for option: CityOption) -> String? {
        option.province
    }
}
