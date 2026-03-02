import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import WordleHelper

ApplicationWindow {
    id: root
    width: 640
    height: 480
    minimumWidth: rootLayout.implicitWidth + 40
    minimumHeight: rootLayout.implicitHeight + 40
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
        spacing: 20

        // -----------------
        // Main vertical content (centered)
        // -----------------

        ColumnLayout {
            id: rootLayout
            spacing: 0

            // Top spacer (pushes content to vertical center)
            Item {
                Layout.fillHeight: true
            }

            // Main content container
            ColumnLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 300

                // --- Correct row ---
                RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

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
                    Layout.alignment: Qt.AlignHCenter

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
                    Layout.alignment: Qt.AlignHCenter

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

                // --- Button ---
                Button {
                    text: "Filter"
                    Layout.alignment: Qt.AlignHCenter

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
                    Layout.preferredHeight: 250
                    Layout.alignment: Qt.AlignHCenter

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

            // Bottom spacer (balances top spacer)
            Item {
                Layout.fillHeight: true
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
                        backend.switchLanguage("/home/andrea/SoftPerso/Lea/MyQMLexercice/WordleHelper/words_list.txt")
                    } else {
                        root.language = "Français"
                        backend.switchLanguage("/home/andrea/SoftPerso/Lea/MyQMLexercice/WordleHelper/mots.txt")
                    }
                }
            }
        }
    }


}
