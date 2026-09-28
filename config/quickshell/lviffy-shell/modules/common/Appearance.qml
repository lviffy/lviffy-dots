import QtQuick
import Quickshell
import qs.modules.common.functions
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property QtObject m3colors
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    property string syntaxHighlightingTheme

    // Transparency. The quadratic functions were derived from analysis of hand-picked transparency values.
    ColorQuantizer {
        id: wallColorQuant
        property string wallpaperPath: Config.options.background.wallpaperPath
        property bool wallpaperIsVideo: wallpaperPath.endsWith(".mp4") || wallpaperPath.endsWith(".webm") || wallpaperPath.endsWith(".mkv") || wallpaperPath.endsWith(".avi") || wallpaperPath.endsWith(".mov")
        source: Qt.resolvedUrl(wallpaperIsVideo ? Config.options.background.thumbnailPath : Config.options.background.wallpaperPath)
        depth: 0 // 2^0 = 1 color
        rescaleSize: 10
    }
    property real wallpaperVibrancy: (wallColorQuant.colors[0]?.hslSaturation + wallColorQuant.colors[0]?.hslLightness) / 2
    property real autoBackgroundTransparency: { // y = 0.5768x^2 - 0.759x + 0.2896
        let x = wallpaperVibrancy
        let y = 0.5768 * (x * x) - 0.759 * (x) + 0.2896
        return Math.max(0, Math.min(0.22, y)) - 0.12 * (m3colors.darkmode ? 0 : 1)
    }
    property real autoContentTransparency: 0.9
    property real backgroundTransparency: Config?.options.appearance.transparency.enable ? Config?.options.appearance.transparency.automatic ? autoBackgroundTransparency : Config?.options.appearance.transparency.backgroundTransparency : 0
    property real contentTransparency: Config?.options.appearance.transparency.automatic ? autoContentTransparency : Config?.options.appearance.transparency.contentTransparency

    m3colors: QtObject {
        property bool darkmode: true
        property bool transparent: false
        // macOS Ventura-inspired dark palette
        property color m3background: "#1c1c1e"
        property color m3onBackground: "#f2f2f7"
        property color m3surface: "#1c1c1e"
        property color m3surfaceDim: "#111113"
        property color m3surfaceBright: "#3a3a3c"
        property color m3surfaceContainerLowest: "#0d0d0f"
        property color m3surfaceContainerLow: "#242426"
        property color m3surfaceContainer: "#2c2c2e"
        property color m3surfaceContainerHigh: "#3a3a3c"
        property color m3surfaceContainerHighest: "#48484a"
        property color m3onSurface: "#f2f2f7"
        property color m3surfaceVariant: "#48484a"
        property color m3onSurfaceVariant: "#aeaeb2"
        property color m3inverseSurface: "#f2f2f7"
        property color m3inverseOnSurface: "#1c1c1e"
        property color m3outline: "#636366"
        property color m3outlineVariant: "#3a3a3c"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#0a84ff"
        // macOS Blue accent
        property color m3primary: "#0a84ff"
        property color m3onPrimary: "#ffffff"
        property color m3primaryContainer: "#0a4a8a"
        property color m3onPrimaryContainer: "#cce4ff"
        property color m3inversePrimary: "#0055cc"
        property color m3secondary: "#636366"
        property color m3onSecondary: "#f2f2f7"
        property color m3secondaryContainer: "#3a3a3c"
        property color m3onSecondaryContainer: "#aeaeb2"
        property color m3tertiary: "#30d158"
        property color m3onTertiary: "#ffffff"
        property color m3tertiaryContainer: "#1a4a28"
        property color m3onTertiaryContainer: "#b8f5c8"
        property color m3error: "#ff453a"
        property color m3onError: "#ffffff"
        property color m3errorContainer: "#7a1f1a"
        property color m3onErrorContainer: "#ffd6d3"
        property color m3primaryFixed: "#cce4ff"
        property color m3primaryFixedDim: "#0a84ff"
        property color m3onPrimaryFixed: "#001733"
        property color m3onPrimaryFixedVariant: "#0055cc"
        property color m3secondaryFixed: "#c7c7cc"
        property color m3secondaryFixedDim: "#8e8e93"
        property color m3onSecondaryFixed: "#1c1c1e"
        property color m3onSecondaryFixedVariant: "#48484a"
        property color m3tertiaryFixed: "#b8f5c8"
        property color m3tertiaryFixedDim: "#30d158"
        property color m3onTertiaryFixed: "#0a1f12"
        property color m3onTertiaryFixedVariant: "#1a4a28"
        property color m3success: "#30d158"
        property color m3onSuccess: "#ffffff"
        property color m3successContainer: "#1a4a28"
        property color m3onSuccessContainer: "#b8f5c8"
        property color term0: "#f2f2f7"
        property color term1: "#ff453a"
        property color term2: "#30d158"
        property color term3: "#ffd60a"
        property color term4: "#0a84ff"
        property color term5: "#bf5af2"
        property color term6: "#32ade6"
        property color term7: "#aeaeb2"
        property color term8: "#636366"
        property color term9: "#ff6961"
        property color term10: "#4cd964"
        property color term11: "#ffd60a"
        property color term12: "#409cff"
        property color term13: "#da8fff"
        property color term14: "#70d7ff"
        property color term15: "#f2f2f7"
    }

    colors: QtObject {
        property color colSubtext: m3colors.m3outline
        // macOS Liquid Glass Layer 0
        property color colLayer0Base: ColorUtils.mix(m3colors.m3background, m3colors.m3primary, Config.options.appearance.extraBackgroundTint ? 0.99 : 1)
        property color colLayer0: Qt.rgba(colLayer0Base.r, colLayer0Base.g, colLayer0Base.b, m3colors.darkmode ? 0.65 : 0.72)
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Hover: Qt.rgba(1, 1, 1, 0.08)
        property color colLayer0Active: Qt.rgba(1, 1, 1, 0.14)
        // 1px macOS Specular Light Rim
        property color colLayer0Border: Qt.rgba(1.0, 1.0, 1.0, m3colors.darkmode ? 0.18 : 0.45)
        // macOS Liquid Glass Layer 1
        property color colLayer1Base: m3colors.m3surfaceContainerLow
        property color colLayer1: Qt.rgba(m3colors.m3surfaceContainerLow.r, m3colors.m3surfaceContainerLow.g, m3colors.m3surfaceContainerLow.b, m3colors.darkmode ? 0.60 : 0.68)
        property color colOnLayer1: m3colors.m3onSurfaceVariant;
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45);
        property color colLayer1Hover: Qt.rgba(1, 1, 1, 0.09)
        property color colLayer1Active: Qt.rgba(1, 1, 1, 0.16)
        // macOS Liquid Glass Layer 2
        property color colLayer2Base: m3colors.m3surfaceContainer
        property color colLayer2: Qt.rgba(m3colors.m3surfaceContainer.r, m3colors.m3surfaceContainer.g, m3colors.m3surfaceContainer.b, m3colors.darkmode ? 0.68 : 0.75)
        property color colLayer2Hover: Qt.rgba(1, 1, 1, 0.10)
        property color colLayer2Active: Qt.rgba(1, 1, 1, 0.18)
        property color colLayer2Disabled: ColorUtils.mix(colLayer2, m3colors.m3background, 0.8);
        property color colOnLayer2: m3colors.m3onSurface;
        property color colOnLayer2Disabled: ColorUtils.mix(colOnLayer2, m3colors.m3background, 0.4);
        // macOS Liquid Glass Layer 3
        property color colLayer3Base: m3colors.m3surfaceContainerHigh
        property color colLayer3: Qt.rgba(m3colors.m3surfaceContainerHigh.r, m3colors.m3surfaceContainerHigh.g, m3colors.m3surfaceContainerHigh.b, m3colors.darkmode ? 0.75 : 0.82)
        property color colLayer3Hover: Qt.rgba(1, 1, 1, 0.12)
        property color colLayer3Active: Qt.rgba(1, 1, 1, 0.20)
        property color colOnLayer3: m3colors.m3onSurface;
        // macOS Liquid Glass Layer 4
        property color colLayer4Base: m3colors.m3surfaceContainerHighest
        property color colLayer4: Qt.rgba(m3colors.m3surfaceContainerHighest.r, m3colors.m3surfaceContainerHighest.g, m3colors.m3surfaceContainerHighest.b, m3colors.darkmode ? 0.82 : 0.88)
        property color colLayer4Hover: Qt.rgba(1, 1, 1, 0.14)
        property color colLayer4Active: Qt.rgba(1, 1, 1, 0.22)
        property color colOnLayer4: m3colors.m3onSurface;
        // Primary
        property color colPrimary: m3colors.m3primary
        property color colOnPrimary: m3colors.m3onPrimary
        property color colPrimaryHover: ColorUtils.mix(colors.colPrimary, colLayer1Hover, 0.87)
        property color colPrimaryActive: ColorUtils.mix(colors.colPrimary, colLayer1Active, 0.7)
        property color colPrimaryContainer: m3colors.m3primaryContainer
        property color colPrimaryContainerHover: ColorUtils.mix(colors.colPrimaryContainer, colors.colOnPrimaryContainer, 0.9)
        property color colPrimaryContainerActive: ColorUtils.mix(colors.colPrimaryContainer, colors.colOnPrimaryContainer, 0.8)
        property color colOnPrimaryContainer: m3colors.m3onPrimaryContainer
        // Secondary
        property color colSecondary: m3colors.m3secondary
        property color colSecondaryHover: ColorUtils.mix(m3colors.m3secondary, colLayer1Hover, 0.85)
        property color colSecondaryActive: ColorUtils.mix(m3colors.m3secondary, colLayer1Active, 0.4)
        property color colOnSecondary: m3colors.m3onSecondary
        property color colSecondaryContainer: m3colors.m3secondaryContainer
        property color colSecondaryContainerHover: ColorUtils.mix(m3colors.m3secondaryContainer, m3colors.m3onSecondaryContainer, 0.90)
        property color colSecondaryContainerActive: ColorUtils.mix(m3colors.m3secondaryContainer, m3colors.m3onSecondaryContainer, 0.54)
        property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
        // Tertiary
        property color colTertiary: m3colors.m3tertiary
        property color colTertiaryHover: ColorUtils.mix(m3colors.m3tertiary, colLayer1Hover, 0.85)
        property color colTertiaryActive: ColorUtils.mix(m3colors.m3tertiary, colLayer1Active, 0.4)
        property color colTertiaryContainer: m3colors.m3tertiaryContainer
        property color colTertiaryContainerHover: ColorUtils.mix(m3colors.m3tertiaryContainer, m3colors.m3onTertiaryContainer, 0.90)
        property color colTertiaryContainerActive: ColorUtils.mix(m3colors.m3tertiaryContainer, colLayer1Active, 0.54)
        property color colOnTertiary: m3colors.m3onTertiary
        property color colOnTertiaryContainer: m3colors.m3onTertiaryContainer
        // Surface
        property color colBackgroundSurfaceContainer: ColorUtils.transparentize(m3colors.m3surfaceContainer, root.backgroundTransparency)
        property color colSurfaceContainerLow: ColorUtils.solveOverlayColor(m3colors.m3background, m3colors.m3surfaceContainerLow, 1 - root.contentTransparency)
        property color colSurfaceContainer: ColorUtils.solveOverlayColor(m3colors.m3surfaceContainerLow, m3colors.m3surfaceContainer, 1 - root.contentTransparency)
        property color colSurfaceContainerHigh: ColorUtils.solveOverlayColor(m3colors.m3surfaceContainer, m3colors.m3surfaceContainerHigh, 1 - root.contentTransparency)
        property color colSurfaceContainerHighest: ColorUtils.solveOverlayColor(m3colors.m3surfaceContainerHigh, m3colors.m3surfaceContainerHighest, 1 - root.contentTransparency)
        property color colSurfaceContainerHighestHover: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.95)
        property color colSurfaceContainerHighestActive: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.85)
        property color colOnSurface: m3colors.m3onSurface
        property color colOnSurfaceVariant: m3colors.m3onSurfaceVariant
        // Misc
        property color colTooltip: m3colors.m3inverseSurface
        property color colOnTooltip: m3colors.m3inverseOnSurface
        property color colScrim: ColorUtils.transparentize(m3colors.m3scrim, 0.5)
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
        property color colOutline: m3colors.m3outline
        property color colOutlineVariant: m3colors.m3outlineVariant
        property color colError: m3colors.m3error
        property color colErrorHover: ColorUtils.mix(m3colors.m3error, colLayer1Hover, 0.85)
        property color colErrorActive: ColorUtils.mix(m3colors.m3error, colLayer1Active, 0.7)
        property color colOnError: m3colors.m3onError
        property color colErrorContainer: m3colors.m3errorContainer
        property color colErrorContainerHover: ColorUtils.mix(m3colors.m3errorContainer, m3colors.m3onErrorContainer, 0.90)
        property color colErrorContainerActive: ColorUtils.mix(m3colors.m3errorContainer, m3colors.m3onErrorContainer, 0.70)
        property color colOnErrorContainer: m3colors.m3onErrorContainer
    }

    rounding: QtObject {
        property int unsharpen: 1
        property int unsharpenmore: 3
        property int verysmall: 6
        property int small: 10
        property int normal: 14
        property int large: 18
        property int verylarge: 24
        property int full: 9999
        property int screenRounding: 14
        property int windowRounding: 16
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Config.options.appearance.fonts.main
            property string numbers: Config.options.appearance.fonts.numbers
            property string title: Config.options.appearance.fonts.title
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: Config.options.appearance.fonts.iconNerd
            property string monospace: Config.options.appearance.fonts.monospace
            property string reading: Config.options.appearance.fonts.reading
            property string expressive: Config.options.appearance.fonts.expressive
        }
        property QtObject variableAxes: QtObject {
            property var main: ({})
            property var numbers: ({})
            property var title: ({})
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 11
            property int smallie: 12
            property int small: 13
            property int normal: 14
            property int large: 15
            property int larger: 17
            property int huge: 20
            property int hugeass: 22
            property int title: huge
        }
    }

    animationCurves: QtObject {
        // macOS uses fast, smooth, non-springy curves
        readonly property list<real> expressiveFastSpatial: [0.25, 0.46, 0.45, 0.94, 1, 1]   // 180ms
        readonly property list<real> expressiveDefaultSpatial: [0.25, 0.46, 0.45, 0.94, 1, 1] // 250ms
        readonly property list<real> expressiveSlowSpatial: [0.23, 1.0, 0.32, 1.0, 1, 1]      // 380ms
        readonly property list<real> expressiveEffects: [0.22, 1.0, 0.36, 1.0, 1, 1]          // 160ms
        readonly property list<real> emphasized: [0.05, 0, 0.15, 0.05, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 0.15, 0.05]
        readonly property list<real> emphasizedLastHalf: [0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.25, 0.46, 0.45, 0.94, 1, 1]
        readonly property list<real> standardAccel: [0.55, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0.2, 1, 1, 1]
        // macOS animation durations — fast and decisive
        readonly property real expressiveFastSpatialDuration: 180
        readonly property real expressiveDefaultSpatialDuration: 250
        readonly property real expressiveSlowSpatialDuration: 380
        readonly property real expressiveEffectsDuration: 160
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

        property QtObject elementMoveSmall: QtObject {
            property int duration: animationCurves.expressiveFastSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveFastSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveSmall.duration
                    easing.type: root.animation.elementMoveSmall.type
                    easing.bezierCurve: root.animation.elementMoveSmall.bezierCurve
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                alwaysRunToEnd: true
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }

        property QtObject elementResize: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasized
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementResize.duration
                    easing.type: root.animation.elementResize.type
                    easing.bezierCurve: root.animation.elementResize.bezierCurve
                }
            }
        }

        property QtObject clickBounce: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 850
            property Component numberAnimation: Component { NumberAnimation {
                alwaysRunToEnd: true
                duration: root.animation.clickBounce.duration
                easing.type: root.animation.clickBounce.type
                easing.bezierCurve: root.animation.clickBounce.bezierCurve
            }}
        }
        
        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.standardDecel
        }

        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }

        property QtObject sidebarSlideEnter: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.sidebarSlideEnter.duration
                    easing.type: root.animation.sidebarSlideEnter.type
                    easing.bezierCurve: root.animation.sidebarSlideEnter.bezierCurve
                }
            }
        }

        property QtObject sidebarSlideExit: QtObject {
            property int duration: 250
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.sidebarSlideExit.duration
                    easing.type: root.animation.sidebarSlideExit.type
                    easing.bezierCurve: root.animation.sidebarSlideExit.bezierCurve
                }
            }
        }
    }

    

    sizes: QtObject {
        property real baseBarHeight: 28  // macOS menubar height
        property real barHeight: Config.options.bar.cornerStyle === 1 ? 
            (baseBarHeight + root.sizes.hyprlandGapsOut * 2) : baseBarHeight
        property real barCenterSideModuleWidth: Config.options?.bar.verbose ? 320 : 120
        property real barCenterSideModuleWidthShortened: 240
        property real barCenterSideModuleWidthHellaShortened: 160
        property real barShortenScreenWidthThreshold: 1200 // Shorten if screen width is at most this value
        property real barHellaShortenScreenWidthThreshold: 1000 // Shorten even more...
        property real elevationMargin: 8
        property real fabShadowRadius: 4
        property real fabHoveredShadowRadius: 6
        property real hyprlandGapsOut: 5
        property real mediaControlsWidth: 420
        property real mediaControlsHeight: 150
        property real notificationPopupWidth: 380
        property real osdWidth: 160
        property real searchWidthCollapsed: 200
        property real searchWidth: 340
        property real sidebarWidth: 440
        property real sidebarWidthExtended: 720
        property real baseVerticalBarWidth: 44
        property real verticalBarWidth: Config.options.bar.cornerStyle === 1 ? 
            (baseVerticalBarWidth + root.sizes.hyprlandGapsOut * 2) : baseVerticalBarWidth
        property real wallpaperSelectorWidth: 1200
        property real wallpaperSelectorHeight: 690
        property real wallpaperSelectorItemMargins: 8
        property real wallpaperSelectorItemPadding: 6
    }

    syntaxHighlightingTheme: root.m3colors.darkmode ? "Monokai" : "ayu Light"
}
