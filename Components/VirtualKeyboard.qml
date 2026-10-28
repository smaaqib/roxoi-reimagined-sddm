// Components/VirtualKeyboard.qml — ROXOI SDDM Theme

import QtQuick
import QtQuick.VirtualKeyboard

InputPanel {
    id: inputPanel

    property bool activated: false
    externalLanguageSwitchEnabled: true

    states: State {
        name: "visible"
        when: inputPanel.active
        PropertyChanges {
            target: inputPanel
            y: parent.height - inputPanel.height
        }
    }

    transitions: Transition {
        from: ""
        to: "visible"
        reversible: true
        PropertyAnimation {
            properties: "y"
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: {
        y = parent.height
    }
}
