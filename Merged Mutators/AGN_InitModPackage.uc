/** 
 *  This is an example of how to create a mutator that can be triggered with the mutate command.
 *  This gives the player a sniper rifle when they type "Mutate Sniper" into the commandline.
 * */
class AGN_InitModPackage extends AGN_Mut_BaseDefenses;

var() array<bool> oldCratesVehSpawning;
var() array<bool> oldCratesNukeSpawning;

var AGN_Veh_Mutator VehMutator;
var AGN_Sys_Mutator SystemMutator;
var AGN_Mut_RepairPad_v2 RepairPads;

var bool modPackageInitComplete;
var bool mutatorInitDone;

simulated function Tick(float DeltaTime)
{
	if ( SystemMutator != None )
		SystemMutator.OnTick(DeltaTime);
}

function InitMutator(string options, out string errorMessage)
{
	local String mapname;

	modPackageInitComplete = false;
	
	if ( mutatorInitDone )
	{
		`log("[AGN-Mutator] Attempted to InitMutator twice, stopped this...");
		return;
	}
		
	mutatorInitDone = true;
	
	if (Rx_Game(WorldInfo.Game) != None)
	{
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
		Rx_Game(WorldInfo.Game).HudClass = class'AGN_HUD';
	}
	
	// This just doesnt work, maybe i'll fix it in the future when my brain doesnt feel like shit.
	//InitMutator_BaseDefences(options, errorMessage);
	
	// Start our Crate System
	InitMutator_CrateSystem();
	
	mapname=WorldInfo.GetmapName();
	`log ( "[AGN-MAP-FINDER] Found map " $ mapname);
	if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);   	
	if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);
	
	// Start our Veh System
	// Spawn our class, and call the functions inside.
	// We dont support flying maps.
	if ( mapname ~= "Walls" || mapname ~= "Lakeside" || mapname ~= "Whiteout" )
	{
		`log("[AGN-Map-Decider] FLYING MAP FOUND, NOT LOADING AGN_VEH MUTATOR");
	} else {
		`log("[AGN-Map-Decider] NON FLYING MAP FOUND, LOADING AGN_VEH_MUTATOR INIT");
		VehMutator = spawn(class'AGN_Veh_Mutator');
		VehMutator.OnInitMutator(options, errorMessage);
	}
	
	SystemMutator = spawn(class'AGN_Sys_Mutator');
	if ( SystemMutator != None )
		SystemMutator.InitSystem();
		
	RepairPads = spawn(class'AGN_Mut_RepairPad_v2');
	if ( RepairPads != None )
		RepairPads.OnInitMutator();
		
	super(Mutator).InitMutator(Options, ErrorMessage);
}

function InitMutator_CrateSystem()
{
	local Rx_CratePickup CratePickup;
		
	LogInternal(" ---------- ");
	LogInternal(" ---------- Loading all current Rx_CratePickup actors on the map");
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', CratePickup)
	{
		LogInternal(" ---------- Found Rx_CratePickup at " $ CratePickup.Location $ "  SpawnVeh: " $ string(CratePickup.bNoVehicleSpawn) $ " SpawnNuke: " $ string(CratePickup.bNoNukeDeath));
		oldCratesVehSpawning.AddItem(CratePickup.bNoVehicleSpawn);
		oldCratesNukeSpawning.AddItem(CratePickup.bNoNukeDeath);
	}
	
	setTimer(5, true, 'ReplaceCrates');
}

function InitMutator_BaseDefences(string options, out string errorMessage)
{
	// Init our Super Class
	Super.InitMutator(options, errorMessage);
}

