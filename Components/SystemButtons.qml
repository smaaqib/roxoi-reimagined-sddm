import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

RowLayout {
    id: powerRow
    spacing: root.font.pointSize * 0.8
    visible: config.ForceHideSystemButtons !== "true"

    property var suspend:   ["Suspend",   config.TranslateSuspend   || "SUSPEND",   sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || "HIBERNATE", sddm.canHibernate]
    property var reboot:    ["Reboot",    config.TranslateReboot    || "REBOOT",    sddm.canReboot]
    property var shutdown:  ["Shutdown",  config.TranslateShutdown  || "SHUTDOWN",  sddm.canPowerOff]

    Repeater {
        model: [powerRow.suspend, powerRow.hibernate, powerRow.reboot, powerRow.shutdown]

        Item {
            id: wrapper
            Layout.alignment: Qt.AlignHCenter
            implicitWidth:  root.font.pointSize * 4.6
            implicitHeight: root.font.pointSize * 4.6

            property bool isHovered: hov.containsMouse

            opacity: !modelData[2] ? 0.55 : isHovered ? 1.0 : 0.50
            Behavior on opacity { NumberAnimation { duration: 180 } }

            // Background
            Rectangle {
                anchors.fill: parent
                radius: 4
                color:        wrapper.isHovered ? "#006018" : "transparent"
                border.color: wrapper.isHovered ? "#005415" : Qt.rgba(1, 0.05, 0.12, 0.50)
                border.width: wrapper.isHovered ? 2 : 1
                Behavior on color        { ColorAnimation { duration: 140 } }
            }

            // SVG Icon
            Image {
                id: ico
                anchors.centerIn: parent
                width:  parent.width  * 0.50
                height: parent.height * 0.50
                sourceSize.width:  parent.width  * 0.50
                sourceSize.height: parent.height * 0.50
                source:   Qt.resolvedUrl("../Assets/" + modelData[0] + ".svgz")
                fillMode: Image.PreserveAspectFit
                mipmap:   true
                smooth:   true
                layer.enabled: true
                layer.effect: ColorOverlay {
                    color: wrapper.isHovered ? "#00f43d" : "#49ff77"
                    Behavior on color { ColorAnimation { duration: 140 } }
                }
            }

            // Label
            Text {
                anchors.top:              parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin:        root.font.pointSize * 0.25
                text:           modelData[1]
                font.family:    "Monospace"
                font.pointSize: root.font.pointSize * 0.62
                font.letterSpacing: 1.2
                color: wrapper.isHovered ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.85)
                Behavior on color { ColorAnimation { duration: 140 } }
            }

            // Hover + Click
            // Plain MouseArea — no Button involved, nothing can block it
            MouseArea {
                id: hov
                anchors.fill: parent
                hoverEnabled: true
                // enabled:      modelData[2]
                // cursorShape:  modelData[2] ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                enabled:      true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if      (index === 0) sddm.suspend()
                    else if (index === 1) sddm.hibernate()
                    else if (index === 2) sddm.reboot()
                    else                  sddm.powerOff()
                }
            }
        }
    }
}
