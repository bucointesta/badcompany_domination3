_plane = _this select 0;
_caller = _this select 1;
_actionarray = _this select 3;
_action = _actionarray select 0;
_carrier = _this select 0;
_loadpos = _carrier ModelToWorld [0,-13,-5.5];
_cargo = _carrier getVariable "cargo";
_act1 = _carrier getVariable "act1";
_carried = objNull;

if (_action == "load") then {
	if (_cargo == "") then {
		_near = nearestObjects [_loadpos, ["LandVehicle","Ship"], 10];
		_obj = _near select 0;
		
		if((count crew (vehicle _obj)) > 0) then {_carried = vehicle _obj;} else {_carried = _obj;};
		
		_bound = boundingBox _obj;
		
		_width = (_bound select 1 select 0) - (_bound select 0 select 0);
		_length = (_bound select 1 select 1) - (_bound select 0 select 1);
		_height = (_bound select 1 select 2) - (_bound select 0 select 2);
		
		if (count _near > 0) then {
			player sidechat format ["x:%1 y:%2 z:%3",_width,_length,_height];
			if ((_width <= 10.0) && (_length <= 22) && (_height <= 12)) then {
				//_carrier setVariable ["cargo",_obj];
				_carrier removeAction _act1;
				
				_carrier setVariable ["cargo",_carried];
				carried = true;
				
				[_carried, true] remoteExecCall ["d_fnc_l_v", _cargo];
				
				_lower = true;
				_heightcorrection = 0;
				_lengthcorrection = -2;
				if (_carrier isKindOf "VTOL_Base_F") then {
					_heightcorrection = -0.8;
					_lengthcorrection = 1;
				};
				_widthcorrection = 0;
				
				_carried setVariable ["rhs_paradrop",true,true];
				
				_carried attachTo [_carrier,[0+_widthcorrection,-52/4,-3.5 +_heightcorrection]];
				if (_carrier isKindOf "VTOL_Base_F") then {
					_carrier animateDoor ["Door_1_source", 1];
				} else {
					_carrier animate ["ramp_top", 1];
					_carrier animate ["ramp_bottom", 1];
				};
				
				hint "Lowering ramp...";
				
				sleep 3;
				
				hint format ["Loading %1 into cargo now...",typeOf _obj];
				
				for "_i" from -52 to 8 do {

					if (_lower) then {_carried attachTo [_carrier,[0+_widthcorrection,_i/4,-3.5 +_heightcorrection]];} else {_carried attachTo [_carrier,[0+_widthcorrection,_i/4,-2.5+_heightcorrection]];};

					sleep 0.1;
					if (_i > -40 && _i < -30) then {_carried setvectorup[0,-0.1,1];};
					if (_i > -30 && _i < -20) then {_carried setvectorup[0,-0.2,1];  _lower = false;};
					if (_i > -20 && _i < -10) then {_carried setvectorup[0,-0.1,1];};
					if (_i > -10 && _i < 0) then {_carried setvectorup[0,0,1];};
				};
				
				_carried attachTo [_carrier,[0 + _widthcorrection,2+_lengthcorrection,-2.5+_heightcorrection]];
				hint "Cargo loaded.";
				//_carried setVariable ["evh",_id];
				//_carried setVariable ["carrier",_carrier];
				sleep 2;
				if (_carrier isKindOf "VTOL_Base_F") then {
					_carrier animateDoor ["Door_1_source", 0];
				} else {
					_carrier animate ["ramp_top", 0];
					_carrier animate ["ramp_bottom", 0];
				};
				sleep 1;
				
				_id = _carrier addaction ["<t color='#0000FF'>Drop cargo</t>", "logistics\cargoscript.sqf", ["drop"],999999,true,true,"","driver  _target == _this"];
				_carrier setVariable ["act1",_id];
				
				[_carrier, _carried]spawn {
					
					//private ["_carrier","_carried"];
					
					_carrier = _this select 0;
					_carried = _this select 1;
					_istank = false;
					if (_carried iskindof "Tank") then {_istank = true;};
					_initdamage = getdammage _carrier;
					
					hint "Cargo loaded.";
					_ehk = _carrier addeventhandler ["killed", {_carried setdamage 1;}];
					damagedc130 = false;
					_ehh = _carrier addeventhandler ["hit", {damagedc130 = true;}];
					
					// damage handler
					while {carried} do {
						
						// _ehf = _carried addeventhandler ["fired",{_carried setdammage (getdammage _carried + 0.1); _carrier setdammage (getdammage _carrier + 0.1);}];     
						
						if (damagedc130) then {
							
							if (istank) then {_carried setdamage (((getdammage _carrier) - _initdamage) / 4);} else {_carried setdamage ((getdammage _carrier) - _initdamage);};
							
							{_x setdamage (getdammage _carried);}foreach crew _carried;
						};
						
						sleep 0.1;
						
						if(!alive _carrier) exitwith {_carried setdamage 1;};
						
					};
					
					_carrier removeeventhandler ["killed", _ehk];
					_carrier removeeventhandler ["hit", _ehh];
					//_carried removeeventhandler ["fired", _ehf];
					
				};
				
				
			} else {
				player sideChat "This won't fit in the cargospace";
				hint "This won't fit in the cargospace";
			};
		} else {
			player sideChat "Nothing in range";
			hint "Nothing in range";
		};
	} else {
		player sideChat "Cargo is already full";
		hint "Cargo is already full";
		_carrier removeaction _act1;
		_id = _carrier addaction ["<t color='#0000FF'>Drop Cargo</t>", "logistics\cargoscript.sqf", ["drop"],999999,true,true,"","driver  _target == _this"];
		_carrier setVariable ["act1",_id];
		// if((count crew _cargo) != 0) then {{_x moveinCargo _carrier;} forEach crew _cargo;};
	};
	
};

