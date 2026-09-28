pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Widgets

/**
 * macOS Liquid Glass styled slider.
 */

Slider {
    id: root

    property list<real> stopIndicatorValues: [1]
    property list<real> dividerValues: []
    enum Configuration {
        Wavy = 4,
        XS = 12,
        S = 18,
        M = 30,
        L = 42,
        XL = 72
    }

    property var configuration: StyledSlider.Configuration.S
    readonly property bool isCapsule: configuration >= StyledSlider.Configuration.M

    property real handleDefaultWidth: isCapsule ? 0 : 16
    property real handlePressedWidth: isCapsule ? 0 : 16
    property color highlightColor: isCapsule ? "#ffffff" : Appearance.colors.colPrimary
    property color trackColor: Qt.rgba(1, 1, 1, 0.16)
    property color handleColor: "#ffffff"
    property color dotColor: Appearance.m3colors.m3onSecondaryContainer
    property color dotColorHighlighted: Appearance.m3colors.m3onPrimary
    property real unsharpenRadius: Appearance.rounding.unsharpen
    property real trackWidth: isCapsule ? 32 : configuration
    property real trackRadius: isCapsule ? (trackWidth / 2)
        : trackWidth >= StyledSlider.Configuration.XL ? 21
        : trackWidth >= StyledSlider.Configuration.L ? 12
        : trackWidth >= StyledSlider.Configuration.M ? 9
        : trackWidth >= StyledSlider.Configuration.S ? 6
        : height / 2
    property real handleHeight: isCapsule ? 0 : 16
    property real handleWidth: root.handleDefaultWidth
    property real handleMargins: isCapsule ? 0 : 4
    property real dividerMargins: 2
    property real trackDotSize: 3
    property bool usePercentTooltip: true
    property string tooltipContent: usePercentTooltip ? `${Math.round(((value - from) / (to - from)) * 100)}%` : `${Math.round(value)}`
    property bool wavy: configuration === StyledSlider.Configuration.Wavy // If true, the progress bar will have a wavy fill effect
    property bool animateWave: true
    property real waveAmplitudeMultiplier: wavy ? 0.5 : 0
    property real waveFrequency: 6
    property real waveFps: 60

    implicitHeight: Math.max(trackWidth, handleHeight)
    leftPadding: handleMargins
    rightPadding: handleMargins
    property real effectiveDraggingWidth: width - leftPadding - rightPadding

    Layout.fillWidth: true
    from: 0
    to: 1

    Behavior on value { // This makes the adjusted value (like volume) shift smoothly
        SmoothedAnimation {
            velocity: Appearance.animation.elementMoveFast.velocity
        }
    }

    Behavior on handleMargins {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    component TrackDot: Rectangle {
        required property real value
        property real normalizedValue: (value - root.from) / (root.to - root.from)
        anchors.verticalCenter: parent.verticalCenter
        x: root.handleMargins + (normalizedValue * root.effectiveDraggingWidth) - (root.trackDotSize / 2)
        width: root.trackDotSize
        height: root.trackDotSize
        radius: Appearance.rounding.full
        color: normalizedValue > root.visualPosition ? root.dotColor : root.dotColorHighlighted

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor 
    }

    background: Item {
        id: background
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width
        implicitHeight: root.trackWidth
        height: root.trackWidth

        // Capsule background (macOS Control Center style)
        Item {
            anchors.fill: parent
            visible: root.isCapsule

            Rectangle {
                anchors.fill: parent
                radius: parent.height / 2
                color: root.trackColor
                border.width: 1
                border.color: Appearance.colors.colLayer0Border
            }

            Rectangle {
                id: capsuleFill
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: Math.max(0, Math.min(parent.width, root.visualPosition * parent.width))
                radius: parent.height / 2
                color: root.highlightColor
                visible: width > 0
            }
        }

        // Standard / thin / wavy slider background
        Item {
            id: thinBackground
            anchors.fill: parent
            visible: !root.isCapsule

            property var normalized: root.dividerValues.map(v => (v - root.from) / (root.to - root.from))
            property var filtered: normalized.filter(v => Math.abs(v - root.visualPosition) * effectiveDraggingWidth > handleMargins + handleWidth / 2 - dividerMargins)
            property var leftValues: [0, ...filtered.filter(v => v < root.visualPosition), root.visualPosition]
            property var rightValues: [root.visualPosition, ...filtered.filter(v => v > root.visualPosition), 1]
            property var leftWidths: leftValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)
            property var rightWidths: rightValues.map((v, i, a) => a[i + 1] - v).slice(0, -1)

            // Fill left
            Repeater {
                model: thinBackground.leftWidths.length

                Loader {
                    required property real index
                    anchors.verticalCenter: parent.verticalCenter
                    property real leftMargin: index > 0 ? root.dividerMargins : 0
                    property real rightMargin: index < thinBackground.leftWidths.length - 1 ? root.dividerMargins : root.handleMargins
                    x: thinBackground.leftValues[index] * root.effectiveDraggingWidth + leftMargin + (index > 0 ? leftPadding : 0)
                    width: thinBackground.leftWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === thinBackground.leftWidths.length - 1 ? handleWidth / 2 : 0) + (index === 0 ? leftPadding : 0)
                    height: root.trackWidth
                    active: !root.wavy
                    sourceComponent: Rectangle {
                        color: root.highlightColor
                        topLeftRadius: index === 0 ? root.trackRadius : root.unsharpenRadius
                        bottomLeftRadius: index === 0 ? root.trackRadius : root.unsharpenRadius
                        topRightRadius: root.unsharpenRadius
                        bottomRightRadius: root.unsharpenRadius
                    }
                }
            }

            Repeater {
                model: thinBackground.leftWidths.length

                Loader {
                    required property int index
                    anchors.verticalCenter: parent.verticalCenter
                    property real leftMargin: index > 0 ? root.dividerMargins : 0
                    property real rightMargin: index < thinBackground.leftWidths.length - 1 ? root.dividerMargins : root.handleMargins
                    x: thinBackground.leftValues[index] * root.effectiveDraggingWidth + leftMargin + (index > 0 ? leftPadding : 0)
                    width: thinBackground.leftWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === thinBackground.leftWidths.length - 1 ? handleWidth / 2 : 0) + (index === 0 ? leftPadding : 0)
                    height: root.height
                    active: root.wavy
                    sourceComponent: WavyLine {
                        id: wavyFill
                        frequency: root.waveFrequency
                        fullLength: root.width
                        color: root.highlightColor
                        amplitudeMultiplier: root.wavy ? 0.5 : 0
                        width: parent.width
                        height: root.trackWidth
                        Connections {
                            target: root
                            function onValueChanged() { wavyFill.requestPaint(); }
                            function onHighlightColorChanged() { wavyFill.requestPaint(); }
                        }
                        FrameAnimation {
                            running: root.animateWave
                            onTriggered: {
                                wavyFill.requestPaint()
                            }
                        }
                    }
                }
            }

            // Fill right
            Repeater {
                model: thinBackground.rightWidths.length

                Rectangle {
                    required property int index
                    anchors.verticalCenter: parent.verticalCenter
                    property real leftMargin: index > 0 ? root.dividerMargins : root.handleMargins
                    property real rightMargin: index < thinBackground.rightWidths.length - 1 ? root.dividerMargins : 0
                    x: thinBackground.rightValues[index] * root.effectiveDraggingWidth + leftMargin + (index === 0 ? handleWidth / 2 : 0) + leftPadding
                    width: thinBackground.rightWidths[index] * root.effectiveDraggingWidth - leftMargin - rightMargin - (index === 0 ? handleWidth / 2 : 0) + (index === thinBackground.rightWidths.length - 1 ? rightPadding : 0)
                    height: trackWidth
                    color: root.trackColor
                    topRightRadius: index === thinBackground.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                    bottomRightRadius: index === thinBackground.rightWidths.length - 1 ? root.trackRadius : root.unsharpenRadius
                    topLeftRadius: root.unsharpenRadius
                    bottomLeftRadius: root.unsharpenRadius
                }
            }

            // Stop indicators
            Repeater {
                model: root.stopIndicatorValues
                TrackDot {
                    required property real modelData
                    value: modelData
                    anchors.verticalCenter: parent?.verticalCenter
                }
            }
        }
    }

    handle: Rectangle {
        id: handle
        visible: !root.isCapsule
        implicitWidth: root.handleWidth
        implicitHeight: root.handleHeight
        x: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2)
        anchors.verticalCenter: parent.verticalCenter
        radius: Appearance.rounding.full
        color: root.handleColor

        layer.enabled: !root.isCapsule
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.35)
            shadowVerticalOffset: 1.5
            shadowHorizontalOffset: 0
            shadowBlur: 0.3
        }

        StyledToolTip {
            extraVisibleCondition: !root.isCapsule && root.pressed
            text: root.tooltipContent
            font {
                family: Appearance.font.family.numbers
                variableAxes: Appearance.font.variableAxes.numbers
            }
        }
    }

    StyledToolTip {
        extraVisibleCondition: root.isCapsule && root.pressed
        text: root.tooltipContent
        font {
            family: Appearance.font.family.numbers
            variableAxes: Appearance.font.variableAxes.numbers
        }
    }
}
