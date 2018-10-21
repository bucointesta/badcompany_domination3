// by Xeno
#define THIS_FILE "x_intro.sqf"
#include "..\x_setup.sqf"

if (isDedicated) exitWith {};

diag_log [diag_frameno, diag_ticktime, time, "Dom intro started"];

enableRadio false;

disableSerialization;

waitUntil {sleep 0.112;!isNil "d_preloaddone"};
sleep 0.01;
1 fadeSound 1;

d_still_in_intro = true;

showCinemaBorder true;

createDialog "d_RscAnimatedLetters";
setMousePosition [1, 1];
private _line = 0;
d_animL_i = 0;
titleText ["", "BLACK IN",0];
"BIS_layerStatic" cutRsc ["RscStatic", "PLAIN"];

private _pspsxx = getPosWorld player;
private _arrow_over_head = "Sign_Arrow_Large_F" createVehicleLocal [0,0,0];
_arrow_over_head setPos [_pspsxx select 0, _pspsxx select 1, 2.2];
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
"dynamicBlur" ppEffectCommit 15;

//playMusic "LeadTrack01b_F";
playMusic "d_intro_music";

//if (sunOrMoon < 0.99) then {camUseNVG true};

d_intro_color = switch (d_own_side) do {case "WEST": {[0.85,0.88,1,1]};case "EAST": {[1,0.36,0.34,1]};case "GUER": {[1,1,0,1]};};
_camstart = markerPos "d_camstart";
deleteMarkerLocal "d_camstart";

private _camera = "camera" camCreate [_camstart select 0, (_camstart select 1) + 1, 120];
_camera camSetTarget [_pspsxx select 0, _pspsxx select 1 , 1.5];
_camera camSetFov 0.7;
_camera cameraEffect ["INTERNAL", "Back"];
_camera camCommit 1;
waitUntil {camCommitted _camera};

private _str2 = "";
private _str = "Bad Company Gaming Community";
private _start_pos = 0;
if (d_with_ai) then {if (_str2 != "") then {_str2 = _str2 + " AI"} else {_str2 = _str2 + "AI"}};
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

0 = [parseText format [ "<br/><t font='PuristaMedium' align='left' size='2.3'> Welcome to Domination! 3</t><br/>  <t align='left' size='1'>  Version 3.74  </t>"], [safeZoneX + 0.1,safeZoneY + safeZoneH - 0.2,0.9,0.3], nil, 5, 1, 0]  spawn BIS_fnc_textTiles;

_camera camSetTarget player;
_p_tpos = [_pspsxx select 0, _pspsxx select 1, 2];
_camera camSetPos _p_tpos;
_camera camCommit 18;

