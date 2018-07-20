import VPlay 2.0
import QtQuick 2.0
import QtMultimedia 5.0
import Server 1.0


// required for SoundEffect.Infinite enum value for infinite looping
GameWindow {
    id: gameWindow
    activeScene: scene
    screenWidth: 2048
    screenHeight: 960

    property int receive
    property int sender: -1
    property int type: 0 //1为服务器， 2为客户端
    property bool connected: false //连接成功为true，否则为false
    property int gameType: 0
    onGameTypeChanged: {
        if(gameType === 0){
            button.visible = false
        }
        else
            button.visible = true
    }

    onReceiveChanged: {
        if(receive === 300){
            gameWindow.gameOverHide()
            entityManager.removeAllEntities()
            gameWindow.startGame()
        }
        else
            gameArea.createOppositeChess()
    }

    //onSplashScreenFinished: scene.startGame()
    onSplashScreenFinished: playBgm()

    EntityManager {
        id: entityManager
        entityContainer: manManchine
    }

    FontLoader {
        id: gameFont
        source: "../assets/fonts/font.ttf" //中文字体
        //source: "../assets/fonts/akaDylan Plain.ttf"   //英文字体
    }

    SoundEffectVPlay {
        id: bgm
        volume: 0.1 // 音量
        source: "../assets/sounds/bgm.wav"
        loops: SoundEffect.Infinite //循环播放
        autoPauseInBackground: true
    }
    Column{
        x: 1600
        y: 560
        z: 1
        spacing: 60
        Text {
            font.family: gameFont.name
            font.pixelSize: 100
            text: "主菜单"
            color: "black"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gameWindow.closeGame()
                    gameWindow.gameOverHide()
                    entityManager.removeAllEntities()
                    //loader.source = "MenuPanel.qml"
                    menuPanel.visible = true
                    console.log("clicked 主菜单")
                    gameType = 0
                }
            }
        }
        Text {
            id: button
            visible: false
            font.family: gameFont.name
            font.pixelSize: 100
            text: "新游戏"
            color: "black"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gameWindow.gameOverHide()
                    entityManager.removeAllEntities()
                    if(gameType === 1)
                        gameWindow.startDoubleGameArea()
                    else if(gameType === 2){
                        sender = 300
                        gameWindow.startGame()
                    }
                    else if(gameType === 3)
                        gameWindow.startManMachineGame()
                }
            }
        }
    }



    Loader {
        id: loader
        //source: "MenuPanel.qml"
    }
    MenuPanel{
        id: menuPanel
        visible: true
    }


    ControlPanel {
        id: controlPanel
    }

    Scene {
        id: scene
        width: 960
        height: 960
        visible: false

        BackgroundImage {
            width: gameWindow.width
            height: gameWindow.height
            source: "../assets/img/moon.jpg"
            anchors.centerIn: scene.gameWindowAnchorItem
        }
        GameOver {
            id: gameOver
            z: 1
        }

        Frame {
        }

        DoubleGameArea {
            id: doubleGameArea
            anchors.horizontalCenter: scene.horizontalCenter
            chessSize: scene.height / 16
        }
        ManMachine {
            id: manManchine
            anchors.horizontalCenter: scene.horizontalCenter
            chessSize: scene.height / 16
        }
        GameArea {
            id: gameArea
            anchors.horizontalCenter: scene.horizontalCenter
            chessSize: scene.height / 16
        }
    }
    function playBgm() {
        bgm.play()
    }

    function startGame() {
        gameType = 2
        entityManager.entityContainer = gameArea
        gameArea.gameOn = true
        gameArea.mouseArea.enabled = (gameWindow.type === 1) ? true : false
        scene.visible = true
        gameArea.visible = true
        //entityManager.removeAllEntities()
        gameArea.initializeField() //bgm.play()
    }

    function startManMachineGame() {
        gameType = 3
        entityManager.entityContainer = manManchine
        manManchine.gameOn = true
        manManchine.mouseArea.enabled = true
        scene.visible = true
        manManchine.visible = true
        manManchine.initializeField()
    }

    function startDoubleGameArea() {
        doubleGameArea.initializeField()
        gameType = 1
        entityManager.entityContainer = doubleGameArea
        scene.visible = true
        doubleGameArea.visible = true
        doubleGameArea.mouseArea.enabled = true

    }

    function closeGame() {
        scene.visible = false
        gameArea.visible = false
        doubleGameArea.visible = false
        manManchine.visible = false
    }

    function muteBgm() {
        bgm.muted = !bgm.muted //静音属性
    }


    function setServer() {
        menuPanel.visible = false
        loader.source = "ServerArea.qml"
    }

    function setClient() {
        menuPanel.visible = false
        loader.source = "ClientArea.qml"
    }

    function gameOverShow(type) {
        gameOver.visible = true
        gameOver.type = type
    }

    function gameOverHide() {
        gameOver.visible = false
    }
}
