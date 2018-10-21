// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_playersnumber.sqf"
#include "..\..\x_setup.sqf"

/*
// returns the number of human players currently playing a mission in MP
private _ret = playersNumber opfor + playersNumber blufor + playersNumber independent + playersNumber civilian;
if (d_IS_HC_CLIENT && {_ret > 0}) then {
	_ret = _ret - 1;
};
_ret
*/
count (allPlayers - (entities "HeadlessClient_F"))