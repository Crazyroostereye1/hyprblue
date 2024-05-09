import QtQuick 2.8
import QtQuick.Controls 2.8
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0
import QtGraphicalEffects 1.0
import "."

Rectangle {
    id : container
    LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit : true
    property int sessionIndex : session.index

    TextConstants {
        id : textConstants
    }

    FontLoader {
        id : basefont
        source : "assets/DejaVuSansCondensed.ttf"
    }

    FontLoader {
        id : seriffont
        source : "assets/DejaVuSerifCondensed.ttf"
    }

    Connections {
        target : sddm

        function onLoginSucceeded() {
            errorMessage.color = "#33ffaa"
            errorMessage.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#ee1111"
            errorMessage.text = textConstants.loginFailed
            errorMessage.bold = true
            font.family = boldfont.name
        }
    }

    Background {
        anchors.fill : parent
        source : config.background
        fillMode : Image.Stretch

        onStatusChanged : {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Image {
        source: "assets/loginbox.svg"
        anchors.centerIn: parent

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 590
            anchors.topMargin: 18
            height: 252
            width: 252
            color: "#4992a7"

            Clock2 {
                id : clock
                anchors.centerIn : parent
                color : "#fafcff"
                timeFont.family : seriffont.name
                dateFont.family : seriffont.name
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.topMargin: 18
            height: 252
            width: 566
            color: "transparent"

            Text {
                id: greeting
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 16
                // text: "Welcome to Plasma-Desktop"
                text: textConstants.welcomeText.arg(sddm.hostName)
                font.family: basefont.name
                font.pixelSize: 18
                color : "black"
            }

            Text{
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: greeting.bottom
                text: textConstants.prompt
                font.family: basefont.name
                font.pixelSize: 11
                color: "#595959"
            }

        Rectangle {
                id: centerlayout
                width: parent.width
                height: 72
                anchors.centerIn: parent
                color: "transparent"

                Image {
                    id: imageinput
                    source: "assets/input.svg"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 264
                    height: 28

                    TextField {
                        id: nameinput
                        focus: true
                        font.family: basefont.name
                        anchors.fill: parent
                        text: userModel.lastUser
                        font.pixelSize: 12
                        color: "black"
                        background: Image {
                            id: textback
                            source: "assets/inputhi.svg"

                            states: [
                                State {
                                    name: "yay"
                                    PropertyChanges {target: textback; opacity: 1}
                                },
                                State {
                                    name: "nay"
                                    PropertyChanges {target: textback; opacity: 0}
                                }
                            ]

                            transitions: [
                                Transition {
                                    to: "yay"
                                    NumberAnimation { target: textback; property: "opacity"; from: 0; to: 1; duration: 200; }
                                },

                                Transition {
                                    to: "nay"
                                    NumberAnimation { target: textback; property: "opacity"; from: 1; to: 0; duration: 200; }
                                }
                            ]
                        }

                        KeyNavigation.tab: password
                        KeyNavigation.backtab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                password.focus = true
                            }
                        }

                        onActiveFocusChanged: {
                            if (activeFocus) {
                                textback.state = "yay"
                            } else {
                                textback.state = "nay"
                            }
                        }
                    }
                }

                Text {
                    id: userlabel
                    anchors.right: imageinput.left
                    anchors.bottom: imageinput.bottom
                    font.family: basefont.name
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    rightPadding: 12
                    height: 28
                    text: textConstants.userName
                    color: "black"
                }

                Image {
                    id: imagepassword
                    source: "assets/input.svg"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 264
                    height :28

                    TextField {
                        id: password
                        font.family: basefont.name
                        anchors.fill: parent
                        font.pixelSize: 12
                        echoMode: TextInput.Password
                        color: "#0c191c"

                        background: Image {
                            id: textback1
                            source: "assets/inputhi.svg"

                            states: [
                                State {
                                    name: "yay1"
                                    PropertyChanges {target: textback1; opacity: 1}
                                },
                                State {
                                    name: "nay1"
                                    PropertyChanges {target: textback1; opacity: 0}
                                }
                            ]

                            transitions: [
                                Transition {
                                    to: "yay1"
                                    NumberAnimation { target: textback1; property: "opacity"; from: 0; to: 1; duration: 200; }
                                },

                                Transition {
                                    to: "nay1"
                                    NumberAnimation { target: textback1; property: "opacity"; from: 1; to: 0; duration: 200; }
                                }
                            ]
                        }

                        KeyNavigation.tab: session
                        KeyNavigation.backtab: nameinput

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(nameinput.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }

                        onActiveFocusChanged: {
                            if (activeFocus) {
                                textback1.state = "yay1"
                            } else {
                                textback1.state = "nay1"
                            }
                        }
                    }
                }

                Text {
                    id: passwordlabel
                    anchors.right: imagepassword.left
                    anchors.bottom: imagepassword.bottom
                    font.family: basefont.name
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    rightPadding: 12
                    height: 28
                    text: textConstants.password
                    color: "black"
                }


            }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            width: parent.width
            height: 32
            color: "transparent"

            Row {
                spacing: 24
                anchors.horizontalCenter: parent.horizontalCenter

                Q1.Button {
                    id : shutdownButton
                    height : 32
                    width : 108

                    style : ButtonStyle {
                        background : Image {
                            source : control.hovered
                                ? "assets/buttonhover.svg"
                                : "assets/buttonup.svg"
                        }
                    }

                    Text {
                        anchors.centerIn: shutdownButton
                        font.family: basefont.name
                        font.pixelSize: 11
                        text: textConstants.shutdown
                    }

                    onClicked : sddm.powerOff()
                }

                Q1.Button {
                    id : rebootButton
                    height : 32
                    width : 108

                    style : ButtonStyle {
                        background : Image {
                            source : control.hovered
                                ? "assets/buttonhover.svg"
                                : "assets/buttonup.svg"
                        }
                    }

                    Text {
                        anchors.centerIn: rebootButton
                        font.family: basefont.name
                        font.pixelSize: 11
                        text: textConstants.reboot
                    }

                    onClicked : sddm.reboot()
                }

                ComboBox {
                    id : session
                    width : 108
                    height : 32
                    font.pixelSize : 11
                    font.family : basefont.name
                    arrowIcon : "assets/comboarrow.svg"
                    model : sessionModel
                    index : sessionModel.lastIndex
                    borderColor : "#595959"
                    color : "#a3a3a3"
                    menuColor : "#f2f2f4"
                    textColor : "#323232"
                    hoverColor : "#bbbbbb"
                    focusColor : "#595959"
                    arrowColor: "#a8a8a8"
                    KeyNavigation.backtab : password
                    KeyNavigation.tab : nameinput
                }

                Image {
                    id : loginButton
                    width : 108
                    height : 32
                    source : "assets/buttonup.svg"

                    Text {
                        anchors.centerIn: loginButton
                        font.family: basefont.name
                        font.pixelSize: 11
                        text: textConstants.login
                    }

                    MouseArea {
                        anchors.fill : parent
                        hoverEnabled : true
                        onEntered : {
                            parent.source = "assets/buttonhover.svg"
                        }
                        onExited : {
                            parent.source = "assets/buttonup.svg"
                        }
                        onPressed : {
                            parent.source = "assets/buttondown.svg"
                            sddm.login(nameinput.text, password.text, sessionIndex)
                        }
                        onReleased : {
                            parent.source = "assets/buttonup.svg"
                        }
                    }
                }
            }
        }
        }
    }

    Component.onCompleted : {
        nameinput.focus = true
        textback1.state = "nay1"  //dunno why both inputs get focused
    }
}
