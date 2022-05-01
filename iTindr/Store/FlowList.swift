import Foundation

struct FlowList {
    var list: [ProfileData] = []

    mutating func setFlowList(profiles: [ProfileData]) {
        list = profiles.filter {
            $0.name != ""
        }
    }

    mutating func getUser() -> ProfileData? {
        if list.isEmpty {
            return nil
        }

        return list.removeFirst()
    }
}
