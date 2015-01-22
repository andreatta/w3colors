import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "helper.js" as Js

ApplicationWindow {
    id: main
    title: qsTr("ColorBlokz")
    width: Screen.width
    height: Screen.height
    visible: true

    property int columnCount: 3
    property int maxColumnCount: 10
    property int minColumnCount: 1
    property string currentColor: Js.colornames[0]
    property int tileWidth: colorgrid.width / colorgrid.columns

    Flickable {
        id: flick
        anchors.fill: parent
        contentHeight: colorgrid.height
        contentWidth: colorgrid.width

        PinchArea {
            anchors.fill: parent

            /* columnCount is not automatically updated from actual Grid.columns.
             * This is necessary to get rid of some jumps in zooming when zooming
             * in and out in the same pinch move. */
            property int currentColumnCount: columnCount

            onPinchStarted: {
                currentColumnCount = colorgrid.columns
            }

            onPinchUpdated: {
                var newScale = Math.floor(pinch.scale)

                if (newScale) {
                    colorgrid.setColumnCount(currentColumnCount - newScale)
                } else {
                    colorgrid.setColumnCount(colorgrid.columns + 1)
                    currentColumnCount = colorgrid.columns
                }
            }

            Row {
                id: rowlayout

                transitions: [
                    Transition {
                        NumberAnimation {
                            target: rowlayout
                            property: "x"
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                ]

                states: [
                    State {
                        name: "fullview"
                        PropertyChanges {
                            target: rowlayout
                            x: -Screen.width
                        }
                    },
                    State {
                        name: "gridview"
                        PropertyChanges {
                            target: rowlayout
                            x: 0
                        }
                    }
                ]

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
                                color: (((299 * colorR + 587 * colorG + 114 * colorB) / 1000) >= 128)?
                                           Qt.darker(tile.color) :
                                           ((tile.color == "#000000")?
                                                "snow" : Qt.lighter(tile.color, 2))
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

                                property int oldTileWidth: tileWidth

                                onDoubleClicked: {
                                    currentColor = Js.colornames[index]
                                    console.log("clicked " + index)
                                    rowlayout.state = "fullview"
                                }

                                onWheel: {
                                    if (wheel.modifiers & Qt.ControlModifier) {
                                        colorgrid.setColumnCount(columnCount - wheel.angleDelta.y / 120)
                                    }
                                }
                            }
                        } // rectangle tile
                    } // repeater
                } // grid

                /* fullview of color */
                Rectangle {
                    id: fullview
                    width: Screen.width
                    height: Screen.height
                    color: "#dedede"

                    Text {
                        text: qsTr("Color")
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Screen.width / 12
                        color: currentColor
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            rowlayout.state = "gridview"
                        }
                    }
                } // full view
            } // row
        } // pinch
    } // flickable
} // main window
