// Components/Clock.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Column {
    id: clock
    spacing: 6
    width: parent.width
    

    // Name + tagline under the logo
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family:    "Monospace"
        font.pointSize: root.font.pointSize * 3
        font.bold:      true
        color:          "#ff2638"
        opacity:        0.88
        text:           ""
        renderType:     Text.QtRendering
    }


    // Time display
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width:  timeLabel.width + 16
        height: timeLabel.height + 4

        Label {
            id: timeLabel
            anchors.centerIn: parent
            font.family:    "Monospace"
            font.pointSize: root.font.pointSize * 4.8
            font.weight:    Font.Bold
            color:          "#ff2638"
            renderType:     Text.QtRendering

            function updateTime() {
                text = new Date().toLocaleTimeString(
                    Qt.locale(config.Locale),
                    config.HourFormat == "long"
                        ? Locale.LongFormat
                        : config.HourFormat !== ""
                            ? config.HourFormat
                            : "HH:mm"
                )
            }
        }
    }

    // Date string
    Label {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font.family:    "Monospace"
        font.pointSize: root.font.pointSize * 0.90
        color:          "#ff2638"
        opacity: 0.90
        renderType:     Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleDateString(
                Qt.locale(config.Locale),
                config.DateFormat == "short"
                    ? Locale.ShortFormat
                    : config.DateFormat !== ""
                        ? config.DateFormat
                        : Locale.LongFormat
            ).toUpperCase()
        }
    }

    // Separator
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width:   parent.width * 0.60
        height:  1
        color:   "#ff2638"
        opacity: 0.25

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: true
            NumberAnimation { to: 0.10; duration: 3000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.40; duration: 3000; easing.type: Easing.InOutSine }
        }
    }

    Timer {
        interval: 1000; repeat: true; running: true
        onTriggered: { dateLabel.updateTime(); timeLabel.updateTime() }
    }

    Component.onCompleted: { dateLabel.updateTime(); timeLabel.updateTime() }
}
