import QtQuick 2.0
import VPlay 2.0

Item {
    id: gameArea
    visible: false
    width: chessSize * 16
    height: chessSize * 16

    property int rows: 16
    property int columns: 16
    property var field: []

    property int chessSize
    property alias mouseArea: mouseArea
    property var scoreMapVec: []
    property int ai
    property bool gameOn: true

    SoundEffectVPlay {
        id: chessSound
        volume: 1 //音量 default 1 max
        source: "../assets/sounds/chessman.wav"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: true
        onClicked: {
            //            console.debug(mouse.x, mouse.y)
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
                    type: 1
                }

                chessSound.play()
                entityManager.createEntityFromUrlWithProperties(
                            Qt.resolvedUrl("ChessMan.qml"), newEntityProperties)

                gameArea.field[gameArea.index(Math.round(mouse.y / chessSize),
                                              Math.round(
                                                  mouse.x / chessSize))] = 1

                gameArea.checkWin(Math.round(mouse.y / chessSize),
                                  Math.round(mouse.x / chessSize), 1)
                gameArea.calculateScore()
                mouseArea.enabled = false
                if (gameArea.gameOn === true) {
                    gameArea.createOppositeChess()
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
            type: 2
        }
        //chessSound.play()
        entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl(
                                                            "ChessMan.qml"),
                                                        entityProperties)

        gameArea.field[gameArea.ai] = 2
        gameArea.checkWin(gameArea.row(), gameArea.column(), 2)
        if (gameArea.gameOn === true) {
            mouseArea.enabled = true
        }
    }

    function index(row, column) {
        return (row - 1) * rows + column
    }

    function row() {
        var r = Math.floor(gameArea.ai / rows) + 1
        return r
    }
    function column() {
        var c = gameArea.ai % rows
        return c
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

    //评分函数
    function calculateScore() {
        // 统计玩家或者电脑连成的子
        var personNum = 0 // 玩家连成子的个数
        var botNum = 0 // AI连成子的个数
        var emptyNum = 0 // 各方向空白位的个数

        var kBoardSizeNum = 16 //棋盘为12 × 12
        //var scoreMapVec = [] //评分数组
        var gameMapVec = gameArea.field.slice()
        //std::vector<std::vector<int>> scoreMapVec;//评分数组
        //std::vector<std::vector<int>> gameMapVec;

        // 清空评分数组
        //scoreMapVec.clear();
        var i
        for (i = 0; i < kBoardSizeNum * kBoardSizeNum; i++) {
            gameArea.scoreMapVec[i] = 0
        }

        // 计分（此处是完全遍历，其实可以用bfs或者dfs加减枝降低复杂度，通过调整权重值，调整AI智能程度以及攻守风格）
        for (var row = 0; row < kBoardSizeNum; row++)
            for (var col = 0; col < kBoardSizeNum; col++) {
                // 空白点就算
                if (row > 0 && col > 0 && gameMapVec[gameArea.index(
                                                         row, col)] === 0) {
                    // 遍历周围4个方向
                    for (var y = -1; y <= 1; y++)
                        // -1, 0, 1
                        for (var x = 0; x <= 1; x++) {
                            // 重置
                            personNum = 0
                            botNum = 0
                            emptyNum = 0

                            // 原坐标不算
                            if (!((y === 0 && x === 0)
                                  || (y === -1 && x === 0))) //x or y != 0
                            {
                                // 每个方向延伸4个子

                                // 对玩家白子评分（正反两个方向）
                                for (i = 1; i <= 4; i++) {
                                    if (row + i * y > 0 && row + i * y < kBoardSizeNum && col
                                            + i * x > 0 && col + i * x < kBoardSizeNum && gameMapVec[gameArea.index(row + i * y, col + i * x)] === 1) // 玩家的子
                                    {
                                        personNum++
                                    } else if (row + i * y > 0 && row + i * y < kBoardSizeNum && col
                                               + i * x > 0 && col + i * x < kBoardSizeNum && gameMapVec[gameArea.index(row + i * y, col + i * x)] === 0) // 空白位
                                    {
                                        emptyNum++
                                        break
                                    } else
                                        // 出边界
                                        break
                                }

                                for (i = 1; i <= 4; i++) {
                                    if (row - i * y > 0 && row - i * y < kBoardSizeNum && col
                                            - i * x > 0 && col - i * x < kBoardSizeNum && gameMapVec[gameArea.index(row - i * y, col - i * x)] === 1) // 玩家的子
                                    {
                                        personNum++
                                    } else if (row - i * y > 0 && row - i * y < kBoardSizeNum && col
                                               - i * x > 0 && col - i * x < kBoardSizeNum && gameMapVec[gameArea.index(row - i * y, col - i * x)] === 0) // 空白位
                                    {
                                        emptyNum++
                                        break
                                    } else
                                        // 出边界
                                        break
                                }

                                if (personNum === 1)
                                    // 杀二
                                    gameArea.scoreMapVec[gameArea.index(
                                                             row, col)] += 10
                                else if (personNum === 2) // 杀三
                                {
                                    if (emptyNum === 1)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 30
                                    else if (emptyNum === 2)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 40
                                } else if (personNum === 3) // 杀四
                                {
                                    // 量变空位不一样，优先级不一样
                                    if (emptyNum === 1)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 60
                                    else if (emptyNum === 2)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 110
                                } else if (personNum === 4)
                                    // 杀五
                                    gameArea.scoreMapVec[gameArea.index(
                                                             row, col)] += 1000

                                // 进行一次清空
                                emptyNum = 0

                                // 对AI黑子评分
                                for (i = 1; i <= 4; i++) {
                                    if (row + i * y > 0 && row + i * y < kBoardSizeNum && col
                                            + i * x > 0 && col + i * x < kBoardSizeNum && gameMapVec[gameArea.index(row + i * y, col + i * x)] === 2) // AI的子
                                    {
                                        botNum++
                                    } else if (row + i * y > 0 && row + i * y < kBoardSizeNum && col
                                               + i * x > 0 && col + i * x < kBoardSizeNum && gameMapVec[gameArea.index(row + i * y, col + i * x)] === 0) // 空白位
                                    {
                                        emptyNum++
                                        break
                                    } else
                                        // 出边界
                                        break
                                }

                                for (i = 1; i <= 4; i++) {
                                    if (row - i * y > 0 && row - i * y < kBoardSizeNum && col
                                            - i * x > 0 && col - i * x < kBoardSizeNum && gameMapVec[gameArea.index(row - i * y, col - i * x)] === 2) // AI的子
                                    {
                                        botNum++
                                    } else if (row - i * y > 0 && row - i * y < kBoardSizeNum && col
                                               - i * x > 0 && col - i * x < kBoardSizeNum && gameMapVec[gameArea.index(row - i * y, col - i * x)] === 0) // 空白位
                                    {
                                        emptyNum++
                                        break
                                    } else
                                        // 出边界
                                        break
                                }

                                if (botNum === 0)
                                    // 普通下子
                                    gameArea.scoreMapVec[gameArea.index(
                                                             row, col)] += 15
                                else if (botNum === 1)
                                    // 活二
                                    gameArea.scoreMapVec[gameArea.index(
                                                             row, col)] += 35
                                else if (botNum === 2) {
                                    if (emptyNum === 1)
                                        // 死三
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 45
                                    else if (emptyNum === 2)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 50 // 活三
                                } else if (botNum === 3) {
                                    if (emptyNum === 1)
                                        // 死四
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 60
                                    else if (emptyNum === 2)
                                        gameArea.scoreMapVec[gameArea.index(
                                                                 row,
                                                                 col)] += 500 // 活四
                                } else if (botNum >= 4)
                                    gameArea.scoreMapVec[gameArea.index(
                                                             row,
                                                             col)] += 10000 // 活五
                            }
                        }
                }
            }
        gameArea.setBorder()
    }
    function setBorder() {
        for (var r = 0; r < 16; r++) {
            scoreMapVec[r * 16] = 0
        }
        for (var c = 0; c < 16; c++) {
            scoreMapVec[16 * 11 + c - 1] = 0
        }
        gameArea.maxScore()
    }
    function maxScore() {
        var max = scoreMapVec[0]
        for (var i = 1; i < 16 * 16; i++) {
            max = (max >= scoreMapVec[i]) ? max : scoreMapVec[i]
        }
        for (var j = 0; j < 16 * 16; j++) {
            if (scoreMapVec[j] === max) {
                gameArea.ai = j
            }
        }
    }
}
