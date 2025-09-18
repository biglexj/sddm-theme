import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    // Componente de selección de sesión del sistema
    id: sessionButton
    width: 380
    height: 70
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    ComboBox {
        // Selector desplegable de sesiones disponibles
        id: selectSession

        hoverEnabled: true
        anchors.left: parent.left
        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened)
                revealSecret.focus = true,
                revealSecret.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened)
                loginButton.focus = true,
                loginButton.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Down && !popup.opened)
                systemButtons.children[0].focus = true,
                systemButtons.children[0].state = "focused",
                currentIndex = currentIndex - 1;
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
                popup.open();
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            // Elemento individual en la lista de sesiones
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: 20
                color: selectSession.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#006a80" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#006a80" : root.palette.highlight : "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.highlight : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            // Texto que muestra la sesión seleccionada
            id: displayedItem
            text: (config.TranslateSession || "Sesión:") + " " + selectSession.currentText  // Traducido de "session:"
            color: root.palette.text
            font.family: config.GeneralFont
            anchors {
                left: parent.left
                leftMargin: parent.height * 0.45  // Ajustado para coincidir con otros elementos
            }
            font.pointSize: 25
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: "transparent"
            border.width: parent.visualFocus ? 1 : 0
            border.color: "transparent"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 3
        }

        popup: Popup {
            // Ventana emergente con lista de sesiones
            id: popupHandler
            y: parent.height - 3  // Cambiado de -1 a -3 para mover el popup más arriba
            x: config.ForceRightToLeft == "true" ? -loginButtonWidth + displayedItem.width : 0
            width: sessionButton.width
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: config.BackgroundColor
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 0
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
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: Qt.darker(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.darker(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: root.palette.highlight
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: root.palette.highlight
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

}
