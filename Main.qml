// Main.qml — ROXOI SDDM Theme · Modern Edition
import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtMultimedia 5.12
import "Components"

Pane {
    id: root

    height: Screen.height
    width:  Screen.width

    // theme.conf switches
    property bool useVideo:  config.UseVideo  !== "false"
    property bool showQuotes: config.ShowQuotes !== "false"

    LayoutMirroring.enabled:         config.ForceRightToLeft == "true"
                                     ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding:            config.ScreenPadding
    palette.button:     "transparent"
    palette.highlight:  config.AccentColor
    palette.text:       config.MainColor
    palette.buttonText: config.MainColor
    palette.window:     config.BackgroundColor
    font.family:        config.Font
    font.pointSize:     config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    // Quotes come from CustomQuotes in theme.conf ("|"-separated) when set,
    // otherwise from the built-in list below.
    property var hackerQuotes: config.CustomQuotes
        ? config.CustomQuotes.split("|").map(function(q) { return "> " + q.trim() })
        : defaultQuotes

    property var defaultQuotes: [
        "> The quieter you become, the more you are able to hear.",
        "> Security is not a product, but a process.",
        "> The only truly secure system is one that is powered off.",
        "> Root access is not a privilege. It's a responsibility.",
        "> sudo make me a sandwich.",
        "> rm -rf /ignorance",
        "> Information wants to be free.",
        "> Code is poetry. Exploit is art.",
        "> Knowledge is the most powerful weapon.",
        "> Never trust a computer you can't throw out a window.",
        "> In a world of locked doors, the person with the key is king.",
        "> Privacy is not a feature",
        "> With great power comes great responsibility.",
        "> Life is too short for proprietary software.",
        "> Hackers don't break systems. They reveal their true shape.",
        "> Curiosity is the engine of achievement.",
        "> Every system is hackable. Every lock has a key.",
        "> The best defense is understanding the offense.",
        "> chmod 777 your mind",
        "> There is no patch for human stupidity.",
        "> grep -r 'truth' /reality",
        "> Not all those who wander are lost. Some are pentesting.",
        "> Encryption is the right to whisper in a loud world.",
        "> The terminal is my canvas. The command is my brush.",
        "> 0x41414141",
        "> Don't fear the root. Fear those who misuse it.",
        "> Firewalls are just suggestions to the determined.",
        "> In God we trust. All others we monitor.",
        "> The quietest packets carry the loudest secrets.",
        "> ls -la /secrets",
        "> Any sufficiently advanced bug is indistinguishable from a feature.",
        "> First, do no harm. Then, do no traceable harm.",
        "> We are not criminals. We are cartographers of the digital frontier.",
        "> ping -t existence",
        "> A hacker is just a curious mind with root access.",
        "> The best backdoor is the one they built themselves.",
        "> It's not a bug. It's an undocumented feature.",
        "> All your base are belong to us.",
        "> Security through obscurity is not security at all.",
        "> The network is the computer.",
        "> cat /proc/enlightenment",
        "> Trust no one. Verify everything. Audit often.",
        "> You can't defend what you don't understand.",
        "> Real hackers don't script. They write the scripts.",
        "> Anonymity is armor. Knowledge is the blade.",
        "> /dev/null"
    ]

    Item {
        id: sizeHelper
        anchors.fill: parent

        // z:0  Base fill
        Rectangle {
            anchors.fill: parent
            color: "#050f07"
            z: 0
        }

        // z:0.5  Static background — always shown, so a failed or disabled
        //        video (missing gstreamer/codecs) still leaves a themed screen
        Image {
            id: staticBackground
            anchors.fill: parent
            source: config.Background ? Qt.resolvedUrl(config.Background) : ""
            fillMode: config.ScaleImageCropped == "false" ? Image.PreserveAspectFit
                                                           : Image.PreserveAspectCrop
            asynchronous: true
            z: 0.5
        }

        // z:1  Looping video background (set UseVideo="false" for static only)
        Video {
            id: backgroundVideo
            anchors.fill: parent
            source: root.useVideo ? Qt.resolvedUrl("Backgrounds/login-background.mp4") : ""
            fillMode: VideoOutput.PreserveAspectCrop
            loops: MediaPlayer.Infinite
            muted: true
            autoPlay: root.useVideo
            // only fade the video in once it is really playing
            opacity: playbackState === MediaPlayer.PlayingState ? 0.85 : 0
            visible: root.useVideo && error === MediaPlayer.NoError
            z: 1
        }

        // Optional darkening overlay (DimBackgroundImage in theme.conf)
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: parseFloat(config.DimBackgroundImage) || 0
            z: 2
        }

        // z:13  Login form — vertically centered in panel
        LoginForm {
            id: form
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            width:  parent.width * 0.32
            height: implicitHeight   // let content define its own height

            z: 13
            onSessionChanged: function(idx) {}
        }

        // Virtual keyboard
        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            state:  "hidden"
            property bool keyboardActive: item ? item.active : false
            onKeyboardActiveChanged: keyboardActive ? state = "visible" : state = "hidden"
            width: parent.width; z: 13
            function switchState() { state = state == "hidden" ? "visible" : "hidden" }
            states: [
                State {
                    name: "visible"
                    PropertyChanges { target: form;           systemButtonVisibility: false; clockVisibility: false }
                    PropertyChanges { target: virtualKeyboard; y: root.height - virtualKeyboard.height; opacity: 1 }
                },
                State {
                    name: "hidden"
                    PropertyChanges { target: virtualKeyboard; y: root.height - root.height/4; opacity: 0 }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    SequentialAnimation {
                        ScriptAction { script: { virtualKeyboard.item.activated = true; Qt.inputMethod.hide() } }
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.OutQuad }
                            OpacityAnimator { target: virtualKeyboard;                duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.InQuad }
                            OpacityAnimator { target: virtualKeyboard;                duration: 100; easing.type: Easing.InQuad }
                        }
                        ScriptAction { script: Qt.inputMethod.hide() }
                    }
                }
            ]
        }

        MouseArea { anchors.fill: parent; onClicked: parent.forceActiveFocus(); z: 5 }

        // z:14  Quote bar
        Item {
            visible:                  root.showQuotes
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     16
            anchors.horizontalCenter: parent.horizontalCenter
            width:  parent.width * 0.48
            height: root.font.pointSize * 2.6
            z: 14

            Rectangle {
                anchors.fill: parent; color: Qt.rgba(24/255, 0, 0, 0.78)
                radius: 3; border.color: "#ff2638"; border.width: 1; opacity: 0.90
            }
            Rectangle { anchors.left: parent.left;   anchors.leftMargin:  10; anchors.verticalCenter: parent.verticalCenter; width: 2; height: parent.height * 0.45; color: "#ff2638"; opacity: 0.50 }
            Rectangle { anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; width: 2; height: parent.height * 0.45; color: "#ff2638"; opacity: 0.50 }

            property int qi: Math.floor(Math.random() * root.hackerQuotes.length)

            Label {
                id: quoteLabel
                anchors.centerIn: parent
                width: parent.width - 44
                text:                root.hackerQuotes[parent.qi]
                font.family:         "Monospace"
                font.pointSize:      root.font.pointSize * 0.88
                font.letterSpacing:  0.8
                color:               "#ff9a9a"
                elide:               Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                opacity: 0

                SequentialAnimation on opacity {
                    loops: Animation.Infinite; running: true
                    NumberAnimation { to: 0.0; duration: 0 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.OutQuad }
                    PauseAnimation  { duration: 8000 }
                    NumberAnimation { to: 0.0; duration: 800;  easing.type: Easing.InQuad }
                    PauseAnimation  { duration: 200 }
                    ScriptAction    { script: {
                        quoteLabel.parent.qi = (quoteLabel.parent.qi + 1) % root.hackerQuotes.length
                        quoteLabel.text = root.hackerQuotes[quoteLabel.parent.qi]
                    }}
                }
            }
        }

    } // sizeHelper
}
