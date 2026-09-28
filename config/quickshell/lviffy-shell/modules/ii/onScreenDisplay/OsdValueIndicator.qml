import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Item {
    id: root
    required property real value
    required property string icon
    required property string name
    property bool rotateIcon: false
    property bool scaleIcon: false
    property alias from: valueProgressBar.from
    property alias to: valueProgressBar.to

    // macOS OSD: slim compact pill, centered
    implicitWidth: Appearance.sizes.osdWidth + 40
    implicitHeight: valueIndicator.implicitHeight + 2 * Appearance.sizes.elevationMargin

    Rectangle {
        id: valueIndicator
        anchors {
            fill: parent
            margins: Appearance.sizes.elevationMargin
        }
        radius: Appearance.rounding.full  // pill shape
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        implicitWidth: valueRow.implicitWidth
        implicitHeight: valueRow.implicitHeight

        RowLayout { 
            id: valueRow
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10

            // macOS icon: filled circle with system blue
            Rectangle {
                id: iconBg
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                width: 36
                radius: height / 2
                color: Appearance.m3colors.m3primary  // macOS Blue

                MaterialSymbol {
                    id: iconSymbol
                    anchors.centerIn: parent
                    color: "#ffffff"
                    renderType: Text.QtRendering
                    text: root.icon
                    iconSize: 20
                    rotation: 180 * (root.rotateIcon ? value : 0)

                    Behavior on iconSize {
                        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
                    }
                    Behavior on rotation {
                        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
                    }
                }
            }

            StyledSlider {
                id: valueProgressBar
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                configuration: StyledSlider.Configuration.M
                stopIndicatorValues: []
                value: root.value
            }

            // Compact % label
            StyledText { 
                id: valueText
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 4
                color: Qt.rgba(
                    Appearance.m3colors.m3onSurface.r,
                    Appearance.m3colors.m3onSurface.g,
                    Appearance.m3colors.m3onSurface.b,
                    0.7
                )
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Font.Medium
                text: Math.round(root.value * 100) + "%"
            }
        }
    }
}