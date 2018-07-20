import QtQuick 2.0

Item {
    id: menuPanel
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

        //        Text {
        //            font.family: gameFont.name
        //            font.pixelSize: 100
        //            x: 200
        //            y: 200
        //            text: "连网对战"
        //            color: "black"
        //            MouseArea {
        //                anchors.fill: parent
        //                onClicked: {
        //                    gameWindow.networkSetting()
        //                    //menuPanel.visible = false
        //                    //                    scene.visible = true
        //                    //                    gameArea.visible = true
        //                    //                    entityManager.removeAllEntities()
        //                    //                    gameArea.initializeField()
        //                }
        //            }
        //        }
        Column {
            id: gameWay
            x: 750
            y: 300
            Text {
                font.family: gameFont.name
                font.pixelSize: 100
                text: "双人对战"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        gameWindow.startDoubleGameArea()

                        //                        menuPanel.visible = false
                        //                        gameTwoScene.removeAllEntities()
                        //                        gameTwoScene.startGame()
                    }
                }
            }

            Text {
                font.family: gameFont.name
                font.pixelSize: 100
                text: "联机对战"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        netMenu.visible = true
                    }
                }
            }

            Text {
                font.family: gameFont.name
                font.pixelSize: 100
                text: "人机对战"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //                        menuPanel.visible = false
                        //                        gameManMachineScene.removeAllEntities()
                        //                        gameManMachineScene.startGame()
                        gameWindow.startManMachineGame()
                    }
                }
            }
        }
        Column {
            id: netMenu
            visible: false
            x: gameWay.x + 50
            y: gameWay.y + 100
            Text {
                font.family: gameFont.name
                font.pixelSize: 50
                x: 400
                y: 400
                text: "创建游戏"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        gameWindow.setServer()
                    }
                }
            }

            Text {
                font.family: gameFont.name
                font.pixelSize: 50
                x: 400
                y: 400
                text: "加入游戏"
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        gameWindow.setClient()
                    }
                }
            }
        }
    }
}
