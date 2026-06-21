import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

Dialog {
    width: 360 
    height: 360 
    visible: false 
    signal wallpaperSelected(string fileName)
    modal: true
    property alias rotation: container.rotation
    Item {
        id: container
        anchors.fill: parent
        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            model: folderModel 
            delegate: Rectangle {
                width: 360 
                height: 30
                clip: true
                Text { text: fileName; font.pointSize: 8 }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { wallpaperSelected(folderModel.folder + fileName) }
                }
            }
        }
    }
    FolderListModel {
        id: folderModel
        nameFilters: ["*.jpg", "*.png"]
        folder: "file:///usr/share/rpd-wallpaper/"
        showDirs: false
    }
}