if (isServer) then {

	[] spawn {

		while {true} do {
		
			sleep 600;
		
			_playerVics = [];
			// this probably doesn't cover all exceptions...
			{
				_playerVics pushBack (_x select 0);
			} foreach d_helirespawn2_ar;
			{
				_playerVics pushBack (_x select 0);
			} foreach d_vrespawn2_ar;
			
			{
				if ((local _x) && {!(_x in _playerVics)} && {({alive _x} count crew _x) > 0}) then {
					_x setFuel 1;
					// maybe crew turning naked is because of this?
					//_x setVehicleAmmo 1;
					// let's try this...
					_loadouts = [];
					_crew = [];
					{
						if (alive _x) then {
							_crew pushBack _x;
							_loadouts pushBack (getUnitLoadout _x);
						};
					} foreach crew _x;
					_x setVehicleAmmo 1;
					sleep 0.003;
					{
						_x setUnitLoadout (_loadouts select _foreachIndex);
					} foreach _crew;
				};
			} foreach vehicles;
			
		};

	};

};