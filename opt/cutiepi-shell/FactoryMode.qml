import QtQuick
import QtMultimedia
import QtQuick.Controls

Rectangle {
    anchors.fill: parent
    color: 'lightgray'

    Row {
        anchors.fill: parent
        anchors.margins: 100
        spacing: 50
        // mcuInfo/accel are never registered as context properties on this board (no MCU or
        // accelerometer, unlike the original custom board this screen was written for) -
        // referencing them unconditionally threw ReferenceErrors that aborted the whole shell
        // on every single boot, since Factory Testing Mode used to auto-open unconditionally
        // (see shell.qml Component.onCompleted). Guarded the same way WebView.qml already
        // guards adblockProfile.
        Component.onCompleted: {
            if (typeof(mcuInfo) !== "undefined") mcuInfo.getVersion();
        }

        Column {
            width: parent.width/2
            spacing: 10
            Text { text: "Firmware version: " + ((typeof(mcuInfo) !== "undefined") ? mcuInfo.version : "N/A (no MCU on this board)") }
            Text { text: "Charging status: " + ((typeof(mcuInfo) !== "undefined") ? ((mcuInfo.charge == 4) ? "true" : "false") : "N/A (no MCU on this board)") }
            Text { text: "Measured voltage: " + ((typeof(mcuInfo) !== "undefined") ? (mcuInfo.battery/1000).toFixed(3) : "N/A (no MCU on this board)") }
            Text { text: "Accelerometer: " + ((typeof(accel) !== "undefined") ? (accel.reading.x.toFixed(3) + ", " + accel.reading.y.toFixed(3) + ", " + accel.reading.z.toFixed(3)) : "N/A (no accelerometer on this board)") }

            MediaPlayer {
                id: mediaplayer
                source: 'gst-pipeline: libcamerasrc ! video/x-raw,width=1920,height=1080,framerate=30/1 ! videoconvert ! qtvideosink'
                autoPlay: true
                videoOutput: cameraView
            }

            VideoOutput {
                id: cameraView
                width: 400; height: 300
            }

            // Mic test stubbed out - this board (Waveshare CM4-DUAL-ETH-4G/5G-BASE) has no
            // microphone hardware and isn't expected to gain one. hw:2,0 doesn't exist here.
            // Buttons disabled rather than left pointing at a nonexistent capture device.
            Row {
                spacing: 20;
                Text { text: "Microphone/Speaker: " }
                Button {
                    text: "N/A - no mic on this board"; enabled: false;
                }
            }
        }
    }
}
