import VPlay 2.0
import QtQuick 2.0

Item {

    BackgroundImage {
        width: scene.width
        height: scene.height
        source: "../assets/img/frame.jpg"

        //anchors.centerIn: scene.gameWindowAnchorItem
        Grid {
            // Board is 12x12 tiles
            columns: 16 //列
            rows: 16

            Repeater {
                model: 16 //为重复器提供的数据模型，类型是any

                //类型是数字的话，代表要重复器要创建的数量
                Repeater {
                    model: 16

                    Rectangle {
                        height: gameArea.chessSize
                        width: height
                        border.color: "black"
                        color: "grey"
                        opacity: 0.5
                    }
                }
            }
        }
    }
}
