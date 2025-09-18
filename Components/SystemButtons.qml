// Botones del sistema: Suspender, Hibernar, Reiniciar, Apagar
// Cada botón muestra un icono y un texto, y está habilitado o deshabilitado
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {

    spacing: root.font.pointSize

    property var suspend: ["Suspend", "Suspender", sddm.canSuspend]
    property var hibernate: ["Hibernate", "Hibernar", sddm.canHibernate]
    property var reboot: ["Reboot", "Reiniciar", sddm.canReboot]
    property var shutdown: ["Shutdown", "Apagar", sddm.canPowerOff]
    property Control exposedSession

    Repeater {

        id: systemButtons
        model: [suspend, hibernate, reboot, shutdown]

        RoundButton {
            text: modelData[1]
            font.pointSize: root.font.pointSize * 0.8
            Layout.alignment: Qt.AlignHCenter
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
            display: AbstractButton.TextUnderIcon
            visible: config.ForceHideSystemButtons != "true" && modelData[2]
            hoverEnabled: true
            palette.buttonText: root.palette.text
            background: Rectangle {
                height: 2
                color: "transparent"
                width: parent.width
                border.width: parent.activeFocus ? 1 : 0
                border.color: "transparent"
                anchors.top: parent.bottom
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.suspend() : index == 1 ? sddm.hibernate() : index == 2 ? sddm.reboot() : sddm.powerOff()
            }
            KeyNavigation.up: exposedSession
            KeyNavigation.left: parent.children[index-1]

            states: [
                State {
                    name: "pressed"
                    when: parent.children[index].down
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.darker(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.darker(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: parent.children[index].hovered
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "focused"
                    when: parent.children[index].activeFocus
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: root.palette.highlight
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: root.palette.highlight
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]

        }

    }

}
