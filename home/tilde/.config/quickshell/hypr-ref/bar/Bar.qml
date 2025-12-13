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
      implicitHeight: Theme.get.barHeight // 32px
      visible: true

      IpcHandler {
        target: "bar"
        function toggleVis(): void { visible = !visible; }
      }
    
      // 2. Positioning (Full Width)
      anchors {
        top: Theme.get.onTop
        bottom: !Theme.get.onTop
        left: true
        right: true
      }

      // 3. Spacing (External Margins -> 0)
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
        
        // CHANGED: Specific Top/Bottom (4px) and Left/Right (24px) padding
        anchors.topMargin: Theme.get.barPaddingY
        anchors.bottomMargin: Theme.get.barPaddingY
        anchors.leftMargin: Theme.get.barPaddingX
        anchors.rightMargin: Theme.get.barPaddingX
  
        // Left side
        Row {
          id: leftBlocks
          spacing: 12 
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
          spacing: 32
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
            // Adjust calculation for new padding (PaddingX * 2)
            var available = bar.width - occupied - (Theme.get.barPaddingX * 2) - 20
            var chars = Math.floor(available / 10)
            return Math.max(10, chars)
        }
      }
    }
  }
}
