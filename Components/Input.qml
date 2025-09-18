// Componente de entrada de usuario y contraseña con selección de sesión
//
// Hypr Ely-Neon Theme
//
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Column {
    id: inputContainer
    Layout.fillWidth: true
    spacing: 1 // Ajusta este valor para aumentar o disminuir el espacio entre los campos

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        id: usernameField

        height: root.font.pointSize * 5
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {

            id: selectUser

            width: parent.height
            height: parent.height
            anchors.left: parent.left

            property var popkey: config.ForceRightToLeft == "true" ? Qt.Key_Right : Qt.Key_Left
            Keys.onPressed: {
                if (event.key == Qt.Key_Down && !popup.opened)
                    username.forceActiveFocus();
                if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
                    popup.open();
                }
            KeyNavigation.down: username
            KeyNavigation.right: username
            z: 2

            model: userModel
            currentIndex: model.lastIndex
            textRole: "name"
            hoverEnabled: true
            onActivated: {
                username.text = currentText
            }

            // Ocultar el texto del ComboBox completamente
            contentItem: Item {
                // Elemento vacío para no mostrar texto
            }

            delegate: ItemDelegate {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    width: parent.width // Asegura que el texto no se desborde
                    text: model.name
                    font.pointSize: root.font.pointSize * 0.8
                    font.capitalization: Font.Capitalize
                    color: selectUser.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#006a80" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#006a80" : root.palette.highlight : "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft // Alinea a la izquierda para un truncamiento predecible
                    elide: Text.ElideRight // Añade "..." si el texto es muy largo
                }
                highlighted: parent.highlightedIndex === index
                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
                }
            }

            // Indicator completamente transparente por defecto
            indicator: Rectangle {
                id: invisibleIndicator
                width: 0
                height: 0
                color: "transparent"
            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                y: parent.height - username.height / 3
                x: config.ForceRightToLeft == "true" ? -loginButton.width + selectUser.width : 0
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + usernameField.width / 2 : undefined
                width: usernameField.width
                implicitHeight: contentItem.implicitHeight
                padding: 10

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight + 20
                    model: selectUser.popup.visible ? selectUser.delegateModel : null
                    currentIndex: selectUser.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    radius: config.RoundCorners / 2
                    color: root.palette.window
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 10 * config.InterfaceShadowSize
                        radius: 20 * config.InterfaceShadowSize
                        samples: 41 * config.InterfaceShadowSize
                        cached: true
                        color: Qt.hsla(0,0,0,config.InterfaceShadowOpacity)
                    }
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1 }
                }
            }

        }

        // Ícono de usuario como elemento independiente
        Button {
            id: usernameIcon
            width: selectUser.height * 0.8
            height: selectUser.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: selectUser.height * 0.1
            icon.height: height * 0.25
            icon.width: height * 0.25
            enabled: false
            icon.color: root.palette.text // Visible por defecto
            icon.source: Qt.resolvedUrl("../Assets/User.svg")
            
            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            states: [
                State {
                    name: "pressed"
                    when: selectUser.down
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: Qt.lighter(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: selectUser.hovered
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: Qt.lighter(root.palette.highlight, 1.2)
                    }
                },
                State {
                    name: "focused"
                    when: selectUser.activeFocus || username.activeFocus
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.palette.highlight
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "icon.color"
                        duration: 150
                    }
                }
            ]
        }

        TextField {
            id: username
            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            font.capitalization: config.AllowBadUsernames == "false" ? Font.Capitalize : Font.MixedCase
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
            // Removido leftPadding para centrar el texto correctamente
            onFocusChanged:{
                if(focus)
                    selectAll()
            }
            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: password
            z: 1

            states: [
                State {
                    name: "focused"
                    when: username.activeFocus
                    PropertyChanges {
                        target: username.background
                        border.color: root.palette.highlight
                    }
                    PropertyChanges {
                        target: username
                        color: root.palette.highlight
                    }
                }
            ]
        }

    }

    Item {
        id: passwordField
        height: root.font.pointSize * 5
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password
            font.family: "Ndot55"
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            horizontalAlignment: TextInput.AlignHCenter
            passwordCharacter: "•"
            passwordMaskDelay: config.ForceHideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: revealSecret
        }

        states: [
            State {
                name: "focused"
                when: password.activeFocus
                PropertyChanges {
                    target: password.background
                    border.color: root.palette.highlight
                }
                PropertyChanges {
                    target: password
                    color: root.palette.highlight
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]
    }

    Item {
        id: secretCheckBox
        height: root.font.pointSize * 5
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: revealSecret
            width: parent.width
            hoverEnabled: true

            indicator: Rectangle {
                id: indicator
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.leftMargin: 4
                implicitHeight: root.font.pointSize
                implicitWidth: root.font.pointSize
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: 2
                Rectangle {
                    id: dot
                    anchors.centerIn: parent
                    implicitHeight: parent.width - 4
                    implicitWidth: parent.width - 4
                    color: root.palette.text
                    opacity: revealSecret.checked ? 1 : 0
                }
            }

            contentItem: Text {
                id: indicatorLabel
                text: config.TranslateShowPassword || "Mostrar Contraseña"
                anchors.verticalCenter: indicator.verticalCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: indicator.right
                anchors.leftMargin: indicator.width / 2
                anchors.topMargin: 3
                font.pointSize: root.font.pointSize * 0.8
                color: root.palette.text
            }

            background: Rectangle {
                color: "transparent"
            }

            states: [
                State {
                    name: "base"
                    when: !revealSecret.down && !revealSecret.hovered && !revealSecret.activeFocus
                    PropertyChanges {
                        target: indicatorLabel
                        color: root.palette.text
                    }
                    PropertyChanges {
                        target: dot
                        color: root.palette.text
                    }
                    PropertyChanges {
                        target: indicator
                        border.color: root.palette.text
                    }
                },
                State {
                    name: "pressed"
                    when: revealSecret.down
                    PropertyChanges {
                        target: indicatorLabel
                        color: Qt.darker(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: dot
                        color: Qt.darker(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: indicator
                        border.color: Qt.darker(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: revealSecret.hovered
                    PropertyChanges {
                        target: indicatorLabel
                        color: root.palette.highlight
                    }
                    PropertyChanges {
                        target: indicator
                        border.color: root.palette.highlight
                    }
                    PropertyChanges {
                        target: dot
                        color: root.palette.highlight
                    }
                },
                State {
                    name: "focused"
                    when: revealSecret.activeFocus
                    PropertyChanges {
                        target: indicatorLabel
                        color: root.palette.highlight
                    }
                    PropertyChanges {
                        target: indicator
                        border.color: root.palette.highlight
                    }
                    PropertyChanges {
                        target: dot
                        color: root.palette.highlight
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "color, border.color"
                        duration: 150
                    }
                }
            ]

            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: loginButton

        }

    }

    Item {
        height: root.font.pointSize * 5
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + " ¡Contraseña incorrecta!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: root.font.pointSize * 0.8
            font.italic: true
            color: root.palette.text
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }
                }
            ]
        }
    }

    Item {
        id: login
        height: root.font.pointSize * 5
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter
    
        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: config.TranslateLogin || textConstants.login
            height: root.font.pointSize * 3
            implicitWidth: parent.width
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                text: parent.text
                color: config.OverrideLoginButtonTextColor != "" ? config.OverrideLoginButtonTextColor : root.palette.highlight.hslLightness >= 0.7 ? "#006a80" : "white"
                font.pointSize: root.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 0.5
            }

            background: Rectangle {
                id: buttonBackground
                color: "white"
                opacity: 0.2
                radius: config.RoundCorners 
            }

            states: [
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.darker(root.palette.highlight, 1.1)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                    }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.palette.highlight, 1.15)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.palette.highlight, 1.2)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "enabled"
                    when: loginButton.enabled
                    PropertyChanges {
                        target: buttonBackground;
                        color: root.palette.highlight;
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem;
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity, color";
                        duration: 300
                    }
                }
            ]

            onClicked: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            KeyNavigation.down: sessionSelect.exposeSession
        }
    }

    SessionButton {
        id: sessionSelect
        textConstantSession: textConstants.session
        loginButtonWidth: loginButton.background.width
    }

    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}