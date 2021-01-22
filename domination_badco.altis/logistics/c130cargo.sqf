_plane = _this select 0;

waitUntil {sleep 3; !isNull player};

if ((typeof _plane) in d_cargoPlanes) then {

	_id = _plane addaction ["<t color='#0000FF'>Load cargo</t>", "logistics\cargoscript.sqf", ["load"],999999,true,true,"","(driver  _target == _this) && {(speed _target) < 2}"];
	_plane setVariable ["act1",_id];
	_plane setVariable ["cargo",""];

};

/*
while {!isNil (_vec getVariable "cargo")} do {
        
        _carried = _vec getVariable "cargo";
        _dammage = getDammage _vec;
        _carried setdammage _dammage; 
        sleep 1;


};
*/

// if (((typeOf vehicle player) == "C130J_US_EP1") && (player != (driver vehicle player))) exitwith {};