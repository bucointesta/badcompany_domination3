// by Xeno
#define THIS_FILE "x_intro.sqf"
#include "..\x_setup.sqf"

if (isDedicated) exitWith {};

diag_log [diag_frameno, diag_ticktime, time, "Dom intro started"];

enableRadio false;

disableSerialization;

waitUntil {sleep 0.112;!isNil "d_preloaddone"};
sleep 0.01;

//JIP set texture for bad co uniforms
{

	if ((str _x) in d_badcompany) then {
	
		_x setObjectTexture [0, "\A3\Characters_F\Common\Data\basicbody_black_co.paa"];
		_x setObjectTexture [1, "\A3\Characters_F\Common\Data\basicbody_black_co.paa"];
		
	};

} foreach allPlayers;

private _playerUID = getPlayerUID player;

1 fadeSound 1;

if (str player == "d_zeus") exitWith {
	d_still_in_intro = false;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
	zeusDisableUserInput = false;
	if !(_playerUID in zeusers) then {
			endMission "zeusRestriction";
	};
	// A Zeus that doesn't clean up after himself is a filthy Zeus...
	[] spawn {
		while {true} do {
			sleep 10;
			{
				deleteGroup _x;
			} foreach (allgroups select {(local _x) && {(count units _x) == 0}});
		};
	};
};

d_still_in_intro = true;

showCinemaBorder true;

createDialog "d_RscAnimatedLetters";
setMousePosition [1, 1];
private _line = 0;
d_animL_i = 0;
titleText ["", "BLACK IN",0];
"BIS_layerStatic" cutRsc ["RscStatic", "PLAIN"];

private _pspsxx = getPosASL player;
private _arrow_over_head = "Sign_Arrow_Large_F" createVehicleLocal [0,0,0];
_arrow_over_head setPosASL (_pspsxx vectorAdd [0, 0, 2.2]);
_arrow_over_head spawn {
	private _dir = 0;
	private _arr = _this;
	while {!isNull _arr} do {
		_arr setDir _dir;
		_dir = _dir + 1;
		if (_dir == 360) then {_dir = 0};
		sleep 0.005;
	};
};

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0;
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 7.5;

playMusic "d_intro_music";

//if (sunOrMoon < 0.99) then {camUseNVG true};

#ifndef __TT__
d_intro_color = switch (d_own_side) do {case "WEST": {[0.85,0.88,1,1]};case "EAST": {[1,0.36,0.34,1]};case "GUER": {[1,1,0,1]};};
_camstart = markerPos "d_camstart";
deleteMarkerLocal "d_camstart";
#else
private "_camstart";
if (side (group player) == blufor) then {
	d_intro_color = [0,0,1,1];
	_camstart = markerPos "d_camstart";
} else {
	d_intro_color = [1,0,0,1];
	_camstart = markerPos "d_camstart_opfor";
};
deleteMarkerLocal "d_camstart";
deleteMarkerLocal "d_camstart_opfor";
#endif

