// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_gethpname.sqf"
#include "..\..\x_setup.sqf"

params ["_u"];
private _n = "";

if (alive _u) then {
	_n = _u getVariable "d_phname";
	if (isNil "_n") then {
		_n = name _u;
		if (d_no_ai && {_u getUnitTrait "Medic"}) then {
			_n = _n + d_phud_loc884;
		};
		_u setVariable ["d_phname", _n];
		_u setVariable ["d_phname_d", format ["%1 %2", _n, d_phud_loc493]];
		_u setVariable ["d_phname_c", 0];
	} else {
		private _nr = (_u getVariable "d_phname_c") + 1;
		if (_nr > 1000) then {
			_u setVariable ["d_phname", nil];
		} else {
			_u setVariable ["d_phname_c", _nr];
		};
	};
} else {
	_n = _u getVariable "d_phname_d";
	__TRACE_1("","_n")
	if (isNil "_n") then {
		_n = name _u;
		if (d_no_ai && {_u getUnitTrait "Medic"}) then {
			_n = _n + d_phud_loc884;
		};
		_n = format ["%1 %2", _n, d_phud_loc493];
	};
};
_n
