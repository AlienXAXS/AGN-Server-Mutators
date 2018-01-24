/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_InventoryManager extends Rx_InventoryManager;

simulated function array<class<Rx_Weapon> > GetAvailableItems() { return default.AvailableItems; }
simulated function bool IsItemAllowed(class<Rx_Weapon> w) { return IsClassifiedWeaponAllowed(w, GetAvailableItems()); }

private simulated function bool IsClassifiedWeaponAllowed(class<Rx_Weapon> w, array<class<Rx_Weapon> > a)
{
	local int i;

	for (i = 0; i < a.length; i++)
	{
		`log("Is " $ string(a[i]) $ " == " $ string(w));
		if (a[i] == w) return true;
	}

	`log("Invalid Weapon/Item etc");
	return false;
}

simulated function Rx_Weapon AddWeaponOfClass(class<Rx_Weapon> wclass, EClassification classindex)
{
	local Rx_Weapon w;
	
	switch (classindex)
	{
		case CLASS_PRIMARY:
			if(IsPrimaryWeaponAllowed(wclass)){
					// `log("Adding weapons from IsPrimaryWeaponAllowed()");
				PrimaryWeapons.AddItem(wclass);
			} 
			else if (wclass == class'Rx_Weapon_Grenade' 
				|| wclass == class'Rx_Weapon_ProxyC4'
				|| wclass == class'Rx_Weapon_EMPGrenade'
				|| wclass == class'Rx_Weapon_SmokeGrenade'
				|| wclass == class'Rx_Weapon_ATMine') {
					// `log("Adding weapons");
				PrimaryWeapons.AddItem(wclass);
			} 
			else {
				// `log("Failed adding weapons");
				return None;	
			}
			break;
		case CLASS_SECONDARY:
			if(IsSecondaryWeaponAllowed(wclass))
				SecondaryWeapons.AddItem(wclass);
			else
				return None;					
			break;
		case CLASS_SIDEARM:
			if(IsSidearmWeaponAllowed(wclass))
				SidearmWeapons.AddItem(wclass);
			else
				return None;					
			break;
		case CLASS_EXPLOSIVE:
			if(IsExplosiveWeaponAllowed(wclass))
				ExplosiveWeapons.AddItem(wclass);
			else
				return None;					
			break;
		case CLASS_ITEM:
			if(IsItemAllowed(wclass))
				Items.AddItem(wclass);
			else
				return None;					
			break;
	}

	if(FindInventoryType(wclass) != None) {
		SetCurrentWeapon(Rx_Weapon(FindInventoryType(wclass)));
		Rx_Pawn(Owner).RefreshBackWeapons();
		
		return None;
	}

	w = Rx_Weapon(CreateInventory(wclass, false));
	SetCurrentWeapon(w);
	Rx_Pawn(Owner).RefreshBackWeapons();
	//PromoteAllWeapons(Rx_PRI(Owner.PlayerReplicationInfo).VRank);
	if(ROLE == ROLE_Authority) w.PromoteWeapon(Rx_Pawn(Owner).VRank);
	
	return w;
}

DefaultProperties
{
	AvailableItems(0) = class'Rx_Weapon_IonCannonBeacon'
	AvailableItems(1) = class'Rx_Weapon_NukeBeacon'
	AvailableItems(2) = class'Rx_Weapon_Airstrike_GDI'
	AvailableItems(3) = class'Rx_Weapon_Airstrike_Nod'
	AvailableItems(4) = class'Rx_Weapon_RepairTool'
}


