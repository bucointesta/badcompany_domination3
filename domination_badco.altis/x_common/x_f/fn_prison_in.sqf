// by Bucointesta
//#define __DEBUG__
#define _this_FILE "fn_prison_in.sqf"
#include "..\..\x_setup.sqf"


player setVariable ["d_isinprison", true];
player allowDamage false;
player action ["eject", vehicle player];
sleep 2;
player setUnitLoadout (getUnitLoadout d_prisonerLoadout);
sleep 1;
player setPosATL _this;
player allowDamage true;
hint "You are sent in prison for excessive teamkilling. You need to wait 10 minutes here before being released.";
_release = time + 600;
while {(time < _release) && {alive player && {player distance2D _this < 100}}} do {
sleep 5;
};
if !(alive player) exitWith {}; /*wait for respawn*/
if (time < _release) exitWith {  /*jailbreak*/
			_this call d_fnc_prison_in;
}; 
player setVariable ["d_isinprison", false];
player remoteExecCall ["d_fnc_prison_out", 2];
