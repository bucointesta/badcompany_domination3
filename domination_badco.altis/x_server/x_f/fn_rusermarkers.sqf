// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_rusermarkers.sqf"
#include "..\..\x_setup.sqf"

private _del_markers = [];
{
	private _id_s = "";
	for "_i" from 0 to (count _x - 1) do {
		if (_x select [_i, 1] == "#") exitWith {
			for "_c" from (_i + 1) to (count _x - 1) do {
				private _char = _x select [_c, 1];
				if (_char == "/") exitWith {};
				_id_s = _id_s + _char;
			};
		};
	};
	
	if (_id_s != "") then {
		private _unit = objectFromNetId _id_s;
		if (isNil "_unit" || {isNull _unit}) then {
			_del_markers pushBack _x;
		};
	};
	false
} count (allMapMarkers select {_x select [0, 15] == "_USER_DEFINED #"});

if !(_del_markers isEqualTo []) then {
	{deleteMarker _x;false} count _del_markers;
};