pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root
  property var get: root

  // --- EXISTING BAR CONFIG ---
  property string barBgColor: "#FF222222"
  property string activeColor: "#40FFFFFF"
  property string inactiveColor: "transparent"
  property string hoverColor: "#60FFFFFF"
  property bool onTop: true

  // --- DIMENSIONS & SPACING ---
  property int workspaceSpacing: 12
  property int barHeight: 32           
  property int iconSize: 24           
  property int barMarginTop: 0        
  property int barMarginLeft: 0       
  property int barMarginRight: 0      
  property int barMarginBottom: 0
  property int barPaddingX: 12
  property int barPaddingY: 4

  // --- GLOBAL COLORS ---
  property color textColorGlobal: "#d0d0d0"

  // --- WORKSPACE COLORS (Left) ---
  property color workspaceColorActive: "#d0d0d0"
  property color workspaceColorInactive: "#888888"

  // --- ACTIVE WORKSPACE COLORS ---
  property color textColorCenter: "#d0d0d0"

  // --- FONTS & WEIGHTS ---
  property string fontFaceWorkspaces: "CommitMono Nerd Font"
  property int fontWeightWorkspaces: Font.Bold
  property int fontSizeWorkspaces: 13

  property string fontFaceCenter: "CommitMono Nerd Font"
  property int fontWeightCenter: Font.Normal
  property int fontSizeCenter: 13
  
  property string fontFaceRight: "CommitMono Nerd Font"
  property int fontWeightRight: Font.Bold
  property int fontSizeRight: 13

  property string fontSymbol: "CommitMono Nerd Font"

  // --- SHADOW CONFIGURATION ---
  
  // Workspaces (Left)
  property bool shadowWorkspacesEnabled: false
  property color shadowWorkspacesColor: "#000000"
  property int shadowWorkspacesX: 1
  property int shadowWorkspacesY: 1

  // Center (Active Title)
  property bool shadowCenterEnabled: false
  property color shadowCenterColor: "#000000"
  property int shadowCenterX: 1
  property int shadowCenterY: 1

  // Right (Time/Date)
  property bool shadowRightEnabled: false
  property color shadowRightColor: "#000000"
  property int shadowRightX: 1
  property int shadowRightY: 1
}
