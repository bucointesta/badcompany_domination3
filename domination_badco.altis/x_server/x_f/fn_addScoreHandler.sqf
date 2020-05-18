// Hunter: all kills now add score 1 so big guns don't get all the points
// might need special handling if score can also come from scripts...
_this addEventHandler ["HandleScore", {
	params ["_unit", "_object", "_score"];
	if ((_unit == _object) && {_score > 0}) then {
		_unit addScore 1;
		false
	} else {
		true
	}
}];