0 spawn {
	disableSerialization;
	sleep 3;
	private _control = (uiNamespace getVariable "d_DomLabel") displayCtrl 50;
	private _posdom = ctrlPosition _control;
	_control ctrlSetPosition [(_posdom select 0) - 0.1, _posdom select 1];
	_control ctrlCommit 0.3;
	waitUntil {ctrlCommitted _control};
	private _control2 = (uiNamespace getVariable "d_DomThree") displayCtrl 50;
	private _pos = ctrlPosition _control2;
	_control2 ctrlSetPosition [0.69, _pos select 1];
	_control2 ctrlCommit 0.5;
	waitUntil {ctrlCommitted _control2};
	"d_Lightning1" cutRsc ["d_Lightning1", "PLAIN"];
	"d_Eyeflare" cutRsc ["d_Eyeflare", "PLAIN"];
	sleep 0.1;
	playSound "d_Thunder";
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

private _uidcheck_done = false;
if (d_reserved_slot != "" && {str player == d_reserved_slot}) then {
	_uidcheck_done = true;
	execVM "x_client\x_reservedslot.sqf";
};
if (!_uidcheck_done && {!(d_uid_reserved_slots isEqualTo [])} && {!(d_uids_for_reserved_slots isEqualTo [])}) then {
	d_uid_reserved_slots = d_uid_reserved_slots apply {toUpper _x};
	if ((toUpper str player) in d_uid_reserved_slots) then {
		if !(getPlayerUID player in d_uids_for_reserved_slots) then {
			execVM "x_client\x_reservedslot2.sqf";
		};
		d_uid_reserved_slots = nil;
		d_uids_for_reserved_slots = nil;
	};
};

d_still_in_intro = false;

sleep 5;

[
	[
		[localize "STR_DOM_MISSIONSTRING_265","<t size='1.0' font='RobotoCondensed'>%1</t><br/>", 0],
		[name player,"<t size='1.0' font='RobotoCondensed'>%1</t><br/>", 5],
		[format [localize "STR_DOM_MISSIONSTRING_1434", actionKeysNames "TeamSwitch"],"<t size='0.5'>%1</t><br/>", 27]
	],
	-safezoneX,0.85,"<t color='#FFFFFFFF' align='right'>%1</t>"
] spawn bis_fnc_typeText;

sleep 5;
//"d_introtxt1" cutText [format [localize "STR_DOM_MISSIONSTRING_1434", actionKeysNames "TeamSwitch"], "PLAIN"];

xr_phd_invulnerable = false;

uiNamespace setVariable ["D_DomLabel", nil];
uiNamespace setVariable ["d_DomThree", nil];

if (str player == "d_admin") exitWith {diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"]};

_backgroundEffect = ppEffectCreate ["ColorCorrections", 1587];
_backgroundEffect ppEffectEnable true;
_backgroundEffect ppEffectAdjust [0.1, 0.5, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
_backgroundEffect ppEffectCommit 0;

if (str player in d_leaders) exitWith {	
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a TEAM-LEADER. Your main role is to organize your team in order to accomplish mission objectives.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, grenade launchers and the PCML launcher (disposable).</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders and laser designators.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_riflemen) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a RIFLEMAN. Your role is to be the main manpower in combat to help achieve your team's objectives.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and the PCML launcher (disposable).</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_grenadiers) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a GRENADIER. Your main role is to provide support to your team in medium range combat with smoke and HE grenades. Use your HE grenades as a force multiplier and your smokes for concealment and to mark targets.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, grenade launchers and the PCML launcher (disposable).</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_autoriflemen) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an AUTOMATIC RIFLEMAN. Your main role is to support friendlies by suppressing enemy contacts at all ranges.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, machine guns and the PCML launcher (disposable).</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light, medium and heavy armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders.</t>";
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
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can only wear light armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can only carry small backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders.</t>";
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
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders and laser designators.</t>";
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
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_saboteurs) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are a SABOTEUR. Your main role is to infiltrate enemy lines and destroy targets with explosives.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles, the PCML launcher (disposable) and some special-purpose weapons and uniforms.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders.</t>";
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
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
  <t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small and medium backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use medkits.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_is_engineer) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an ENGINEER. Your main role is to repair friendly vehicles, destroy enemy targets with explosives and defuse enemy mines.</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols, submachineguns, assault rifles and the PCML launcher (disposable).</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear light and medium armor.</t><br/>
	<t color='#FF4030' shadow='1' shadowColor='#000000' size='1.2'>You can carry small, medium and large backpacks.</t><br/>
	<t color='#FF5050' shadow='1' shadowColor='#000000' size='1.2'>You can use rangefinders and toolkits.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};
if (str player in d_attack_pilots) exitWith {
	"Welcome to Bad Company Domination!" hintc parseText
	"<t size='7' shadow='0' align='center'> <img image='pics\dthree.paa' /></t><br/><br/>
	<t color='#FF5500' shadow='1' shadowColor='#000000' size='1.5'>Press and hold your TeamSwitch key (default: U) to use the Domination menu.</t><br/><br/>
	<t color='#A545FF' shadow='1' shadowColor='#000000' size='1.6'>You are an ATTACK PILOT. Your main role is to provide close air support (ONLY WHEN REQUESTED BY YOUR TEAM - READ THE RULES).</t><br/><br/>
	<t color='#00FF00' shadow='1' shadowColor='#000000' size='1.2'>You can use pistols and submachineguns.</t><br/>
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms and parachutes.</t>";
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
	<t color='#FF3010' shadow='1' shadowColor='#000000' size='1.2'>You can wear pilot uniforms and parachutes.</t>";
	sleep 0.1;
	ppEffectDestroy _backgroundEffect;
	diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];
};