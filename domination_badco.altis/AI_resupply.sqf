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
				if ((local _x) && {!(_x in _playerVics)} && {({alive _x} count crew _x) > 0} && {({isPlayer _x} count crew _x) == 0}) then {
					_x setFuel 1;					
					_x setVehicleAmmo 1;
				};
			} foreach vehicles;
			
		};

	};

};