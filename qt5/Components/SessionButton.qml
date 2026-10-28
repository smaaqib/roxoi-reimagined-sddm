// Components/SessionButton.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    id: sessionButton
    width: btnLabel.contentWidth + root.font.pointSize * 3
    height: root.font.pointSize * 2.5

    property int currentIndex: sessionModel.lastIndex
    signal sessionChanged(int session)

    function updateSession(idx) {
        currentIndex = idx
        sessionChanged(idx)
    }

    visible: sessionModel.rowCount() > 1

    Button {
        id: btn
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sessionPopup.open()

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 6
            Label {
                id: sessionIcon
                text: "⬡"
                font.family: "Monospace"
                font.pointSize: root.font.pointSize * 0.7
                color: btn.hovered ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.7)
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Label {
                id: btnLabel
                text: sessionModel.data(sessionModel.index(sessionButton.currentIndex, 0), Qt.DisplayRole) || "SESSION"
                font.family: "Monospace"
                font.pointSize: root.font.pointSize * 0.7
                color: btn.hovered ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.7)
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        background: Rectangle {
            color: "transparent"
            border.color: btn.hovered ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.3)
            border.width: 1
            radius: 8
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }
    }

    Popup {
        id: sessionPopup
        y: -implicitHeight - 4
        x: -sessionButton.width
        width: sessionButton.width * 3
        padding: 6

        contentItem: ListView {
            id: sessionList
            clip: true
            implicitHeight: contentHeight + 10
            model: sessionModel
            currentIndex: sessionButton.currentIndex
            delegate: ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: model.name
                    font.family: "Monospace"
                    font.pointSize: root.font.pointSize * 0.75
                    color: sessionList.currentIndex === index ? "#000" : "#ff2638"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 8
                }
                highlighted: sessionList.currentIndex === index
                background: Rectangle {
                    color: sessionList.currentIndex === index ? "#ff2638" : "transparent"
                    radius: 8
                }
                onClicked: {
                    sessionButton.updateSession(index)
                    sessionPopup.close()
                }
            }
        }

        background: Rectangle {
            color: "#0a1a0d"
            border.color: "#ff2638"
            border.width: 1
            radius: 8
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 4
                radius: 12
                samples: 25
                color: Qt.rgba(1, 0.05, 0.12, 0.35)
            }
        }

        enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 } }
        exit:  Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 } }
    }
}
