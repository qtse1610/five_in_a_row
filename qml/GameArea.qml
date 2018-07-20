import VPlay 2.0
import QtQuick 2.0

Item {
    id: gameArea
    visible: false
    width: chessSize * 16
    height: chessSize * 16

    property int rows: 16
    property int columns: 16
    property var field: []

    property bool player1_turn: true

    property int chessSize
    property alias mouseArea: mouseArea
    property bool gameOn: true

    SoundEffectVPlay {
        id: chessSound
        volume: 1 //音量 default 1 max
        source: "../assets/sounds/chessman.wav"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: (gameWindow.type === 1) ? true : false
        onClicked: {
            //            console.debug(mouse.x, mouse.y)
            if(gameArea.gameOn){
                var tmp = gameArea.field[gameArea.index(
                                             Math.round(mouse.y / chessSize),
                                             Math.round(mouse.x / chessSize))]

                if (tmp === 0 && Math.round(mouse.x / chessSize) > 0 && Math.round(
                            mouse.x / chessSize) < 16 && Math.round(
                            mouse.y / chessSize) > 0 && Math.round(
                            mouse.y / chessSize) < 16) {
                    var newEntityProperties = {
                        width: chessSize,
                        height: chessSize,
                        x////Math.round（）取最近的整数
                        : Math.round(
                              mouse.x / chessSize) * chessSize - chessSize / 2,
                        y: Math.round(
                               mouse.y / chessSize) * chessSize - chessSize / 2,
                        type: gameWindow.type
                    }
                    entityManager.createEntityFromUrlWithProperties(
                                Qt.resolvedUrl("ChessMan.qml"), newEntityProperties)

                    gameArea.field[gameArea.index(
                                       Math.round(mouse.y / chessSize), Math.round(
                                           mouse.x / chessSize))] = gameWindow.type

                    gameArea.checkWin(Math.round(mouse.y / chessSize),
                                      Math.round(mouse.x / chessSize),
                                      gameWindow.type)
                    gameWindow.sender = gameArea.index(
                                Math.round(mouse.y / chessSize),
                                Math.round(mouse.x / chessSize))
                    mouseArea.enabled = false
                }
            }
        }
    }
    function array() {
        for (var i = 0; i < 256; i++) {
            console.log(i, ":  ", gameArea.field[i])
        }
    }

    function createOppositeChess() {
        var entityProperties = {
            width: chessSize,
            height: chessSize,
            x: gameArea.column() * chessSize - chessSize / 2,
            y: gameArea.row() * chessSize - chessSize / 2,
            type: (gameWindow.type === 1) ? 2 : 1
        }
        chessSound.play()
        entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl(
                                                            "ChessMan.qml"),
                                                        entityProperties)

        gameArea.field[gameWindow.receive] = (gameWindow.type === 1) ? 2 : 1
        gameArea.checkWin(gameArea.row(), gameArea.column(),
                          (gameWindow.type === 1) ? 2 : 1)
        mouseArea.enabled = true
    }

    function index(row, column) {
        return (row - 1) * rows + column
    }

    function row() {
        var r = Math.floor(gameWindow.receive / rows) + 1
        return r
    }
    function column() {
        var c = gameWindow.receive % rows
        return c
    }

    function switchTurn() {
        player1_turn = !player1_turn
    }

    function initializeField() {
        for (var i = 0; i < 16 * 16; i++) {
            gameArea.field[i] = 0
        }
    }

    function muteChessSound() {
        chessSound.muted = !chessSound.muted
    }

    function checkWin(row, column, type) {
        //        console.log("checkin: ", row, column, "(row, column): ",
        //                    gameArea.field[index(row, column)], "type :", type)
        gameArea.array()
        var count1 = 1
        var r = row
        var c = column
        var r2 = row
        var c2 = column
        var flag = true
        //纵向检查
        for (var i1 = 1; i1 <= 6; i1++) {
            if (count1 === 5) {
                gameWindow.gameOverShow(type)
                gameArea.gameOn = false
                console.log(type, "纵向 win")
                //                gameOver.show()
                //                gameArea.visible = false
                break
            }
            if (flag === true) {
                r--

                if (gameArea.field[gameArea.index(r, c)] !== type) {
                    flag = false
                } else {
                    console.log("相同类型")
                    count1++
                    //console.log("count1++ ", count1)
                }
            } else {
                r2++
                if (gameArea.field[gameArea.index(r2, c)] !== type)
                    break
                else
                    count1++
            }
        }
        console.log("纵向", count1)

        //横向检查
        var count2 = 1
        r = row
        c = column
        r2 = row
        c2 = column
        flag = true
        for (var i2 = 1; i2 <= 6; i2++) {
            if (count2 === 5) {
                gameWindow.gameOverShow(type)
                gameArea.gameOn = false
                console.log(type, "横向win")
                //                gameArea.visible = false
                //                gameOver.show()
                break
            }
            if (flag === true) {
                c--

                if (gameArea.field[gameArea.index(r, c)] !== type) {
                    flag = false
                } else {
                    console.log("相同类型")
                    count2++
                    console.log("count2++ ", count2)
                }
            } else {
                c2++

                if (gameArea.field[gameArea.index(r, c2)] !== type)
                    break
                else
                    count2++
            }
        }
        console.log("横向", count2)

        //斜线（/）检查
        var count3 = 1
        r = row
        c = column
        r2 = row
        c2 = column
        flag = true
        for (var i3 = 1; i3 <= 6; i3++) {
            if (count3 === 5) {
                gameWindow.gameOverShow(type)
                gameArea.gameOn = false
                console.log(type, "斜线 win")
                //                gameArea.visible = false
                //                gameOver.show()
                break
            }
            if (flag === true) {
                r--
                c++
                if (gameArea.field[gameArea.index(r, c)] !== type) {
                    flag = false
                } else {
                    console.log("相同类型")
                    count3++
                }
            } else {
                r2++
                c2--
                if (gameArea.field[gameArea.index(r2, c2)] !== type)
                    break
                count3++
            }
        }
        console.log("斜线", count3)

        //反斜线（\）检查
        var count4 = 1
        r = row
        c = column
        r2 = row
        c2 = column
        flag = true
        for (var i4 = 1; i4 <= 6; i4++) {

            if (count4 === 5) {
                gameWindow.gameOverShow(type)
                gameArea.gameOn = false
                console.log(type, "反斜线 win")
                //                gameArea.visible = false
                //                gameOver.show()
                break
            }
            if (flag) {
                r--
                c--
                if (gameArea.field[gameArea.index(r, c)] !== type) {
                    flag = false
                } else {
                    console.log("1 类型相同")
                    count4++
                }
            } else {
                r2++
                c2++
                if (gameArea.field[gameArea.index(r2, c2)] !== type)
                    break
                count4++
            }
        }
        console.log("反斜线", count4)
    }
}
