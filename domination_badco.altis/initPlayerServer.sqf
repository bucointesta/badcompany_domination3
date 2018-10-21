// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerServer.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerServer.sqf"];
__TRACE_1("","_this")

params ["_pl"];

//exit the script if the client is Headless
if (str _pl == "HC_D_UNIT") exitWith {
	d_HC_CLIENT_OBJ_OWNER = owner HC_D_UNIT;
	__TRACE_1("","d_HC_CLIENT_OBJ_OWNER")
};

private _name = name _pl;
private _uid = getPlayerUID _pl;

/*
object d_player_store is a sort of player database
each variable in this object is an array wich name is the uid of the player joining
the array is initialized like this:
0)  d_autokicktime = i suppose its a variable you can set up in mission settings
1)  time = time when player joined server
2)  ??? = empty string
3)  ??? = 0
4)  the whole object player passed initially by the script and converted to a string
5)  sideUnknown
6)  the name of the player as extracted from the argument passed by the script
7)  number of teamkill = 0
8)  number of lives: initially is -2 (infinite) or the value set up in x_setupplayer.sqf
9)  ??? = 0 (relative to time / handledisconnect)
10) ??? = empty string
11) loadout = empty array
12) score = player's score (update every 1 to maxplayer seconds) 
13) prison_cell = number of prison's slot, 0 if free
14) out_prison = used to calculate the time player has passed in prison
*/
private _p = d_player_store getVariable _uid;
private _f_c = false;

/*
if you cant find any variable into object d_player_stored called as the player uid, 
then 
	create a new variable with uid as name and initialize it
else
	- check in d_player_store if player changed his name and in case display a message that he has changed his name
	- if time since the mission started - d_player_store(9) is greater than 600, set the lives of player to maximum
	- refresh the entry for the player in d_player_object (array position 1,4,6)
	
*/
if (isNil "_p") then {
	_p = [d_AutoKickTime, time, "", 0, str _pl, sideUnknown, _name, 0, [-2, xr_max_lives] select (xr_max_lives != -1), 0, "", [], [], 0];
	d_player_store setVariable [_uid, _p];
	_f_c = true;
	__TRACE_3("Player not found","_uid","_name","_p")
} else {
	__TRACE_1("player store before change","_p")
	if (_name != _p select 6) then {
		[format [localize "STR_DOM_MISSIONSTRING_506", _name, _p select 6], "GLOBAL"] remoteExecCall ["d_fnc_HintChatMsg", [0, -2] select isDedicated];
		diag_log format [localize "STR_DOM_MISSIONSTRING_942", _name, _p select 6, _uid];
	};
	if (time - (_p select 9) > 600) then {
		_p set [8, xr_max_lives];
	};
	_p set [1, time];
	_p set [4, str _pl];
	_p set [6, _name];
	__TRACE_1("player store after change","_p")
};

//execute x_client/x_f/fn_player_stuff.sqf on player's PC
_p remoteExecCall ["d_fnc_player_stuff", owner _pl];


if (d_database_found) then {
	//private _dbresult = parseSimpleArray ("extdb3" callExtension format ["0:dom:playerGet:%1", _uid]);
	//private _dbresult = parseSimpleArray ("extdb3" callExtension format ["0:dom:playerExists:%1", _uid]);
	private _dbresult = parseSimpleArray ("extdb3" callExtension format ["0:dom:playerGetTS:%1", _uid]);
	//private _dbresult = parseSimpleArray ("extdb3" callExtension format ["0:dom:playerGetPT:%1", _uid]);
	__TRACE_1("","_dbresult")
	if (_dbresult select 0 == 1) then {
		//if !(((_dbresult select 1) select 0) select 0) then {
		if (_dbresult select 1 isEqualTo []) then {
			// create new database entry for UID
			__TRACE("creating new db entry");
			"extdb3" callExtension format ["1:dom:playerInsert:%1:%2", _uid, _name];
		} else {
			__TRACE("adding nums played for player in db");
			"extdb3" callExtension format ["1:dom:numplayedAdd:%1:%2", _name, _uid];
			if (d_set_pl_score_db && {_f_c && {isNil {d_player_store getVariable (_uid + "_scores")}}}) then {
				__TRACE("Adding score");
				#ifdef __DEBUG__
				private _tspp = ((_dbresult select 1) select 0) select 0;
				__TRACE_1("","_tspp")
				__TRACE_1("","score _pl")
				#endif
				d_player_store setVariable [_uid + "_scores", [0, 0, 0, 0, 0, ((_dbresult select 1) select 0) select 0]];
				[_pl, ((_dbresult select 1) select 0) select 0] spawn {
					params ["_pl", "_tsp"];
					sleep 5;
					_pl addScore (_tsp - score _pl);
				};
			};
		};
		_dbresult = parseSimpleArray ("extdb3" callExtension format ["0:dom:playerGet:%1", _uid]);
		__TRACE_1("","_dbresult")
		if (_dbresult select 0 == 1) then { 
			[missionNamespace, ["d_pl_db_mstart", (_dbresult select 1) select 0]] remoteExecCall ["setVariable", _pl];
		};
	};
};

_pl spawn {
	sleep 1;
	[_this] call d_fnc_addceo;
};

if ((_p select 13) == 0) then {_pl setVariable ["d_isinprison", false]} else {_pl setVariable ["d_isinprison", true]};

/*if (str _pl == "d_leader_1") then {if (["IsGroupRegistered", "Alpha"] call BIS_fnc_dynamicGroups) then {["SwitchLeader", "Alpha", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Alpha", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_leader_2") then {if (["IsGroupRegistered", "Bravo"] call BIS_fnc_dynamicGroups) then {["SwitchLeader", "Bravo", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Bravo", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_leader_3") then {if (["IsGroupRegistered", "Charlie"] call BIS_fnc_dynamicGroups) then {["SwitchLeader", "Charlie", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Charlie", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_leader_4") then {if (["IsGroupRegistered", "Delta"] call BIS_fnc_dynamicGroups) then {["SwitchLeader", "Delta", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Delta", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_leader_5") then {if (["IsGroupRegistered", "Echo"] call BIS_fnc_dynamicGroups) then {["SwitchLeader", "Echo", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Echo", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_leader_6") then {if ("Foxtrot" in (["GetAllGroups"] call BIS_fnc_dynamicGroups)) then {["SwitchLeader", "Foxtrot", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["111thID", "Foxtrot", true]]] call BIS_fnc_dynamicGroups}};
if (str _pl == "d_badco_1") then {if ("Bad Company" in (["GetAllGroups"] call BIS_fnc_dynamicGroups)) then {["SwitchLeader", "Bad Company", _pl] call BIS_fnc_dynamicGroups} else {["RegisterGroup", [group d_leader_1, d_leader_1, ["Curator", "d_badco_1", true]]] call BIS_fnc_dynamicGroups}};*/

_pl call d_fnc_prison_check;

diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerServer.sqf processed"];