private _camera = "camera" camCreate [_camstart # 0, (_camstart # 1) + 1, 120];
_camera camSetTarget [_pspsxx # 0, _pspsxx # 1 , (player modelToWorld [0,0,1.5]) # 2];
_camera camSetFov 0.7;
_camera cameraEffect ["INTERNAL", "Back"];
_camera camCommit 1;
waitUntil {camCommitted _camera};

private _str2 = "";
#ifndef __TT__
//private _str = "One Team - " + d_version_string;
private _str = "Bad Company Gaming Community";
private _start_pos = 0;
if (d_with_ai) then {if (_str2 != "") then {_str2 = _str2 + " AI"} else {_str2 = _str2 + "AI"}};
#else
private _str = "Two Teams";
private _sarray = [];
private _start_pos = 8;
#endif
#ifdef __IFA3LITE__
_start_pos = 3;
#endif
#ifdef __RHS__
_start_pos = 0;
#endif
if (d_with_ranked) then {if (_str2 != "") then {_str2 = _str2 + " RA"} else {_str2 = _str2 + "RA"}};
if (d_WithRevive == 0) then {if (_str2 != "") then {_str2 = _str2 + " REVIVE"} else {_str2 = _str2 + "REVIVE"}};
private _start_pos2 = switch (count _str2) do {
	case 2: {11};
	case 3: {11};
	case 4: {10};
	case 5: {10};
	case 6: {9};
	case 7: {9};
	case 8: {8};
	case 9: {8};
	case 10: {8};
	case 11: {7};
	case 12: {6};
	case 13: {5};
	case 14: {5};
	case 15: {4};
	case 16: {3};
	default {0};
};

"d_DomLabel" cutRsc ["d_DomLabel", "PLAIN", 2];
"d_DomThree" cutRsc ["d_DomThree", "PLAIN", 2];
"d_ArmaLogo" cutRsc ["d_ArmaLogo", "PLAIN", 2];
[_start_pos, _str, 5] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
[_start_pos, "www.BadCompanyPMC.com", 6] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
//if (_str2 != "") then {[_start_pos2, _str2, 6] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line}};
switch (d_MissionType) do {
	case 2: {
		[4, localize "STR_DOM_MISSIONSTRING_263", 4] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
	};
	case 1: {
		[4, localize "STR_DOM_MISSIONSTRING_264", 4] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
	};
};

0 = [parseText format [ "<br/><t font='PuristaMedium' align='left' size='2.3'> Welcome to Domination! 3</t><br/>  <t align='left' size='1'>  Version 3.99k  </t>"], [safeZoneX + 0.1,safeZoneY + safeZoneH - 0.2,0.9,0.3], nil, 5, 1, 0]  spawn BIS_fnc_textTiles;

_camera camSetTarget player;
_p_tpos = [_pspsxx # 0, _pspsxx # 1, (player modelToWorld [0,0,2]) # 2];
_camera camSetPos _p_tpos;
_camera camCommit 18;

0 spawn {
	disableSerialization;
	sleep 3;
	private _control = (uiNamespace getVariable "d_DomLabel") displayCtrl 50;
	private _posdom = ctrlPosition _control;
	_control ctrlSetPosition [(_posdom # 0) - 0.1, _posdom # 1];
	_control ctrlCommit 0.3;
	waitUntil {ctrlCommitted _control};
	private _control2 = (uiNamespace getVariable "d_DomThree") displayCtrl 50;
	private _pos = ctrlPosition _control2;
	_control2 ctrlSetPosition [0.69, _pos # 1];
	_control2 ctrlCommit 0.5;
	waitUntil {ctrlCommitted _control2};
	"d_Lightning1" cutRsc ["d_Lightning1", "PLAIN"];
	"d_Eyeflare" cutRsc ["d_Eyeflare", "PLAIN"];
	sleep 0.1;
	playSound "thunder_2";
};

"d_Xlabel" cutRsc ["d_Xlabel", "PLAIN"];
sleep 6;
waitUntil {camCommitted _camera};
deleteVehicle _arrow_over_head;
player cameraEffect ["terminate","back"];
camDestroy _camera;
closeDialog 0;

enableRadio true;
showChat true;
"dynamicBlur" ppEffectEnable false;

#ifndef __IFA3LITE__
if (sunOrMoon < 0.99 && {d_without_nvg == 1 && {player call d_fnc_hasnvgoggles}}) then {player action ["NVGoggles", player]};
#endif

private _uidcheck_done = false;
if (!(d_reserved_slot isEqualTo []) && {str player in d_reserved_slot}) then {
	_uidcheck_done = true;
	execVM "x_client\x_reservedslot.sqf";
};

if (!_uidcheck_done && {!(d_uid_reserved_slots isEqualTo [])} && {!(membersarr isEqualTo [])}) then {
	d_uid_reserved_slots = d_uid_reserved_slots apply {toUpper _x};
	if ((toUpper str player) in d_uid_reserved_slots) then {
		if !(_playerUID in membersarr) then {
			execVM "x_client\x_reservedslot2.sqf";
		} else {
			if (((count (squadParams player)) == 0) || {
				_clanTag = ((squadParams player) select 0) select 0;
				(_clanTag != "Bad Co") || {_clanTag != "B.A.D. PMC"}
			}) then {
				execVM "x_client\x_reservedslot3.sqf";
			};		
		};
		d_uid_reserved_slots = nil;
		membersarr = nil;
	};
};

if ((!isnil "adminarr") && {_playerUID in adminarr}) then {

	d_spectating = false;
	player addAction ["<t color='#CCCC00'>Spectate Players</t﻿﻿>",{d_spectating = true; hintc "To stop spectating, you need to spectate yourself in FIRST PERSON and use your scroll wheel menu options."; sleep 1; waituntil {isnull (findDisplay 57)}; ["Initialize", [player, [side player], false, false, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;},[],-99,false,true,"","!d_spectating"];
	player addAction ["<t color='#FF0000'>Stop Spectating</t﻿﻿>",{d_spectating = false; ["Terminate"] call BIS_fnc_EGSpectator;},[],99,false,true,"","d_spectating"];
		
	player addEventHandler ["Respawn",{
		params ["_unit", "_corpse"];	
		_unit addAction ["<t color='#CCCC00'>Spectate Players</t﻿﻿>",{d_spectating = true; hintc "To stop spectating, you need to spectate yourself in FIRST PERSON and use your scroll wheel menu options."; sleep 1; waituntil {isnull (findDisplay 57)}; ["Initialize", [player, [side player], false, false, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;},[],-99,false,true,"","!d_spectating"];
		_unit addAction ["<t color='#FF0000'>Stop Spectating</t﻿﻿>",{d_spectating = false; ["Terminate"] call BIS_fnc_EGSpectator;},[],99,false,true,"","d_spectating"];
	}];	
		
};

d_still_in_intro = false;

enableSentences false;

sleep 5;

[
	[
		[localize "STR_DOM_MISSIONSTRING_265","<t size='1.0' font='RobotoCondensed'>%1</t><br/>", 0],
		[profileName,"<t size='1.0' font='RobotoCondensed'>%1</t><br/>", 5],
		[localize "STR_DOM_MISSIONSTRING_266","<t size='0.9'>%1</t><br/>", 27]
	],
	-safezoneX,0.85,"<t color='#FFFFFFFF' align='right'>%1</t>"
] spawn bis_fnc_typeText;

sleep 6;
//"d_introtxt1" cutText [format [localize "STR_DOM_MISSIONSTRING_1434", actionKeysNames "TeamSwitch"], "PLAIN"];
xr_phd_invulnerable = false;

uiNamespace setVariable ["D_DomLabel", nil];
uiNamespace setVariable ["d_DomThree", nil];
if (name player == "Error: No unit" || {!isPlayer player}) then {
	hintC "Please rejoin again!!!! Your game has not connected correctly!!!!!";
};

if (str player == "d_admin") exitWith {diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"]};

_backgroundEffect = ppEffectCreate ["ColorCorrections", 1587];
_backgroundEffect ppEffectEnable true;
_backgroundEffect ppEffectAdjust [0.1, 0.5, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
_backgroundEffect ppEffectCommit 0;

if (str player in d_crewmen) exitWith {	
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a CREWMAN. Your main role is to make use of armoured vehicles to support your team.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light armor and crewman helmets.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_riflemen) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a RIFLEMAN. Your role is to be the main manpower in combat to help achieve your team's objectives.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and disposable launchers.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators and you can deploy MAVs.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_grenadiers) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a GRENADIER. Your main role is to provide support to your team in medium range combat with smoke and HE grenades. Use your HE grenades as a force multiplier and your smokes for concealment and to mark targets.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and grenade launchers.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_autoriflemen) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an AUTOMATIC RIFLEMAN. Your main role is to support friendlies by suppressing enemy contacts at all ranges.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and machine guns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_snipers) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a MARKSMAN. Your main role is to support your team by providing precision fire at medium and long range.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, sniper rifles and sniper optics.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can only carry small backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_spotters) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a FORWARD OBSERVER. Your main role is to spot targets for artillery and close air support (CAS).</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and sniper optics.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can only wear light armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can only carry small backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_missilesp) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a MISSILE SPECIALIST. Your main role is to support your team by engaging enemy ground and air vehicles.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and all launchers.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_saboteurs) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a SABOTEUR. Your main role is to infiltrate enemy lines and destroy targets with explosives.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, disposable launchers and some special-purpose weapons and uniforms.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if ((str player) == "d_medpilot") exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a MEDEVAC PILOT. Your main role is to provide rapid air transport for medical operations.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_medics) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a COMBAT MEDIC. Your main role is to support your team by healing and reviving wounded friendlies on the battlefield.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use medkits and laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_is_engineer) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an ENGINEER. Your main role is to repair friendly vehicles, destroy enemy targets with explosives and defuse enemy mines.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns and assault rifles.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use toolkits.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
/*
if (str player in d_attack_pilots) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an ATTACK PILOT. Your main role is to provide close air support (ONLY WHEN REQUESTED BY YOUR TEAM - READ THE RULES).</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_transport_pilots) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a TRANSPORT PILOT. Your main role is to provide air transport for troops and logistics, as well as delivery and retrieval of friendly vehicles.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
*/

if ((str player in d_transport_pilots) || {str player in d_attack_pilots}) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a PILOT. Your primary role is to provide air transport for troops and logistics, as well as delivery and retrieval of friendly vehicles (remember that with more than 25 players online, MHQs will be disabled). Your secondary role is to provide close air support (ONLY WHEN REQUESTED BY YOUR TEAM - READ THE RULES).</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};

diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];