import QtQuick 2.11
import QtQuick.Controls 2.4

Column {
    id: clock
    spacing: 0
    width: parent.width / 2

    Label {
        // Texto de bienvenida personalizado en la parte superior
        anchors.horizontalCenter: parent.horizontalCenter
        font {
            family: "Kefa"
            pointSize: 70
            bold: true
        }
        color: root.palette.text
        renderType: Text.QtRendering
        text: config.HeaderText
        bottomPadding: 40
    }

    Label {
        // Reloj digital con hora actual
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font {
            family: "Ndot55"
            pointSize: 150
            bold: true
        }
        color: root.palette.text
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
        }
    }

    Label {
        // Fecha actual con formato personalizado
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font {
            family: "Fira Sans"
            pointSize: 20
        }
        color: root.palette.text
        renderType: Text.QtRendering
        bottomPadding: 40
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
