pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

RowLayout {
    id: root
    spacing: 6
    property bool animateWidth: false
    property alias searchInput: searchInput
    property string searchingText

    function forceFocus() {
        searchInput.forceActiveFocus();
    }

    enum SearchPrefixType { Action, App, Clipboard, Emojis, Symbols, Math, ShellCommand, WebSearch, Keybinds, DefaultSearch }

    property var searchPrefixType: {
        if (root.searchingText.startsWith(Config.options.search.prefix.action)) return SearchBar.SearchPrefixType.Action;
        if (root.searchingText.startsWith(Config.options.search.prefix.app)) return SearchBar.SearchPrefixType.App;
        if (root.searchingText.startsWith(Config.options.search.prefix.clipboard)) return SearchBar.SearchPrefixType.Clipboard;
        if (root.searchingText.startsWith(Config.options.search.prefix.emojis)) return SearchBar.SearchPrefixType.Emojis;
        if (root.searchingText.startsWith(Config.options.search.prefix.symbols)) return SearchBar.SearchPrefixType.Symbols;
        if (root.searchingText.startsWith(Config.options.search.prefix.math)) return SearchBar.SearchPrefixType.Math;
        if (root.searchingText.startsWith(Config.options.search.prefix.shellCommand)) return SearchBar.SearchPrefixType.ShellCommand;
        if (root.searchingText.startsWith(Config.options.search.prefix.webSearch)) return SearchBar.SearchPrefixType.WebSearch;
        if (root.searchingText.startsWith(Config.options.search.prefix.keybinds ?? "<")) return SearchBar.SearchPrefixType.Keybinds;
        return SearchBar.SearchPrefixType.DefaultSearch;
    }
    
    MaterialSymbol {
        id: searchIcon
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 4
        iconSize: 22
        text: "search"
        color: Qt.rgba(1, 1, 1, 0.5)
    }
    ToolbarTextField { // Search box
        id: searchInput
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        implicitHeight: 40
        focus: GlobalStates.overviewOpen
        font.pixelSize: Appearance.font.pixelSize.normal
        font.family: Appearance.font.family.main
        placeholderText: Translation.tr("Spotlight Search")
        implicitWidth: root.searchingText == "" ? Appearance.sizes.searchWidthCollapsed : Appearance.sizes.searchWidth

        Behavior on implicitWidth {
            id: searchWidthBehavior
            enabled: root.animateWidth
            NumberAnimation {
                duration: 300
                easing.type: Appearance.animation.elementMove.type
                easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
            }
        }

        onTextChanged: LauncherSearch.query = text

        onAccepted: {
            if (appResults.count > 0) {
                // Get the first visible delegate and trigger its click
                let firstItem = appResults.itemAtIndex(0);
                if (firstItem && firstItem.clicked) {
                    firstItem.clicked();
                }
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Tab) {
                if (LauncherSearch.results.length === 0) return;
                const tabbedText = LauncherSearch.results[0].name;
                LauncherSearch.query = tabbedText;
                searchInput.text = tabbedText;
                event.accepted = true;
            }
        }
    }

    IconToolbarButton {
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        onClicked: {
            GlobalStates.overviewOpen = false;
            Quickshell.execDetached(["qs", "-p", Quickshell.shellPath(""), "ipc", "call", "region", "search"]);
        }
        text: "image_search"
        StyledToolTip {
            text: Translation.tr("Google Lens")
        }
    }

    IconToolbarButton {
        id: songRecButton
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        Layout.rightMargin: 4
        toggled: SongRec.running
        onClicked: SongRec.toggleRunning()
        text: "music_cast"

        StyledToolTip {
            text: Translation.tr("Recognize music")
        }

        colText: toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSurfaceVariant
        background: MaterialShape {
            RotationAnimation on rotation {
                running: songRecButton.toggled
                duration: 12000
                easing.type: Easing.Linear
                loops: Animation.Infinite
                from: 0
                to: 360
            }
            shape: {
                if (songRecButton.down) {
                    return songRecButton.toggled ? MaterialShape.Shape.Circle : MaterialShape.Shape.Square
                } else {
                    return songRecButton.toggled ? MaterialShape.Shape.SoftBurst : MaterialShape.Shape.Circle
                }
            }
            color: {
                if (songRecButton.toggled) {
                    return songRecButton.hovered ? Appearance.colors.colPrimaryHover : Appearance.colors.colPrimary
                } else {
                    return songRecButton.hovered ? Appearance.colors.colSurfaceContainerHigh : ColorUtils.transparentize(Appearance.colors.colSurfaceContainerHigh)
                }
            }
            Behavior on color {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }
        }
    }
}
