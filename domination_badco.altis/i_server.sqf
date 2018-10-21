// d_init include server
#define THIS_FILE "i_server.sqf"
#include "x_setup.sqf"


d_bap_counter = 0;
d_bonus_create_pos = markerPos "d_bonus_create_pos";
deleteMarker "d_bonus_create_pos";
d_bonus_air_positions = [];
for "_i" from 1 to 10000 do {
	private _mna = format ["d_bonus_air_positions_%1", _i];
	if (markerPos _mna isEqualTo [0,0,0]) exitWith {};
	d_bonus_air_positions pushBack [markerPos _mna, markerDir _mna];
	deleteMarker _mna;
};

d_bvp_counter = 0;
d_bonus_vec_positions = [];
for "_i" from 1 to 10000 do {
	private _mna = format ["d_bonus_vec_positions_%1", _i];
	if (markerPos _mna isEqualTo [0,0,0]) exitWith {};
	d_bonus_vec_positions pushBack [markerPos _mna, markerDir _mna];
	deleteMarker _mna;
};

// add some random patrols on the island
// if the array is empty, no patrols
// simply place a rectangular marker called "d_isledefense_marker", marker text = number of patrols
if (d_WithIsleDefense == 0) then {
	private _mna = "d_isledefense_marker";
	if (markerPos _mna isEqualTo [0,0,0]) exitWith {
		d_with_isledefense = [];
	};
	private _msize = markerSize _mna;
	d_with_isledefense = [markerPos _mna, _msize param [0], _msize param [1], markerDir _mna, parseNumber (markerText _mna)];
	deleteMarker _mna;
} else {
	d_with_isledefense = [];
};

__TRACE_1("","d_with_isledefense")

if (d_MissionType != 2) then {
	0 spawn {
		scriptName "spawn_ServicePoint_Building";
		private _stype = [d_servicepoint_building] call BIS_fnc_simpleObjectData;
		private _pos = [];
		private _fac = objNull;
		
		if !((d_service_buildings select 0) isEqualTo []) then {
			_pos = (d_service_buildings select 0) select 0;
			_pos set [2, 3.3];
			_fac = createSimpleObject [_stype select 1, _pos];
			_fac setDir ((d_service_buildings select 0) select 1);
			_fac setPos _pos;
		};

		if !((d_service_buildings select 1) isEqualTo []) then {
			_pos = (d_service_buildings select 1) select 0;
			_pos set [2, 3.3];
			_fac = createSimpleObject [_stype select 1, _pos];
			_fac setDir ((d_service_buildings select 1) select 1);
			_fac setPos _pos;
		};

		if !((d_service_buildings select 2) isEqualTo []) then {
			_pos = (d_service_buildings select 2) select 0;
			_pos set [2, 3.3];
			_fac = createSimpleObject [_stype select 1, _pos];
			_fac setDir ((d_service_buildings select 2) select 1);
			_fac setPos _pos;
		};
	};
};

if (d_with_ai) then {
	d_pos_ai_hut = [markerPos "d_pos_aihut", markerDir "d_pos_aihut"];
	d_AI_HUT = createVehicle ["Land_CashDesk_F", d_pos_ai_hut select 0, [], 0, "NONE"];
	d_AI_HUT setDir (d_pos_ai_hut select 1);
	d_AI_HUT setPos (d_pos_ai_hut select 0);
	d_AI_HUT addEventHandler ["handleDamage", {0}];
	publicVariable "d_AI_HUT";
	["d_RecruitB_100010000", d_pos_ai_hut select 0, "ICON","ColorYellow", [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_313", 0, "mil_dot"] call d_fnc_CreateMarkerGlobal;
};
deleteMarker "d_pos_aihut";

if (isDedicated) then {
	deleteMarkerLocal "d_player_ammobox_pos";
};

if (!isServer) exitWith {};

private _civcenter = createCenter civilian;

private _opforcenter = createCenter opfor;
private _independentcenter = createCenter independent;
blufor setFriend [opfor, 0];
opfor setFriend [blufor, 0];
blufor setFriend [independent, 1];
independent setFriend [blufor, 1];
opfor setFriend [independent, 0];
independent setFriend [opfor, 0];
