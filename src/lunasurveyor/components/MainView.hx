package lunasurveyor.components;

import rm.types.LunaTea.CharacterPriority;
import rm.types.LunaTea.MoveSpeed;
import rm.types.LunaTea.MoveFrequency;
import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.macros.ComponentMacros.build("src/lunasurveyor/components/main.xml")) class MainView extends VBox {
 public var menu: Menu = new Menu();

 public var debugInfo: DebugInfo = new DebugInfo();

 public function new() {
  super();
  this.setupElements();
 }

 public function setupElements() {
  this.menuContainer.addComponent(this.menu);
  this.debugInfoContainer.addComponent(this.debugInfo);
 }

 /**
  * Shows the debug tools for the user on click.
  */
 @:bind(this.menu.showDebug, MouseEvent.CLICK)
 public function showDebugTools(event: MouseEvent) {
  this.debugInfoContainer.show();
 }

 /**
  * Hides the debug tools from view for the user.
  */
 @:bind(this.menu.hideDebug, MouseEvent.CLICK)
 public function hideDebugTools(event: MouseEvent) {
  this.debugInfoContainer.hide();
 }

 // ========================================
 // Tracking changes for debug information
 // @:bind(this.debugInfo.infoGrid, UIEvent.CHANGE)

 public function setMapWidth(value: Int) {
  this.debugInfo.mapWidth.value = value;
 }

 public function setMapHeight(value: Int) {
  this.debugInfo.mapHeight.value = value;
 }

 public function setEventName(value: String) {
  this.debugInfo.eventCharacterName.value = value;
 }

 public function setEventId(value: Int) {
  this.debugInfo.eventId.value = value;
 }

 public function setEventXCoordinate(value: Int) {
  this.debugInfo.eventYCoordinate.value = value;
 }

 public function setEventYCoordinate(value: Int) {
  this.debugInfo.eventXCoordinate.value = value;
 }

 public function setEventSpeed(value: MoveSpeed) {
  this.debugInfo.eventSpeed.value = '${cast (value, Int)}: ${value.toString()}';
 }

 public function setEventFrequency(value: MoveFrequency) {
  this.debugInfo.eventFrequency.value = '${cast (value, Int)}: ${value.toString()}';
 }

 public function setEventPriority(value: CharacterPriority) {
  this.debugInfo.eventPriority.value = '${cast (value, Int)}: ${value.toString()}';
 }
}

@:build(haxe.ui.macros.ComponentMacros.build("src/lunasurveyor/components/menu.xml"))
class Menu extends VBox {
 public function new() {
  super();
 }
}

@:build(haxe.ui.macros.ComponentMacros.build("src/lunasurveyor/components/debug-info.xml"))
class DebugInfo extends VBox {
 public function new() {
  super();
 }
}
