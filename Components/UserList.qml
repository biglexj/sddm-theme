// Campo de nombre de usuario con lista desplegable de usuarios recientes
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: usernameField

    height: root.font.pointSize * 4.5
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedUser: selectUser.currentIndex
    property alias user: username.text
    
    // Función para calcular la altura máxima óptima del popup
    function getMaxPopupHeight() {
        const minHeight = root.font.pointSize * 8 // Mínimo para al menos 3-4 usuarios
        const maxHeight = root.font.pointSize * 16 // Máximo absoluto
        const screenBasedHeight = Screen.height * 0.2 // Reducido del 30% al 20%
        
        return Math.max(minHeight, Math.min(maxHeight, screenBasedHeight))
    }

    ComboBox {

        id: selectUser

        width: parent.height
        height: parent.height
        anchors.left: parent.left
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
            height: root.font.pointSize * 2.5 // Altura fija para cada elemento
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.capitalization: Font.Capitalize
                color: selectUser.highlightedIndex === index ? "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight : "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight // Trunca el texto si es muy largo
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
                radius: 5
            }
        }

        indicator: Button {
                id: usernameIcon
                width: selectUser.height * 0.8
                height: parent.height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: selectUser.height * 0.125
                icon.height: parent.height * 0.25
                icon.width: parent.height * 0.25
                enabled: false
                icon.color: "transparent" // Inicialmente transparente
                icon.source: Qt.resolvedUrl("../Assets/User.svg")
                
                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"
                }
        }

        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }

        popup: Popup {
            y: parent.height - username.height / 3
            rightMargin: config.ForceRightToLeft == "true" ? usernameField.width / 2 : undefined
            width: usernameField.width
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                id: userListView
                clip: true
                // Altura mejorada con límites más inteligentes
                implicitHeight: Math.min(
                    contentHeight, 
                    usernameField.getMaxPopupHeight()
                )
                model: selectUser.popup.visible ? selectUser.delegateModel : null
                currentIndex: selectUser.highlightedIndex
                
                // ScrollIndicator mejorado
                ScrollIndicator.vertical: ScrollIndicator { 
                    visible: userListView.contentHeight > userListView.height
                    active: userListView.moving
                    policy: ScrollIndicator.AsNeeded
                }
                
                // Mejora la experiencia de scroll en listas largas
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
            }

            background: Rectangle {
                radius: 10
                color: root.palette.window
                border.width: 1
                border.color: Qt.darker(root.palette.window, 1.2)
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 100
                    samples: 201
                    cached: true
                    color: "#88000000"
                }
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
                NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 200 }
            }
            
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
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
                when: selectUser.visualFocus
                PropertyChanges {
                    target: usernameIcon
                    icon.color: root.palette.highlight
                }
            },
            State {
                name: "normal"
                when: !selectUser.down && !selectUser.hovered && !selectUser.visualFocus
                PropertyChanges {
                    target: usernameIcon
                    icon.color: root.palette.text
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
        id: username
        text: config.ForceLastUser == "true" ? selectUser.currentText : null
        font.capitalization: Font.Capitalize
        anchors.centerIn: parent
        height: root.font.pointSize * 3
        width: parent.width
        placeholderText: config.TranslateUsernamePlaceholder || textConstants.userName
        leftPadding: selectUser.width
        selectByMouse: true
        horizontalAlignment: TextInput.AlignHCenter
        renderType: Text.QtRendering
        background: Rectangle {
            color: "transparent"
            border.color: root.palette.text
            border.width: parent.activeFocus ? 2 : 1
            radius: config.RoundCorners || 0
        }
        Keys.onReturnPressed: loginButton.clicked()
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