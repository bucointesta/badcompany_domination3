// by Xeno
#define THIS_FILE "fn_repengineer.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if (!d_eng_can_repfuel && {!(player distance2D D_TR7 < 21 || {player distance2D D_TR8 < 21})}) exitWith {
	hintSilent (localize "STR_DOM_MISSIONSTRING_324");
};

private _exitit = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 0)) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_325", score player, (d_ranked_a select 0)];
		_exitit = true;
	};
	if (time >= d_last_base_repair) then {d_last_base_repair = -1};
};
if (_exitit) exitWith {};

if (d_with_ranked && {player inArea d_base_array && {d_last_base_repair != -1}}) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_326");
};

if (d_with_ranked && {player inArea d_base_array}) then {d_last_base_repair = time + 300};

private _caller = param [1];
_caller removeAction (param [2]);
if !(local _caller) exitWith {};

private _rep_count = if (d_objectID2 isKindOf "Air") then {
	0.1
} else {
	if (d_objectID2 isKindOf "Tank") then {
		0.2
	} else {
		0.3
	};
};

private _fuel = fuel d_objectID2;
private _damage = damage d_objectID2;

hintSilent format [localize "STR_DOM_MISSIONSTRING_327", _fuel, _damage];
private _type_name = [typeOf d_objectID2, "CfgVehicles"] call d_fnc_GetDisplayName;
systemChat format [localize "STR_DOM_MISSIONSTRING_328", _type_name];
private _damage_ok = false;
private _fuel_ok = false;
d_cancelrep = false;
private _breaked_out = false;
private _rep_action = player addAction[format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_329"], {d_cancelrep = true}];
for "_wc" from 1 to ceil ((_damage / _rep_count) max ((1 - _fuel) / _rep_count)) do {
	if (!alive player || {d_cancelrep}) exitWith {player removeAction _rep_action};
	systemChat (localize "STR_DOM_MISSIONSTRING_330");
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 1;
	waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic" || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}};
	if (!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}) exitWith {
		_breaked_out = true;
		player removeAction _rep_action;
	};
	if (d_cancelrep) exitWith {
		_breaked_out = true;
		systemChat (localize "STR_DOM_MISSIONSTRING_332");
		player removeAction _rep_action;
	};
	if (!isNull objectParent player) exitWith {
		_breaked_out = true;
		hintSilent (localize "STR_DOM_MISSIONSTRING_331");
	};
	if (!_fuel_ok) then {_fuel = _fuel + _rep_count};
	if (_fuel >= 1 && {!_fuel_ok}) then {_fuel = 1;_fuel_ok = true};
	if (!_damage_ok) then {_damage = _damage - _rep_count};
	if (_damage <= 0.01 && {!_damage_ok}) then {_damage = 0;_damage_ok = true};
	if (_damage > 0) then {
		[d_objectID2, _damage] remoteExecCall ["setDamage"];
	};
	if (fuel d_objectID2 < 1) then {
		[d_objectID2, _fuel] remoteExecCall ["setFuel", d_objectID2];
	};
	hintSilent format [localize "STR_DOM_MISSIONSTRING_327", _fuel, _damage];
};
if (_breaked_out) exitWith {};
d_eng_can_repfuel = false;
player removeAction _rep_action;
if (!alive player) exitWith {player removeAction _rep_action};
if (d_with_ranked) then {
	private _parray = d_ranked_a select 1;
	private _addscore = if (d_objectID2 isKindOf "Air") then {
		_parray select 0
	} else {
		if (d_objectID2 isKindOf "Tank") then {
			_parray select 1
		} else {
			if (d_objectID2 isKindOf "Car") then {
				_parray select 2
			} else {
				_parray select 3
			};
		};
	};
	if (_addscore > 0) then {
		[player, _addscore] remoteExecCall ["addScore", 2];
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_333", _addscore];
	};
};

systemChat format [localize "STR_DOM_MISSIONSTRING_334", _type_name];
