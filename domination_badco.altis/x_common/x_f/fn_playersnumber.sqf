// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_playersnumber.sqf"
#include "..\..\x_setup.sqf"

if (isMultiplayer) then {

	count (allPlayers - (entities "HeadlessClient_F"))

} else {

	20

}
