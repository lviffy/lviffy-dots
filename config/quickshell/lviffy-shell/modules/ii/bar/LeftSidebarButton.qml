import QtQuick
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

RippleButton {
    id: root
    property bool showPing: false
    property bool vertical: Config.options.bar.vertical
    property bool aiChatEnabled: Config.options.policies.ai !== 0
    property bool translatorEnabled: Config.options.sidebar.translator.enable
    property bool isMaterial: Config.options.bar.cornerStyle === 3
    property real buttonPadding: 5

    visible: true

    implicitWidth: 28
    implicitHeight: 28

    buttonRadius: 6
    colBackground: "transparent"
    colBackgroundHover: Qt.rgba(1, 1, 1, 0.1)
    colRipple: Qt.rgba(1, 1, 1, 0.15)
    colBackgroundToggled: Qt.rgba(1, 1, 1, 0.12)
    colBackgroundToggledHover: Qt.rgba(1, 1, 1, 0.16)
    colRippleToggled: Qt.rgba(1, 1, 1, 0.2)
    toggled: GlobalStates.sidebarLeftOpen

    onPressed: {
        GlobalStates.sidebarLeftOpen = !GlobalStates.sidebarLeftOpen;
    }

    CustomIcon {
        id: distroIcon
        anchors.centerIn: parent
        width: 17
        height: 17
        source: Config.options.custom.distroIcon || "apple-symbolic.svg"
        colorize: true
        color: Appearance.colors.colOnLayer0

        Rectangle {
            opacity: root.showPing ? 1 : 0
            visible: opacity > 0
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -2
                rightMargin: -2
            }
            implicitWidth: 8
            implicitHeight: 8
            radius: Appearance.rounding.full
            color: Appearance.colors.colTertiary
            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
            }
        }
    }
}