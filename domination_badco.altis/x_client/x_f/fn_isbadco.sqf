if (isNil "d_playerisbadco_cached") then {
	if ((getPlayerUID player) in membersarr) then {
		d_playerisbadco_cached = true;
	} else {
		d_playerisbadco_cached = false;
	};
	d_playerisbadco_cached
} else {
	d_playerisbadco_cached
}