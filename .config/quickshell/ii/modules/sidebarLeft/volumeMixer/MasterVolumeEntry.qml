// MasterVolumeEntry.qml
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root
    property string uiLogMessage: "Initializing..."

    // ====================================================================
    // NEW: Add a property to easily toggle debug visuals
    // ====================================================================
    property bool showDebugBoundaries: true
    // ====================================================================

    // ... (Component.onCompleted and Connections blocks are unchanged)
    Component.onCompleted: {
        const initialVolume = Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume.toFixed(2) : "N/A";
        root.uiLogMessage = `Loaded. Vol: ${initialVolume}`;
        console.log(root.uiLogMessage);
    }
    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
        function onVolumeChanged() {
            const newVolume = Pipewire.defaultAudioSink.audio.volume.toFixed(2);
            root.uiLogMessage = `External Vol: ${newVolume}`;
            console.log(root.uiLogMessage);
        }
        function onMuteChanged() {
            const newMuteState = Pipewire.defaultAudioSink.audio.mute;
            root.uiLogMessage = `External Mute: ${newMuteState}`;
            console.log(root.uiLogMessage);
        }
    }

    implicitHeight: rowLayout.implicitHeight

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 6

        Item {
            id: iconWrapper
            // --- REMOVED --- We will set the size directly instead of using a layout hint.
            // Layout.preferredWidth: slider.height * 0.9
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            // --- ADDED --- Explicitly anchor the size of the wrapper to the icon.
            // This guarantees the wrapper (and thus the MouseArea) is the correct size.
            width: icon.implicitWidth
            height: icon.implicitHeight

            MaterialSymbol {
                id: icon // Give the icon an ID so we can reference it
                anchors.centerIn: parent // Center the icon within the wrapper
                
                text: (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.mute ``) ? "volume_off" : "volume_up"
                color: Appearance.colors.colSubtext
                font.pixelSize: 24
            }
            
            Rectangle {
                id: debugBoundary
                visible: false 
                anchors.fill: parent
                color: "transparent"
                border.width: 1
                border.color: "red"
            }
            
            MouseArea {
                anchors.fill: parent 
                cursorShape: Qt.PointingHandCursor 
                onClicked: {
                    // ... (onClicked logic is unchanged)
                    if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                        const before = Pipewire.defaultAudioSink.audio.mute;
                        Pipewire.defaultAudioSink.audio.mute = !before;
                        const after = Pipewire.defaultAudioSink.audio.mute;
                        root.uiLogMessage = `Mute Click! Before: ${before}, After: ${after}`;
                        console.log(root.uiLogMessage);
                    } else {
                        root.uiLogMessage = "ERROR: Cannot toggle mute, sink not found.";
                        console.log(root.uiLogMessage);
                    }
                }
            }
        }

        ColumnLayout {
            // ... (rest of the file is unchanged)
            Layout.fillWidth: true
            spacing: -4
            StyledText { text: Translation.tr("Master Volume") }
            StyledSlider {
                id: slider
                value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
                onMoved: {
                    if (Pipewire.defaultAudioSink) {
                        Pipewire.defaultAudioSink.audio.volume = value
                        root.uiLogMessage = `Slider set to: ${value.toFixed(2)}`;
                    }
                }
            }
            StyledText {
                Layout.fillWidth: true
                Layout.topMargin: 4
                text: root.uiLogMessage
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
                wrapMode: Text.WordWrap
            }
        }
    }
}