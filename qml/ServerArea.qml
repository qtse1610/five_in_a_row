import QtQuick 2.0
import QtQuick.Controls 2.0
import Server 1.0

Item {
    id: serverArea
    visible: true


    Image {
        width: gameWindow.width
        height: gameWindow.height
        source: "../assets/img/moon.jpg"

        //anchors.centerIn: scene.gameWindowAnchorItem
        BorderImage {
            width: gameWindow.width
            height: gameWindow.height

            AnimatedImage {
                id: animation
                source: "../assets/img/live.gif"
            }
        }

        Column {
            x: 200
            y: 150
            spacing: 40

            Text {
                id: listening
                font.family: gameFont.name
                font.pixelSize: 120
                text: "监听"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        server.on_pushButton_Listen_clicked()
                        t.text = server.ipShow()
                    }
                }
            }

            Text {
                id: t
                anchors.left: listening.left
                font.family: gameFont.name
                font.pixelSize: 50
                color: "black"
            }
        }

        Server {
            id: server
            sender: gameWindow.sender
            onSenderChanged: {
                on_pushButton_Send_clicked()
            }
            onReceiveChanged: {
                gameWindow.receive = receive
            }
            onConnectedChanged: {
                if (connected === true) {
                    gameWindow.connected = true
                    gameWindow.type = 1
                    gameWindow.startGame()
                }
            }
        }
    }
}
