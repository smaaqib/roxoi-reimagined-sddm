// Components/UserList.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

ListView {
    id: userList
    orientation: ListView.Horizontal
    clip: true
    snapMode: ListView.SnapToItem

    delegate: Item {
        width: userList.width
        height: userList.height

        Column {
            anchors.centerIn: parent
            spacing: root.font.pointSize * 0.5

            Rectangle {
                id: avatarCircle
                anchors.horizontalCenter: parent.horizontalCenter
                width: root.font.pointSize * 5
                height: root.font.pointSize * 5
                radius: width / 2
                color: "#0a1a0d"
                border.color: "#ff2638"
                border.width: userList.currentIndex === index ? 2 : 1
                opacity: userList.currentIndex === index ? 1.0 : 0.5
                Behavior on opacity { NumberAnimation { duration: 200 } }

                Image {
                    anchors.centerIn: parent
                    source: "file:///" + model.icon
                    width: parent.width * 0.7
                    height: parent.height * 0.7
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: ColorOverlay { color: "#ff2638" }
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: model.name
                font.family: "Monospace"
                font.pointSize: root.font.pointSize * 0.8
                color: userList.currentIndex === index ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.55)
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: userList.currentIndex = index
        }
    }
}
