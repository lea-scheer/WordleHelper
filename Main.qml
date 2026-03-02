import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import WordleHelper

ApplicationWindow {
    id: root
    width: 640
    height: 480
    minimumWidth: rootLayout.implicitWidth + 250
    minimumHeight: rootLayout.implicitHeight + 250
    visible: true
    title: qsTr("Wordle Helper")

    property var correctLetters: ["", "", "", "", ""]
    property var goodLetters: ["", "", "", "", ""]

    property string language: ""

    WordleBackend {
        id: backend
    }

    RowLayout {
        anchors.fill: parent

        // -----------------
        // Main vertical content (centered)
        // -----------------

        ColumnLayout {
            id: rootLayout
            spacing: 0
            Layout.alignment: Qt.AlignTop
            Layout.margins: 20

            // Main content container
            ColumnLayout {
                spacing: 15
                Layout.preferredWidth: 300

                // --- Correct row ---
                RowLayout {
                    spacing: 5

                    Label {
                        text: "Correct:"
                        Layout.preferredWidth: 60
                    }

                    Repeater {
                        model: 5
                        delegate: TextField {
                            Layout.preferredWidth: 40
                            maximumLength: 1
                            horizontalAlignment: Text.AlignHCenter
                            text: correctLetters[index]

                            onTextChanged: {

                                correctLetters[index] = text
                                bg1.color = text === "" ? "lightgray" : "#71F757"
                            }

                            background: Rectangle {
                                id: bg1
                                color: "lightgray"
                                border.color: "gray"
                                border.width: 1
                                radius: 2
                            }
                        }
                    }
                }

                // --- Good row ---
                RowLayout {
                    spacing: 5

                    Label {
                        text: "Good:"
                        Layout.preferredWidth: 60
                    }

                    Repeater {
                        model: 5
                        delegate: TextField {
                            Layout.preferredWidth: 40
                            maximumLength: 1
                            horizontalAlignment: Text.AlignHCenter
                            text: goodLetters[index]

                            onTextChanged: {

                                goodLetters[index] = text
                                bg2.color = text === "" ? "lightgray" : "#FFA230"
                            }

                            background: Rectangle {
                                id: bg2
                                color: "lightgray"
                                border.color: "gray"
                                border.width: 1
                                radius: 2
                            }
                        }
                    }
                }

                // --- Absent row ---
                RowLayout {
                    spacing: 5

                    Label {
                        text: "Absent:"
                        Layout.preferredWidth: 60
                    }

                    TextField {
                        id: absentInput
                        Layout.preferredWidth: 200
                        placeholderText: "Absent letters (e.g. TLE)"
                    }
                }

                // --- Filter button ---
                Button {
                    id: filterButton
                    text: "Filter"
                    background: Rectangle {
                        radius: 4
                        border.width: 2
                        border.color: "#444"
                        color: filterButton.down ? "#d0d0d0" : "#f0f0f0"
                    }

                    onClicked: {
                        var correct = correctLetters.map(function(letter) {
                            return letter === "" ? "-" : letter;
                        }).join("");

                        var good = goodLetters.map(function(letter) {
                            return letter === "" ? "-" : letter;
                        }).join("");

                        backend.updateConstraints(correct, good, absentInput.text);
                    }
                }

                // --- GridView ---
                GridView {
                    id: wordView

                    Layout.preferredWidth: 350
                    Layout.fillHeight: true

                    model: backend.possibleWords

                    cellWidth: 90
                    cellHeight: 24

                    flow: GridView.LeftToRight   // normal grid behavior
                    clip: true

                    flickableDirection: Flickable.VerticalFlick

                    ScrollBar.vertical: ScrollBar { }

                    delegate: Text {
                        text: modelData
                    }
                }
            }

        }

        // -----------------
        // Right side top ComboBox
        // -----------------

        ColumnLayout {

            Layout.alignment: Qt.AlignTop
            Layout.margins: 20
            spacing: 10

            RowLayout {

                Label {
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 11
                    text: "Language"
                    font.bold: true
                }

                Image {
                    source: root.language === "English" ? "qrc:/images/united-kingdom.png" : "qrc:/images/france.png"
                }
            }

            ComboBox {
                id: languageDropDown
                Layout.alignment: Qt.AlignLeft
                model: ["English", "Français"]


                delegate: ItemDelegate {
                        text: modelData
                        width: parent.width

                        // Make the hover / pressed background transparent
                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: hovered || pressed ? "lightblue" : "transparent"
                        }

                        // Optional: keep text black even when hovered
                        contentItem: Text {
                            text: modelData
                            color: "black"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                onCurrentIndexChanged: {
                    if(currentIndex === 0) //english
                    {
                        root.language = "English"
                        backend.switchLanguage("/home/andrea/SoftPerso/Lea/MyQMLexercice/WordleHelper/dictionaries/words_list.txt")
                    } else {
                        root.language = "Français"
                        backend.switchLanguage("/home/andrea/SoftPerso/Lea/MyQMLexercice/WordleHelper/dictionaries/mots.txt")
                    }
                    filterButton.clicked()
                }
            }
        }
    }


}
