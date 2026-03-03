import QtQuick
import QtQuick.Controls

TextField {
    id: letterField
    property int index: 0
    property int maxIndex: 4
    property color activeColor: "#71F757"
    property color emptyColor: "lightgray"
    property string boundText: ""
    property var rowFields: []   // <-- parent row sets this

    text: boundText
    maximumLength: 1
    horizontalAlignment: Text.AlignHCenter

    onTextChanged: {
        boundText = text
        bg.color = text.trim() === "" ? emptyColor : activeColor

        // Auto-forward focus
        if (text.length === 1 && index < maxIndex && rowFields.length > 0) {
            rowFields[index + 1].forceActiveFocus()
        }
    }

    Keys.onPressed: {
        if ((event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) && text === "" && index > 0 && rowFields.length > 0) {
            rowFields[index - 1].forceActiveFocus()
            rowFields[index - 1].text = ""
        }
        else if (event.key === Qt.Key_Left && index > 0 && rowFields.length > 0) {
            rowFields[index - 1].forceActiveFocus()
        }
        else if (event.key === Qt.Key_Right && index < maxIndex && rowFields.length > 0) {
            rowFields[index + 1].forceActiveFocus()
        }
        else if (event.key === Qt.Key_Space && index < maxIndex && rowFields.length > 0) {
            rowFields[index + 1].forceActiveFocus()
        }
    }

    background: Rectangle {
        id: bg
        color: emptyColor
        border.color: "gray"
        border.width: 1
        radius: 2
    }
}
