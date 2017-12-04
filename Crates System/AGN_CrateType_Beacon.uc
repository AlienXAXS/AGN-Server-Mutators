/*
 *
 * ---  Random Beacon Crate ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- Sarah & AlienX
 */

class AGN_CrateType_Beacon extends AGN_CrateType;

//AlienX: Put the WeaponClass variable up here so that it can be used elsewhere in the script.
var class<Rx_Weapon> WeaponClass;
var array<class <Rx_Weapon> > BeaconType;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return "GAME" `s "Crate;" `s "`beacon`" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	//AlienX: WeaponClass is now accessable at the top of the class, so it can be read here now
  if(WeaponClass == class'Rx_Weapon_NukeBeacon'){
     return Repl("You got a `beacon`!","`beacon`", "Nuclear Strike Beacon", false);
   } else {
     return Repl("You got an `beacon`!","`beacon`", "Ion Cannon Beacon", false);
 }
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
    local Rx_Building building;
    local float Probability;

        Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

        ForEach CratePickup.AllActors(class'Rx_Building',building)
        {
            if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_InfantryFactory(building) != none  && Rx_Building_GDI_InfantryFactory(building).IsDestroyed()) ||
                (Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_InfantryFactory(building) != none  && Rx_Building_Nod_InfantryFactory(building).IsDestroyed()))
            {
              //  Probability += ProbabilityIncreaseWhenInfantryProductionDestroyed;
            }
        }

        return Probability;
    }

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	local Rx_InventoryManager InvManager;
	WeaponClass = BeaconType[rand(BeaconType.Length)];
	InvManager = Rx_InventoryManager(Recipient.InvManager);

	if (InvManager.PrimaryWeapons.Find(WeaponClass) < 0) { // Make sure it isn't in there already.
		WeaponClass = BeaconType[rand(BeaconType.Length)]; // Hopefully this will resolve the issue with duplicate weapons.
	}
	InvManager.PrimaryWeapons.AddItem(WeaponClass); // Give it

	if(InvManager.FindInventoryType(WeaponClass) != None)
	{
		InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.FindInventoryType(WeaponClass)));
	} else {
		InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.CreateInventory(WeaponClass, false)));
	}
}

DefaultProperties
{
    BroadcastMessageIndex = 22
    BeaconType.Add(class'Rx_Weapon_NukeBeacon')
    BeaconType.Add(class'Rx_Weapon_IonCannonBeacon')
    PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}
