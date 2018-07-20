import QtQuick 2.0
import QtQuick.Controls 2.0
import Client 1.0

import QtQuick 2.0

Item {
    id: networkSetting
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
            spacing: 20


            Text {
                font.family: gameFont.name
                font.pixelSize: 100
                text: "连接"
                color: "black"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        client.connect()
                    }
                }
            }
            TextField {
                id: ip
                visible: true

                width: 500
                //                height: 50
                font.pointSize: 50
                font.family: gameFont.name
                background: Rectangle {
                    opacity: 0
                }

                //background: "../assets/img/text.jpg"
                renderType: Text.QtRendering
                placeholderText: qsTr("点击输入IP")
            }
        }

        Client {
            id: client
            ip: ip.text
            sender: gameWindow.sender
            onSenderChanged: {
                on_pushButton_Send_clicked()
            }
            onReceiveChanged: {
                gameWindow.receive = receive
            }
            onConnectedChanged: {
                if (connected === true) {
                    gameWindow.type = 2
                    gameWindow.startGame()
                }
            }
        }
    }
}
