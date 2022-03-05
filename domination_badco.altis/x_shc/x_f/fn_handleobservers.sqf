// by Xeno
#define THIS_FILE "fn_handleobservers.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _e_ari_avail = true;
private _nextaritime = 0;

private _man_type = format ["Soldier%1B", d_enemy_side_short];

sleep 10.123;
while {d_nr_observers > 0} do {
	if (_e_ari_avail && {(call d_fnc_PlayersNumber) > 44}) then {
		{
			if (alive _x) then {
				private _enemy = _x findNearestEnemy _x;
				// Hunter: increased max distance from observer, changed personal knowledge to side knowledge and increased required knowledge
				if (!isNull _enemy && {alive _enemy && {!captive _enemy} && {d_side_enemy knowsAbout _enemy > 3.5 && {!((vehicle _enemy) isKindOf "Air") && {_x distance2D _enemy < 1500}}}}) then {
					
					// Hunter: always fire 120mm HE shells...
					_e_ari_avail = false;
					_nextaritime = time + 120 + (random 240);
					[getPosWorld _enemy, 1] spawn d_fnc_shootari;
					
					/*
					if ((_enemy nearEntities [_man_type, 30]) isEqualTo []) then {
						_e_ari_avail = false;
						_nextaritime = time + 120 + (random 120);
						[getPosWorld _enemy, floor (random 2)] spawn d_fnc_shootari;
					} else {
						_e_ari_avail = false;
						_nextaritime = time + 120 + (random 120);
						if (random 100 < 15) then {// 1 to 6 chance for smoke
							[getPosWorld _enemy, 2] spawn d_fnc_shootari;
						};
					};
					*/
				};
			};
			sleep 2.321;
			// Hunter: also exit here if arty already called by one observer so all of them don't spam at same time...
			if (!_e_ari_avail) exitWith {};
		} forEach (d_obs_array select {alive _x});
	};
	sleep 5.123;
	if (!_e_ari_avail && {time > _nextaritime}) then {_e_ari_avail = true};
};
