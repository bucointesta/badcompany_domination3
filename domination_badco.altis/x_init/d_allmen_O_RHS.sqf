#include "d_allmen_O_default.sqf"


/*


["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_squad"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_squad_2mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_squad_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_squad_mg_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_section_mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_section_marksman"] call d_fnc_GetConfigGroup,
["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_section_AT"] call d_fnc_GetConfigGroup,
["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_section_AA"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry","rhs_group_rus_msv_infantry_fireteam"] call d_fnc_GetConfigGroup,
["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_squad"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_squad_2mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_squad_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_squad_mg_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_section_mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_section_marksman"] call d_fnc_GetConfigGroup,
["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_section_AT"] call d_fnc_GetConfigGroup,
["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_section_AA"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_msv","rhs_group_rus_msv_infantry_emr","rhs_group_rus_msv_infantry_emr_fireteam"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_squad"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_squad_2mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_squad_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_squad_mg_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_section_mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_section_marksman"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_section_AT"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry","rhs_group_rus_vdv_infantry_section_AA"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_squad"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_squad_2mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_squad_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_squad_mg_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_section_mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_section_marksman"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_section_AT"] call d_fnc_GetConfigGroup,
["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_section_AA"] call d_fnc_GetConfigGroup


//["East","rhs_faction_vdv","rhs_group_rus_vdv_infantry_flora","rhs_group_rus_vdv_infantry_flora_fireteam"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vmf","rhs_group_rus_vmf_infantry_recon","rhs_group_rus_vmf_infantry_recon_squad"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vmf","rhs_group_rus_vmf_infantry_recon","rhs_group_rus_vmf_infantry_recon_squad_2mg"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vmf","rhs_group_rus_vmf_infantry_recon","rhs_group_rus_vmf_infantry_recon_squad_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vmf","rhs_group_rus_vmf_infantry_recon","rhs_group_rus_vmf_infantry_recon_squad_mg_sniper"] call d_fnc_GetConfigGroup,
//["East","rhs_faction_vmf","rhs_group_rus_vmf_infantry_recon","rhs_group_rus_vmf_infantry_recon_fireteam"] call d_fnc_GetConfigGroup


*/