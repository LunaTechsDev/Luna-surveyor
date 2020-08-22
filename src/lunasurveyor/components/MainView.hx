package lunasurveyor.components;

import rm.managers.SceneManager;
import rm.core.Utils;
import rm.abstracts.objects.GameSwitches;
import rm.Globals;
import rm.types.LunaTea.CharacterPriority;
import rm.types.LunaTea.MoveSpeed;
import rm.types.LunaTea.MoveFrequency;
import haxe.ui.containers.VBox;
import haxe.ui.events.KeyboardEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import rm.abstracts.objects.GameActor;
import utils.Fn;

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

 @:bind(this.menu.openConsole, MouseEvent.CLICK)
 public function openNwJsConsole(event: MouseEvent) {
  // Open NWJS
  if (Utils.isNwjs()) {
   #if !compileMV
   SceneManager.showDevTools();
   #else
   // add require statement code here for opening dev tools
   #end
  }
 }

 /**
  * Shows the debug tools for the user on click.
  */
 @:bind(this.menu.showDebug, MouseEvent.CLICK)
 public function showDebugTools(event: MouseEvent) {
  this.debugInfoContainer.show();
  LunaDebug.isOpen = true;
 }

 /**
  * Hides the debug tools from view for the user.
  */
 @:bind(this.menu.hideDebug, MouseEvent.CLICK)
 public function hideDebugTools(event: MouseEvent) {
  this.debugInfoContainer.hide();
  LunaDebug.isOpen = false;
 }

 // ========================================
 // Tracking changes for debug information
 // @:bind(this.debugInfo.infoGrid, UIEvent.CHANGE)

 public function setMapName(value: String) {
  this.debugInfo.mapName.value = value;
 }

 public function setMapWidth(value: Int) {
  this.debugInfo.mapWidth.value = value;
 }

 public function setMapHeight(value: Int) {
  this.debugInfo.mapHeight.value = value;
 }

 public function setEventName(value: String) {
  this.debugInfo.eventName.value = value;
 }

 public function setEventSpriteSheetName(value: String, index: Int) {
  this.debugInfo.eventSpriteSheetName.value = '${value}_${index}';
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

 public function setNumMembers(value: Int) {
  this.debugInfo.numMembers.value = value;
 }

 public function setGold(value: Int) {
  this.debugInfo.gold.value = value;
 }

 public function setPartyMembers(members: Array<GameActor>) {
  for (member in members) {
   this.debugInfo.partyMemberList.dataSource.add({
    actorName: member.name()
   });
  }
 }

 @:bind(this.debugInfo.gameVariableList, MouseEvent.CLICK)
 public function updateGameVariable(event: MouseEvent) {
  this.debugInfo.updateGameVariableList();
 }

 @:bind(this.debugInfo.gameSwitchesList, MouseEvent.CLICK)
 public function updateGameSwitchValue(event: MouseEvent) {
  var list = this.debugInfo.gameSwitchesList;
  var index = this.debugInfo.gameSwitchesList.selectedIndex;
  if (list.selectedItem != null) {
   list.selectedItem.gameSwitchValue = !list.selectedItem.gameSwitchValue;
   Globals.GameSwitches.setValue(index + 1, list.selectedItem.gameSwitchValue);
   this.debugInfo.gameSwitchesList.dataSource.update(index, list.selectedItem);
  }
  this.debugInfo.updateGameSwitchList();
 }

 @:bind(this.debugInfo.updateVariables, MouseEvent.CLICK)
 public function updateVariables(event: MouseEvent) {
  for (index in 0...this.debugInfo.gameVariableList.dataSource.size) {
   trace("Update Variable");
   var item = this.debugInfo.gameVariableList.dataSource.get(index);
   Globals.GameVariables.setValue(index + 1, item.gameVariableValue);
  }
 }

 //  @:bind(this.debugInfo.scriptCallBox, KeyboardEvent.KEY_UP)
 //  public function handleKeyboardEvents(event: KeyboardEvent) {
 //   final backSpace = 8;
 //   final upArrow = 38;
 //   final leftArrow = 37;
 //   final rightArrow = 39;
 //   final downArrow = 40;
 //   trace(this.debugInfo.scriptCallBox.text);
 //   trace("KeyCode", event.keyCode);
 //   // Handle backspace
 //   switch (event.keyCode) {
 //    case backSpace:
 //     this.debugInfo.scriptCallBox.value;
 //    case _:
 //     // Do nothing
 //   }
 //  }

 @:bind(this.debugInfo.scriptCallRunBtn, MouseEvent.CLICK)
 public function runScriptCall(event: MouseEvent) {
  var code = this.debugInfo.scriptCallBox.value;
  var result = Fn.eval(code);
  Fn.JsLog("Script Call Evaluation Result = ", result);
 }

 @:bind(this.debugInfo.scriptCallClearBtn, MouseEvent.CLICK)
 public function clearScriptCallText(event: MouseEvent) {
  this.debugInfo.scriptCallBox.value = "";
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
  this.updateGameVariableList();
  this.updateGameSwitchList();
 }

 public function updateGameVariableList() {
  var dataSystem = Globals.DataSystem;
  if (dataSystem != null) {
   for (index in 1...dataSystem.variables.length) {
    if (this.gameVariableList.dataSource.get(index) == null) {
     this.gameVariableList.dataSource.add({
      gameVariableName: '${index}: ${dataSystem.variables[index]}',
      gameVariableValue: Globals.GameVariables.value(index)
     });
    }
   }
  }
 }

 public function updateGameSwitchList() {
  var dataSystem = Globals.DataSystem;
  if (dataSystem != null) {
   trace("Update List");
   for (index in 1...dataSystem.switches.length) {
    if (this.gameSwitchesList.dataSource.get(index) == null) {
     this.gameSwitchesList.dataSource.add({
      gameSwitchName: '${index}: ${dataSystem.switches[index]}',
      gameSwitchValue: Globals.GameSwitches.value(index)
     });
    }
   }
  }
 }
}
