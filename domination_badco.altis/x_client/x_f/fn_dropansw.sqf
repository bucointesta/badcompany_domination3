// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dropansw.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

[playerSide, "HQ"] sideChat (switch (_this) do {
	case 0: {localize "STR_DOM_MISSIONSTRING_642"};
	case 1: {localize "STR_DOM_MISSIONSTRING_643"};
	case 2: {localize "STR_DOM_MISSIONSTRING_644"};
	case 3: {localize "STR_DOM_MISSIONSTRING_645"};
	case 4: {localize "STR_DOM_MISSIONSTRING_646"};
});