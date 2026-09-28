import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.modules.common

Switch {
    id: root

    property real scale: 0.75
    property color activeColor: "#34c759" // macOS System Green
    property color inactiveColor: Qt.rgba(1, 1, 1, 0.16) // macOS inactive glass track

    implicitHeight: 30 * root.scale
    implicitWidth: 52 * root.scale

    PointingHandInteraction {
    }

    background: Rectangle {
        width: parent.width
        height: parent.height
        radius: height / 2
        color: root.checked ? root.activeColor : root.inactiveColor

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: root.checked ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(1, 1, 1, 0.15)
        }

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }

    }

    indicator: Rectangle {
        readonly property real thumbSize: (root.height - 4)
        readonly property real pad: 2

        width: thumbSize
        height: thumbSize
        radius: thumbSize / 2
        color: "#ffffff"
        layer.enabled: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.checked ? parent.width - width - pad : pad

        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.35)
            shadowVerticalOffset: 1.5
            shadowHorizontalOffset: 0
            shadowBlur: 0.3
        }

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.25, 0.46, 0.45, 0.94, 1, 1]
            }

        }

    }

}
