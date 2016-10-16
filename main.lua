function OnGameModeInit()
	print("My server has started.");
	SetSpawnPoint(-817.657, 178.111, 75.0);
	SetSpawnPoint(-640.183, 297.111, 91.0);
	
	CreateVehicle("Adder", -3.0, 6.0, 73.0, 360.0, 5, 10, true, 500);
	vehicle = CreateVehicle("Police", -6.0, 8.0, 73.0, 360.0, 5, 10, true, 500);
	CreateVehicle("Voltic", -9.0, 10.0, 73.0, 360.0, 5, 10, true, 500);
	CreateVehicle("Gargoyle", -12.0, 12.0, 73.0, 360.0, 5, 10, true, 500);
	
	SetVehicleColor(0, 1, 2, 29);
	SetVehicleCustomColor(2, 1, 255, 0, 239);
	SetVehicleNumberPlate(2, "Voltic");
	SetVehicleMod(2, 0, 1);
	SetVehicleMod(2, 14, 5);
	
	local biff = CreateVehicle("biff", -7.0, 27.0, 71.0, 290.0, 5, 10, true, 5000);
	local ramp1 = CreateObject("prop_mp_ramp_01", 0, 0, 0, 0, 0, false);
	local ramp2 = CreateObject("prop_mp_ramp_01", 0, 0, 0, 0, 0, false);
	AttachEntityToEntity("OBJECT", ramp1, "VEHICLE", biff, 0, 0, -8.0, 0, 13, 0, 0, false, true, 0, true);
	AttachEntityToEntity("OBJECT", ramp2, "VEHICLE", biff, 0, 0, -2.5, 2.2, 13, 0, 0, false, true, 0, true);
	
	blip = CreateBlip();
	SetBlipLocationType(blip, 1, vehicle);
	SetBlipColor(blip, 23);
	SetBlipImage(blip, 56);
	SetBlipName(blip, "Voltic car");
	
	pickup = CreatePickup();
	SetPosition("PICKUP", pickup, -16, 13, 71);
	SetPickupModel(pickup, "prop_ld_health_pack");
	SetPickupRespawnTime(pickup, 2000);
	
	--Known bug, it doesn't create folders!!!!!!
	--Make sure that folders are created.
	inifile = LoadINIFile("test.ini");
	WriteInteger(inifile, "testsection", "int", 5);
	WriteFloat(inifile, "testsection", "float", 0.2);
	WriteBoolean(inifile, "testsection", "boolean", true);
	WriteString(inifile, "testsection", "string", "testing");
	
	arg1 = ReadInteger(inifile, "testsection", "int");
	arg2 = ReadFloat(inifile, "testsection", "float");
	arg3 = ReadBoolean(inifile, "testsection", "boolean");
	arg4 = ReadString(inifile, "testsection", "string");
	
	print(arg1);
	print(arg2);
	print(arg3);
	print(arg4);
	
	CloseINIFile(inifile);
	
	SetTime(14, 24);
	SetDate(28, 12, 2000);

	require("constants")
	require("fracon_functions")
	
	
	return 1;
end

--[[Registerstration BEGIN]]--

function OnGameModeInit()
    MAX_PLAYERS = 32; -- Макимальное количество игроков
    -- Initialize the pInfo table
    pInfo = {};
    for i=0, MAX_PLAYERS do
        pInfo[i] = nil;
    end
end

function OnPlayerConnect(playerid)
	playername = GetPlayerName(playerid);

	pInfo[playerid] = {Logged=false};
    if (not Users.IsRegistered(GetPlayerName(playerid))) then
        SendMessageToPlayer(playerid, "You are not registered. Use /register [password] to do that.");
    else
        SendMessageToPlayer(playerid, "You are registered. Use /login [password] to do login.");
    end

	return 1;
end

function OnPlayerDisconnect(playerid)
    pInfo[playerid] = nil;
end

