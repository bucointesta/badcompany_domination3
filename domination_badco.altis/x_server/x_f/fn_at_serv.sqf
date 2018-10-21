// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_at_serv.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")
params ["_pl", "_apos", "_npl", "_aritype", "_ari_salv"];

private _mname = format ["d_arttmx|%1|%2|%3", ["1", netId _pl] select (isMultiplayer), _aritype, _ari_salv];
__TRACE_1("","_mname")
private _pa = d_player_store getVariable (getPlayerUID _pl);
if (!isNil "_pa") then {
	private _omar = _pa select 10;
	__TRACE_1("","_omar")
	if (_omar != "" && {!(markerPos _omar isEqualTo [0,0,0])}) then {
		deleteMarker _omar;
	};
	_pa set [10, _mname];
};
[_mname, _apos, "ICON", d_color_m_marker, [1, 1], _npl, 0, d_arty_m_marker] call d_fnc_CreateMarkerGlobal;

if (d_no_ai) then {
	{
		private _aunit = missionNamespace getVariable _x;
		__TRACE_1("","_aunit")
		if (!isNil "_aunit" && {!isNull _aunit && {_aunit != _pl}}) then {
			_npl remoteExecCall ["d_fnc_upd_aop", _aunit];
		};
		false
	} count d_can_use_artillery;
};