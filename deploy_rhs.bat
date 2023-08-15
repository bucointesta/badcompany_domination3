@echo off


set mapName=Takistan
set mapExtention=takistan


























if exist maps\%mapName%\mission.sqm (

	echo Deploying domination_badco_rhs.%mapExtention%...
	
	if exist __DEPLOYMENT (
		rmdir __DEPLOYMENT /s /q
	)
	
	mkdir __DEPLOYMENT
	mkdir __DEPLOYMENT\domination_badco_rhs.%mapExtention%
	echo Copying files
	xcopy "domination_badco.altis" "__DEPLOYMENT\domination_badco_rhs.%mapExtention%" /s /e /q
	echo Copying map files
	xcopy "maps\%mapName%" "__DEPLOYMENT\domination_badco_rhs.%mapExtention%" /s /e /q
	
	echo Done!
	pause
	
) else (

	echo Error! Mission file for %mapName% doesn't exist!
	pause
)