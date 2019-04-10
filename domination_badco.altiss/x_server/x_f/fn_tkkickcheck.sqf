// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_tkkickcheck.sqf"
#include "..\..\x_setup.sqf"

//assign to variable _tk the killer player's object
private _tk = _this select 2;

//subtracts the points for teamkilling to player's object
_tk addScore (d_sub_tk_points * -1);
//get the killer uid and extract the killer's array from players database
private _uid = getPlayerUID _tk;
__TRACE_2("TKKickCheck","_tk","_uid")
private _p = d_player_store getVariable _uid;
/*add 1 to the total teamkilling made by the player (position 7 of player's array)
if the total teamkilling reach or get above the allowed server's limit,
then
	- log the event
	- display a message on each client
	- call function prison_check
	if a database is connected, update the teamkill count
*/
if (!isNil "_p") then {
	private _numtk = (_p # 7) + 1;
	_p set [7, _numtk];
	if (_numtk >= d_maxnum_tks_forkick) exitWith {
		remoteExecCall ["d_fnc_save_layoutgear", _tk];
		private _pna = _p select 6;
		[format [localize "STR_DOM_MISSIONSTRING_507", _pna, _numtk], "GLOBAL"] remoteExecCall ["d_fnc_HintChatMsg", [0, -2] select isDedicated];
		diag_log format ["killer is %1", _tk];
		_tk call d_fnc_prison_check; //	"LOSER" remoteExecCall ["endMission", _tk];
		if (d_database_found) then {
			"extdb3" callExtension format ["1:dom:teankillsAdd:%1", _uid];
		};
	};
};