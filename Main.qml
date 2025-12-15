import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    id: window
    width: 360
    height: 640
    visible: true
    title: qsTr("Gym Tracker")

    color: "#202020"

    header: ToolBar{
        background: Rectangle { color: "#b71c1c"}
        Label{
            text: "Gym Tracker"
            font.pixelSize: 20
            color: "white"
            anchors.centerIn: parent
        }
    }

    ListView{
        id:listView
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15
        model: myModel
        clip: true

        delegate: Rectangle{
            id: card
            width: listView.width
            height: 160
            radius: 10
            color: "#333333"
            border.color: "#444"

            RowLayout{
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                Rectangle {
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    color: "gray"
                    radius: 5
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: imagePath ? imagePath : ""
                        fillMode: Image.PreserveAspectCrop

                        Text{
                            anchors.centerIn: parent
                            text: "No Image"
                            visible: parent.status != Image.Ready
                            color: "white"
                            font.pixelSize: 10
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    ColumnLayout{
                        id: columnText
                        Layout.fillWidth: true
                        spacing: 5

                        Text{
                            text: name
                            color: "white"
                            font.bold: true
                            font.pixelSize: 18
                        }

                        Text{
                            text: "Weight: " + weight + " Kg"
                            color: "#cccccc"
                            font.pixelSize: 14
                        }

                        Text {
                            // 3 x 12 format
                            text: "Sets/Reps: " + sets + " x " + reps
                            color: "#cccccc"
                            font.pixelSize: 14
                        }

                        Text{
                            text: "Last: " + lastDate
                            color: "#888888"
                            font.pixelSize: 12
                        }
                    }

                    MouseArea{
                    anchors.fill: columnText
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Open dialog in edit mode with current data
                        addDialog.openEdit(
                                    index,
                                    name,
                                    weight.toString(),
                                    sets.toString(),
                                    reps.toString(),
                                    imagePath)
                        }
                    }
                }

                Button {
                    text: "x"
                    Layout.preferredWidth: 40
                    flat: true
                    onClicked:{
                        deleteDialog.targetIndex = index
                        deleteDialog.open()
                    }
                    contentItem: Text{
                        text: "x"
                        color: "#b71c1c"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle{color: "transparent"}
                }
            }

        }

        Text{
            anchors.centerIn: parent
            text: "No machines added yet. Tap + to start."
            color: "#555"
            visible: listView.count === 0
            horizontalAlignment: Text.AlignHCenter
        }

    }

    RoundButton{
        text: "+"
        width: 60
        height: 60
        radius: 30
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        contentItem: Text{
            text: "+"
            font.pixelSize: 30
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle{
            radius: 30
            color: "#b71c1c"
        }

        onClicked: addDialog.openAdd()
    }

    AddDialog{
        id: addDialog
        onAccepted:{
            if (targetIndex === -1) {
                            // ADD MODE
                            myModel.addMachine(
                                machineName,
                                machineImage, // Placeholder image
                                parseFloat(machineWeight),
                                parseInt(machineSets),
                                parseInt(machineReps)
                            )
                        } else {
                            // EDIT MODE
                            myModel.editMachine(
                                targetIndex,
                                machineName,
                                machineImage, // Keep image placeholder for now
                                parseFloat(machineWeight),
                                parseInt(machineSets),
                                parseInt(machineReps)
                            )
                        }
        }
    }

    MessageDialog{
        id: deleteDialog
        title: "Delete Card"
        text: "Are you sure to remove this card?"
        buttons: MessageDialog.Yes | MessageDialog.No

        property int targetIndex: -1

        onButtonClicked: (button, role) => {
                             if(button === MessageDialog.Yes){
                                 myModel.removeMachine(targetIndex)
                             }
                             targetIndex = -1
                         }
    }
}
