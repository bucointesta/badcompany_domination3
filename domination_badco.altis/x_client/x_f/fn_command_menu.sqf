// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_command_menu.sqf"
#include "..\..\x_setup.sqf"

__TRACE("frame")
if (alive player && {!(player getVariable ["xr_pluncon", false]) && {!(player getVariable ["ace_isunconscious", false])}}) then {
	#ifdef __DEBUG__
	_cmdm = commandingMenu;
	__TRACE_1("","_cmdm")
	#endif
	if (commandingMenu == "") then {
		call d_commandingMenuCode;
		d_commandingMenuCode = nil;
		d_DomCommandingMenuBlocked = false;
	};
} else {
	d_commandingMenuCode = nil;
	d_DomCommandingMenuBlocked = false;
	d_commandingMenuIniting = false;
};