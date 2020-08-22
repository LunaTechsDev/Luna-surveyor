package lunasurveyor;

import rm.abstracts.objects.GameParty;
import core.Amaryllis;
import rm.abstracts.managers.SceneMgr;
import rm.Globals;
import rm.abstracts.objects.GameMap;
import js.html.MouseEvent;
import lunasurveyor.Events.SCustomEvents;
import rm.abstracts.objects.GameEvent;
import js.Browser;
import haxe.ui.Toolkit;
import lunasurveyor.components.MainView;

class LunaDebug {
 public static var mainView = new MainView();
 public static var isOpen: Bool = true;

 public static function initializeDebug() {
  Toolkit.init({
   container: Browser.document.body,
  });

  // Toolkit.theme = 'kenney';
  var element = Browser.document.createElement("style");

  element.textContent = ".haxeui-component {z-Index:150}";
  Browser.document.head.appendChild(element);
  var gameCanvas = Browser.document.getElementById("ErrorPrinter");
  Browser.document.body.insertBefore(mainView.element, gameCanvas);
  trace("Added Debug to the current scene.");

  setupMouseEvents();
 }

 public static function setupMouseEvents() {
  trace("Setup Mouse Event");
  Browser.document.addEventListener(SCustomEvents.MOUSE_DOWN,
   (event : MouseEvent) -> {
    if (Globals.GameMap.mapId() > 0) {
     var mapX = Globals.GameMap.canvasToMapX(event.clientX);
     var mapY = Globals.GameMap.canvasToMapY(event.clientY);
     var gameEvent = Globals.GameMap.eventsXy(mapX, mapY).shift();
     if (gameEvent != null) {
      setEventInformation(gameEvent);
     }
    }
   }, {passive: false});
 }

 public static function setMapInfo(map: GameMap) {
  mainView.setMapName(map.displayName());
  mainView.setMapWidth(map.width());
  mainView.setMapHeight(map.height());
 }

 public static function setPartyInfo(party: GameParty) {
  mainView.setNumMembers(party.members().length);
  mainView.setGold(party.gold());
  mainView.setPartyMembers(party.members());
 }

 public static function setEventInformation(event: GameEvent) {
  mainView.setEventName(event.event().name);
  mainView.setEventSpriteSheetName(event.characterName(),
   event.characterIndex());
  mainView.setEventId(event.eventId());
  mainView.setEventXCoordinate(event.x);
  mainView.setEventYCoordinate(event.y);
  mainView.setEventSpeed(event.moveSpeed());
  mainView.setEventFrequency(event.moveFrequency());
  var eventDyn: Dynamic = event;
  mainView.setEventPriority(eventDyn._priorityType);
 }
}
