// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dosshowhuddo2spawn.sqf"
#include "..\..\x_setup.sqf"

waitUntil {time >= d_pnhuddo2_endtime};
d_showPlayerNameRSC_shown = false;
"d_showPlayerNameRsc" cutFadeOut 0;