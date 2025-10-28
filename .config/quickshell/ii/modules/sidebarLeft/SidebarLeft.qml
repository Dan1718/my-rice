import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import "./quickToggles/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property int sidebarWidth: Appearance.sizes.sidebarWidth
    property int sidebarPadding: 12
    property string settingsQmlPath: Quickshell.shellPath("settings.qml")

    PanelWindow {
        id: sidebarRoot
        // Changed to control the visibility of the left sidebar
        visible: GlobalStates.sidebarLeftOpen

        function hide() {
            // Changed to control the visibility of the left sidebar
            GlobalStates.sidebarLeftOpen = false
        }

        exclusiveZone: 0
        implicitWidth: sidebarWidth
        // Changed namespace for the left sidebar
        WlrLayershell.namespace: "quickshell:sidebarLeft"
        // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        color: "transparent"

        // Changed anchors to position the window on the left
        anchors {
            top: true
            left: true // Changed from 'right' to 'left'
            bottom: true
        }

        HyprlandFocusGrab {
            id: grab
            windows: [ sidebarRoot ]
            // Changed to activate based on the left sidebar's state
            active: GlobalStates.sidebarLeftOpen
            onCleared: () => {
                if (!active) sidebarRoot.hide()
            }
        }

        Loader {
            id: sidebarContentLoader
            // Changed to load based on the left sidebar's state
            active: GlobalStates.sidebarLeftOpen || Config?.options.sidebar.keepLeftSidebarLoaded
            anchors {
                fill: parent
                margins: Appearance.sizes.hyprlandGapsOut
                // Changed to apply elevation margin on the right, as the panel is on the left
                rightMargin: Appearance.sizes.elevationMargin
            }
            width: sidebarWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
            height: parent.height - Appearance.sizes.hyprlandGapsOut * 2

            focus: GlobalStates.sidebarLeftOpen
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
                    sidebarRoot.hide();
                }
            }

            sourceComponent: Item {
                implicitHeight: sidebarLeftBackground.implicitHeight
                implicitWidth: sidebarLeftBackground.implicitWidth

                StyledRectangularShadow {
                    // Changed target to the renamed background element
                    target: sidebarLeftBackground
                }
                Rectangle {
                    // Renamed id for clarity
                    id: sidebarLeftBackground

                    anchors.fill: parent
                    implicitHeight: parent.height - Appearance.sizes.hyprlandGapsOut * 2
                    implicitWidth: sidebarWidth - Appearance.sizes.hyprlandGapsOut * 2
                    color: Appearance.colors.colLayer0
                    border.width: 1
                    border.color: Appearance.colors.colLayer0Border
                    radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: sidebarPadding
                        spacing: sidebarPadding

                        RowLayout {
                            Layout.fillHeight: false
                            spacing: 10
                            Layout.margins: 10
                            Layout.topMargin: 5
                            Layout.bottomMargin: 0

                            CustomIcon {
                                id: distroIcon
                                width: 25
                                height: 25
                                source: SystemInfo.distroIcon
                                colorize: true
                                color: Appearance.colors.colOnLayer0
                            }

                            StyledText {
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colOnLayer0
                                text: Translation.tr("Up %1").arg(DateTime.uptime)
                                textFormat: Text.MarkdownText
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            ButtonGroup {
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "restart_alt"
                                    onClicked: {
                                        Hyprland.dispatch("reload")
                                        Quickshell.reload(true)
                                    }
                                    StyledToolTip {
                                        content: Translation.tr("Reload Hyprland & Quickshell")
                                    }
                                }
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "settings"
                                    onClicked: {
                                        // Changed to close the left sidebar
                                        GlobalStates.sidebarLeftOpen = false
                                        Quickshell.execDetached(["qs", "-p", root.settingsQmlPath])
                                    }
                                    StyledToolTip {
                                        content: Translation.tr("Settings")
                                    }
                                }
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "power_settings_new"
                                    onClicked: {
                                        GlobalStates.sessionOpen = true
                                    }
                                    StyledToolTip {
                                        content: Translation.tr("Session")
                                    }
                                }
                            }
                        }

                        ButtonGroup {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 5
                            padding: 5
                            color: Appearance.colors.colLayer1

                            NetworkToggle {}
                            BluetoothToggle {}
                            NightLight {}

                            IdleInhibitor {}
                        }

                        // Center widget group
                        CenterWidgetGroup {
                            focus: sidebarRoot.visible
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }
/*
                        BottomWidgetGroup {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            Layout.preferredHeight: implicitHeight
                        }
                        */
                    }
                }
            }
        }
    }

    IpcHandler {
        // Changed target for IPC calls
        target: "sidebarLeft"

        function toggle(): void {
            GlobalStates.sidebarLeftOpen = !GlobalStates.sidebarLeftOpen;
            if(GlobalStates.sidebarLeftOpen) Notifications.timeoutAll();
        }

        function close(): void {
            GlobalStates.sidebarLeftOpen = false;
        }

        function open(): void {
            GlobalStates.sidebarLeftOpen = true;
            Notifications.timeoutAll();
        }
    }

    // --- Renamed Global Shortcuts ---
    GlobalShortcut {
        name: "sidebarLeftToggle"
        description: "Toggles left sidebar on press"

        onPressed: {
            GlobalStates.sidebarLeftOpen = !GlobalStates.sidebarLeftOpen;
            if(GlobalStates.sidebarLeftOpen) Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "sidebarLeftOpen"
        description: "Opens left sidebar on press"

        onPressed: {
            GlobalStates.sidebarLeftOpen = true;
            Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "sidebarLeftClose"
        description: "Closes left sidebar on press"

        onPressed: {
            GlobalStates.sidebarLeftOpen = false;
        }
    }
}
