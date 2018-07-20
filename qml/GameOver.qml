import VPlay 2.0
import QtQuick 2.0

Item {
    id: gameOver
    visible: false
    property int type: 0
    onTypeChanged: {
        if (type === 1) {
            t.text = "白子胜利"
        }
        if (type === 2) {
            t.text = "黑子胜利"
        }
    }

    Column {
        x: -430
        y: 350
        spacing: 20
        Text {
            font.family: gameFont.name
            font.pixelSize: 100
            text: "游戏结束"
            color: "#600000"
        }
        Text {
            id: t
            font.family: gameFont.name
            font.pixelSize: 100
            color: "#600000"
        }
    }
}
