import Foundation

struct Store {
    static var flow: FlowList = FlowList()
    static var user: User = User()
    static var topics: TopicList = TopicList()

    static func loadProfileDataFromServer(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        UserActions.profile(successCallback: { profileData in
            user.setData(userProfile: profileData)
            successCallback()
        }, errorCallBack: {
            errorCallBack()
        })
    }

    static func loadFlowDataFromServer(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        UserActions.getCurrentUserFlowUsers(
                successCallback: { profilesData in
                    flow.setFlowList(profiles: profilesData)
                    successCallback()
                }, errorCallBack: {
            errorCallBack()
        })
    }

    static func loadTopicsDataFromServer(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        UserActions.topics(
                successCallback: { topicsData in
                    topics.list = topicsData
                    successCallback()
                }, errorCallBack: {
            errorCallBack()
        })
    }

    static func loadAllDataFromServer(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        loadProfileDataFromServer(successCallback: { group.leave() }, errorCallBack: { group.leave() })
        group.enter()
        loadFlowDataFromServer(successCallback: { group.leave() }, errorCallBack: { group.leave() })
        group.enter()
        loadTopicsDataFromServer(successCallback: { group.leave() }, errorCallBack: { group.leave() })

        group.notify(queue: .main, execute: {
            successCallback()
        })
    }

    static func loadProfileAndTopicsDataFromServer(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        loadProfileDataFromServer(successCallback: { group.leave() }, errorCallBack: { group.leave() })
        group.enter()
        loadTopicsDataFromServer(successCallback: { group.leave() }, errorCallBack: { group.leave() })

        group.notify(queue: .main, execute: {
            successCallback()
        })
    }
}
