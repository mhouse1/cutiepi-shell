import QtQuick
import QtWebEngine

WebEngineView { 
    id: webView
    anchors.fill: parent
    anchors.topMargin: 85
    z: 2 

    signal openTab(string url)
    signal openNewTab(string url)

    profile: ((typeof(adblockProfile) !== "undefined") && 
        view.systemSettings.value("enableAdblocker", true)) ? adblockProfile : defaultProfile

    function updateProfile() {
        webView.profile = ((typeof(adblockProfile) !== "undefined") && 
        view.systemSettings.value("enableAdblocker", true)) ? adblockProfile : defaultProfile
    }

    WebEngineProfile {
        id: defaultProfile
        // Spoofed ChromeOS UA (Chrome/69, 2018) was getting Google Sign-In and other sites to
        // reject/block login outright - ported from cutiepi-shell master (db2026f/2359a61).
        // Leave unset so QtWebEngine sends its own real, current Chromium UA.
        //httpUserAgent: "Mozilla/5.0 (X11; CrOS armv7l 10895.56.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.102 Safari/537.36"
        offTheRecord: false
    }

    onNewWindowRequested: function(request) {
        if (!request.userInitiated) {
            console.log('block popup')
        } else if (request.destination === WebEngineNewWindowRequest.InNewTab) {
            openNewTab(request.requestedUrl)
        } else {
            openTab(request.requestedUrl)
        }
        console.log(JSON.stringify(request))
    }

    onContextMenuRequested: function(request) {
        //console.log(request.mediaUrl, request.mediaType);
        if (request.position.x !== 0 && String(request.mediaUrl).length !== 0) {
            contextMenu.linkUrl = request.mediaUrl
            contextMenu.x = request.position.x; contextMenu.y = request.position.y;
            contextMenu.visible = true
        }
	    request.accepted = true;
    }

    MouseArea { 
        id: webViewOverlay
        anchors.fill: parent 
        enabled: contextMenu.visible 
        z: 3 
        onClicked: { contextMenu.visible = false }
    }

    Rectangle { 
        id: contextMenu
        z: 4
        visible: false
        color: "#2E3440"
        width: 300
        height: 250
        property string linkUrl: ""
        MouseArea { anchors.fill: parent; onClicked: parent.visible = false }
        radius: 15
        Column { 
            anchors.fill: parent 
            spacing: 10
            Rectangle {
                width: parent.width
                height: 50 
                color: 'transparent'
                Text {
                    width: parent.width
                    text: contextMenu.linkUrl
                    wrapMode: Text.WrapAnywhere
                    color: "#ECEFF4" 
                    font.pointSize: 6
                    anchors { 
                        top: parent.top; left: parent.left; right: parent.right; 
                        margins: 20; topMargin: 10
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 50 
                color: 'transparent'
                Text {
                    anchors.centerIn: parent
                    text: "Open" 
                    color: "#ECEFF4" 
                    font.pointSize: 10 
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        contextMenu.visible = false 
                        webView.openTab(contextMenu.linkUrl);
                    }
                }
            }
            Rectangle {
                width: parent.width
                height: 50 
                color: 'transparent'
                Text {
                    anchors.centerIn: parent
                    text: "Open in New Tab" 
                    color: "#ECEFF4" 
                    font.pointSize: 10 
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        contextMenu.visible = false 
                        webView.openNewTab(contextMenu.linkUrl);
                    }
                }
            }
            Rectangle {
                width: parent.width
                height: 50 
                color: 'transparent'
                Text {
                    anchors.centerIn: parent
                    text: "Copy" 
                    color: "#ECEFF4" 
                    font.pointSize: 10 
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        contextMenu.visible = false 
                    }
                }
            }
        }
    }
}
