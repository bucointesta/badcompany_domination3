// by Xeno
#define THIS_FILE "x_reservedslot3.sqf"
#include "..\x_setup.sqf"

if (isDedicated) exitWith {};

sleep 1;

for "_i" from 1 to 3 do {
	hint "There is a problem with your clan tag. Please make sure you have followed the instructions on how to add your clan tag to your profile and that your name is spelled correctly. If you did everything correctly and it's still not working, please contact recruitment staff for support. You will not be able to use reserved slots until the problem is resolved.";
	sleep 5;
};

hint (localize "STR_DOM_MISSIONSTRING_338");
sleep 1;
[player, d_name_pl, -1] remoteExecCall ["d_fnc_KickPlayerBS", 2];