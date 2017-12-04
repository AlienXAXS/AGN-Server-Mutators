/*
 *
 * ---  Random Weapon Crate ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- Sarah & AlienX
 */

class AGN_CrateType_RandomWeapon extends AGN_CrateType;

//AlienX: Put the WeaponClass variable up here so that it can be used elsewhere in the script.
var class<Rx_Weapon> WeaponClass;
var config float ProbabilityIncreaseWhenInfantryProductionDestroyed;
var array<class <Rx_Weapon> > weaponList;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return "GAME" `s "Crate;" `s "`weapon`" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return "You were given a " $ WeaponClass.default.PickupMessage $ "!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
    local Rx_Building building;
    local float Probability;
    Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

    if (isSBH(Recipient)) // Don't swap character if we have paid for a unit
          return 0;

    ForEach CratePickup.AllActors(class'Rx_Building',building)
    {
      if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_InfantryFactory(building) != none  && Rx_Building_GDI_InfantryFactory(building).IsDestroyed()) ||
        (Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_InfantryFactory(building) != none  && Rx_Building_Nod_InfantryFactory(building).IsDestroyed()))
      {
        Probability += ProbabilityIncreaseWhenInfantryProductionDestroyed;
      }
    }

        return Probability;
    }

  function bool isSBH(Rx_Pawn Recipient)
    {
        if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_StealthBlackHand')
            return true;

        return false;
    }

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	local Rx_InventoryManager InvManager;
	WeaponClass = weaponList[rand(weaponList.Length)];
	InvManager = Rx_InventoryManager(Recipient.InvManager);


	if (InvManager.PrimaryWeapons.Find(WeaponClass) < 0) { // Make sure it isn't in there already.
		WeaponClass = weaponList[rand(weaponList.Length)]; // Hopefully this will resolve the issue with duplicate weapons.
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
    BroadcastMessageIndex = 1002
    weaponList.Add(class'Rx_Weapon_VoltAutoRifle_GDI')
    weaponList.Add(class'Rx_Weapon_TiberiumFlechetteRifle')
    weaponList.Add(class'Rx_Weapon_TiberiumFlechetteRifle')
    weaponList.Add(class'Rx_Weapon_TiberiumFlechetteRifle')
    weaponList.Add(class'Rx_Weapon_TacticalRifle')
    weaponList.Add(class'Rx_Weapon_GrenadeLauncher')
    weaponList.Add(class'Rx_Weapon_Shotgun')
    weaponList.Add(class'Rx_Weapon_Railgun')
    weaponList.Add(class'Rx_Weapon_PersonalIonCannon')
    weaponList.Add(class'Rx_Weapon_RepairGun')
    weaponList.Add(class'Rx_Weapon_RocketLauncher')
    weaponList.Add(class'Rx_Weapon_FlameThrower')
    weaponList.Add(class'Rx_Weapon_FlakCannon')
    weaponList.Add(class'Rx_Weapon_Chaingun_Nod')
    weaponList.Add(class'Rx_Weapon_ChemicalThrower')
    weaponList.Add(class'Rx_Weapon_AutoRifle_Nod')
    weaponList.Add(class'Rx_Weapon_RepairGunAdvanced')
    weaponList.Add(class'Rx_Weapon_HeavyPistol')
    weaponList.Add(class'Rx_Weapon_Carbine')
    weaponList.Add(class'Rx_Weapon_LaserChainGun')
    weaponList.Add(class'Rx_Weapon_LaserRifle')
    PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}
