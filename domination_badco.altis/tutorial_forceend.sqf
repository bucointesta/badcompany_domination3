disableSerialization;

sleep 10;
waitUntil {isnull tutorialHandle};

sleep 2;

if (tutorialError) then {
	hint "WARNING!\n\nYour tutorial ended unexpectedly.\nWe are always here to help if you have any questions!";
};

d_still_in_intro = false;
(findDisplay 46) displayRemoveEventHandler ["KeyDown",tutorialEscEH];
ppEffectDestroy tutorialBackgroundEffect;
xr_phd_invulnerable = false;
2 fadeSound 1;
enableRadio true;
showChat true;
player forceWalk false;