cmds.register = function(playerid, sPass)
    if checkparams(sPass, "a") then return SendMessageToPlayer(playerid, "Usage: /register ~b~[password]"); end;
    local hasRegistered, err = Users.Register(GetPlayerName(playerid), sPass);
    if (not hasRegistered) then
        if (err == "already registered") then
            SendMessageToPlayer(playerid, "~r~This username is already registered.");
        end
    else
        SendMessageToPlayer(playerid, "You have successfully registered. To login use /login [password]");
        print("Registered successfully");
        Users.SetStats(GetPlayerName(playerid), {money=5000, kills=0, deaths=0, weapon="none"});


	    SendMessageToPlayer(playerid, "Hi there ~b~"..playername.. "~w~, welcome to this Five~r~MP ~w~server!");
		SendMessageToPlayer(playerid, "Your player ID is ~b~" .. playerid);
		
		SetPlayerPosition(playerid, GET_STARTED_SPAWN_X, GET_STARTED_SPAWN_Y, GET_STARTED_SPAWN_Z);
		SetPlayerFacingAngle(playerid, 45.0);
		
		SetPlayerMoney(playerid, GET_STARTED_MONEY);
		SetPlayerMaxTagDrawDistance(playerid, 50);
		SetPlayerRespawnTime(playerid, 5000);
		
		SetPlayerHealth(playerid, GET_STARTED_HEALTH);
		SetPlayerArmour(playerid, GET_STARTED_ARMOUR);
		SetPlayerModel(playerid, 420);
		
		GivePlayerWeapon(playerid, "Pistol", 45);
		GivePlayerWeapon(playerid, "parachute", 1);
		ShowBlipForPlayer(blip, playerid);
		
		ShowPickupForPlayer(pickup, playerid);
		
		SetPlayerWaypointPos(playerid, 0, 0);
		SetPlayerVisible(playerid, true);


    end
end;

cmds.login = function(playerid, sPass)
    if (pInfo[playerid].Logged) then return SendMessageToPlayer(playerid, "You are already logged in."); end;
    if checkparams(sPass, "a") then return SendMessageToPlayer(playerid, "Usage: /login [password]"); end;
    local hasLogged, err = Users.Login(GetPlayerName(playerid), sPass);
    if (not hasLogged) then
        if (err == "not registered") then
            SendMessageToPlayer(playerid, "You are not registered");
        elseif (err == "wrong password") then
            SendMessageToPlayer(playerid, "~r~Wrong password");
        end
    else
        pInfo[playerid].Logged = true;
        pInfo[playerid].Stats = Users.GetStats(GetPlayerName(playerid), {"money", "kills", "deaths", "weapon"});
        SendMessageToPlayer(playerid, "You have logged in successfully.");
        print("Logged in successfully");
    end
end; 

--[[Registerstration END]]--

function OnPlayerSpawn(playerid)
	print("~b~" .. playerid .. " has spawned");
	PlayerScreenFadeIn(playerid, 500);
	return 1;
end

function OnPlayerDeath(playerid)
	playername = GetPlayerName(playerid);
	SendMessageToAll("~b~" .. playername .. "(".. playerid .. ")~w~ has died.");
	print(playerid .. " has died.");
	PlayerScreenFadeOut(playerid, 500);
	return 1;
end

function OnPlayerUpdate(playerid)
	
	return 1;
end

function OnPlayerPickUpPickup(pickup, player)
	playername = GetPlayerName(player);
	SendMessageToAll("~b~" .. playername .. "~w~ picked up ~b~Pickup");
end

function OnPlayerMessage(playerid, message)
	playername = GetPlayerName(playerid);
	SendMessageToAll( "~r~" .. playername .. "(".. playerid .."): ~w~" .. message);
	return 1;
end

local function isempty(s)
  return s == nil or s == ''
end

