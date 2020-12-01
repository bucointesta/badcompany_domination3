#define __WAITFORHINTCCLOSED uisleep 0.1; (findDisplay 72) displayAddEventHandler ["KeyDown", {if ((_this select 1) == 1) then {true} else {false}}]; uisleep 3; _timeout = time + 20; waitUntil {((isnull findDisplay 57) && {isnull findDisplay 72}) || {time > _timeout}}; if (time > _timeout) then {(findDisplay 57) closeDisplay 1; (findDisplay 72) closeDisplay 1;}

d_tutorialStartingPos = getpos player;
tutorialError = true;
player forceWalk true;
0 fadeSound 0;
enableRadio false;
showChat false;
uisleep 3;
//"d_introtxt1" cutText [format [localize "STR_DOM_MISSIONSTRING_1434", actionKeysNames "TeamSwitch"], "PLAIN"];

disableSerialization;
closeDialog 0;
uisleep 1;
// disable Esc key on main display
tutorialEscEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {if ((_this select 1) == 1) then {true} else {false}}];

tutorialBackgroundEffect = ppEffectCreate ["ColorCorrections", 1587];
tutorialBackgroundEffect ppEffectEnable true;
tutorialBackgroundEffect ppEffectAdjust [0, 0, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
tutorialBackgroundEffect ppEffectCommit 0;

_keyArr = actionKeysNamesArray ["TeamSwitch", 1];
_key = "undefined";
if ((count _keyArr) > 0) then {
	_key = _keyArr select 0;
};

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#FFFFFF' shadow='1' shadowColor='#000000' size='1.0'>Welcome to Bad Company Domination, an Invade &amp; Annex type of mission, customized by Bad Company to give you the best casual teamwork environment Arma 3 can offer!</t>
<br/><br/><t color='#FFFFFF' shadow='1' shadowColor='#000000' size='0.7'>Click 'continue' to move on</t>";
__WAITFORHINTCCLOSED;
uisleep 1;

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>This server offers you different roles to choose from, which will all give you different abilities.</t>
<br/><br/><t color='#FF4444' shadow='1' shadowColor='#000000' size='1.2'>You can change your role at any time, by exiting back to the server lobby and picking a different slot.</t>";
__WAITFORHINTCCLOSED;
uisleep 3;

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText format ["<t color='#FF22FF' shadow='1' shadowColor='#000000' size='1.2'>Press and hold down the  %1  button (your TeamSwitch key) to show the mission menu on the top left of your screen.</t>
<br/><br/><t color='#FF2222' shadow='1' shadowColor='#000000' size='3.0' align='center'>%1</t>", _key];
__WAITFORHINTCCLOSED;
uisleep 10;
_timeout = time + 10;
waitUntil {((!dialog) && {isnull findDisplay 60490}) || {time > _timeout}};
closeDialog 0;
(findDisplay 60490) closeDisplay 0;
uisleep 1;

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText format ["<t color='#FF2222' shadow='1' shadowColor='#000000' size='1.2'>Use the mission menu to join/create a squad, put on earplugs, change rendering (view) distance or show current mission status.</t>
<br/><br/><t color='#FF2222' shadow='1' shadowColor='#000000' size='3.0' align='center'>Remember, PRESS and HOLD %1 </t>", _key];
__WAITFORHINTCCLOSED;
uisleep 10;
_timeout = time + 10;
waitUntil {((!dialog) && {isnull findDisplay 60490}) || {time > _timeout}};
closeDialog 0;
uisleep 1;

_keyArr = actionKeysNamesArray ["showMap", 1];
_key = "undefined";
if ((count _keyArr) > 0) then {
	_key = _keyArr select 0;
};
hint "";
showCommandingMenu "";
"Tutorial" hintc parseText format ["<t color='#2222FF' shadow='1' shadowColor='#000000' size='1.2'>Everything you need for the mission is marked on your map. Open your map using the  %1  key whenever you feel lost.</t>", _key];
__WAITFORHINTCCLOSED;
uisleep 0.3;
openMap true;
uisleep 10;
_timeout = time + 10;
waitUntil {(!visibleMap) && {((!dialog) && {isnull findDisplay 60490}) || {time > _timeout}}};
closeDialog 0;
d_still_in_intro = false;
uisleep 1;

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#2222FF' shadow='1' shadowColor='#000000' size='1.2'>You're now at the Virtual Arsenal. You can create a loadout suitable for your chosen role here.</t>
<br/><br/><t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.5' align='center'>Time to gear up!</t>";
__WAITFORHINTCCLOSED;

_box = d_arsenal_boxes select 0;
player setpos ((getpos _box) vectorAdd [(1 max (random 5))*([-1, 1] select ((random 1) < 0.5)), (1 max (random 5))*([-1, 1] select ((random 1) < 0.5)), 0]);
player setDir (player getDir _box);
player switchMove "";

player forceWalk false;
ppEffectDestroy tutorialBackgroundEffect;
2 fadeSound 1;
enableRadio true;
showChat true;

waitUntil {(player distance _box) > 8.5};

0 fadeSound 0;
enableRadio false;
showChat false;
tutorialBackgroundEffect = ppEffectCreate ["ColorCorrections", 1587];
tutorialBackgroundEffect ppEffectEnable true;
tutorialBackgroundEffect ppEffectAdjust [0, 0, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
tutorialBackgroundEffect ppEffectCommit 0;

hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>Now that you've geared up, it's time to join a squad. If there are no squads available, you can create one yourself.
<br/><br/>You can also invite other players to your squad from the group management system.</t>";
__WAITFORHINTCCLOSED;
uisleep 1;
uiNamespace setVariable ["d_dyxn_gr_disp", findDisplay 46 createDisplay "RscDisplayDynamicGroups"];
0 spawn d_fnc_grouplead;
uisleep 2;
waitUntil {isnull findDisplay 60490};

uisleep 2;
_keyArr = actionKeysNamesArray ["TeamSwitch", 1];
_key = "undefined";
if ((count _keyArr) > 0) then {
	_key = _keyArr select 0;
};
hint "";
showCommandingMenu "";
"Tutorial" hintc parseText format ["<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>You can use the mission menu to show the squad management window anytime.</t>
<br/><br/><t color='#FF4444' shadow='1' shadowColor='#000000' size='1.5' align='center'>Remember, PRESS and HOLD  %1  to use the mission menu.</t>", _key];
__WAITFORHINTCCLOSED;

uisleep 2;
hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#7C5295' shadow='1' shadowColor='#000000' size='1.2'>It's now time to join the action!</t>
<br/><br/><t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.4'>If you want to use a vehicle, remember that pilots can give your vehicle an airlift with a cargo plane or heavy cargo helicopter so you don't have to drive long distances.</t>";
__WAITFORHINTCCLOSED;

uisleep 2;
hint "";
showCommandingMenu "";
"Tutorial" hintc parseText "<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>Mobile Headquarters (MHQ) vehicles allow you to fast travel to their location when deployed.
<br/><br/>You can also respawn on them when you die.</t>";
__WAITFORHINTCCLOSED;

uisleep 2;
_keyArr = actionKeysNamesArray ["showMap", 1];
_key = "undefined";
if ((count _keyArr) > 0) then {
	_key = _keyArr select 0;
};
hint "";
showCommandingMenu "";
"Tutorial" hintc parseText format ["<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>It's up to your team to deploy an MHQ near your area of operations to ease logistics.
<br/><br/>Head to the Teleporter now and see if there is an MHQ available that you can fast travel to.</t>
<br/><br/><t color='#FF4444' shadow='1' shadowColor='#000000' size='1.5' align='center'>Remember, press  %1  to open the map and find your way around base.</t>", _key];
__WAITFORHINTCCLOSED;

d_tutorialMHQNotDone = true;

d_tutorialMHQ = {
	disableSerialization;	
	tutorialError = true;
	player forceWalk true;
	0 fadeSound 0;
	enableRadio false;
	showChat false;
	closeDialog 0;
	xr_phd_invulnerable = true;
	tutorialBackgroundEffect = ppEffectCreate ["ColorCorrections", 1587];
	tutorialBackgroundEffect ppEffectEnable true;
	tutorialBackgroundEffect ppEffectAdjust [0, 0, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
	tutorialBackgroundEffect ppEffectCommit 0;
	uisleep 1;
	
	_keyArr = actionKeysNamesArray ["Action", 1];
	_key = "undefined";
	if ((count _keyArr) > 0) then {
		_key = _keyArr select 0;
	};
	hint "";
	showCommandingMenu "";
	"Tutorial" hintc parseText "<t color='#7C5295' shadow='1' shadowColor='#000000' size='1.2'>The MHQ allows you to create a vehicle.</t>";
	__WAITFORHINTCCLOSED;
	uisleep 0.1;
	
	hint "";
	showCommandingMenu "";
	"Tutorial" hintc parseText format ["<t color='#FFFF00' shadow='1' shadowColor='#000000' size='1.2'>Look at the MHQ and you will see the 'MHQ Menu' text.
	<br/><br/>Use the  %1  button while looking at the MHQ to access the MHQ menu.</t>", _key];
	__WAITFORHINTCCLOSED;
	uisleep 0.1;
	
	hint "";
	showCommandingMenu "";
	"Tutorial" hintc parseText "<t color='#22FFFF' shadow='1' shadowColor='#000000' size='1.2'>Try creating a vehicle from the MHQ menu now!</t>";
	__WAITFORHINTCCLOSED;
	
	2 fadeSound 1;
	enableRadio true;
	showChat true;
	player forceWalk false;
	ppEffectDestroy tutorialBackgroundEffect;
	xr_phd_invulnerable = false;
	tutorialError = false;
};

2 fadeSound 1;
enableRadio true;
showChat true;
uisleep 2;
(findDisplay 46) displayRemoveEventHandler ["KeyDown",tutorialEscEH];
ppEffectDestroy tutorialBackgroundEffect;
xr_phd_invulnerable = false;
tutorialError = false;
