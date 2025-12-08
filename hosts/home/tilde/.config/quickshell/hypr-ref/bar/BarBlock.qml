import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/"

Rectangle {
  id: root
  
  Layout.preferredWidth: Math.max(Theme.get.iconSize, (content ? content.implicitWidth : 0) + 0)
  
  // CHANGED: Height is now iconSize (24px) to fit inside the 32px bar with 4px padding
  Layout.preferredHeight: Theme.get.iconSize

  property Item content
  property Item mouseArea: mouseArea

  property string text
  property bool dim: false
  property bool underline
  
  signal clicked() 

  color: "transparent"
  border.width: 0

  Behavior on color {
    ColorAnimation { duration: 200 }
  }

  Item {
    id: contentContainer
    implicitWidth:  content.implicitWidth
    implicitHeight: content.implicitHeight
    anchors.centerIn: parent
    children: content
  }

  MouseArea {
    id: mouseArea
    anchors.fill: root
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onClicked: root.clicked()
  }

  Rectangle {
    id: wsLine
    height: 0 
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0 
    radius: root.radius 

    color: {
      if (parent.underline)
        return "white";
      return "transparent";
    }
  }
}