if (_action == "drop") then {

	if (((speed _carrier) > 5) && {((getposatl _carrier) select 2) < 1000}) exitWith {
		hint "You must at least 1000m high to drop your cargo!";
	};
	
	_carrier removeAction _act1;
	//_id = _cargo getVariable "evh";
	//_cargo removeEventHandler ["GetOut", _id];
	hint "Lowering ramp...";
	if (_carrier isKindOf "VTOL_Base_F") then {
		_carrier animateDoor ["Door_1_source", 1];
	} else {
		_carrier animate ["ramp_top", 1];
		_carrier animate ["ramp_bottom", 1];
	};
	sleep 3;
	
	
	if ((getpos _carrier select 2) > 20) then {
		hint "Cargo is releasing now, hold it steady!";
		/* BELOW CODE DOES NOT WORK IN MP IF CARGO OR CARRIER HAVE OTHER PLAYERS IN IT. YOU WILL SUFFER FROM A BAD "ACCIDENT"!
									
								_droppos = _carrier ModelToWorld [0,-20,-12];
								detach _cargo;
								_cargo setpos _droppos;
								sleep 0.1;
								*/
		_lower = false;
		_heightcorrection = 0;		
		_lengthcorrection = -2;
		if (_carrier isKindOf "VTOL_Base_F") then {
			_heightcorrection = -0.8;
			_lengthcorrection = 1;
		};
		_widthcorrection = 0;
		
		for "_i" from -4 to 24 do {
			
			if (_lower) then {_cargo attachTo [_carrier,[0+_widthcorrection,-_i/2,-3.5+_heightcorrection]];} else {_cargo attachTo [_carrier,[0+_widthcorrection,-_i/4,-2.5+_heightcorrection]];};
			
			sleep 0.1;
			if (_i > 10 && _i < 20) then {_cargo setvectorup[0,-0.1,1];};
			if (_i > 20 && _i < 30) then {_cargo setvectorup[0,-0.2,1];  _lower = true;};
			if (_i > 30 && _i < 40) then {_cargo setvectorup[0,-0.1,1];};
			if (_i > 40 && _i < 50) then {_cargo setvectorup[0,0,1];};
		};
		_cargo attachTo [_carrier,[0+_widthcorrection,-13+_lengthcorrection,-8+_heightcorrection]];
		sleep 0.3;
		detach _cargo;
		carried = false;
		hint "Cargo is out!";
		sleep 1;
		
		[_plane, _cargo] remoteExec ["d_fnc_cargoPlaneDropMP",_cargo,false];
		
		waituntil {((getpos _cargo) select 2) < 750};
		
		if (_carrier isKindOf "VTOL_Base_F") then {
			_carrier animateDoor ["Door_1_source", 0];
		} else {
			_carrier animate ["ramp_top", 0];
			_carrier animate ["ramp_bottom", 0];
		};
		
		_chute = "B_Parachute_02_F" createVehicle [(getpos _cargo select 0),(getpos _cargo select 1),(getpos _cargo select 2) + 10];
		//_chute setpos (_cargo ModelToWorld [0,0,3]);
		//_chute setVelocity ((velocity _cargo));
		_chute attachTo [_cargo,[0,0,3]];
		sleep 3;
		
		while {((getpos _cargo) select 2) > 20} do {			
			sleep 0.3;
			hintsilent format ["Cargo Vertical Speed: %1 m/s\nCargo Altitude: %2 m", velocity _cargo select 2,getpos _cargo select 2];
		};
		
		waituntil {((getpos _cargo) select 2) < 5};
		if(alive _cargo)then {hint "Cargo has landed!"; } else {hint "Cargo was destroyed!";};
		
		sleep 2;
		detach _chute;
		_posChute = getposatl _chute;
		_chute setposatl [(_posChute select 0) - 5, (_posChute select 1) - 5,0];
		_landpos = getpos _cargo;
		[_cargo, false] remoteExecCall ["d_fnc_l_v", _cargo];
		"SmokeShellOrange" createVehicle _landpos;
		"F_40mm_yellow"    createVehicle [(_landpos select 0),(_landpos select 1),(_landpos select 2) + 400 ];
		sleep 15;
		"F_40mm_blue"    createVehicle [(_landpos select 0),(_landpos select 1),(_landpos select 2) + 400 ];
		sleep 55;
		"SmokeShellBlue" createVehicle _landpos;
		"F_40mm_yellow"    createVehicle [(_landpos select 0),(_landpos select 1),(_landpos select 2) + 400 ];
		sleep 15;
		"F_40mm_blue"    createVehicle [(_landpos select 0),(_landpos select 1),(_landpos select 2) + 400 ];
	} else {
		
		// Commented out code below replaced with alternative method. Detaching cargo first is not safe for MP.
		
		//detach _cargo;
		//_cargo setpos _loadpos;
		
		//     _cargo attachTo [_carrier,[0,-13,-3.5]]; // this position is safe to release a large vehicle on the ground. More margin probably needed for airdrop.
		//    sleep 1;
		//    detach _cargo;
		
		hint "Cargo is being released...";
		
		_lower = false;
		_heightcorrection = 0;		
		_lengthcorrection = -2;
		if (_carrier isKindOf "VTOL_Base_F") then {
			_heightcorrection = -0.8;
			_lengthcorrection = 1;
		};
		_widthcorrection = 0;		
		
		for "_i" from -8 to 48 do {
			
			if (_lower) then {_cargo attachTo [_carrier,[0+_widthcorrection,-_i/4,-3.5+_heightcorrection]];} else {_cargo attachTo [_carrier,[0+_widthcorrection,-_i/4,-2.5+_heightcorrection]];};
			
			sleep 0.1;
			if (_i > 10 && _i < 20) then {_cargo setvectorup[0,-0.1,1];};
			if (_i > 20 && _i < 30) then {_cargo setvectorup[0,-0.2,1];  _lower = true;};
			if (_i > 30 && _i < 40) then {_cargo setvectorup[0,-0.1,1];};
			if (_i > 40 && _i < 50) then {_cargo setvectorup[0,0,1];};
		};
		_cargo attachTo [_carrier,[0+_widthcorrection,-13+_lengthcorrection,-3.5+_heightcorrection]];
		sleep 1;
		detach _cargo;
		_cargo setVelocity (velocity _carrier);
		carried = false;
		hint "Cargo released.";
		[_cargo, false] remoteExecCall ["d_fnc_l_v", _cargo];
		if (_carrier isKindOf "VTOL_Base_F") then {
			_carrier animateDoor ["Door_1_source", 0];
		} else {
			_carrier animate ["ramp_top", 0];
			_carrier animate ["ramp_bottom", 0];
		};
	};
	
	_carrier setVariable ["cargo",""];
	_id = _carrier addaction ["<t color='#0000FF'>Load cargo</t>", "logistics\cargoscript.sqf", ["load"],999999,true,true,"","driver  _target == _this"];
	_carrier setVariable ["act1",_id];

};