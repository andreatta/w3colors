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

    Flickable {
        width: main.width
        height: main.height
        contentHeight: colorgrid.height
        contentWidth: colorgrid.width

        Grid {
            id: colorgrid
            columns: main.width / 300
            spacing:0

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
                        color: Qt.rgba(255 - colorR, 255 - colorG, 255 - colorB, 255)
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: tile.width / 10
                        style: Text.Raised
                        styleColor: "#202020"
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
            pinch.minimumScale: 0.1
            pinch.maximumScale: 10
            onPinchStarted: setFrameColor();
                MouseArea {
                    id: dragArea
                    hoverEnabled: true
                    anchors.fill: parent
                    drag.target: colorgrid

                    onWheel: {
                        if (wheel.modifiers & Qt.ControlModifier) {
                        colorgrid.rotation += wheel.angleDelta.y / 120 * 5;
                            if (Math.abs(colorgrid.rotation) < 4)
                            colorgrid.rotation = 0;
                        } else {
                        colorgrid.rotation += wheel.angleDelta.x / 120;
                            if (Math.abs(colorgrid.rotation) < 0.6)
                            colorgrid.rotation = 0;
                            var scaleBefore = colorgrid.scale;
                            colorgrid.scale += colorgrid.scale * wheel.angleDelta.y / 120 / 10;
                            colorgrid.x -= colorgrid.width * (colorgrid.scale - scaleBefore) / 2.0;
                            colorgrid.y -=colorgrid.height * (colorgrid.scale - scaleBefore) / 2.0;
                        }
                    }
                }
        }
    } // flickable
}
