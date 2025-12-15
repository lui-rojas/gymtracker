import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Dialog {
    id: root
    title: targetIndex === -1 ? "Add New Machine" : "Edit Machine" // Dynamic Title
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    property int targetIndex: -1
    property alias machineName: nameField.text
    property alias machineWeight: weightField.text
    property alias machineSets: setsField.text
    property alias machineReps: repsField.text
    property alias machineImage: root.currentImagePath

    property string currentImagePath: ""

    // Helper function to open dialog in "Edit Mode"
       function openEdit(index, name, weight, sets, reps, image) {
           targetIndex = index
           nameField.text = name
           weightField.text = weight
           setsField.text = sets
           repsField.text = reps
            currentImagePath = image //
           root.open()
       }

       // Helper function to open dialog in "Add Mode"
       function openAdd() {
           targetIndex = -1
           nameField.text = ""
           weightField.text = ""
           setsField.text = ""
           repsField.text = ""
           currentImagePath = ""
           root.open()
       }


    x: (parent.width - width)/2
    y: (parent.height - height)/2
    width: parent.width * 0.9

    ColumnLayout{
        width: parent.width
        spacing: 15

        ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    // Image Preview Circle/Square
                    Rectangle {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100
                        Layout.alignment: Qt.AlignHCenter
                        color: "#444"
                        radius: 10
                        clip: true
                        border.color: "#666"
                        border.width: 1

                        Image {
                            anchors.fill: parent
                            source: root.currentImagePath
                            fillMode: Image.PreserveAspectCrop
                            visible: root.currentImagePath !== ""
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "No Image"
                            color: "#888"
                            visible: root.currentImagePath === ""
                        }
                    }

            Button {
                text: "Select Image"
                Layout.alignment: Qt.AlignHCenter
                onClicked: fileDialog.open()
            }
        }

        TextField{
            id: nameField
            placeholderText: "Machine Name (e.g. Leg press)"
            Layout.fillWidth: true
        }
        RowLayout{
            Layout.fillWidth:  true
            TextField{
                id: weightField
                placeholderText: "Weight (Kg)"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                Layout.fillWidth: true
            }
        }

        RowLayout{
            Layout.fillWidth: true
            spacing: 10

            TextField{
                id: setsField
                placeholderText: "Sets (e.g. 3)"
                inputMethodHints: Qt.ImhDigitsOnly
                Layout.fillWidth: true
            }

            Label{ text: "x"}

            TextField{
                id: repsField
                placeholderText: "Reps (e.g. 12)"
                inputMethodHints: Qt.ImhDigitsOnly
                Layout.fillWidth: true
            }
        }
    }

    FileDialog {
          id: fileDialog
          title: "Please choose a file"
          nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
          onAccepted: {
              // Store the selected file path
              root.currentImagePath = selectedFile.toString()
          }
      }

}