function ReplaceCrates()
{
	local int count;
	local AGN_CratePickup CratePickup;
	local Rx_CratePickup RxCratePickup;
	local Controller c;
	local Rx_Vehicle thisVehicle;
	local bool foundHarvester;
	
	// Try to find the harvesters, this means the map has started (is there a better way?)
	
	if ( modPackageInitComplete )
		return;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Vehicle', thisVehicle)
	{
		if (thisVehicle.isA('Rx_Vehicle_Harvester'))
		{
			foundHarvester = true;
		}
	}
	
	if ( foundHarvester == false )
		return;
	
	// Turn the timer off
	setTimer(0, false, 'ReplaceCrates');
	modPackageInitComplete = true;
	
	count = 0;
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		LogInternal(" ---------- Found AGN_CratePickup at " $ CratePickup.Location $ "  SpawnVeh: " $ string(oldCratesVehSpawning[count]) $ " SpawnNuke: " $ string(oldCratesNukeSpawning[count]));
		CratePickup.bNoVehicleSpawn = oldCratesVehSpawning[count];
		CratePickup.bNoNukeDeath = oldCratesNukeSpawning[count];
		
		count++;
	}
	
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if (Rx_PRI(c.PlayerReplicationInfo) != None)
		{
			if (PlayerController(c) != None)
			{
				//Recipient.CTextMessage(GetPickupMessage(),'LightGreen',90);
				Rx_Controller(c).CTextMessage("[AGN] Crate system booted - Loaded " $ count $ " crates",'LightGreen',90);
			}
		}
	}

	LogInternal ( "[AGN] REMOVED OLD CRATES ARRAY" );
	//Rx_Game(class'WorldInfo'.static.GetWorldInfo()).AllCrates.Length = 0;
	Rx_Game(`WorldInfoObject.Game).AllCrates.Length = 0;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', RxCratePickup)
	{
		if ( RxCratePickup.MessageClass == class'Rx_Message_Crates' )
		{
			RxCratePickup.DeactivateCrate();
		}
	}
	
	SetTimer(10, false, 'WelcomeMessages');
}

function Mutate(string MutateString, PlayerController Sender)
{
	// Call our VehicleMutator
	if ( VehMutator != None )
		VehMutator.OnMutate(MutateString, Sender);

	MutateHandler(MutateString, Sender);
	Super.Mutate(MutateString, Sender);
}

reliable server function MutateHandler(string MutateString, PlayerController Sender)
{
	local array<string> MutateStringSplit;
	
	MutateStringSplit = SplitString ( MutateString, " ", true );
	if ( MutateStringSplit.Length == 0) return;
	
	if ( MutateStringSplit.Length == 1 && MutateStringSplit[0] ~= "agn_admin" )
	{
		if (!Sender.PlayerReplicationInfo.bAdmin)
		{
			Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
			return;
		}
		
		Sender.ClientMessage("[AGN-Admin] - use agn_admin help for help");
		return;
	}
	
	if ( MutateStringSplit.Length > 1 && MutateStringSplit[0] ~= "agn_admin" )
	{
		/*
		 * [0] = agn_admin
		 * [1] = cmd
		 * (2) = params (optional, depends on cmd)
		 */
		 
		if (!Sender.PlayerReplicationInfo.bAdmin)
		{
			Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
			return;
		}
		 
		Sender.ClientMessage("1 = |" $ MutateStringSplit[1] $ "|");
		if ( MutateStringSplit[1] ~= "help" )
		{
			Sender.ClientMessage("[AGN-Admin] Commands: respawn_crates, despawn_crates (case sensitive)");
		}else if ( MutateStringSplit[1] ~= "respawn_crates" )
		{
			AGNAdmin_RespawnCrates(Sender);
		}else if ( MutateStringSplit[1] ~= "despawn_crates" )
		{
			AGNAdmin_DespawnCrates(Sender);
		} else {
			Sender.ClientMessage("[AGN-Crates-Admin] Unknown command");
		}
	}
}

function AGNAdmin_RespawnCrates(PlayerController Sender)
{
	local AGN_CratePickup CratePickup;
	local int count;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		if(!CratePickup.getIsActive())
		{
			count++;
			CratePickup.ActivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}
	
	Sender.ClientMessage("[AGN-Crates-Admin] Re-spawned " $ count $ " crates");
}

function AGNAdmin_DespawnCrates(PlayerController Sender)
{
	local AGN_CratePickup CratePickup;
	local int count;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		if(CratePickup.getIsActive())
		{
			count++;
			CratePickup.DeactivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}
	
	Sender.ClientMessage("[AGN-Crates-Admin] Despawned " $ count $ " crates");
}

function bool CheckReplacement(Actor Other)
{
	// Call our Vehicle Mutator
	if ( VehMutator != None )
		VehMutator.OnClassReplacement(Other);

	if(Other.IsA('Rx_Pickup') && !Other.IsA('AGN_Pickup'))
	{
		LogInternal("[AGN] Attempting to write over Rx_CratePickup (AllCrates)...");
		ReplaceWith(Other, "AGN_Mut_AlienXSystem.AGN_Pickup");
	}

	if (other.isA('Rx_CratePickup') && !other.isA('AGN_CratePickup'))
	{	
		ReplaceWith(Other,"AGN_Mut_AlienXSystem.AGN_CratePickup");
	}

	if(Other.IsA('Rx_TeamInfo'))
	{
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
	}

	// Call our Super BaseDefences 
	Super.CheckReplacement(Other);
	
	return true;
}

DefaultProperties
{
}