function OnPlayerCommand(playerid, message)
    args = {}
    index = 0
    for value in string.gmatch(message,"%S+") do
        args [index] = value
        index = index + 1
    end
 
    if message == "/test2" then
        SendMessageToAll("This is a testing message which tests 'SendMessageToAll'");
        return 1;
    end
	
	if args[0] == "/forcetosit" then
		if not isempty(args[1]) and not isempty(args[2]) then
		
			playerid1 = GetPlayerId(args[1]);
			if playerid1 < 0 then
				SendMessageToPlayer(playerid, "~r~No player found ~b~" .. args[1] .. "~r~");
				return 1;
			end
			
			vehicle = GetPlayerVehicleID(playerid);
			if vehicle == -1 then
				SendMessageToPlayer(playerid, "~y~You are not sitting in any vehicle!");
			end
			
			playername1 = GetPlayerName(playerid);
			playername2 = GetPlayerName(playerid1);
			SendMessageToPlayer(playerid, "~g~You forced ~o~"..playername2.."~g~ to go into your vehicle!");
			SendMessageToPlayer(playerid1,"~o~"..playername1.."~y~ forced you to go into his vehicle!");
			
			PutPlayerInVehicle(playerid1, vehicle, -2);
		
		end
		
		return 1;
	end
   
    if args[0] == "/tp" then
        if not isempty(args[1]) and not isempty(args[2]) then
			playerid1 = GetPlayerId(args[1])
			playerid2 = GetPlayerId(args[2])
		
			if(playerid1 < 0) then
				SendMessageToPlayer(playerid, "~r~No player found ~b~" .. args[1] .. "~r~");
				return 1;
			end
			if(playerid2 < 0) then
				SendMessageToPlayer(playerid, "~r~No player found ~b~" .. args[2] .. "~r~");
				return 1;
			end
			
			playername1 = GetPlayerName(playerid1)
			playername2 = GetPlayerName(playerid2)
			
			local x, y, z = GetPlayerPosition(playerid2)
			SetPlayerPosition(playerid1, x, y, z)
			
			SendMessageToPlayer(playerid, "You Teleported ~b~" .. playername1 .. " ~w~to ~b~" .. playername2);
			SendMessageToPlayer(playerid1, "You have been Teleported to ~b~" .. playername2);
			SendMessageToPlayer(playerid2, "~b~" .. playername1 .. " ~w~has Teleported to you");
		end
        return 1;
    end
	
	if args[0] == "/goto" then
        if not isempty(args[1]) then
			playerid1 = GetPlayerId(args[1])
			if(playerid1 < 0) then
				SendMessageToPlayer(playerid, "~r~No player found ~b~" .. args[1] .. "~r~");
				return 1;
			end
			
			playername1 = GetPlayerName(playerid1)
			
			local x, y, z = GetPlayerPosition(playerid1)
			SetPlayerPosition(playerid, x, y, z)
			
			SendMessageToPlayer(playerid, "You Teleported to ~b~" .. playername1);
		end
        return 1;
    end
	
	if args[0] == "/weapon" then
        if not isempty(args[1]) then
			GivePlayerWeapon(playerid, args[1], 500);
		end
        return 1;
    end
	
	if args[0] == "/bring" then
        if not isempty(args[1]) then
			playerid1 = GetPlayerId(args[1])
			if(playerid1 < 0) then
				SendMessageToPlayer(playerid, "~r~No player found ~b~" .. args[1] .. "~r~");
				return 1;
			end
			
			playername = GetPlayerName(playerid)
			
			local x, y, z = GetPlayerPosition(playerid)
			SetPlayerPosition(playerid1, x, y, z)
			
			SendMessageToPlayer(playerid1, "You have been Teleported to ~b~" .. playername);
		end
        return 1;
    end
	
	if args[0] == "/ramp" then
	
		local x, y, z = GetPlayerPosition(playerid)
        local id = CreateObject("prop_mp_ramp_01", x, y, z, 0, 0, 85);
        return 1;
    end
	
	if args[0] == "/spawn" then
        SetPlayerPosition(playerid, -3.73, 19.03, 72);
        return 1;
    end
	
	if args[0] =='/setspawn' then 
       SetSpawnPoint(args[1],args[2],args[3]); 
       return 1; 
    end
	
	if args [0] == '/kick' then
		if not isempty(args[1]) then
	   		KickPlayer (GetPlayerId(args[1]), args[2] );
	   	end
	   	return 1;
	end    
	
	if args[0] == "/veh" then
		if args[1] == nil then
			SendMessageToPlayer(playerid,"/veh vehiclename");
			return 1
		end
		
		local x,y,z = GetPlayerPosition(playerid)
		CreateVehicle(args[1], x+5, y, z, 360.0, 0,0, true, 500);
		
		return 1;
    end
   
    return 0;
end

function OnPlayerEnterVehicle(playerid, vehicleid, seatid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ entered in vehicle!");
end

function OnPlayerExitVehicle(playerid, vehicleid, seatid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ exited from vehicle!");
end

function OnPlayerEnterCheckpoint(playerid, checkpointid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ entered checkpoint " .. checkpointid);
	return 1;
end

function OnPlayerExitCheckpoint(playerid, checkpointid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ left a checkpoint " .. checkpointid);
	return 1;
end

function OnPlayerEnteringVehicle(playerid, vehicleid, seatid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ entering a vehicle!" .. vehicleid);
	return 1;
end

function OnPlayerExitingVehicle(playerid, vehicleid, seatid)
	local playername = GetPlayerName(playerid);
	SendMessageToAll("~b~"..playername.."~w~ exiting a vehicle!" .. vehicleid);
	return 1;
end

function OnVehicleRespawn(vehicleid)
	print("Vehicle "..vehicleid.." respawned");
	return 1;
end
