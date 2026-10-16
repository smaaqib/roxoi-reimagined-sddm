// Components/Input.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Column {
    id: inputContainer
    spacing: 0
    width: parent.width

    property bool failed: false
    property alias exposeSession: sessionSelect
    signal loginRequest(string username, string password)
    property alias currentSession: sessionSelect.currentIndex

    // Hidden session selector
    ComboBox {
        id: sessionSelect
        visible: false
        model: sessionModel
        currentIndex: sessionModel.lastIndex
        textRole: "name"
    }

    // USERNAME label
    Item {
        height: root.font.pointSize * 2.0
        width:  parent.width
        Label {
            anchors.left:           parent.left
            anchors.verticalCenter: parent.verticalCenter
            text:           "[ USERNAME ]"
            font.family:    "Monospace"
            font.pointSize: root.font.pointSize * 1.10
            color:          "#ff2638"
            opacity:        0.60
        }
        

        SessionButton {
            height: root.font.pointSize * 2.1
            id: sessionPicker
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter   
            visible: sessionModel.rowCount() > 1
            onSessionChanged: function(idx) {
                inputForm.exposeSession.currentIndex = idx
                loginForm.sessionChanged(idx)
            }
        }
        
    }


    // Username row
    Item {
        id: usernameRow
        height: root.font.pointSize * 3.6
        width:  parent.width

        ComboBox {
            id: userCombo
            width:  parent.height
            height: parent.height
            anchors.left: parent.left
            z: 2

            property var popkey: config.ForceRightToLeft === "true" ? Qt.Key_Right : Qt.Key_Left
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Down && !popup.opened)
                    usernameField.forceActiveFocus()
                if ((event.key === Qt.Key_Up || event.key === popkey) && !popup.opened)
                    popup.open()
            }
            KeyNavigation.down:  usernameField
            KeyNavigation.right: usernameField
            model:        userModel
            currentIndex: model.lastIndex
            textRole:     "name"
            hoverEnabled: true
            onActivated:  usernameField.text = currentText

            delegate: ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text:                model.name
                    font.family:         "Monospace"
                    font.pointSize:      root.font.pointSize * 1.0
                    font.capitalization: Font.Capitalize
                    color:               userCombo.highlightedIndex === index ? "#000" : "#ff2638"
                    verticalAlignment:   Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                highlighted: parent.highlightedIndex === index
                background: Rectangle {
                    color:  userCombo.highlightedIndex === index ? "#ff2638" : "transparent"
                    radius: 2
                }
            }

            indicator: Button {
                id: userIcon
                width:  userCombo.height * 0.75
                height: parent.height
                anchors.left:           parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin:     userCombo.height * 0.12
                icon.height: parent.height * 0.32
                icon.width:  parent.height * 0.32
                enabled:     false
                icon.color:  "#ff2638"
                icon.source: Qt.resolvedUrl("../Assets/User.svgz")
            }

            background: Rectangle { color: "transparent"; border.color: "transparent" }

            popup: Popup {
                y:       parent.height
                width:   usernameRow.width
                padding: 8
                implicitHeight: contentItem.implicitHeight
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight + 16
                    model:        userCombo.popup.visible ? userCombo.delegateModel : null
                    currentIndex: userCombo.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator {}
                }
                background: Rectangle {
                    radius: 4; color: "#070f09"
                    border.color: "#ff2638"; border.width: 1
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0; verticalOffset: 6
                        radius: 14; samples: 29
                        color: Qt.rgba(1, 0.05, 0.12, 0.35)
                    }
                }
                enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 140 } }
            }
        }

        TextField {
            id: usernameField
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            height:      root.font.pointSize * 3.0
            leftPadding: parent.height + 2
            z: 1

            text:                config.ForceLastUser === "true" ? userCombo.currentText : ""
            font.family:         "Monospace"
            font.pointSize:      root.font.pointSize * 1.10
            font.capitalization: config.AllowBadUsernames === "false" ? Font.Capitalize : Font.MixedCase
            color:               "#ff2638"
            placeholderText:     ""
            selectionColor:      Qt.rgba(1, 0.05, 0.12, 0.28)
            selectByMouse:       true
            horizontalAlignment: TextInput.AlignLeft
            renderType:          Text.QtRendering

            onFocusChanged: { if (focus) selectAll() }
            onAccepted:     loginBtn.clicked()
            KeyNavigation.down: passwordField

            background: Rectangle {
                color:        Qt.rgba(0, 0.078, 0.031, 0.50)
                border.color: usernameField.activeFocus ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.333)
                border.width: 1
                radius: 8
                Behavior on border.color { ColorAnimation { duration: 140 } }
                layer.enabled: usernameField.activeFocus
                layer.effect: Glow { radius: 4; samples: 9; color: "#3eff6e6b"; transparentBorder: true }
            }
        }
    }

    Item { height: root.font.pointSize * 0.6; width: parent.width }

    // PASSWORD label
    Item {
        height: root.font.pointSize * 2.0
        width:  parent.width
        Label {
            anchors.left:           parent.left
            anchors.verticalCenter: parent.verticalCenter
            text:           "[ PASSWORD ]"
            font.family:    "Monospace"
            font.pointSize: root.font.pointSize * 1.10
            color:          "#ff2638"
            opacity:        0.60
        }
    }

    // Password row
    Item {
        id: passwordRow
        height: root.font.pointSize * 3.6
        width:  parent.width

        TextField {
            id: passwordField
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            height:      root.font.pointSize * 3.0
            leftPadding: root.font.pointSize * 1.0
            focus:       config.ForcePasswordFocus === "true"

            echoMode:          revealCheck.checked ? TextInput.Normal : TextInput.Password
            passwordCharacter: "■"
            passwordMaskDelay: config.ForceHideCompletePassword === "true" ? undefined : 0
            font.family:       "Monospace"
            font.pointSize:    root.font.pointSize * 1.10
            color:             "#ff2638"
            placeholderText:   ""
            selectionColor:    Qt.rgba(1, 0.05, 0.12, 0.28)
            selectByMouse:     true
            horizontalAlignment: TextInput.AlignLeft
            renderType:        Text.QtRendering
            
            onAccepted: loginBtn.clicked()
            KeyNavigation.down: revealCheck

            background: Rectangle {
                color:        Qt.rgba(0, 0.078, 0.031, 0.50)
                border.color: passwordField.activeFocus ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.333)
                border.width: 1
                radius: 8
                Behavior on border.color { ColorAnimation { duration: 140 } }
                layer.enabled: passwordField.activeFocus
                layer.effect: Glow { radius: 4; samples: 9; color: "#3eff6e6b"; transparentBorder: true }
            }
        }
    }

    // Show password checkbox
    Item {
        height: root.font.pointSize * 2.4
        width:  parent.width

        CheckBox {
            id: revealCheck
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: true

            indicator: Rectangle {
                id: cbBox
                anchors.left:           parent.left
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: root.font.pointSize * 1.0
                implicitWidth:  root.font.pointSize * 1.0
                color:        "transparent"
                border.color: "#ff2638"
                border.width: 1
                radius: 2
                opacity: 0.65

                Rectangle {
                    anchors.centerIn: parent
                    implicitHeight: parent.width - 4
                    implicitWidth:  parent.width - 4
                    color:   "#ff2638"; radius: 1
                    opacity: revealCheck.checked ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 110 } }
                }
            }

            contentItem: Text {
                text:           config.TranslateShowPassword || "show password"
                leftPadding:    cbBox.width + 8
                font.family:    "Monospace"
                font.pointSize: root.font.pointSize * 0.90
                color: revealCheck.hovered ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.50)
                verticalAlignment: Text.AlignVCenter
                Behavior on color { ColorAnimation { duration: 140 } }
            }

            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed:  toggle()
            KeyNavigation.down:   loginBtn
            background: Rectangle { color: "transparent" }
        }
    }

    // Error / caps-lock
    Item {
        height: root.font.pointSize * 2.0
        width:  parent.width

        Label {
            id: errLabel
            width:               parent.width
            horizontalAlignment: Text.AlignHCenter
            font.family:         "Monospace"
            font.pointSize:      root.font.pointSize * 0.90
            font.italic:         true
            opacity: 0
            text: inputContainer.failed
                  ? "[ ACCESS DENIED — " + (config.TranslateLoginFailedWarning || textConstants.failed) + " ]"
                  : keyboard.capsLock ? "[ CAPS LOCK ACTIVE ]" : ""
            color: inputContainer.failed ? "#ff4444" : "#ffaa00"
            states: [
                State {
                    name: "default"
                    when: !inputContainer.failed && !keyboard.capsLock
                    PropertyChanges { target: errLabel; opacity: 0 }
                },
                State {
                    name: "fail"
                    when: inputContainer.failed
                    PropertyChanges { target: errLabel; opacity: 1 }
                },
                State {
                    name: "caps"
                    when: !inputContainer.failed && keyboard.capsLock
                    PropertyChanges { target: errLabel; opacity: 1 }
                }
            ]
            transitions: Transition { NumberAnimation { property: "opacity"; duration: 130 } }
        }
    }

    // Login button
    Item {
        id: loginBtnWrapper
        height: root.font.pointSize * 3.8
        width:  parent.width

        // Authentication state flag
        property bool isAuthenticating: false

        Connections {
            target: sddm
            onLoginSucceeded: {
                loginBtnWrapper.isAuthenticating = false
            }
            onLoginFailed: {
                loginBtnWrapper.isAuthenticating = false
            }
        }

        // Dot animation timer
        Timer {
            id: authDotTimer
            interval: 400
            repeat:   true
            running: loginBtnWrapper.isAuthenticating
            property int dotCount: 0
            onTriggered:      dotCount = (dotCount + 1) % 6
            onRunningChanged: if (!running) dotCount = 0
        }

        Button {
            id: loginBtn
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            height:       root.font.pointSize * 3.0
            hoverEnabled: true
            enabled: !loginBtnWrapper.isAuthenticating && (
                        config.AllowEmptyPassword === "true"
                        || (usernameField.text !== "" && passwordField.text !== "")
                    )

            onClicked: {
                loginBtnWrapper.isAuthenticating = true
                inputContainer.loginRequest(usernameField.text, passwordField.text)
            }

            contentItem: Item {

                // Idle label
                Label {
                    anchors.centerIn: parent
                    opacity: loginBtnWrapper.isAuthenticating ? 0.0 : 1.0
                    font.family:      "Monospace"
                    font.pointSize:   root.font.pointSize * 1.0
                    font.letterSpacing: 2
                    text:  config.TranslateLogin || "[ ACCESS SYSTEM ]"
                    color: loginBtn.enabled
                        ? (loginBtn.hovered ? "#000000" : "#ff2638")
                        : Qt.rgba(1, 0.05, 0.12, 0.35)
                    Behavior on color   { ColorAnimation  { duration: 150 } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                Label {
                    anchors.centerIn: parent
                    opacity: loginBtnWrapper.isAuthenticating ? 1.0 : 0.0
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    font.family:      "Monospace"
                    font.letterSpacing: 5
                    lineHeight:       1.6
                    text: "AUTHENTICATING"
                        + ["     ", "⏹    ", "⏹⏹   ", "⏹⏹⏹  ", "⏹⏹⏹⏹ ", "⏹⏹⏹⏹⏹"][authDotTimer.dotCount]
                    color: loginBtn.down ? "#000000" : "#ff2638"
                    Behavior on color   { ColorAnimation  { duration: 150 } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            background: Rectangle {
                color:        loginBtn.down    ? "#ff2638"
                            : loginBtn.hovered ? "#ff2638"
                            :                    "transparent"
                border.color: loginBtn.enabled ? "#ff2638" : Qt.rgba(1, 0.05, 0.12, 0.28)
                border.width: 1
                radius: 8
                Behavior on color { ColorAnimation { duration: 150 } }
                layer.enabled: loginBtn.hovered || loginBtn.activeFocus
                layer.effect: Glow { radius: 8; samples: 17; color: "#ff2638"; transparentBorder: true }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape:  loginBtn.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                acceptedButtons: Qt.NoButton
            }

            KeyNavigation.up: revealCheck
        }
    }
}
