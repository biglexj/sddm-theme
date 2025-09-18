// Reloj digital con fecha y hora actual, y texto de bienvenida personalizado
import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock
    spacing: 0
    width: parent.width / 2

    Label {
        font.family: "Kefa"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: config.HeaderText !=="" ? root.font.pointSize * 3 : 0
        color: root.palette.text
        renderType: Text.QtRendering
        text: config.HeaderText
        bottomPadding: 30
    }

    Label {
        id: timeLabel
        font.family: "Ndot55"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: root.font.pointSize * 7
        color: root.palette.text
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.palette.text
        font.pointSize: root.font.pointSize * 0.8
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
        }
        bottomPadding: 40
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
