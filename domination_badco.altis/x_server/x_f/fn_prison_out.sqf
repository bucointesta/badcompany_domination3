// by Bucointesta
//#define __DEBUG__
#define _this_FILE "fn_prison_out.sqf"
#include "..\..\x_setup.sqf"

private _p = d_player_store getVariable (getPlayerUID _this);

_this setPos (getMarkerPos "base_spawn_1");
(d_prison select (_p select 13)) set [1, false];
_p set [7, 0];
_p set [13, 0];
"You are released. Please respect fire discipline from now on." remoteExecCall ["hint", _this];
remoteExecCall ["d_fnc_retrieve_layoutgear", _this];

