// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_arifire.sqf"
#include "..\..\x_setup.sqf"

if (!isServer || {!d_ari_available}) exitWith {};

params ["_ari_type", "_ari_salvos", "_arti_operator", "_sel_ari_mkr"];

private _ari_tgt_pos = markerPos _sel_ari_mkr;
private _topicside_arti = d_kb_topic_side_arti;
private _topicside = d_kb_topic_side;
private _logic = d_kb_logic2;
private _logic1 = d_kb_logic1;
private _channel = d_kbtel_chan;

__TRACE_3("","_ari_type","_ari_salvos","_arti_operator")
__TRACE_2("","_sel_ari_mkr","_ari_tgt_pos")

d_ari_available = false; publicVariable "d_ari_available";
remoteExecCall ["d_fnc_updatesupportrsc", [0, -2] select isDedicated];

sleep 9.123;

private _aop = missionNamespace getVariable _arti_operator;
if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
_logic1 kbTell [_aop,_topicside_arti,"ArtilleryRoger",["1","",localize "STR_DOM_MISSIONSTRING_934",[]],_channel];
sleep 1;
private _aristr = localize "STR_DOM_MISSIONSTRING_937";
_logic1 kbTell [_logic, _topicside, "ArtilleryUnAvailable", ["1", "", _aristr, []],_channel];

sleep 6.54;
private _aop = missionNamespace getVariable _arti_operator;
if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
_logic1 kbTell [_aop, _topicside_arti,"ArtilleryExecute", ["1", "", _aristr, []], ["2", "", getText(configFile>>"CfgMagazines">>_ari_type>>"displayname"), []], ["3", "", str _ari_salvos, []], _channel];

sleep 8 + (random 7);

private _ari_vecs = [];
private _avec_str = "d_artyvec_%1";
for "_i" from 0 to 30 do {
	private _vvx = missionNamespace getVariable format [_avec_str, _i];
	if (!isNil "_vvx") then {
		_ari_vecs pushBack _vvx;
		_vvx enableSimulationGlobal true;
		_vvx setVariable ["d_who_fired", _arti_operator];
	};
};

__TRACE_1("","_ari_vecs")

if (_ari_vecs isEqualTo []) exitWith {
	d_ari_available = true; publicVariable "d_ari_available";
	remoteExecCall ["d_fnc_updatesupportrsc", [0, -2] select isDedicated];
	private _aop = missionNamespace getVariable _arti_operator;
	if (isNil "_aop" || {isNull _aop}) exitWith {};
	[player , localize "STR_DOM_MISSIONSTRING_1519"] remoteExecCall ["sideChat", _aop];
};

private _eta_time = (_ari_vecs select 0) getArtilleryETA [_ari_tgt_pos, _ari_type];
__TRACE_1("","_eta_time")

//_inrange = _ari_tgt_pos inRangeOfArtillery [[(_ari_vecs select 0)], _ari_type];
//__TRACE_2("","_eta_time","_inrange")

private _ammoconf = configFile>>"CfgAmmo">>getText(configFile>>"CfgMagazines">>_ari_type>>"ammo");
private _is_flare = getText(_ammoconf>>"effectFlare") == "CounterMeasureFlare";
private _is_smoke = getText(_ammoconf>>"submunitionAmmo") == "SmokeShellArty";

__TRACE_3("","_ammoconf","_is_flare","_is_smoke")

if (getText(_ammoconf>>"submunitionAmmo") == "Mo_cluster_AP") then {
	_ari_vecs resize 1;
	__TRACE("is cluster")
};

private _aweapon = getArray(configFile>>"CfgVehicles">>(typeOf (_ari_vecs select 0))>>"Turrets">>"MainTurret">>"weapons") select 0;
private _reloadtime = getNumber(configFile>>"CfgWeapons">>_aweapon>>"reloadTime");
__TRACE_2("","_aweapon","_reloadtime")

for "_series" from 1 to _ari_salvos do {
	{	
		_x setVehicleAmmo 1;
		_x setFuel 1;
		_x setDamage 0;
		
		private _radius = 20 + random 10;
		private _angle = floor random 360;
		
		_x doArtilleryFire [[(_ari_tgt_pos select 0) - ((random _radius) * sin _angle), (_ari_tgt_pos select 1) - ((random _radius) * cos _angle), 0], _ari_type, 1];
		sleep 0.2;
	} forEach _ari_vecs;
	
	private _aop = missionNamespace getVariable _arti_operator;
	if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
	_logic1 kbTell [_aop,_topicside_arti,"ArtilleryOTW",["1","",str _series,[]],["2","",str(round _eta_time),[]],_channel];

	sleep _eta_time;
	
	private _aop = missionNamespace getVariable _arti_operator;
	if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
	_logic1 kbTell [_aop,_topicside_arti,"ArtillerySplash",["1","",str _series,[]],_channel];

	if (_series < _ari_salvos) then {
		private _aop = missionNamespace getVariable _arti_operator;
		if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
		_logic1 kbTell [_aop,_topicside_arti,"ArtilleryReload",["1","",_aristr,[]],_channel];
		sleep _reloadtime;
	};
};

{
	_x enableSimulationGlobal false;
	_x setVariable ["d_who_fired", nil];
	false
} count _ari_vecs;
_ari_vecs = nil;

sleep 3;

private _aop = missionNamespace getVariable _arti_operator;
if (isNil "_aop" || {isNull _aop}) then {_aop = _logic};
_logic1 kbTell [_aop,_topicside_arti,"ArtilleryComplete",["1","",_aristr,[]],_channel];

if (!(markerPos _sel_ari_mkr isEqualTo [0,0,0]) && {_ari_tgt_pos isEqualTo (markerPos _sel_ari_mkr)}) then {
	deleteMarker _sel_ari_mkr;
};

[_ari_salvos, _aristr, _logic1] spawn {
	scriptName "spawn_x_arifire_artiavailable";
	params ["_ari_salvos", "_aristr"];
	sleep (300 + ((_ari_salvos - 1) * 200)) + (random 60) + (if (d_MissionType != 2) then {0} else {300});
	d_ari_available = true; publicVariable "d_ari_available";
	private _channel = d_kbtel_chan;
	remoteExecCall ["d_fnc_updatesupportrsc", [0, -2] select isDedicated];
	(param [2]) kbTell [d_kb_logic2, d_kb_topic_side, "ArtilleryAvailable", ["1", "", _aristr, []],_channel];
};
