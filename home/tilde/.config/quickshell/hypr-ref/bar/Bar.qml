import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "blocks" as Blocks
import "root:/"

Scope {
  Variants {
    model: Quickshell.screens
  
    PanelWindow {
      id: bar
      property var modelData
      screen: modelData

      // 1. Visuals
      color: Theme.get.barBgColor
      implicitHeight: Theme.get.barHeight
      visible: true

      IpcHandler {
        target: "bar"
        function toggleVis(): void { visible = !visible; }
      }
    
      // 2. Positioning
      anchors {
        top: Theme.get.onTop
        bottom: !Theme.get.onTop
        left: true
        right: true
      }

      // 3. Structural Margins
      margins {
        left: Theme.get.barMarginLeft
        right: Theme.get.barMarginRight
        top: Theme.get.onTop ? Theme.get.barMarginTop : 0
        bottom: !Theme.get.onTop ? Theme.get.barMarginBottom : 0
      }
    
      RowLayout {
        id: allBlocks
        anchors.fill: parent
        spacing: 0
        
        anchors.leftMargin: Theme.get.barPaddingX
        anchors.rightMargin: Theme.get.barPaddingX
  
        // Left side
        Row {
          id: leftBlocks
          // CHANGED: Uses Theme.get.sectionSpacingLeft (was 12)
          spacing: Theme.get.sectionSpacingLeft
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
          
          Blocks.SpecialWorkspaces {}
          Blocks.Workspaces {}
        }

        // Spacer
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true
        }
  
        // Right side
        RowLayout {
          id: rightBlocks
          // CHANGED: Uses Theme.get.sectionSpacingRight (was 32)
          spacing: Theme.get.sectionSpacingRight
          Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
  
          // Blocks.Weather {}
          Blocks.Date {}
          Blocks.Time {}
        }
      }

      // Center Overlay
      Blocks.ActiveWorkspace {
        id: activeWorkspace
        anchors.centerIn: parent

        chopLength: {
            var occupied = rightBlocks.implicitWidth + leftBlocks.implicitWidth
            var available = bar.width - occupied - (Theme.get.barPaddingX * 2) - 20
            var chars = Math.floor(available / 10)
            return Math.max(10, chars)
        }
      }
    }
  }
}