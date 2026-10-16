// Components/VirtualKeyboard.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.VirtualKeyboard 2.1

InputPanel {
    id: inputPanel

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
