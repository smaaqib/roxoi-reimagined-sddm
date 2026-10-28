// Components/LoginForm.qml — ROXOI SDDM Theme

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: loginForm

    property alias clockVisibility: clock.visible
    property alias systemButtonVisibility: systemButtons.visible
    property bool failed: false
    property var stackView
    signal sessionChanged(int session)

    Connections {
        target: sddm
        function onLoginSucceeded() {
            loginForm.failed = false
        }
        function onLoginFailed() {
            loginForm.failed = true
            failedClearTimer.restart()
        }
    }

    Timer {
        id: failedClearTimer
        interval: 2000
        repeat:   false
        onTriggered: loginForm.failed = false
    }

    // All content centered vertically in the panel
    Column {
        id: content
        anchors.centerIn: parent
        width: parent.width - 32   // 16px padding each side (matches HTML padding: 16px)
        spacing: 10                // matches HTML gap: 10px

        // Avatar + Clock (Clock.qml contains avatar, greeting, time, date, sep)
        Clock {
            id: clock
            width: parent.width
        }

        // Input form (labels + fields + button)
        Input {
            id: inputForm
            width: parent.width
            failed: loginForm.failed

            onLoginRequest: {
                loginForm.failed = false
                failedClearTimer.stop()
                sddm.login(username, password, inputForm.currentSession)
            }

            exposeSession.onCurrentIndexChanged: {
                loginForm.sessionChanged(inputForm.currentSession)
            }
        }
        
        // System power buttons
        SystemButtons {
            id: systemButtons
            anchors.horizontalCenter: parent.horizontalCenter
            height: 100
        }

    }
}
