//
// This file is part of SDDM Sugar Candy.
// A theme for the Simple Display Desktop Manager.
//
// Copyright (C) 2018–2020 Marian Arlt
//
// SDDM Sugar Candy is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
//
// You are required to preserve this and any additional legal notices, either
// contained in this file or in other files that you received along with
// SDDM Sugar Candy that refer to the author(s) in accordance with
// sections §4, §5 and specifically §7b of the GNU General Public License.
//
// SDDM Sugar Candy is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SDDM Sugar Candy. If not, see <https://www.gnu.org/licenses/>
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Column {
    // Contenedor principal de los elementos de entrada
    id: inputContainer
    Layout.fillWidth: true
    spacing: 40

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        // Campo de usuario con selector de usuarios
        id: usernameField  // Contenedor principal para el campo de usuario
        height: 50
        width: 380
        anchors.horizontalCenter: parent.horizontalCenter
        //margen inferior
        anchors.bottomMargin: 70

        ComboBox {
            // Selector desplegable de usuarios registrados
            id: selectUser  // Botón de selección de usuario con ícono
            width: parent.height  // Se ajusta al nuevo alto
            height: parent.height
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

            delegate: ItemDelegate {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: model.name
                    font.pointSize: 20
                    font.capitalization: Font.Capitalize
                    color: selectUser.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#006a80" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#006a80" : root.palette.highlight : "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                highlighted: parent.highlightedIndex === index
                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
                }
            }

            indicator: Button { //Icono de user
                    id: usernameIcon
                    width: selectUser.height * 0.9
                    height: selectUser.height * 0.9
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: selectUser.height * 0.45  // Aumentado de 0.25 a 0.45 para moverlo más a la derecha
                    icon.height: selectUser.height * 0.5
                    icon.width: selectUser.height * 0.5
                    enabled: false
                    icon.color: root.palette.text
                    icon.source: Qt.resolvedUrl("../Assets/User.svg")
            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                y: parent.height - username.height / 3
                x: config.ForceRightToLeft == "true" ? -loginButton.width + selectUser.width : 0
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + usernameField.width / 2 : undefined
                width: 220
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
                    when: selectUser.activeFocus
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.palette.highlight
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "color, border.color, icon.color"
                        duration: 150
                    }
                }
            ]

        }

        TextField {
            // Campo de entrada para el nombre de usuario
            id: username    // Campo de texto para el nombre de usuario
            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            font {
                family: "Fira Sans"
                pointSize: 25
                capitalization: config.AllowBadUsernames == "false" ? Font.Capitalize : Font.MixedCase
            }
            anchors.centerIn: parent
            height: 70      // Altura ajustada
            width: 350     // Ancho aumentado
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
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
        // Campo de contraseña con opción de mostrar/ocultar
        id: passwordField  // Contenedor del campo de contraseña
        height: 70        // Altura ajustada
        width: 380       // Ancho aumentado
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            // Campo de entrada para la contraseña
            id: password   // Campo de texto para la contraseña
            font {
                family: "Ndot55"
                pointSize: 30
            }
            anchors.centerIn: parent
            height: 70     // Altura ajustada
            width: 350    // Ancho aumentado
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
        height: 70
        width: 380
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: revealSecret
            width: parent.width
            height: parent.height * 0.5
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top  // Anclar a la parte superior
                topMargin: -18    // Ajustar este valor para mover verticalmente
            }

            indicator: Rectangle {
                id: indicator
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.height * 0.8
                implicitHeight: 20  // Tamaño del bottom
                implicitWidth: 20
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                anchors.verticalCenterOffset: 4

                radius: 5

                Rectangle {
                    id: dot
                    anchors.centerIn: parent
                    implicitHeight: parent.width - 8
                    implicitWidth: parent.width - 8
                    color: root.palette.text
                    opacity: revealSecret.checked ? 1 : 0
                }
            }

            contentItem: Text {
                id: indicatorLabel
                text: config.TranslateShowPassword || "Mostrar Contraseña" // Show Password
                font {
                    family: "Fira Sans"
                    pointSize: 20
                }
                anchors {
                    left: parent.indicator.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 5
                }
                color: root.palette.text
            }

            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: loginButton

            background: Rectangle {
                color: "transparent"
                border.width: parent.activeFocus ? 1 : 0
                border.color: parent.activeFocus ? root.palette.text : "transparent"
                height: parent.activeFocus ? 2 : 0
                width: (indicator.width + indicatorLabel.contentWidth + indicatorLabel.anchors.leftMargin + 2)
                anchors.top: indicatorLabel.bottom
                anchors.left: parent.left
                //anchors.leftMargin: 3
                anchors.topMargin: 8
            }
        }

        states: [
            State {
                name: "pressed"
                when: revealSecret.down
                PropertyChanges {
                    target: revealSecret.contentItem
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
                PropertyChanges {
                    target: revealSecret.background
                    border.color: Qt.darker(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "hovered"
                when: revealSecret.hovered
                PropertyChanges {
                    target: indicatorLabel
                    color: Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: indicator
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: dot
                    color: Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: revealSecret.background
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
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
                PropertyChanges {
                    target: revealSecret.background
                    border.color: root.palette.highlight
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, opacity"
                    duration: 150
                }
            }
        ]

    }

    // Controles de alineación vertical del checkbox "Mostrar Contraseña":
    // - anchors.verticalCenter: parent.verticalCenter -> Centra el checkbox verticalmente en su contenedor
    // - anchors.verticalCenterOffset -> Ajusta la posición vertical desde el centro (negativo = arriba, positivo = abajo)
    // - height: parent.height * 0.5 -> Controla el tamaño vertical del área del checkbox

    Item {
        // Área de mensajes de error y advertencias
        height: root.font.pointSize * 2.3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || "¡Contraseña incorrecta!" : keyboard.capsLock ? config.TranslateCapslockWarning || "¡Bloq Mayús activado!" : null
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 22
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
        // Botón de inicio de sesión
        id: login
        height: 70
        width: 380       
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: config.TranslateLogin || "Iniciar Sesión"
            height: 70
            width: 350
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                text: parent.text
                color: config.OverrideLoginButtonTextColor != "" ? config.OverrideLoginButtonTextColor : root.palette.highlight.hslLightness >= 0.7 ? "#006a80" : "white"
                font.pointSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 0.5
            }

            background: Rectangle {
                id: buttonBackground
                color: "white"
                opacity: 0.2
                radius: config.RoundCorners || 0
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

    // Selector de sesión del sistema
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
