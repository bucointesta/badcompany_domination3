@echo off


set mapName=Altis
set mapExtention=altis


























if exist maps\%mapName%\mission.sqm (

	echo Deploying domination_badco.%mapExtention%...
	
	if exist __DEPLOYMENT (
		rmdir __DEPLOYMENT /s /q
	)
	
	mkdir __DEPLOYMENT
	mkdir __DEPLOYMENT\domination_badco.%mapExtention%
	echo Copying files
	xcopy "domination_badco.altis" "__DEPLOYMENT\domination_badco.%mapExtention%" /s /e /q
	echo Copying map files
	xcopy "maps\%mapName%" "__DEPLOYMENT\domination_badco.%mapExtention%" /s /e /q
	
	echo Done!
	pause
	
) else (

	echo Error! Mission file for %mapName% doesn't exist!
	pause
)