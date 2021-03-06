package lunasurveyor;

import rm.core.Input;
import rm.Globals;
import rm.scenes.Scene_Map;
import rm.objects.Game_Player;
import haxe.Timer;
import lunasurveyor.Events.SCustomEvents;
import core.Amaryllis;
import utils.Fn;
import rm.scenes.Scene_Base;
import utils.Comment;
import macros.MacroTools;

@:nullSafety(Strict)
class Luna_Surveyor {
 public static var surveyorEmitter = Amaryllis.createEventEmitter();

 public static function main() {
  Comment.title("Setup Events");
  surveyorEmitter.on(SCustomEvents.SETUP_DEBUG, () -> {
   LunaDebug.initializeDebug();
  });

  surveyorEmitter.on(SCustomEvents.ON_MAP, () -> {
   LunaDebug.setMapInfo(Globals.GameMap);
   LunaDebug.setPartyInfo(Globals.GameParty);
  });

  Comment.title("Base Class Overrides");
  var SurveyorSceneBase = Fn.renameClass(Scene_Base, SurveyorSceneBaseExt);
  var SurveyorSceneMap = Fn.renameClass(Scene_Map, SurveyorSceneMapExt);
  var SurveyorGamePlayer = Fn.renameClass(Game_Player, SurveyorGamePlayerExt);
  var SurveyorInput = Fn.renameClass(Input, SurveyorInputExt);
 }

 public static function setupDebugTool() {
  var Timer = Timer.delay(() -> {
   surveyorEmitter.emit(SCustomEvents.SETUP_DEBUG);
  }, 1500);
 }
}

@:keep
class SurveyorSceneBaseExt extends Scene_Base {
 public function new() {
  super();
 }

 override public function create() {
  super.create();
  Luna_Surveyor.setupDebugTool();
  // HeliosWinMgr.clearWindows();
  // Helios.setupHeliosWinManager();
  // Helios.addEditor();
 }
}

@:keep
class SurveyorSceneMapExt extends Scene_Map {
 public function new() {
  super();
 }

 override public function onMapLoaded() {
  super.onMapLoaded();
  Luna_Surveyor.surveyorEmitter.emit(SCustomEvents.ON_MAP);
 }
}

class SurveyorGamePlayerExt extends Game_Player {
 public function new() {
  super();
 }

 override public function canMove() {
  var result = super.canMove();
  if (LunaDebug.isOpen) {
   return false;
  } else {
   return result;
  }
 }
}

@:keep
class SurveyorInputExt extends Input {
 private static function _shouldPreventDefault(keyCode: Int) {
  if (LunaDebug.isOpen) {
   return false;
  } else {
   return Input._shouldPreventDefault(keyCode);
  }
 }
}
