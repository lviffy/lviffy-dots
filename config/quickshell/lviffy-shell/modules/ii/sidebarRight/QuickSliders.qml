import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Rectangle {
    id: root

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    implicitWidth: contentItem.implicitWidth + root.horizontalPadding * 2
    implicitHeight: contentItem.implicitHeight + root.verticalPadding * 2
    radius: Appearance.rounding.large
    color: Appearance.colors.colLayer1
    border.width: 1
    border.color: Appearance.colors.colLayer0Border
    property real verticalPadding: 12
    property real horizontalPadding: 12

    Column {
        id: contentItem
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
            topMargin: root.verticalPadding
        }
        spacing: 12

        // Brightness / Display slider
        Loader {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: item ? item.implicitHeight : 0
            visible: active
            active: Config.options.sidebar.quickSliders.showBrightness
            sourceComponent: QuickSliderGroup {
                title: Translation.tr("Display")
                value: Hyprsunset.gamma === 100 
                    ? (0.3 + (root.brightnessMonitor?.brightness ?? 0) * 0.7) 
                    : ((Hyprsunset.gamma - Hyprsunset.gammaLowerLimit) / (100 - Hyprsunset.gammaLowerLimit) * 0.3)
                valueText: Hyprsunset.gamma === 100 
                    ? `${Math.round((root.brightnessMonitor?.brightness ?? 0) * 100)}%` 
                    : `${Translation.tr("Gamma")} ${Hyprsunset.gamma}%`
                iconName: value < 0.3 ? "wb_twilight" : "brightness_medium"
                onMoved: (val) => {
                    if (val >= 0.3) {
                        if (root.brightnessMonitor) root.brightnessMonitor.setBrightness((val - 0.3) / 0.7);
                        if (Hyprsunset.gamma !== 100) Hyprsunset.setGamma(100);
                    } else {
                        if (root.brightnessMonitor && root.brightnessMonitor.brightness !== 0) root.brightnessMonitor.setBrightness(0);
                        Hyprsunset.setGamma(val / 0.3 * (100 - Hyprsunset.gammaLowerLimit) + Hyprsunset.gammaLowerLimit);
                    }
                }
                onIconClicked: {
                    if (Hyprsunset.gamma !== 100) Hyprsunset.setGamma(100);
                }
            }
        }

        // Volume / Sound slider
        Loader {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: item ? item.implicitHeight : 0
            visible: active
            active: Config.options.sidebar.quickSliders.showVolume
            sourceComponent: QuickSliderGroup {
                title: Translation.tr("Sound")
                value: Audio.sink?.audio?.volume ?? 0
                valueText: Audio.sink?.audio?.muted 
                    ? Translation.tr("Muted") 
                    : `${Math.round((Audio.sink?.audio?.volume ?? 0) * 100)}%`
                iconName: Audio.sink?.audio?.muted ? "volume_off" 
                    : (value === 0 ? "volume_mute" 
                    : (value < 0.5 ? "volume_down" : "volume_up"))
                onMoved: (val) => {
                    if (Audio.sink?.audio) Audio.sink.audio.volume = val;
                }
                onIconClicked: {
                    if (Audio.sink?.audio) Audio.sink.audio.muted = !Audio.sink.audio.muted;
                }
            }
        }

        // Mic slider
        Loader {
            anchors {
                left: parent.left
                right: parent.right
            }
            height: item ? item.implicitHeight : 0
            visible: active
            active: Config.options.sidebar.quickSliders.showMic
            sourceComponent: QuickSliderGroup {
                title: Translation.tr("Microphone")
                value: Audio.source?.audio?.volume ?? 0
                valueText: Audio.source?.audio?.muted 
                    ? Translation.tr("Muted") 
                    : `${Math.round((Audio.source?.audio?.volume ?? 0) * 100)}%`
                iconName: Audio.source?.audio?.muted ? "mic_off" : "mic"
                onMoved: (val) => {
                    if (Audio.source?.audio) Audio.source.audio.volume = val;
                }
                onIconClicked: {
                    if (Audio.source?.audio) Audio.source.audio.muted = !Audio.source.audio.muted;
                }
            }
        }
    }

    component QuickSliderGroup: Column {
        id: sliderGroup
        required property string title
        required property string iconName
        property real value: 0
        property real from: 0
        property real to: 1
        property string valueText: `${Math.round(((value - from) / (to - from)) * 100)}%`
        signal moved(real val)
        signal iconClicked()

        spacing: 5
        anchors {
            left: parent?.left
            right: parent?.right
        }

        RowLayout {
            id: headerRow
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 2
                rightMargin: 2
            }
            StyledText {
                text: sliderGroup.title
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Font.DemiBold
                color: Appearance.colors.colOnLayer1
                opacity: 0.85
            }
            Item { Layout.fillWidth: true }
            StyledText {
                text: sliderGroup.valueText
                font.pixelSize: Appearance.font.pixelSize.smaller
                font.weight: Font.Medium
                color: Appearance.colors.colOnLayer1
                opacity: 0.60
            }
        }

        Item {
            id: sliderRowItem
            anchors {
                left: parent.left
                right: parent.right
            }
            implicitHeight: 32
            height: 32

            StyledSlider {
                id: slider
                anchors.fill: parent
                configuration: StyledSlider.Configuration.M
                from: sliderGroup.from
                to: sliderGroup.to
                value: sliderGroup.value
                highlightColor: "#ffffff"
                onMoved: sliderGroup.moved(value)
            }

            // Left icon inside capsule with dynamic contrast inversion
            MouseArea {
                id: iconArea
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                width: 22
                height: 22
                cursorShape: Qt.PointingHandCursor
                onClicked: sliderGroup.iconClicked()

                MaterialSymbol {
                    anchors.centerIn: parent
                    iconSize: 18
                    text: sliderGroup.iconName
                    color: (slider.visualPosition * slider.width > 28) ? "#1D1D1F" : "#FFFFFF"

                    Behavior on color {
                        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                    }
                }
            }
        }
    }
}
