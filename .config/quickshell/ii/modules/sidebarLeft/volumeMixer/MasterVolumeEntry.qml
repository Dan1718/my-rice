// MasterVolumeEntry.qml
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    // --- DEBUGGING 1: Check the initial value when the component is created ---
    Component.onCompleted: {
        console.log("MasterVolumeEntry Loaded. Initial volume:", Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : "No Sink Found");
    }

    // --- DEBUGGING 2: React to external volume changes (e.g., media keys) ---
    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
        function onVolumeChanged() {
            console.log("External volume change detected! New volume:", Pipewire.defaultAudioSink.audio.volume)
        }
    }

    implicitHeight: rowLayout.implicitHeight

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 6

        MaterialSymbol {
            Layout.preferredWidth: slider.height * 0.9
            // ... (rest of the icon is the same)
            text: "volume_up"
            color: Appearance.colors.colSubtext
            font.pixelSize: 24
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -4

            StyledText {
                // ... (Master Volume text is the same)
                text: Translation.tr("Master Volume")
            }

            StyledSlider {
                id: slider
                value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
                
                onMoved: {
                    if (Pipewire.defaultAudioSink) {
                        Pipewire.defaultAudioSink.audio.volume = value
                    }
                }
            }


        }
    }
}