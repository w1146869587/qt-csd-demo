import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint
    width: 640
    height: 480
    title: qsTr("Stack")
    color: "#99000000"

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            let e = 0;
            if (p.x / width < 0.10) { e |= Qt.LeftEdge }
            if (p.x / width > 0.90) { e |= Qt.RightEdge }
            if (p.y / height < 0.10) { e |= Qt.TopEdge }
            if (p.y / height > 0.90) { e |= Qt.BottomEdge }
            window.startSystemResize(e);
        }
    }

    Page {
        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? 5 : 0 // TODO: this messes up the window geometry
        //    footer: ToolBar {
        header: ToolBar {
            contentHeight: toolButton.implicitHeight
            Item {
                anchors.fill: parent
                TapHandler {
                    onTapped: if (tapCount === 2) toggleMaximized()
                    gesturePolicy: TapHandler.DragThreshold
                }
                DragHandler {
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { window.startSystemMove(); }
                }
                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 3
                    Layout.fillWidth: true
                    TabBar {
                        spacing: 0
                        Repeater {
                            model: ["Google", "GitHub - johanhelsing/qt-csd-demo", "Unicode: Arrows"]
                            TabButton {
                                id: tab
                                implicitWidth: 150
                                text: modelData
                                padding: 0
                                //background: Rectangle {
                                //    implicitWidth: 10
                                //    implicitHeight: 20
                                //    opacity: enabled ? 1 : 0.3
                                //    color: tab.checked ? "red" : "green"
                                //    //border.width: 1
                                //    //radius: width
                                //}
                                contentItem: Item {
                                    implicitWidth: 120
                                    implicitHeight: 20
                                    clip: true // TODO: get rid of this
                                    Label { 
                                        id: tabIcon
                                        text: "↻" 
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        width: 30
                                    } // TODO: icon instead
                                    Text {
                                        anchors.left: tabIcon.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        text: tab.text
                                        font: tab.font
                                        opacity: enabled ? 1.0 : 0.3
                                        //color: tab.down ? "#17a81a" : "#21be2b"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                    Rectangle {
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: tab.checked ? closeButton.left : parent.right
                                        width: 20
                                        gradient: Gradient {
                                            orientation: Gradient.Horizontal
                                            GradientStop { position: 0; color: "transparent" }
                                            //GradientStop { position: 1; color: palette.button }
                                            GradientStop { position: 0.7; color: tab.background.color }
                                        }
                                    }
                                    Button {
                                        id: closeButton
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.top: parent.top
                                        visible: tab.checked
                                        text: "🗙"
                                        contentItem: Text {
                                            //width: 40
                                            //height: 40
                                            text: closeButton.text
                                            font: closeButton.font
                                            opacity: enabled ? 1.0 : 0.3
                                            //color: closeButton.down ? "#17a81a" : "#21be2b"
                                            color: "black"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                        }
                                        background: Rectangle {
                                            implicitWidth: 10
                                            implicitHeight: 10
                                            opacity: enabled ? 1 : 0.3
                                            color: tab.background.color // TODO: different color on click
                                            //border.width: 1
                                            //radius: width
                                        }
                                    }
                                }
                            }
                        }
                    }
                    RowLayout {
                        spacing: 0
                        ToolButton { text: "+" }
                        Item { Layout.fillWidth: true }
                        ToolButton {
                            text: "🗕"
                            onClicked: window.showMinimized();
                        }
                        ToolButton {
                            text: window.visibility === Window.Maximized ? "🗗" : "🗖" 
                            onClicked: window.toggleMaximized()
                        }
                        ToolButton {
                            text: "🗙"
                            onClicked: window.close()
                        }
                    }
                }
            }
        }

        // TODO: wrap in stacklayout?
        Page {
            anchors.fill: parent
            header: ToolBar {
                RowLayout {
                    spacing: 0
                    anchors.fill: parent
                    ToolButton { text: "←" }
                    ToolButton { text: "→" }
                    ToolButton { text: "↻" }
                    TextField {
                        text: "https://google.com"
                        Layout.fillWidth: true
                    }
                    ToolButton {
                        id: toolButton
                        text: "\u2630"
                        onClicked: drawer.open()
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: window.width * 0.66
            height: window.height
            edge: Qt.RightEdge
            interactive: window.visibility !== Window.Windowed || position > 0
        }

    }
}