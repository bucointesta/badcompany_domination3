// by Xeno
#define THIS_FILE "fn_the_end.sqf"
#include "..\..\x_setup.sqf"

if (_this == 0) then {
	if (isNil "d_end_cam_running") then {
		execVM "x_client\x_endcam.sqf";
	};
} else {
	endMission "END1";
	forceEnd;
};