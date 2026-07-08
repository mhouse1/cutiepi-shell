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
        Component.onCompleted: mcuInfo.getVersion();

        Column {
            width: parent.width/2
            spacing: 10
            Text { text: "Firmware version: " + mcuInfo.version }
            Text { text: "Charging status: " + ( (mcuInfo.charge == 4) ? "true" : "false" ) }
            Text { text: "Measured voltage: " + (mcuInfo.battery/1000).toFixed(3);  }
            Text { text: "Accelerometer: " + accel.reading.x.toFixed(3) + ", " + accel.reading.y.toFixed(3) + ", " + accel.reading.z.toFixed(3) }

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
