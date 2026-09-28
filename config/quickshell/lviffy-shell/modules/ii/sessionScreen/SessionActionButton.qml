import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

RippleButton {
    id: button

    property string buttonIcon
    property string buttonText
    property bool keyboardDown: false
    property real size: 100

    // macOS logout buttons: frosted glass circle, macOS Blue on hover
    buttonRadius: size / 2  // always full circle
    border: true
    borderWidth: 1
    colBorder: Appearance.colors.colLayer0Border
    colBackground: button.keyboardDown ? Appearance.m3colors.m3primary :
        button.focus ? Appearance.m3colors.m3primary :
        Qt.rgba(
            Appearance.m3colors.m3surfaceContainerHigh.r,
            Appearance.m3colors.m3surfaceContainerHigh.g,
            Appearance.m3colors.m3surfaceContainerHigh.b,
            0.7
        )
    colBackgroundHover: Appearance.m3colors.m3primary
    colRipple: Qt.lighter(Appearance.m3colors.m3primary, 1.3)
    property color colText: (button.down || button.keyboardDown || button.focus || button.hovered) ?
        "#ffffff" : Qt.rgba(1, 1, 1, 0.9)

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    background.implicitHeight: size
    background.implicitWidth: size

    Behavior on buttonRadius {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = true
            button.clicked()
            event.accepted = true;
        }
    }
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = false
            event.accepted = true;
        }
    }

    contentItem: MaterialSymbol {
        id: icon
        anchors.fill: parent
        color: button.colText
        horizontalAlignment: Text.AlignHCenter
        iconSize: 38
        text: buttonIcon
    }

    StyledToolTip {
        text: buttonText
    }

}
