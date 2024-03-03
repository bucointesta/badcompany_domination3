// by Xeno
#define THIS_FILE "fn_handleobservers.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _e_ari_avail = true;
private _nextaritime = 0;
private _enemy = objNull;
private _targets = [];

sleep 10.123;
while {d_nr_observers > 0} do {
	if (_e_ari_avail && {d_mt_spotted} && {(call d_fnc_PlayersNumber) > 44}) then {
		_targets = playableUnits apply {[_x, _x distance d_cur_tgt_pos]};
		_targets sort true;
		_targets = _targets apply {_x select 0};
		{
			_enemy = vehicle _x;
			if (alive _enemy && {!captive _enemy && {(speed _enemy) < 2} && {d_side_enemy knowsAbout _enemy > 3.25 && {!((vehicle _enemy) isKindOf "Air") && {(_enemy distance2D (markerpos "d_base_marker")) > 1500}}}}) then {
				
				// Hunter: only use HE or cluster >:D
				_e_ari_avail = false;
				_nextaritime = time + 260 + (random 200);
				if (({(_x in playableUnits) && {!captive _x} && {(d_side_enemy knowsAbout _x) > 1.25}} count (_enemy nearEntities ["CAManBase", 100])) < 6) then {
					[getPosWorld _enemy, 1] spawn d_fnc_shootari;
				} else {
					_nextaritime = _nextaritime + 120;
					[getPosWorld _enemy, 0] spawn d_fnc_shootari;
				};
			};
			sleep 0.15;
			if (!_e_ari_avail) exitWith {};
		} foreach _targets;
	};
	sleep 5.123;
	if (!_e_ari_avail && {time > _nextaritime}) then {_e_ari_avail = true};
};
