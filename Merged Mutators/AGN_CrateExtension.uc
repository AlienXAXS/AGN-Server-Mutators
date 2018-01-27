class AGN_CrateExtension extends Rx_Mutator;

var array<class<Rx_CrateType> >   DefaultCrateTypes;
var array <Rx_CrateType> InstancedCrateTypes;
var Rx_CratePickup GlobalCratePickup;
	
function OnMutatorLoaded()
{
	local Rx_CratePickup CratePickup;
	local int i;
	
	`log("[AGN-CrateExtension] There are " $ string(DefaultCrateTypes.Length) $ " custom crates to load" );
	
	for (i = 0; i <= DefaultCrateTypes.Length-1; i++)
	{
		`log ( "[AGN-CrateExtension] (Iteration "$string(i)$") Creating a new instanced crate type, with the class of " $ string(DefaultCrateTypes[i]) );
		InstancedCrateTypes.AddItem(new DefaultCrateTypes[i]);
	}

	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', CratePickup)
	{
		GlobalCratePickup = CratePickup;
		break;
	}
	
	if ( GlobalCratePickup == None )
		`log( "[AGN-CrateExtension] ERROR ####### -- GlobalCratePickup is NONE!" );
}

function OnAdminRespawnCrates(PlayerController Sender)
{
	local Rx_CratePickup CratePickup;
	local int count;

	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', CratePickup)
	{
		if(!CratePickup.getIsActive())
		{
			count++;
			CratePickup.ActivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}

	Sender.ClientMessage("[AGN-CrateExtension] Re-spawned " $ count $ " crates");
}

function OnAdminDespawnCrates(PlayerController Sender)
{
	local Rx_CratePickup CratePickup;
	local int count;

	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', CratePickup)
	{
		if(CratePickup.getIsActive())
		{
			count++;
			CratePickup.DeactivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}

	Sender.ClientMessage("[AGN-CrateExtension] Despawned " $ count $ " crates");
}

function Rx_CrateType OnDetermineCrateType(Rx_Pawn Recipient)
{
	local int i;
	local float probabilitySum, random;
	local array<float> probabilities;
	
	if ( GlobalCratePickup == None )
		return None;
	
	// Get sum of probabilities, and cache values
	for (i = 0; i < InstancedCrateTypes.Length; i++)
	{
		if (WorldInfo.GRI.ElapsedTime >= InstancedCrateTypes[i].StartSpawnTime)
		{
			probabilities.AddItem(InstancedCrateTypes[i].GetProbabilityWeight(Recipient,GlobalCratePickup));
			probabilitySum += probabilities[i];
		}
		else
			probabilities.AddItem(0.0f);
	}

	random = FRand() * probabilitySum;

	for (i = 0; i < InstancedCrateTypes.Length; i++)
	{
		if (random <= probabilities[i])
			return InstancedCrateTypes[i];
		else
			random -= probabilities[i];
	}

	// The code should not get here, but if something screwed up above, return None so that the game itself deals with it
	return None;
}

function string OnCratePickupMessageBroadcastPre(int CrateMesageID, PlayerReplicationInfo PRI)
{
	if(CrateMesageID == 1001)
	{
		return PRI.PlayerName $ " found a super money crate!";
	}
	if(CrateMesageID == 1002)
	{
		return PRI.PlayerName $ " found a weapon crate!";
	}
	if(CrateMesageID == 1003)
	{
		return PRI.PlayerName $ " found a drop money crate!";
	}
	if(CrateMesageID == 1004)
	{
		return PRI.PlayerName $ " found a beacon crate!";
	}
	if(CrateMesageID == 1005)
	{
	    return PRI.PlayerName $ " found a base defense EMP crate!"; 
	}
	if(CrateMesageID == 1006)
	{
	    return PRI.PlayerName $ " found a mega speed crate!"; 
	}
	if(CrateMesageID == 1007)
	{
	    return PRI.PlayerName $ " found a Personal Obelisk Cannon crate!"; 
	}
	if(CrateMesageID == 1008)
	{
	    return PRI.PlayerName $ " found a Tesla Tank crate!"; 
	}
	
	// Default
	return "";
}

defaultproperties
{
	DefaultCrateTypes[0] = class'AGN_CrateType_Money'
	DefaultCrateTypes[1] = class'AGN_CrateType_Spy'
	DefaultCrateTypes[2] = class'AGN_CrateType_Refill'
	DefaultCrateTypes[3] = class'AGN_CrateType_Vehicle'
	DefaultCrateTypes[4] = class'AGN_CrateType_Suicide'
	DefaultCrateTypes[5] = class'AGN_CrateType_Character'
	DefaultCrateTypes[6] = class'AGN_CrateType_TimeBomb'
	DefaultCrateTypes[7] = class'AGN_CrateType_Nuke'
	DefaultCrateTypes[8] = class'AGN_CrateType_Speed'
	DefaultCrateTypes[9] = class'AGN_CrateType_Abduction'
	DefaultCrateTypes[10] = class'AGN_CrateType_TSVehicle'
	DefaultCrateTypes[11] = class'AGN_CrateType_SuperMoney'
	DefaultCrateTypes[12] = class'AGN_CrateType_RandomWeapon'
	DefaultCrateTypes[13] = class'AGN_CrateType_Beacon'
	DefaultCrateTypes[14] = class'AGN_CrateType_BasePower'
	DefaultCrateTypes[15] = class'AGN_CrateType_MegaSpeed'
	DefaultCrateTypes[16] = class'AGN_CrateType_Veterancy'
	DefaultCrateTypes[17] = class'AGN_CrateType_PersonalObeliskCannon'
	DefaultCrateTypes[18] = class'AGN_CrateType_RAVehicle'
}