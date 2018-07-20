import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: chessMan
    entityType: "chessMan"

    // hide block if outside of game area
    visible: true

    // each block knows its type and its position on the field
    property int type
    property int row
    property int column

    // show different images for block types
    Image {
        anchors.fill: parent
        source: {
            console.log("type", type)
            if (type === 1)
                return "../assets/img/tile_button1.png"
            else if (type === 2) {
                console.log("pic2")
                return "../assets/img/tile_button2.png"
            }
        }
    }
}
