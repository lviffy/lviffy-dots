pragma Singleton
import QtQuick

Item {
    id: root
    property var providers: ({})
    property var responses: []
    property int runningRequests: 0
    property string currentProvider: ""
}
