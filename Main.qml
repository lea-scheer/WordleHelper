import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Controls.Material
import QtQml.Models
import WordleHelper

ApplicationWindow {
    id: root
    width: 640
    height: 480
    minimumWidth: rootLayout.implicitWidth + 250
    minimumHeight: rootLayout.implicitHeight + 250
    visible: true
    title: qsTr("Wordle Helper")

    Material.theme: colorTheme.currentIndex === 0
                    ? Material.Light
                    : Material.Dark
    Material.accent: Material.BlueGrey

    property string language: ""
    property var correctLetters: ["", "", "", "", ""]
    property bool seen: false

    // Good rows
    ListModel {
        id: goodRows
        ListElement { l0: ""; l1: ""; l2: ""; l3: ""; l4: "" }
    }

    // Functions to deal with empty rows for good letters
    function rowIsEmpty(rowObj) {
        return rowObj.l0 === "" &&
               rowObj.l1 === "" &&
               rowObj.l2 === "" &&
               rowObj.l3 === "" &&
               rowObj.l4 === "";
    }

    function lastRowHasLetter() {
        if (goodRows.count === 0)
            return false;
        var last = goodRows.get(goodRows.count - 1);
        return !rowIsEmpty(last);
    }

    component ClearButton: Button {
        text: "Clear"
        Layout.preferredWidth: 80

        background: Rectangle {
            radius: 4
            border.width: 1
            border.color: "#999"
            color: control.down ? "#ddd" : "#eee"
        }

        contentItem: Text {
            text: control.text
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
        }
    }

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
                ColumnLayout {
                    spacing: 15

                    Label {
                        text: "Correct:"
                        font.bold: true
                        Layout.preferredWidth: 60
                    }

                    RowLayout {

                        Repeater {
                            model: 5

                            delegate: TextField {
                                id: field
                                objectName: "correctField" + index
                                Layout.preferredWidth: 40
                                maximumLength: 1
                                horizontalAlignment: Text.AlignHCenter
                                text: correctLetters[index]

                                onTextChanged: {

                                    correctLetters[index] = text
                                    bg1.color = text.trim() === "" ? "lightgray" : "#71F757"
                                    // Move to next field automatically
                                    if (text.length === 1 && index < 4) {
                                        var next = parent.children[index + 1]
                                        if (next) next.forceActiveFocus()
                                    }
                                }

                                Keys.onPressed: function(event){
                                    if (event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                                        if (text === "" && index > 0) {
                                            // Move to previous field
                                            var prev = parent.children[index - 1]
                                            if (prev) {
                                                prev.forceActiveFocus()
                                                prev.text = ""  // optional: clear previous
                                            }
                                        }
                                    }
                                    else if (event.key === Qt.Key_Left && index > 0) {
                                        // Left arrow: move to previous field
                                        var previous = parent.children[index - 1]
                                        if (previous) previous.forceActiveFocus()
                                    }
                                    else if (event.key === Qt.Key_Right && index < 4) {
                                        // Right arrow: move to next field
                                        var next = parent.children[index + 1]
                                        if (next) next.forceActiveFocus()
                                    }
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
                }

                // --- Good row (scalable) ---
                ColumnLayout {
                    spacing: 5

                    // Header row with label + add button
                    RowLayout {
                        spacing: 5

                        Label {
                            text: "Good:"
                            font.bold: true
                            Layout.preferredWidth: 60
                        }

                        Button {
                            text: "+"
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            enabled: lastRowHasLetter()
                            onClicked: {
                                goodRows.append({
                                    "l0": "", "l1": "", "l2": "", "l3": "", "l4": ""
                                })
                            }
                        }
                    }

                    // All good-letter rows
                    Repeater {
                        model: goodRows

                        delegate: RowLayout {
                            spacing: 5
                            property int rowIndex: index // <-- this is the ListModel row index
                            property string p0: l0
                            property string p1: l1
                            property string p2: l2
                            property string p3: l3
                            property string p4: l4

                            // 5 textfields per row
                            Repeater {
                                model: 5

                                delegate: TextField {
                                    Layout.preferredWidth: 40
                                    maximumLength: 1
                                    horizontalAlignment: Text.AlignHCenter

                                     // bind to correct property
                                    text: model.index === 0 ? p0 :
                                          model.index === 1 ? p1 :
                                          model.index === 2 ? p2 :
                                          model.index === 3 ? p3 :
                                          p4

                                    onTextChanged: {
                                        if (model.index === 0) goodRows.setProperty(rowIndex, "l0", text)
                                        else if (model.index === 1) goodRows.setProperty(rowIndex, "l1", text)
                                        else if (model.index === 2) goodRows.setProperty(rowIndex, "l2", text)
                                        else if (model.index === 3) goodRows.setProperty(rowIndex, "l3", text)
                                        else goodRows.setProperty(rowIndex, "l4", text)

                                        bg2.color = text.trim() === "" ? "lightgray" : "#FFA230"

                                        // Auto remove if row becomes empty AND not the only row
                                        var row = goodRows.get(rowIndex)

                                        if (rowIsEmpty(row) && goodRows.count > 1) {
                                            goodRows.remove(rowIndex)
                                        }

                                        // Move to next field automatically
                                        if (text.length === 1 && index < 4) {
                                            var next = parent.children[index + 1]
                                            if (next) next.forceActiveFocus()
                                        }
                                    }

                                    Keys.onPressed: function(event){
                                        if (event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                                            if (text === "" && index > 0) {
                                                // Move to previous field
                                                var prev = parent.children[index - 1]
                                                if (prev) {
                                                    prev.forceActiveFocus()
                                                    prev.text = ""  // optional: clear previous
                                                }
                                            }
                                        }
                                        else if (event.key === Qt.Key_Left && index > 0) {
                                            // Left arrow: move to previous field
                                            var previous = parent.children[index - 1]
                                            if (previous) previous.forceActiveFocus()
                                        }
                                        else if (event.key === Qt.Key_Right && index < 4) {
                                            // Right arrow: move to next field
                                            var next = parent.children[index + 1]
                                            if (next) next.forceActiveFocus()
                                        }
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

                            // Remove row button
                            Button {
                                text: "-"
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                visible: goodRows.count > 1
                                onClicked: goodRows.remove(index)
                            }
                        }
                    }
                }

                // --- Absent row ---
                RowLayout {
                    spacing: 5

                    Label {
                        text: "Absent:"
                        font.bold: true
                        Layout.preferredWidth: 60
                    }

                    TextField {
                        id: absentInput
                        Layout.preferredWidth: 200
                        placeholderText: "Absent letters (e.g. tle)"

                        onTextChanged: {
                            var textLower = text.toLowerCase()

                            var seen = {}
                            for(var i=0; i<textLower.length; i++)
                            {
                                var c = textLower[i]
                                if(seen[c])
                                {
                                    // Remove the last typed character
                                    text = textLower.slice(0, -1)
                                    // Display msg and trigger timer to make it disapeear after 3s
                                    root.seen = true
                                    timerMsgDuplicate.start()
                                    return
                                }
                                seen[c] = true
                            }
                        }
                    }
                }

                // --- Warning msg if duplicate in absent letters + timer for 3s display
                Rectangle {
                    width: msgDuplicate.width
                    height: absentInput.height/2
                    color: "#FFEAB8"
                    visible: root.seen
                    Text {
                        id: msgDuplicate
                        text: "You can't add the same letter twice!"
                    }
                }

                Timer {
                    id: timerMsgDuplicate
                    interval: 3000
                    onTriggered: root.seen = false
                }

                // --- Search button ---
                Button {
                    id: searchButton

                    contentItem: Text {
                        text: "Search"
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                    }

                    background: Rectangle {
                        radius: 4
                        border.width: 2
                        border.color: "#FFD552"
                        color: searchButton.down ? "#DEBA68" : "#FFD552"
                    }

                    onClicked: {
                        // Correct letters
                        var correct = correctLetters.map(function(letter) {
                            return letter === "" ? "-" : letter;
                        }).join("");

                        // Build ARRAY of good rows
                        var good = []
                        for (var r = 0; r < goodRows.count; r++) {
                            var row = goodRows.get(r);

                            var rowStr =
                                (row.l0 === "" ? "-" : row.l0) +
                                (row.l1 === "" ? "-" : row.l1) +
                                (row.l2 === "" ? "-" : row.l2) +
                                (row.l3 === "" ? "-" : row.l3) +
                                (row.l4 === "" ? "-" : row.l4);

                            good.push(rowStr);
                        }


                        backend.updateConstraints(correct, good, absentInput.text);
                    }
                }

                // --- GridView ---
                GridView {
                    id: wordView

                    Layout.fillWidth: true
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
                        color: colorTheme.currentIndex === 0
                               ? "black"
                               : "white"
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

            // Language selection
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
                    searchButton.clicked()
                }
            }

            // Color Mode selection
            Label {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 11
                text: "Color Theme"
                font.bold: true
            }

            ComboBox {
                id: colorTheme
                Layout.alignment: Qt.AlignLeft
                model: ["White", "Dark"]

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
            }
        }
    }
}
