import VPlay 2.0
import QtQuick 2.0

Item {
    x: 50
    y: 850
    z: 1
    id: controlPanel
    Row {
        spacing: 20
        Image {
            id: quit
            width: 50
            height: 50
            visible: true
            source: "../assets/img/Power.ico"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }
        Image {
            id: sound
            width: 50
            height: 50
            visible: true
            source: "../assets/img/Sound.ico"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gameWindow.muteBgm()
                    gameArea.muteChessSound()
                }
            }
        }
    }
}
