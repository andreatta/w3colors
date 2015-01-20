import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "helper.js" as Js

ApplicationWindow {
    id: main
    title: qsTr("Colors")
    width: Screen.width
    height: Screen.height
    visible: true

    property int columnCount: 3
    property int maxColumnCount: 10
    property int minColumnCount: 1
    property int tileWidth: colorgrid.width / colorgrid.columns

    Flickable {
        width: main.width
        height: main.height
        contentHeight: colorgrid.height
        contentWidth: colorgrid.width

        Grid {
            id: colorgrid
            columns: columnCount
            spacing:0

            function setColumnCount(columns) {
                if (columns < minColumnCount)
                    columns = minColumnCount

                if (columns > maxColumnCount)
                    columns = maxColumnCount

                columnCount = columns
            }

            Repeater {
                model: Js.colornames.length
                Rectangle {
                    id: tile
                    width: main.width / colorgrid.columns
                    height: width
                    color: Js.colornames[index]

                    property int colorR: tile.color.r * 255
                    property int colorG: tile.color.g * 255
                    property int colorB: tile.color.b * 255

                    Text {
                        color: (((299 * colorR + 587 * colorG + 114 * colorB) / 1000) >= 128)? Qt.darker(tile.color) : ((tile.color == "#000000")? "snow" : Qt.lighter(tile.color))
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: tile.width / 10
                        text: Js.colornames[index] +
                              "\nRGB(" + colorR+ "," + colorG + "," + colorB + ")" +
                              "\nHex #" + String("00" + colorR.toString(16)).slice(-2) +
                              String("00" + colorG.toString(16)).slice(-2) +
                              String("00" + colorB.toString(16)).slice(-2)
                    }

                    MouseArea {
                        anchors.fill: parent
                        //                        onPressed: {
                        //                            tile.width = tile.width * 2
                        //                        }
                        //                        onReleased: {
                        //                            tile.width = tile.width / 2
                        //                        }
                    }
                } // rectangle tile
            } // repeater
        } // grid

        PinchArea {
            anchors.fill: parent
            pinch.target: colorgrid

            onPinchStarted: {
                console.log(tileWidth)
            }

            onPinchUpdated: {
                colorgrid.setColumnCount(maxColumnCount - Math.ceil(pinch.scale))
//                columnCount = maxColumnCount - Math.ceil(pinch.scale)
//                console.log(Math.ceil(pinch.scale))
//                if (columnCount < minColumnCount)
//                    columnCount = minColumnCount

//                if (columnCount > maxColumnCount)
//                    columnCount = maxColumnCount
//                console.log("Scale " + pinch.scale + " tileWidth " + tileWidth + " columnCount " + columnCount)
            }

            onPinchFinished: {
                console.log(scale)
                console.log(tileWidth)
            }

            MouseArea {
//                id: dragArea
                anchors.fill: parent

                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        colorgrid.setColumnCount(columnCount - wheel.angleDelta.y / 120)
//                        columnCount -= (wheel.angleDelta.y / 120)

//                        if (columnCount < minColumnCount)
//                            columnCount = minColumnCount

//                        if (columnCount > maxColumnCount)
//                            columnCount = maxColumnCount
                    } else if (wheel.modifiers) {
//                        colorgrid.
                    }
                }
            }
        }
    } // flickable
}
