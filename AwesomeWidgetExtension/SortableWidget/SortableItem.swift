import AppIntents
import SwiftUICore
import Foundation
// 可排序的操作项
struct SortableItem: AppEntity, Hashable {
    let id: String
    var title: String
    var icon: String?
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "操作项"
    static var defaultQuery = SortableItemQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: title),
            image: icon.flatMap { .init(systemName: $0) }
        )
    }
}

// 查询实现
struct SortableItemQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [SortableItem] {
        SortableItem.allItems.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [SortableItem] {
        SortableItem.defaultItems
    }
}

// 示例数据
extension SortableItem {
    static var allItems: [SortableItem] = [
        SortableItem(id: "weather", title: "天气", icon: "cloud.sun"),
        SortableItem(id: "calendar", title: "日历", icon: "calendar"),
        SortableItem(id: "reminders", title: "提醒", icon: "list.bullet"),
        SortableItem(id: "news", title: "新闻", icon: "newspaper")
    ]
    
    static var defaultItems: [SortableItem] {
        Array(allItems.prefix(2))
    }
}

// 背景样式枚举
enum WidgetBackground: String, AppEnum {
    case system, light, dark, accent
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "背景样式"
    
    static var caseDisplayRepresentations: [WidgetBackground: DisplayRepresentation] = [
        .system: "系统默认",
        .light: "浅色",
        .dark: "深色",
        .accent: "强调色"
    ]
    
    var color: Color {
        switch self {
        case .system: return Color(.systemBackground)
        case .light: return .white
        case .dark: return .black
        case .accent: return .blue
        }
    }
}


struct CityOption: AppEntity, Hashable {
    let id: String
    let name: String
    let province: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "城市"
    static var defaultQuery = CityOptionQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: name)
        )
    }
}

struct CityOptionQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [CityOption] {
        CityOption.allCities.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [CityOption] {
        CityOption.defaultCities
    }
    
}


extension CityOption {
    static var allCities: [CityOption] = [
        // 浙江
        .init(id: "hz", name: "杭州", province: "浙江"),
        .init(id: "nb", name: "宁波", province: "浙江"),
        .init(id: "wz", name: "温州", province: "浙江"),
        
        // 江苏
        .init(id: "nj", name: "南京", province: "江苏"),
        .init(id: "sz", name: "苏州", province: "江苏"),
        .init(id: "wx", name: "无锡", province: "江苏")
    ]
    
    static var defaultCities: [CityOption] {
        [.init(id: "hz", name: "杭州", province: "浙江")]
    }
}
