// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_prestart.sqf"
#include "..\x_setup.sqf"
if (isDedicated || {!isNil "d_prestart_started"}) exitWith {};
d_prestart_started = true;

if !(str player in d_virtual_entities) then {
	if (d_IS_HC_CLIENT) then {
		__TRACE("Headless client found")
		call compile preprocessFileLineNumbers "x_shc\x_setuphc.sqf";
		disableRemoteSensors true;
	} else {
		call compile preprocessFileLineNumbers "x_client\x_setupplayer.sqf";
		call compile preprocessFileLineNumbers "i_arsenal.sqf";
		// TODO check if it works, not sure about it
		//disableRemoteSensors !d_with_ai;
		disableRemoteSensors true;
	};
};

diag_log [diag_frameno, diag_ticktime, time, "Dom local player prestart processed"];