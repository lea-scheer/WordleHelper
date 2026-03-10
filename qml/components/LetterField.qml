import QtQuick
import QtQuick.Controls

TextField {
    id: field

    property int fieldIndex: 0
    property int maxIndex: 4
    property color filledColor: "#71F757"
    property color emptyColor: "lightgray"

    maximumLength: 1
    horizontalAlignment: Text.AlignHCenter

    validator: RegularExpressionValidator {
        regularExpression: /[a-zA-Z]/
    }

    implicitWidth: 40
    implicitHeight: 40

    signal letterChanged(string value)

    onTextChanged: {
        text = text.toLowerCase()
        letterChanged(text)

        bg.color = text.trim() === "" ? emptyColor : filledColor

        if(text.length === 1 && fieldIndex < maxIndex)
        {
            var next = parent.children[fieldIndex+1]
            if(next) next.forceActiveFocus()
        }
    }

    Keys.onPressed: function(event) {

        // When key pressed is for deleting letters
        if((event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) && text === "" && fieldIndex > 0)
        {
            var prev1 = parent.children[fieldIndex-1]
            if(prev1)
            {
                prev1.forceActiveFocus()
            }
        }
        // When key pressed is left arrow
        else if(event.key === Qt.Key_Left && fieldIndex > 0)
        {
            var prev2 = parent.children[fieldIndex-1];
            if(prev2)
            {
                prev2.forceActiveFocus();
            }
        }
        // When key pressed is right arrow
        else if(event.key === Qt.Key_Right && fieldIndex < maxIndex)
        {
            var next = parent.children[fieldIndex+1];
            if(next)
            {
                next.forceActiveFocus();
            }
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
