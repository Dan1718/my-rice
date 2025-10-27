// QuickSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// This ScrollView ensures your content is scrollable if it gets too long
ScrollView {
    clip: true
    width: parent.width
    height: parent.height
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
        width: parent.width
        spacing: 15

        // --- Power Menu Section ---
        SectionHeader { text: Translation.tr("Power") }
        GridLayout {
            columns: 3
            Layout.fillWidth: true
            columnSpacing: 10
            rowSpacing: 10

            PowerButton {
                buttonIcon: "lock"
                buttonText: Translation.tr("Lock")
                onClicked: { /* Quickshell.exec("hyprlock") */ }
            }
            PowerButton {
                buttonIcon: "logout"
                buttonText: Translation.tr("Logout")
                onClicked: { /* Hyprland.dispatch("exit") */ }
            }
            PowerButton {
                buttonIcon: "dark_mode" // Using this icon for sleep
                buttonText: Translation.tr("Sleep")
                onClicked: { /* Quickshell.exec("systemctl suspend") */ }
            }
            PowerButton {
                buttonIcon: "restart_alt"
                buttonText: Translation.tr("Reboot")
                onClicked: { /* Quickshell.exec("systemctl reboot") */ }
            }
            PowerButton {
                buttonIcon: "power_settings_new"
                buttonText: Translation.tr("Shutdown")
                onClicked: { /* Quickshell.exec("systemctl poweroff") */ }
            }
        }
        
        // --- Connectivity Section ---
        SectionHeader { text: Translation.tr("Connectivity") }
        SettingRow {
            icon: "wifi"
            text: Translation.tr("Wi-Fi")
            Switch {
                // checked: someWifiState
                // onToggled: toggleWifi()
            }
        }
        SettingRow {
            icon: "bluetooth"
            text: Translation.tr("Bluetooth")
            Switch {
                // checked: someBluetoothState
                // onToggled: toggleBluetooth()
            }
        }

        // --- Sliders Section ---
        SectionHeader { text: Translation.tr("Hardware") }
        SliderRow {
            icon: "brightness_medium"
            // value: currentBrightness
            // onValueChanged: setBrightness(value)
        }
        SliderRow {
            icon: "volume_up"
            // value: currentVolume
            // onValueChanged: setVolume(value)
        }
        SliderRow {
            icon: "mic"
            // value: currentMicVolume
            // onValueChanged: setMicVolume(value)
        }
        
        // --- Other Toggles ---
        SectionHeader { text: Translation.tr("Modes") }
        SettingRow {
            icon: "nightlight"
            text: Translation.tr("Night Light")
            Switch {}
        }
        SettingRow {
            icon: "notifications_off"
            text: Translation.tr("Do Not Disturb")
            Switch {}
        }
    }
}

// --- Helper Components (can be in the same file or separate files) ---

component SectionHeader: Label {
    font.pixelSize: Appearance.font.pixelSize.small
    font.weight: Font.Bold
    color: Appearance.colors.colOnLayer1
    text: "Section"
    topPadding: 10
    bottomPadding: 5
}

component SettingRow: RowLayout {
    property string icon: "settings"
    property string text: "Setting"
    
    Layout.fillWidth: true
    spacing: 15

    CustomIcon {
        source: parent.icon
        width: 22
        height: 22
        color: Appearance.colors.colOnLayer1
    }
    StyledText {
        text: parent.text
        Layout.fillWidth: true
    }
    // The Switch or other control is added as a child where this is used
}

component SliderRow: RowLayout {
    property string icon: "tune"
    property real value: 0.5
    signal valueChanged(real value)

    Layout.fillWidth: true
    spacing: 15
    
    CustomIcon {
        source: parent.icon
        width: 22
        height: 22
        color: Appearance.colors.colOnLayer1
    }
    Slider {
        from: 0.0
        to: 1.0
        value: parent.value
        Layout.fillWidth: true
        onValueChanged: parent.valueChanged(value)
    }
}

component PowerButton: Button {
    property string buttonIcon: "power_settings_new"
    property string buttonText: "Action"

    Layout.fillWidth: true
    text: buttonText
    icon.name: buttonIcon
    icon.color: Appearance.colors.colOnLayer1

    background: Rectangle {
        color: parent.hovered ? Qt.lighter(Appearance.colors.colLayer2, 1.1) : Appearance.colors.colLayer2
        radius: Appearance.rounding.small
    }
}
