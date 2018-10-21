// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_doexechcf.sqf"
#include "..\..\x_setup.sqf"

params ["_type"];

if (_type == 0) then {
	execFSM "fsms\fn_XClearSidemission.fsm";
} else {
	(param [1]) execFSM "fsms\fn_DeleteUnits.fsm";
};