// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_handlenet.sqf"
#include "..\..\x_macros.sqf"

__TRACE_1("","_this")
switch (param [1]) do {
	case 100: {
		if (local (param [0])) then {
			__TRACE("Die case 100")
			(param [0]) playActionNow "Die";
		};
	};
	case 101: {
		params ["_u"];
		_u switchMove "AmovPpneMstpSnonWnonDnon_healed";
		_u playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
		if (local _u) then {
			__TRACE("Die case 101")
			_u playActionNow "Die";
		};
	};
	case 102: {
		params ["_u"];
		_u switchMove "AmovPpneMstpSnonWnonDnon_healed";
		_u playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
	};
	case 103: {
		params ["_u"];
		_u switchMove "";
		if (local _u) then {_u moveInCargo (param [2])};
	};
	case 104: {if (local (param [0])) then {unassignVehicle (param [0])}};
	case 105: {(param [0]) switchMove ""};
};