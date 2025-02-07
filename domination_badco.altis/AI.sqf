Hz_customUnitLoadouts = true;

//global params

AI_skill_general = 0.6;
AI_skill_aimingAccuracy = 0.15;
AI_skill_aimingShake = 0.15;
AI_skill_aimingSpeed = 1;
AI_skill_reloadSpeed = 1;
AI_skill_commanding = 1;
AI_skill_courage = 1;
AI_skill_spotDistance = 1;
AI_skill_spotTime = 1;

AI_skill_aimingAccuracy_SOP = 0.225;
AI_skill_aimingShake_SOP = 0.3;


AI_setSkill = {
	
	private _isSpecOps = (group _this) getVariable ["d_isSpecOps", false];

	_this setskill AI_skill_general;
	_this setskill ["aimingAccuracy",[AI_skill_aimingAccuracy, AI_skill_aimingAccuracy_SOP] select _isSpecOps];
	_this setskill ["aimingShake",[AI_skill_aimingShake, AI_skill_aimingShake_SOP] select _isSpecOps];
	_this setskill ["aimingSpeed",AI_skill_aimingSpeed];
	_this setskill ["reloadSpeed",AI_skill_reloadSpeed];
	_this setskill ["commanding",AI_skill_commanding];
	_this setskill ["courage",AI_skill_courage];
	_this setskill ["spotDistance",AI_skill_spotDistance];
	_this setskill ["spotTime",AI_skill_spotTime];

};

AI_setupUnitCustomLoadout = compile preprocessFileLineNumbers "AI_setupUnitCustomLoadout.sqf";
if (Hz_customUnitLoadouts) then {
	#ifdef __RHS__
		Hz_TKfnames = (configProperties [configfile >> "CfgWorlds" >> "GenericNames" >> "TakistaniMen" >> "FirstNames"]) apply {(getText _x) + " "};
		Hz_TKlnames = (configProperties [configfile >> "CfgWorlds" >> "GenericNames" >> "TakistaniMen" >> "LastNames"]) apply {getText _x};
		Hz_RUfnames = (configProperties [configfile >> "CfgWorlds" >> "GenericNames" >> "RussianMen" >> "FirstNames"]) apply {(getText _x) + " "};
		Hz_RUlnames = (configProperties [configfile >> "CfgWorlds" >> "GenericNames" >> "RussianMen" >> "LastNames"]) apply {getText _x};
		Hz_TKfaces = ["PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03"];
		Hz_RUfaces = ["RussianHead_1","RussianHead_2","RussianHead_3","RussianHead_4","RussianHead_5"];
		Hz_TKspeakers = ["Male01PER","Male02PER","Male03PER"];
		Hz_RUspeakers = ["Male01RUS","Male02RUS","Male03RUS"];
	#endif
};