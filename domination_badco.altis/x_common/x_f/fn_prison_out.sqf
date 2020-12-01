// by Bucointesta
//#define __DEBUG__
#define _this_FILE "fn_prison_out.sqf"
#include "..\..\x_setup.sqf"

private _p = d_player_store getVariable (getPlayerUID _this);


(d_prison select (_p select 13)) set [1, true];
_p set [7, 0];
_p set [13, 0];

