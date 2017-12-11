class AGN_Veh_GfxPurchaseMenu extends Rx_GFxPurchaseMenu;

var GFxClikWidget VehicleMenuButton2[9];

var PTMenuBlock GDIItemMenuData2[8];
var PTMenuBlock NodItemMenuData2[8];

var PTVehicleBlock GDIVehicleMenuData2[9];
var PTVehicleBlock NodVehicleMenuData2[9];

var PTMenuBlock GDIClassMenuData2[10];
var PTMenuBlock NodClassMenuData2[10];

var PTMenuBlock NodMainMenuData2[10];
var PTMenuBlock GDIMainMenuData2[10];

var private class<Rx_FamilyInfo> OwnedFamilyInfo2;
var private class<Rx_Weapon> OwnedSidearm2, OwnedExplosive2, OwnedItem2;

function Initialize(LocalPlayer player, Rx_BuildingAttachment_PT PTOwner)
{
	local byte i; 
	local string WidgetTeamPrefix;
	local array<PTEquipmentBlock> explosiveData;
	local array<PTEquipmentBlock> sidearmData;
	local Rx_InventoryManager rxInv;

	`log("<PT Log> ------------------ [ Setting up ] ------------------ ");
	Init(player);
	Start();
	Advance(0.0f);

	
	rxPC						=	AGN_Rx_Controller(GetPC());
	rxHUD						=	Rx_HUD(rxPC.myHUD);
	rxBuildingOwner				=   PTOwner;
	rxPRI						=	Rx_PRI(rxPC.PlayerReplicationInfo);

	rxPC.bIsInPurchaseTerminal	=   true;
	rxHUD.bShowHUD              =   false;
	rxHUD.bCrosshairShow        =   false;
	
	//store items here
	rxInv                       =   Rx_InventoryManager(RxPC.Pawn.InvManager);

	// 	[ASSIGN ROOT MC]
	Root                        =   GetVariableObject("_root");

	//ButtonGroup Widget
	MainMenuGroup               =   InitButtonGroupWidget("mainMenu", Root);
	ClassMenuGroup				=	InitButtonGroupWidget("classMenu", Root);
	ItemMenuGroup				=	InitButtonGroupWidget("itemMenu", Root);
	WeaponMenuGroup				=	InitButtonGroupWidget("weaponMenu", Root);
	VehicleMenuGroup			=	InitButtonGroupWidget("vehicleMenu", Root);
	EquipmentMenuGroup          =   InitButtonGroupWidget("equipmentMenu", Root);


	VehicleDrawer				=	GetVariableObject("_root.vehicleDrawer");
	EquipmentDrawer				=	GetVariableObject("_root.equipmentDrawer");
	BottomDrawer				=	GetVariableObject("_root.bottomDrawer");
	MainDrawer					=	GetVariableObject("_root.mainDrawer");
	ClassDrawer					=	GetVariableObject("_root.classDrawer");
	ItemDrawer					=	GetVariableObject("_root.itemDrawer");

	ExitTween 					=	GetVariableObject("_root.bottomDrawer.exitButton");
	BackTween 					=	GetVariableObject("_root.bottomDrawer.backButton");
	VehicleInfoTween 			=	GetVariableObject("_root.bottomDrawer.vehicleInfoButton");
	CreditsTween 				=	GetVariableObject("_root.bottomDrawer.creditsButton");
	PurchaseTween 				=	GetVariableObject("_root.bottomDrawer.purchaseButton");

	CursorMC                    =   GetVariableObject("_root.CursorMC");

	LastCursorXPosition         =   CursorMC.GetFloat("x");

	WidgetTeamPrefix            =   TeamID == TEAM_GDI ? "GDI" : "Nod";

	GetVariableObject("_root.bottomDrawer.exitButton.PTButton").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.bottomDrawer.backButton.PTButton").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.bottomDrawer.vehicleInfoButton.PTButton").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.bottomDrawer.creditsButton.PTButton").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.bottomDrawer.purchaseButton.PTButton").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.equipmentDrawer.tween.equipsidearm").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
	GetVariableObject("_root.equipmentDrawer.tween.equipexplosives").GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);

	//	[ASSIGN EXIT BACK VEHICLE CREDITS PURCHASEBUTTON]
	ExitButton 					=	GFxClikWidget(GetVariableObject("_root.bottomDrawer.exitButton.PTButton."$WidgetTeamPrefix $"Button", class'GFxClikWidget'));
	ExitButton.SetString("label", "<b>"$"<font size='14'>Exit [</font>" $ "<font size='10'> Escape </font>" $ "<font size='14'>]</font>"$"</b>");

	BackButton 					=	GFxClikWidget(GetVariableObject("_root.bottomDrawer.backButton.PTButton."$WidgetTeamPrefix $"Button", class'GFxClikWidget'));
	BackButton.SetString("label", "<b>"$"<font size='14'>Back [</font>" $ "<font size='10'> Back Space </font>" $ "<font size='14'>]</font>"$"</b>");

	VehicleInfoButton 			=	GFxClikWidget(GetVariableObject("_root.bottomDrawer.vehicleInfoButton.PTButton."$WidgetTeamPrefix $"Button", class'GFxClikWidget'));

	CreditsButton 				=	GFxClikWidget(GetVariableObject("_root.bottomDrawer.creditsButton.PTButton."$WidgetTeamPrefix $"Button", class'GFxClikWidget'));
	CreditsButton.SetString("label", "Credits: 0");
	
	PurchaseButton 				=	GFxClikWidget(GetVariableObject("_root.bottomDrawer.purchaseButton.PTButton."$WidgetTeamPrefix $"Button", class'GFxClikWidget'));
	PurchaseButton.SetString("label", "<b>"$"<font size='14'>Purchase [</font>" $ "<font size='10'> Enter </font>" $ "<font size='14'>]</font>"$"</b>");




	OwnedFamilyInfo2 = Rx_Pawn(RxPC.Pawn).GetRxFamilyInfo();

	if (rxInv.SidearmWeapons.Length > 0) {
		OwnedSidearm2            =   rxInv.SidearmWeapons[rxInv.SidearmWeapons.Length - 1];
	}
	if (rxInv.ExplosiveWeapons.Length > 0){
		if (OwnedFamilyInfo2 == class'Rx_FamilyInfo_GDI_Hotwire' || OwnedFamilyInfo2 == class'Rx_FamilyInfo_Nod_Technician') {
			OwnedExplosive2      =   rxInv.ExplosiveWeapons[rxInv.ExplosiveWeapons.Length - 1];
		} else {
			OwnedExplosive2      =   rxInv.ExplosiveWeapons[rxInv.ExplosiveWeapons.Length - 1];
		}
	}
	if (rxInv.Items.Length > 0){
		OwnedItem2               =   rxInv.Items[rxInv.Items.Length - 1];
	}



	`log("<PT Log> rxPC.bJustBaughtEngineer= "$ rxPC.bJustBaughtEngineer);
	`log("<PT Log> rxPC.bJustBaughtHavocSakura= "$ rxPC.bJustBaughtHavocSakura);
	`log("<PT Log> OwnedFamilyInfo2= " $ OwnedFamilyInfo2);
	`log("");
	`log("<PT Log> OwnedSidearm2= " $ OwnedSidearm2);
	`log("<PT Log> OwnedExplosive2= " $ OwnedExplosive2);
	`log("<PT Log> OwnedItem2= " $ OwnedItem2);
	`log("");


	`log("<PT Log> rxPC.CurrentSidearmWeapon= " $ rxPC.CurrentSidearmWeapon);

	`log("<PT Log> rxPC.CurrentExplosiveWeapon= " $ rxPC.CurrentExplosiveWeapon);

	`log("[AGN-PT] Assigning Character Classes (" $ WidgetTeamPrefix $ ")...");
	for (i = 0; i < 10; i++) {
		`log(" > On iteration " $ i $ " step 1");
		GetVariableObject("_root.mainDrawer.tween.btnMenu"$i).GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
		GetVariableObject("_root.classDrawer.tween.btnMenu"$i).GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
		GetVariableObject("_root.itemDrawer.tween.btnMenu"$i).GotoAndStopI(TeamID == TEAM_GDI? 1 : 2);
		
		`log(" > On iteration " $ i $ " step 2");
		
		MainMenuButton[i] 		= 	GFxClikWidget(GetVariableObject("_root.mainDrawer.tween.btnMenu"$i $"."$WidgetTeamPrefix$"Button", class'GFxClikWidget'));	
		
		`log(" > Assninging Button Data (" $ TeamID $ ")..." $ MainMenuButton[i]);
		`log(" GDIMenuData: " $ GDIMainMenuData2[i].title);
		`log(" NodMenuData: " $ NodMainMenuData2[i].title);
		AssignButtonData(MainMenuButton[i], TeamID == TEAM_GDI ? GDIMainMenuData2[i] : NodMainMenuData2[i], i);
		
		`log(" > Assining button group to " $ MainMenuGroup);
		MainMenuButton[i].SetObject("group", MainMenuGroup);

		if(i == 9)
		{
			`log(" > On iteration " $ i $ " step 2a");
			MainMenuButton[i].SetBool("enable", false);
			MainMenuButton[i].SetVisible(false);
		}
		
		`log(" > On iteration " $ i $ " step 3");
		ClassMenuButton[i] 		=	GFxClikWidget(GetVariableObject("_root.classDrawer.tween.btnMenu"$i $"."$WidgetTeamPrefix$"Button", class'GFxClikWidget'));
		ItemMenuButton[i] 		=	GFxClikWidget(GetVariableObject("_root.itemDrawer.tween.btnMenu"$i $"."$WidgetTeamPrefix$"Button", class'GFxClikWidget'));
		
		`log(" > On iteration " $ i $ " step 4");
		AssignButtonData(ClassMenuButton[i], TeamID == TEAM_GDI ? GDIClassMenuData2[i] : NodClassMenuData2[i], i);
		ClassMenuButton[i].SetObject("group", ClassMenuGroup);
		
		`log(" > On iteration " $ i $ " step 5");
		//Enable the first 8 items in item menu, disable the rest
		if (i < 8) {
			`log(" > On iteration " $ i $ " step 5a");
			AssignButtonData(ItemMenuButton[i], TeamID == TEAM_GDI ? GDIItemMenuData2[i] : NodItemMenuData2[i], i);
			ItemMenuButton[i].SetObject("group", ItemMenuGroup);
		} else {
			`log(" > On iteration " $ i $ " step 5b");
			ItemMenuButton[i].SetBool("enable", false);
			ItemMenuButton[i].SetVisible(false);
		}
	}
	
	`log("[AGN-PT] Assigning Vehicle Data...");

	for (i = 0; i < 9; i++) {
		`log(" > On iteration " $ i);
		GetVariableObject("_root.vehicleDrawer.tween.btnVehicle"$i).GotoAndStopI(TeamID == TEAM_GDI ? 1 : 2);

		if (TeamID == TEAM_GDI) {
				VehicleMenuButton2[i] = GFxClikWidget(GetVariableObject("_root.vehicleDrawer.tween.btnVehicle" $ i $"." $WidgetTeamPrefix $"Button", class 'GFxClikWidget'));
			if (i == 8) {
				VehicleMenuButton2[i].SetBool("enable", false);
				VehicleMenuButton2[i].SetVisible(false);
			}
		} else if (TeamID == TEAM_NOD) {
			VehicleMenuButton2[i] = GFxClikWidget(GetVariableObject("_root.vehicleDrawer.tween.btnVehicle" $ i $"." $WidgetTeamPrefix $"Button", class 'GFxClikWidget'));
		}
 		AssignVehicleData(VehicleMenuButton2[i], TeamID == TEAM_GDI ? GDIVehicleMenuData2[i] : NodVehicleMenuData2[i], i);
 		VehicleMenuButton2[i].SetObject("group", VehicleMenuGroup);

	}
	
	`log("[AGN-PT] >>  Done");
	
	EquipSideArmButton 			=	GFxClikWidget(GetVariableObject("_root.equipmentDrawer.tween.equipsidearm."$WidgetTeamPrefix $"Button", class 'GFxClikWidget'));
	EquipSideArmList 			=	GFxClikWidget(GetVariableObject("_root.equipmentDrawer.tween.equipsidearm."$WidgetTeamPrefix $"EquipmentList", class 'GFxClikWidget'));
	EquipExplosivesButton 		=	GFxClikWidget(GetVariableObject("_root.equipmentDrawer.tween.equipexplosives."$WidgetTeamPrefix $"Button", class 'GFxClikWidget'));
	EquipExplosivesList 		=	GFxClikWidget(GetVariableObject("_root.equipmentDrawer.tween.equipexplosives."$WidgetTeamPrefix $"EquipmentList", class 'GFxClikWidget'));

	explosiveData = TeamID == TEAM_GDI ? GDIEquipmentExplosiveData : NodEquipmentExplosiveData;
	sidearmData = TeamID == TEAM_GDI ? GDIEquipmentSideArmData : NodEquipmentSideArmData;

	if (rxPC.CurrentSidearmWeapon != none) {
		AssignEquipmentData(EquipSideArmButton, EquipSideArmList, sidearmData, rxInv.AvailableSideArmWeapons, rxPC.CurrentSidearmWeapon);
	} else {
		
		AssignEquipmentData(EquipSideArmButton, EquipSideArmList, sidearmData, rxInv.AvailableSidearmWeapons, rxInv.class.default.SidearmWeapons[0]);
	}
	EquipSideArmButton.SetObject("group", EquipmentMenuGroup);

	if (rxPC.bJustBaughtEngineer 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Hotwire' 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Technician'){
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_TimedC4')]);
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_RemoteC4')]);
			explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_ProxyC4')].bFree = true;

			//log
			`log("<PT Log>              ====================== ");
			
			for (i=0; i<explosiveData.Length; i++) {
				`log("<PT Log> Engi explosiveData["$ i $"]= " $ explosiveData[i].title);
			}

	} else if (rxPC.bJustBaughtHavocSakura 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Havoc'
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Sakura' ) {
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_TimedC4')]);
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_ProxyC4')]);
			explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_RemoteC4')].bFree = true;
		}
	
	else {
		
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_RemoteC4')]);
			explosiveData.RemoveItem(explosiveData[explosiveData.Find('WeaponClass', class'Rx_Weapon_ProxyC4')]);

			//log
			`log("<PT Log>              ====================== ");
			for (i=0; i<explosiveData.Length; i++) {
				`log("<PT Log> Norm explosiveData["$ i $"]= " $ explosiveData[i].title);
			}
	}

	if (rxPC.CurrentExplosiveWeapon != none) {
		AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, rxPC.CurrentExplosiveWeapon);
	} else {
		if (rxPC.bJustBaughtEngineer 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Hotwire' 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Technician'){
			`log("<PT Log> engi rxPC.Pawn.InvManager= " $ rxPC.Pawn.InvManager);
			if (TeamID == TEAM_GDI) {
				AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, class'Rx_InventoryManager_GDI_Hotwire'.default.ExplosiveWeapons[0]);
			} else {
				AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, class'Rx_InventoryManager_Nod_Technician'.default.ExplosiveWeapons[0]);
			}
		} else if (rxPC.bJustBaughtHavocSakura 
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Havoc'
		|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Sakura' ) {
			`log("<PT Log> Hvc/Skr rxPC.Pawn.InvManager= " $ rxPC.Pawn.InvManager);
			if (TeamID == TEAM_GDI) {
				AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, class'Rx_InventoryManager_GDI_Havoc'.default.ExplosiveWeapons[0]);
			} else {
				AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, class'Rx_InventoryManager_Nod_Sakura'.default.ExplosiveWeapons[0]);
			}
		} else {
			`log("<PT Log> norm rxPC.Pawn.InvManager= " $ rxPC.Pawn.InvManager);
			AssignEquipmentData(EquipExplosivesButton, EquipExplosivesList, explosiveData , rxInv.AvailableExplosiveWeapons, class'Rx_InventoryManager'.default.ExplosiveWeapons[0]);
		}
	}
	EquipExplosivesButton.SetObject("group", EquipmentMenuGroup);


	bIsInTransition = true;
	BottomWidgetFadeIn(ExitTween);
	BottomWidgetFadeIn(CreditsTween);
	BottomWidgetFadeIn(PurchaseTween);
	MainDrawerFadeIn();
	//EquipmentDrawerFadeIn();
	bIsInTransition = false;;

	//  [WIRE EVENTS FOR EQUIPMENT BUTTON]
	RemoveWidgetEvents();
	AddWidgetEvents();

	//set the dummy pawn/vehicle here
	SetupPTDummyActor();
	
	`log("[AGN-PT] Init Complete");
}

function AssignButtonData(GFxClikWidget widget, PTMenuBlock menuData, byte i)
{
	local GFxObject Type;

	////`log("AssignButtonData > 1");
	
	//if (i == menuData.ID) {
		widget.SetString("hotkeyLabel", menuData.hotkey);
		widget.SetString("data", "" $ menuData.ID);
		widget.SetString("label", menuData.title);
		
		//`log("AssignButtonData > 1 end");
		//`log("AssignButtonData > 2");

		//if this is engineer type, display repair bar instead.
		if (menuData.title == "ENGINEER" || menuData.title == "HOTWIRE" || menuData.title == "TECHNICIAN") {
			//`log("AssignButtonData > 2a");
			widget.SetBool("isDamageBar", false);
		}
		
		//`log("AssignButtonData > 2 end");
		
		//`log("AssignButtonData > 3 (" $ string(menuData.BlockType) $")");
		//widget.SetString("Group", menuData.Group);
		switch (menuData.BlockType)
		{
			case EPBT_MENU:
				//`log("AssignButtonData > 3 EPBT_MENU");
				widget.SetString("costLabel", "MENU");
				widget.SetBool("toggle", false);
				//`log("AssignButtonData > 3 EPBT_MENU END");
				break;
			case EPBT_CLASS:
				//`log("AssignButtonData > 3 EPBT_CLASS");
				if (rxPurchaseSystem.GetClassPrices(TeamID, menuData.ID) > 0) {
					widget.SetString("costLabel", "$" $ rxPurchaseSystem.GetClassPrices(TeamID, menuData.ID));
				} else {
					widget.SetString("costLabel", "FREE");
				}
				widget.SetBool("toggle", true);
				//`log("AssignButtonData > 3 EPBT_CLASS END");
				break;
			case EPBT_ITEM:
				//`log("AssignButtonData > 3 EPBT_ITEM");
				if (rxPurchaseSystem.GetItemPrices(TeamID, menuData.ID) > 0) {
					widget.SetString("costLabel", "$" $ rxPurchaseSystem.GetItemPrices(TeamID, menuData.ID));
				} else {
					widget.SetString("costLabel", "FREE");
				}
				widget.SetBool("toggle", true);
				//`log("AssignButtonData > 3 EPBT_ITEM END");
				break;
			case EPBT_WEAPON:
				//`log("AssignButtonData > 3 EPBT_WEAPON");
				if (rxPurchaseSystem.GetWeaponPrices(TeamID, menuData.ID) > 0) {
					widget.SetString("costLabel", "$" $ rxPurchaseSystem.GetWeaponPrices(TeamID, menuData.ID));
				} else {
					widget.SetString("costLabel", "FREE");
				}
				widget.SetBool("toggle", true);
				//`log("AssignButtonData > 3 EPBT_WEAPON END");
				break;
		}
		//`log("AssignButtonData > 3 end");
		
		//`log("AssignButtonData > 4");
		//[VEHICLE COUNT]
		Type = widget.GetObject("type");
		Type.GotoAndStopI(menuData.type);
		
		//`log("AssignButtonData > 4 end");
		//Type.GetObject("icon").GotoAndStopI(menuData.iconID);

		//`log("AssignButtonData > 5");
		//`log(" texture: " $ string(menuData.PTIconTexture));
		//the following is the test
		LoadTexture("img://" $ PathName(menuData.PTIconTexture), Type.GetObject("icon"));
		//end test
		//`log("AssignButtonData > 5 end");

		//`log("AssignButtonData > 6");
		if (menuData.title == "VEHICLES" || menuData.title == "CHARACTERS" || menuData.title == "REFILL") {
			widget.SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, menuData.title, rxPC));
			if (menuData.title == "VEHICLES") {
				widget.SetString("vehicleCountLabel", "( "$ VehicleCount $ " )");
			}
		} else {
			widget.SetString("sublabel", menuData.desc);
		}
		if (menuData.type == 2) {
			Type.GetObject("DamageBar").GotoAndStopI(menuData.damage + 1);
			Type.GetObject("RangeBar").GotoAndStopI(menuData.range + 1);
			Type.GetObject("RoFBar").GotoAndStopI(menuData.rateOfFire + 1);
			Type.GetObject("MagCapBar").GotoAndStopI(menuData.magCap + 1);
		}

		widget.SetBool("enabled", menuData.bEnable);
		//hide anything that is disabled
		if (!menuData.bEnable) {
			widget.SetBool("visible", menuData.bEnable);
		}

		if (!rxPurchaseSystem.AreSilosCaptured(TeamID)) {
			if (menuData.bSilo) {
				widget.SetBool("enabled", false);
			}
		}
}

function SetSelectedButtonByIndex (int index, optional bool selected = true)
{
	`log("<PT Log> Button Selected Index? " $ Index);
	if (bMainDrawerOpen) {
		if (index < 5) {
			MainMenuGroup.ActionScriptVoid("setSelectedButtonByIndex");
		}
		return;
	}
	if (bClassDrawerOpen) {
		ClassMenuGroup.ActionScriptVoid("setSelectedButtonByIndex");
		return;
	}
	if (bItemDrawerOpen) {
		if (index < 8){
			ItemMenuGroup.ActionScriptVoid("setSelectedButtonByIndex");
		}
		return;
	}
	if (bVehicleDrawerOpen) {
		if (index < 9) {
			VehicleMenuGroup.ActionScriptVoid("setSelectedButtonByIndex");
		}
		return;
	}
}

function RemoveWidgetEvents()
{
	local byte i;

	for (i = 0; i < 9; i ++)
	{

		MainMenuButton[i].RemoveAllEventListeners("CLIK_buttonClick");
		MainMenuButton[i].RemoveAllEventListeners("buttonClick");
		ClassMenuButton[i].RemoveAllEventListeners("CLIK_buttonClick");
		ClassMenuButton[i].RemoveAllEventListeners("buttonClick");
		ItemMenuButton[i].RemoveAllEventListeners("CLIK_buttonClick");
		ItemMenuButton[i].RemoveAllEventListeners("buttonClick");
	}
	
	for (i = 0; i < 9; i ++)
	{
		VehicleMenuButton2[i].RemoveAllEventListeners("CLIK_buttonClick");
		VehicleMenuButton2[i].RemoveAllEventListeners("buttonClick");
	}
	
	ExitButton.RemoveAllEventListeners("CLIK_buttonClick");
	ExitButton.RemoveAllEventListeners("buttonClick");
	BackButton.RemoveAllEventListeners("CLIK_buttonClick");
	BackButton.RemoveAllEventListeners("buttonClick");
	PurchaseButton.RemoveAllEventListeners("CLIK_buttonClick");
	PurchaseButton.RemoveAllEventListeners("buttonClick");

	EquipSideArmButton.RemoveAllEventListeners("CLIK_buttonClick");
	EquipSideArmButton.RemoveAllEventListeners("buttonClick");
	EquipSideArmList.RemoveAllEventListeners("CLIK_itemClick");
	EquipSideArmList.RemoveAllEventListeners("itemClick");
	EquipExplosivesButton.RemoveAllEventListeners("CLIK_buttonClick");
	EquipExplosivesButton.RemoveAllEventListeners("buttonClick");
	EquipExplosivesList.RemoveAllEventListeners("CLIK_itemClick");
	EquipExplosivesList.RemoveAllEventListeners("itemClick");

	
}

function AddWidgetEvents()
{
	local byte i;

	for (i = 0; i < 10; i ++)
	{
		if (MainMenuButton[i].GetBool("enabled")){
			MainMenuButton[i].AddEventListener('CLIK_buttonClick', OnPTButtonClick);
		}
		if (ClassMenuButton[i].GetBool("enabled")){
			ClassMenuButton[i].AddEventListener('CLIK_buttonClick', OnPTButtonClick);
		}
		if (ItemMenuButton[i].GetBool("enabled")){
			ItemMenuButton[i].AddEventListener('CLIK_buttonClick', OnPTButtonClick);
		}
		/**if (WeaponMenuButton[i].GetBool("enabled")){
			WeaponMenuButton[i].AddEventListener('CLIK_buttonClick', OnPTButtonClick);
		*/
	}
	
	for (i = 0; i < 9; i ++)
	{
		if (VehicleMenuButton2[i].GetBool("enabled")){
			VehicleMenuButton2[i].AddEventListener('CLIK_buttonClick', OnPTButtonClick);
		}
	}

	//bottom drawer 
	ExitButton.AddEventListener('CLIK_buttonClick', OnExitButtonClick);
	BackButton.AddEventListener('CLIK_buttonClick', OnBackButtonClick);
	PurchaseButton.AddEventListener('CLIK_buttonClick', OnPurchaseButtonClick);
	EquipSideArmButton.AddEventListener('CLIK_buttonClick', OnEquipButtonClick);
	EquipSideArmList.AddEventListener('CLIK_itemClick', OnEquipSideArmListItemClick);
	EquipExplosivesButton.AddEventListener('CLIK_buttonClick', OnEquipButtonClick);
	EquipExplosivesList.AddEventListener('CLIK_itemClick', OnExplosivesListItemClick);

}

function SelectMenu(int selectedIndex)
{
	if (selectedIndex != Clamp(selectedIndex, 0, 9) || bIsInTransition) {
		return;
	}
	
	`log("---------------" @ selectedIndex @ "---------------");

	switch (selectedIndex)
	{
		case 0: 
			if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[9].ID : NodClassMenuData2[9].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;		
		case 1: 
			if (bMainDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodMainMenuData2[selectedIndex - 1].ID);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;
		case 2: 
			if (bMainDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodMainMenuData2[selectedIndex - 1].ID);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;
		case 3: 
			if (bMainDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodMainMenuData2[selectedIndex - 1].ID);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;
		case 4: 
			if (bMainDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodMainMenuData2[selectedIndex - 1].ID);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;
		case 5: 
			if (bMainDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodMainMenuData2[selectedIndex - 1].ID);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-1].ID : NodVehicleMenuData[selectedIndex - 1].ID);
			}
			break;
		case 6: 
			if (bMainDrawerOpen) {
				rxPC.PlaySound(SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundRefill');
				
				//set the current weapon to defaults so we can force perform our loadouts
		
				if (rxPC.CurrentSidearmWeapon == none) {
					//rxPC.CurrentSidearmWeapon = class<Rx_InventoryManager>(rxPC.Pawn.InventoryManagerClass).default.SidearmWeapons[0];
					rxPC.CurrentSidearmWeapon = class'Rx_InventoryManager'.default.SidearmWeapons[0];
				}
				
				//`log("<PT Log> rxPC.CurrentExplosiveWeapon? " $ rxPC.CurrentExplosiveWeapon);
				if (rxPC.CurrentExplosiveWeapon == none) {
					if (rxPC.bJustBaughtEngineer 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Hotwire' 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Technician'){
						rxPC.RemoveAllExplosives();
						//class<Rx_InventoryManager>(rxPC.Pawn.InventoryManagerClass).default.ExplosiveWeapons[0]
						if (TeamID == TEAM_GDI) {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_GDI_Hotwire'.default.ExplosiveWeapons[0];
						} else {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_Nod_Technician'.default.ExplosiveWeapons[0];
						}
						//`log("<PT Log> new rxPC.CurrentExplosiveWeapon? " $ rxPC.CurrentExplosiveWeapon);
						rxPC.SetAdvEngineerExplosives(rxPC.CurrentExplosiveWeapon);
					} else if (rxPC.bJustBaughtHavocSakura 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Havoc'
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Sakura' ) {
						rxPC.RemoveAllExplosives();
						//rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager'.default.ExplosiveWeapons[0];
						if (TeamID == TEAM_GDI) {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_GDI_Havoc'.default.ExplosiveWeapons[0];
						} else {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_Nod_Sakura'.default.ExplosiveWeapons[0];
						}
						//`log("<PT Log> new rxPC.CurrentExplosiveWeapon? " $ rxPC.CurrentExplosiveWeapon);
						rxPC.AddExplosives(rxPC.CurrentExplosiveWeapon);
					}  else {
						rxPC.RemoveAllExplosives();
						rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager'.default.ExplosiveWeapons[0];
						//`log("<PT Log> new rxPC.CurrentExplosiveWeapon? " $ rxPC.CurrentExplosiveWeapon);
						rxPC.AddExplosives(rxPC.CurrentExplosiveWeapon);
					}
				}

				SetLoadout();
				rxPC.PerformRefill(rxPC);
				rxPC.SwitchWeapon(0);
				ClosePTMenu(false);
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				if (TeamID == TEAM_NOD) {
					ChangeDummyVehicleClass(NodVehicleMenuData[selectedIndex - 1].ID);
				}
			}
			break;
		case 7: 
			if (bMainDrawerOpen) {
				if (GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')) != none) {
					GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')).SetBool("selected", false);
				}
				//check if there is something transitioning, fade out immidietly
				CancelCurrentAnimations();
				/**if (EquipmentDrawer.GetInt("currentFrame") != 20 && bEquipmentDrawerOpen) {
					EquipmentDrawer.GotoAndPlay("Fade Out");
				} */
				bIsInTransition = true;
				MainDrawerFadeOut();
				//EquipmentDrawerFadeOut();
				ItemDrawerFadeIn();
				BottomWidgetFadeIn(BackTween);
				bIsInTransition = false;
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			} else if (bVehicleDrawerOpen) {
				if (!rxBuildingOwner.AreAircraftDisabled()) {
					ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-2].ID : NodVehicleMenuData[selectedIndex - 1].ID);
				}
			}
			break;
		case 8: 
			if (bMainDrawerOpen) { 
				if (GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')) != none) {
					GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')).SetBool("selected", false);
				}
				//check if there is something transitioning, fade out immidietly
				CancelCurrentAnimations();

				bIsInTransition = true;
				MainDrawerFadeOut();
				ClassDrawerFadeIn();
				BottomWidgetFadeIn(BackTween);
				bIsInTransition = false;
			}else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID);
			}
			else if (bVehicleDrawerOpen) {
				if (!rxBuildingOwner.AreAircraftDisabled()) {
					ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData2[selectedIndex-2].ID : NodVehicleMenuData[selectedIndex - 1].ID);
				}
			}
			break;
		case 9: 
			if (bMainDrawerOpen) {
				if (!rxPurchaseSystem.AreVehiclesDisabled(TeamID, rxPC)) {
					if (GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')) != none) {
						GFxClikWidget(MainMenuGroup.GetObject("selectedButton", class'GFxClikWidget')).SetBool("selected", false);
					}
					//check if there is something transitioning, fade out immidietly
					CancelCurrentAnimations();
				/**	if (EquipmentDrawer.GetInt("currentFrame") != 20 && bEquipmentDrawerOpen) {
						EquipmentDrawer.GotoAndPlay("Fade Out");
					} 
				*/
					bIsInTransition = true;
					rxPC.bIsInPurchaseTerminalVehicleSection = true;
					MainDrawerFadeOut();
					//EquipmentDrawerFadeOut();
					VehicleDrawerFadeIn();
					BottomWidgetFadeIn(BackTween);
					BottomWidgetFadeIn(VehicleInfoTween);
					bIsInTransition = false;
				}
			} else if (bClassDrawerOpen){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[selectedIndex-1].ID : NodClassMenuData2[selectedIndex - 1].ID); 
				//ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData2[9].ID : NodClassMenuData2[9].ID);
			}
			break;
	}
	
}

function TickHUD() 
{
	local Rx_Hud H;
	local Rx_TeamInfo rxTeamInfo;
	local byte i, j;
	local int data;
	local Rx_Vehicle RxV;

	// Draw our custom text here
	H = Rx_HUD(GetPC().myHUD);
	//H = UTHUDBase(HUD);
	if ( H == None )
		return;
	
	H.Canvas.SetDrawColor(0, 255, 0, 120);
	H.Canvas.DrawText("[AGN] Purchase Terminal v0.3",true,1.2f,1.2f);
	
	
	if (!bMovieIsOpen) {
		return;
	}

	rxTeamInfo = Rx_TeamInfo(rxPRI.Team);

	if (PlayerCredits != rxPRI.GetCredits()){
		PlayerCredits = rxPRI.GetCredits();
		CreditsButton.SetString("label", "Credits: "$int(PlayerCredits));
	}

	if (VehicleCount != rxTeamInfo.GetVehicleCount()){
		VehicleCount = rxTeamInfo.GetVehicleCount();
		
		if (VehicleCount ==  Clamp(VehicleCount, 1, 10)) {
			VehicleInfoButton.GetObject("vehicleCount").SetVisible(true);
			VehicleInfoButton.GetObject("vehicleCount").GotoAndStopI(VehicleCount);

			i = 0;			
			foreach rxPC.WorldInfo.AllPawns(class'Rx_Vehicle', RxV) {
				if (RxV.GetTeamNum() != TeamID || i > VehicleCount) {
					continue;
				} 
				if (TeamID == TEAM_GDI){
					for (j=0; j < rxPurchaseSystem.GDIVehicleClasses.Length; j++) {
						if (RxV.Class != rxPurchaseSystem.GDIVehicleClasses[j])
							continue;
							
						LoadTexture("img://" $ PathName(GDIVehicleMenuData2[j].PTIconTexture), VehicleInfoButton.GetObject("vehicleCount").GetObject("icon"$i));
					}
				} else if (TeamID == TEAM_NOD) {
					for (j=0; j < rxPurchaseSystem.NodVehicleClasses.Length; j++) {
						if (RxV.Class != rxPurchaseSystem.NodVehicleClasses[j])
							continue;
						LoadTexture("img://" $ PathName(NodVehicleMenuData2[j].PTIconTexture), VehicleInfoButton.GetObject("vehicleCount").GetObject("icon"$i));
					}
				}
				i++;
			}
		} else {
			VehicleInfoButton.GetObject("vehicleCount").SetVisible(false);
			if (VehicleCount > 10) {
				`log("<PT Log> WARNING: vehicle exceeding the game vehicle limit");
			}
		}

		VehicleInfoButton.SetString("label", "Vehicles: " $ VehicleCount $" / " $ rxTeamInfo.VehicleLimit);
		MainMenuButton[7].SetString("vehicleCountLabel", "( "$ VehicleCount $ " )");
		//vehicle button number update here
		
	}

	//Pay Class Condition

	if (rxPurchaseSystem.AreHighTierPayClassesDisabled(TeamID)) {
		if (bClassDrawerOpen) {
			//enabled deadeye/BHS when bar/hon is dead (nBab)
			for (i = 9; i > 3; i--) {
				if (!ClassMenuButton[i].GetBool("enabled")) {
					continue;
				}
				ClassMenuButton[i].SetBool("selected", false);
				ClassMenuButton[i].SetBool("visible", false);
				ClassMenuButton[i].SetBool("enabled", false);
			}
			//enabled deadeye/BHS when bar/hon is dead (nBab)
			for (i = 0; i < 4; i++) {
				data = int(ClassMenuButton[i].GetString("data"));
 				ClassMenuButton[i].SetBool("enabled", TeamID == TEAM_GDI ? GDIClassMenuData2[i].bEnable : NodClassMenuData2[i].bEnable);
			}			
		} else if (bMainDrawerOpen) {
			MainMenuButton[7].SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, (TeamID == TEAM_GDI ? GDIMainMenuData2[6].title : NodMainMenuData2[6].title), rxPC));
			MainMenuButton[7].SetBool("enabled", true);
		}
	} else {
		if (bClassDrawerOpen) {
			for (i = 0; i < 10; i++) {
				data = int(ClassMenuButton[i].GetString("data"));
 				ClassMenuButton[i].SetBool("enabled", TeamID == TEAM_GDI ? GDIClassMenuData2[i].bEnable : NodClassMenuData2[i].bEnable);
			}
		} else if (bMainDrawerOpen) {
			MainMenuButton[7].SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, (TeamID == TEAM_GDI ? GDIMainMenuData2[6].title : NodMainMenuData2[6].title), rxPC));
			MainMenuButton[7].SetBool("enabled", true);
		}
	}

	//Vehicle Condition

	if (rxPurchaseSystem.AreVehiclesDisabled(TeamID, rxPC)) {
		if (bVehicleDrawerOpen) {
 			
			for(i=0; i < 9; i++) {
				if (!VehicleMenuButton2[i].GetBool("enabled")) {
					continue;
				}
 				VehicleMenuButton2[i].SetBool("selected", false);
 				VehicleMenuButton2[i].SetBool("enabled", false);
 			}
			SelectBack();
			MainMenuButton[7].SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, (TeamID == TEAM_GDI ? GDIMainMenuData2[7].title : NodMainMenuData2[7].title), rxPC ));
			MainMenuButton[7].SetBool("selected", false);
			MainMenuButton[7].SetBool("enabled", false);
		} else if (bMainDrawerOpen) {
			MainMenuButton[7].SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, (TeamID == TEAM_GDI ? GDIMainMenuData2[7].title : NodMainMenuData2[7].title), rxPC));
			MainMenuButton[7].SetBool("selected", false);
			MainMenuButton[7].SetBool("enabled", false);
		}
	} else {
		if (bVehicleDrawerOpen) {
 			for(i=0; i < 9; i++) {
				
				//`log("Team ID = " @ TeamID);
				if(rxPurchaseSystem.AreHighTierVehiclesDisabled(TeamID) && i > 1) //limit to buggies / APCs
				{
					if(!VehicleMenuButton2[i].GetBool("enabled")) 
							continue; 
					//enable bike and wolverine with airdrop (nBab)
					if (i==6) 
					{
						VehicleMenuButton2[i].SetBool("visible", true);
						VehicleMenuButton2[i].SetBool("enabled", true);
						continue;
					}

						//`log("Parsed through vehicles");
				VehicleMenuButton2[i].SetBool("selected", false);
				VehicleMenuButton2[i].SetBool("visible", false);
				VehicleMenuButton2[i].SetBool("enabled", false);
						
					
				}
				
				data = int(VehicleMenuButton2[i].GetString("data"));
 				VehicleMenuButton2[i].SetBool("enabled", TeamID == TEAM_GDI ? GDIVehicleMenuData2[i].bEnable : NodVehicleMenuData2[i].bEnable);


				if (rxBuildingOwner.AreAircraftDisabled()) {
					if (TeamID == TEAM_GDI) {
						if (GDIVehicleMenuData2[data].bAircraft) {
 							VehicleMenuButton2[i].SetBool("selected", false);
 							VehicleMenuButton2[i].SetBool("enabled", false);
						}
					} else {
						if (NodVehicleMenuData2[data].bAircraft) {
 							VehicleMenuButton2[i].SetBool("selected", false);
 							VehicleMenuButton2[i].SetBool("enabled", false);
						}
					}
				}

 			}
		} else if (bMainDrawerOpen) {
			MainMenuButton[7].SetString("sublabel", rxPurchaseSystem.GetFactoryDescription(TeamID, (TeamID == TEAM_GDI ? GDIMainMenuData2[7].title : NodMainMenuData2[7].title), rxPC));
			MainMenuButton[7].SetBool("enabled", true);
		}
	}

	//silo condition
	//nbabweapon
	/*if (!rxPurchaseSystem.AreSilosCaptured(TeamID)) {
		if (bWeaponDrawerOpen) {
			for (i=0; i < 9; i++) {
				data = int(WeaponMenuButton[i].GetString("data"));
				if (TeamID == TEAM_GDI) {
					if (GDIWeaponMenuData[data].bSilo){
						WeaponMenuButton[i].SetBool("selected", false);
						WeaponMenuButton[i].SetBool("enabled", false);
					}
				} else {
					if (NodWeaponMenuData[data].bSilo){
						WeaponMenuButton[i].SetBool("selected", false);
						WeaponMenuButton[i].SetBool("enabled", false);
					}
				}
			}
		}
	} else {
		if (bWeaponDrawerOpen) {
			for (i=0; i < 9; i++) {
				data = int(WeaponMenuButton[i].GetString("data"));
				if (TeamID == TEAM_GDI) {
					if (GDIWeaponMenuData[data].bSilo){
						WeaponMenuButton[i].SetBool("enabled", true);
					}
				} else {
					if (NodWeaponMenuData[i].bSilo){
						WeaponMenuButton[i].SetBool("enabled", true);
					}
				}
			}
		}
	}*/
	
	
	//payment conditions

		if (bClassDrawerOpen) {
			for (i = 0; i < 10; i++) {
				data = int(ClassMenuButton[i].GetString("data"));
				if (TeamID == TEAM_GDI) {
					if (!GDIClassMenuData2[i].bEnable) {
						
						continue;
					}
				} else {
					if (!NodClassMenuData2[i].bEnable) {
						continue;
					}
				}
				if (ClassMenuButton[i].GetBool("enabled") && PlayerCredits < rxPurchaseSystem.GetClassPrices(TeamID, data)){
					ClassMenuButton[i].SetBool("enabled", false);
				}
			}
		} else if (bVehicleDrawerOpen) 			
			{
				for (i = 0; i < 9; i++) {
					
					if(rxPurchaseSystem.AreHighTierVehiclesDisabled(TeamID) && i > 1 && i!=6)
					{
					if(VehicleMenuButton2[i].GetBool("enabled")) 
						{
						VehicleMenuButton2[i].SetBool("enabled",false); 					
						}
					continue; //No need to parse the info for everything else if it isn't enabled and visible.
					}
					data = int(VehicleMenuButton2[i].GetString("data"));
					if (TeamID == TEAM_GDI) {
						if (!GDIVehicleMenuData2[i].bEnable) {
							continue;
						}
					} else {
						if (!NodVehicleMenuData2[i].bEnable) {
							continue;
						}
					}
					if (rxBuildingOwner.AreAircraftDisabled()) {
						if (TeamID == TEAM_GDI) {
							if (GDIVehicleMenuData2[i].bAircraft) {
								continue;
							}
						} else {
							if (NodVehicleMenuData2[i].bAircraft) {
								continue;
							}
						}
					}
				
				
					if (TeamID == TEAM_GDI) {
						VehicleMenuButton2[i].SetString("costLabel", "$" $ rxPurchaseSystem.GetVehiclePrices(TeamID, GDIVehicleMenuData2[i].ID, rxPurchaseSystem.AirdropAvailable(rxPRI)));
					} else {
						VehicleMenuButton2[i].SetString("costLabel", "$" $ rxPurchaseSystem.GetVehiclePrices(TeamID, NodVehicleMenuData2[i].ID, rxPurchaseSystem.AirdropAvailable(rxPRI)));
					}				
				
					if (PlayerCredits > rxPurchaseSystem.GetVehiclePrices(TeamID, data, rxPurchaseSystem.AirdropAvailable(rxPRI)) ){
						//nBab
		 				if (TeamID == TEAM_GDI)
		 				{
		 					VehicleMenuButton2[i].SetBool("enabled", true);
		 				}
		 				else if (TeamID == TEAM_Nod)
		 				{
		 					VehicleMenuButton2[i].SetBool("enabled", true);
		 				}
					} else {
						VehicleMenuButton2[i].SetBool("enabled", false);
					}
				}
		}	else if (bItemDrawerOpen) {
			for (i = 0; i < 8; i++) {
				data = int(ItemMenuButton[i].GetString("data"));
				if (TeamID == TEAM_GDI) {
					if (!GDIItemMenuData2[i].bEnable) {
						continue;
					}
				} else {
					if (!NodItemMenuData2[i].bEnable) {
						continue;
					}
				}
				if (PlayerCredits > rxPurchaseSystem.GetItemPrices(TeamID, data)){
					ItemMenuButton[i].SetBool("enabled", true);
				} else {
					ItemMenuButton[i].SetBool("enabled", false);
				}
			}
		}

}

DefaultProperties
{
	MovieInfo                       =   SwfMovie'FortPurchaseMenu.RenxPurchaseMenu'

	// We have to replicate these inside this class, otherwise
	// the UDK crashes when attempting to access them from the
	// extended class, because UnrealScript?
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// MAIN MENU START
	////////////////////////////////////////////////////////////////////////////////////////////
	
	NodMainMenuData2(0) 				= (BlockType=EPBT_CLASS, id=0,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Autorifle', iconID=27, hotkey="1", title="SOLDIER",	 	 desc="Armour: Kevlar\nSpeed: 95\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=1, range=3, rateOfFire=5, magCap=4 )
	NodMainMenuData2(1) 				= (BlockType=EPBT_CLASS, id=1,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Shotgun', iconID=52, hotkey="2", title="SHOTGUNNER",	 desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=3, range=1, rateOfFire=2, magCap=2 )
	NodMainMenuData2(2) 				= (BlockType=EPBT_CLASS, id=2,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FlameThrower', iconID=32, hotkey="3", title="FLAMETHROWER", desc="Armour: Flak\nSpeed: 105\nSide: Silenced Pistol\n+Anti-Everything",						cost="FREE", type=2, damage=2, range=1, rateOfFire=4, magCap=4 )
	NodMainMenuData2(3) 				= (BlockType=EPBT_CLASS, id=3,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MarksmanRifle', iconID=41, hotkey="4", title="MARKSMAN",	 desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",			cost="FREE", type=2, damage=3, range=5, rateOfFire=3, magCap=2 )
	NodMainMenuData2(4) 				= (BlockType=EPBT_CLASS, id=4,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="5", title="ENGINEER",	 desc="Armour: Flak\nSpeed: 95\nSide: Silenced Pistol\nRemote C4\n+Anti-Building\n+Repair/Support",	cost="FREE", type=2, damage=3, range=1, rateOfFire=6, magCap=6 )
	NodMainMenuData2(5) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Refill', iconID=05, hotkey="R", title="REFILL",	 	 desc="\nRefill Health\nRefill Armour\nRefill Ammo\nRefill Stamina",									cost="MENU", type=1 )
	NodMainMenuData2(6) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Characters', iconID=02, hotkey="C", title="CHARACTERS",	 desc="",																								cost="MENU", type=1 )
	NodMainMenuData2(7) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Vehicles_Nod', iconID=61, hotkey="V", title="VEHICLES",	 desc="",																								cost="MENU", type=1 )
	NodMainMenuData2(8) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_ItemsNod', iconID=04, hotkey="Q", title="ITEM",		 desc="\n\nSuperweapons\nEquipment\nDeployables",														cost="MENU", type=1 )
	
	GDIMainMenuData2[0] 				= (BlockType=EPBT_CLASS, id=0,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Autorifle',  iconID=27, hotkey="1", title="SOLDIER",	    desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=1,range=3,rateOfFire=5,magCap=4)
	GDIMainMenuData2[1] 				= (BlockType=EPBT_CLASS, id=1,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Shotgun', iconID=52, hotkey="2", title="SHOTGUNNER",  desc="Armour: Kevlar\nSpeed: 95\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=3,range=1,rateOfFire=2,magCap=2)
	GDIMainMenuData2[2] 				= (BlockType=EPBT_CLASS, id=2,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_GrenadeLauncher', iconID=34, hotkey="3", title="GRENADIER",   desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Armour\n+Anti-Building",	cost="FREE", type=2, damage=3,range=4,rateOfFire=2,magCap=2)
	GDIMainMenuData2[3] 				= (BlockType=EPBT_CLASS, id=3,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MarksmanRifle', iconID=41, hotkey="4", title="MARKSMAN",	desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",			cost="FREE", type=2, damage=3,range=5,rateOfFire=3,magCap=2)
	GDIMainMenuData2[4] 				= (BlockType=EPBT_CLASS, id=4,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="5", title="ENGINEER",	desc="Armour: Flak\nSpeed: 95\nSide: Silenced Pistol\nRemote C4\n+Anti-Building\n+Repair/Support",	cost="FREE", type=2, damage=3,range=1,rateOfFire=6,magCap=6)
	GDIMainMenuData2[5] 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Refill', iconID=05, hotkey="R", title="REFILL",	    desc="\nRefill Health\nRefill Armour\nRefill Ammo\nRefill Stamina",										cost="FREE", type=1)
	GDIMainMenuData2[6] 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Characters', iconID=02, hotkey="C", title="CHARACTERS",  desc="",																								cost="MENU", type=1)
	GDIMainMenuData2[7] 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Vehicles_GDI', iconID=25, hotkey="V", title="VEHICLES",	desc="",																								cost="MENU", type=1)
	GDIMainMenuData2[8] 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_ItemsGDI', iconID=03, hotkey="Q", title="ITEM",		desc="\n\nSuperweapons\nEquipment\nDeployables",														cost="MENU", type=1)
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// MAIN MENU END
	////////////////////////////////////////////////////////////////////////////////////////////
	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// ITEMS START
	////////////////////////////////////////////////////////////////////////////////////////////
	NodItemMenuData2[0]				= (BlockType=EPBT_ITEM, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_NukeBeacon', iconID=71, hotkey="1", title="NUKE STRIKE BEACON", desc="<font size='8'>Pros:\n-Instant Building Destruction\nCons:\n-60 Seconds for impact\n-USES ITEM SLOT</font>", cost="1000", type=1)
	NodItemMenuData2[1]				= (BlockType=EPBT_ITEM, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Airstrike_AC130', iconID=63, hotkey="2", title="AC-130 AIRSTRIKE",	 desc="<font size='8'>Pros:\n-5 seconds to impact\n-Quick bombardment\n-Anti-Infrantry/Vehicle\nCons:\n-Weak Vs. Buildings\n-USES ITEM SLOT</font>", 												cost="800" , type=1)
	NodItemMenuData2[2]				= (BlockType=EPBT_ITEM, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="3", title="REPAIR TOOL",      desc="<font size='8'>Pros:\n-Repairs Units/Buildings\n-Disarms Mines\n\nCons:\n-Must Recharge\n-USES ITEM SLOT </font>", cost="200")
	NodItemMenuData2[3]				= (BlockType=EPBT_ITEM, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_AmmoKit', iconID=64, hotkey="4", title="AMMUNITION KIT",	 desc="<font size='8'>Pros:\n-Rearms near by infrantry\n-30 seconds before depletion\n\nCons:\n-Rearms near by enemies as well\n-Cannot refill</font>", 							cost="150" , type=1, bEnable = false)
	NodItemMenuData2[4]				= (BlockType=EPBT_ITEM, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MechanicalKit', iconID=65, hotkey="5", title="MECHANICAL KIT",	 desc="<font size='8'>Pros:\n-Repairs near by vehicles\n-30 seconds before depletion\n\nCons:\n-Repairs near by enemies as well\n-Cannot refill</font>", 							cost="150" , type=1, bEnable = false)
	NodItemMenuData2[5]				= (BlockType=EPBT_ITEM, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MotionSensor', iconID=67, hotkey="6", title="MOTION SENSOR",	 	 desc="<font size='8'>Pros:\n-Relays enemy position in a radius\n-Detects mines and beacons\n\nCons:\n-Emits an audible sound\n-Cannot refill</font>", 								cost="200" , type=1, bEnable = false)
	NodItemMenuData2[6]				= (BlockType=EPBT_ITEM, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_MG', iconID=68, hotkey="7", title="MG SENTRY",	 		 desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Infrantry\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300" , type=1, bEnable = false)
	NodItemMenuData2[7]				= (BlockType=EPBT_ITEM, id=7, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_AT', iconID=69, hotkey="8", title="AT SENTRY",	 		 desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Vehicle\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300" , type=1, bEnable = false)
	
	GDIItemMenuData2(0) 				= (BlockType=EPBT_ITEM, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_IonCannonBeacon', iconID=70, hotkey="1", title="ION CANNON BEACON", desc="<font size='8'>Pros:\n-Instant Building Destruction\nCons:\n-60 Seconds for impact\n-USES ITEM SLOT</font>", 	cost="1000", type=1)
	GDIItemMenuData2(1) 				= (BlockType=EPBT_ITEM, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Airstrike_A10', iconID=62, hotkey="2", title="A-10 AIRSTRIKE",	desc="<font size='8'>Pros:\n-5 seconds to impact\n-Quick bombardment\n-Anti-Infrantry/Vehicle\nCons:\n-Weak Vs. Buildings\n-USES ITEM SLOT</font>", 												cost="800",  type=1)
	GDIItemMenuData2(2) 				= (BlockType=EPBT_ITEM, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="3", title="REPAIR TOOL",      desc="<font size='8'>Pros:\n-Repairs Units/Buildings\n-Disarms Mines\n\nCons:\n-Must Recharge\n-USES ITEM SLOT  </font>", cost="250")
	GDIItemMenuData2(3) 				= (BlockType=EPBT_ITEM, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_AmmoKit', iconID=64, hotkey="4", title="AMMUNITION KIT",	desc="<font size='8'>Pros:\n-Rearms near by infrantry\n-30 seconds before depletion\n\nCons:\n-Rearms near by enemies as well\n-Cannot refill</font>", 								cost="150",  type=1 , bEnable = false)
	GDIItemMenuData2(4) 				= (BlockType=EPBT_ITEM, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MechanicalKit', iconID=65, hotkey="5", title="MECHANICAL KIT",	desc="<font size='8'>Pros:\n-Repairs near by vehicles\n-30 seconds before depletion\n\nCons:\n-Repairs near by enemies as well\n-Cannot refill</font>", 							cost="150",  type=1 , bEnable = false)
	GDIItemMenuData2(5) 				= (BlockType=EPBT_ITEM, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MotionSensor', iconID=67, hotkey="6", title="MOTION SENSOR",	 	desc="<font size='8'>Pros:\n-Relays enemy position in a radius\n-Detects mines and beacons\n\nCons:\n-Emits an audible sound\n-Cannot refill</font>", 								cost="200",  type=1 , bEnable = false)
	GDIItemMenuData2(6) 				= (BlockType=EPBT_ITEM, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_MG', iconID=68, hotkey="7", title="MG SENTRY",	 	 	desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Infrantry\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300",  type=1 , bEnable = false)
	GDIItemMenuData2(7) 				= (BlockType=EPBT_ITEM, id=7, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_AT', iconID=69, hotkey="8", title="AT SENTRY",	 	 	desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Vehicle\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 											cost="300",  type=1 , bEnable = false)
	////////////////////////////////////////////////////////////////////////////////////////////
	// ITEMS END
	////////////////////////////////////////////////////////////////////////////////////////////
	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// VEHICLES START
	////////////////////////////////////////////////////////////////////////////////////////////
	
	NodVehicleMenuData2(0)			= (BlockType=EPBT_VEHICLE, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_Buggy', iconID=20, hotkey="1", title="BUGGY", 						desc="<font size='10'>-.50 Calibre Machine Gun\n-Light Armour\n-Fast Attack Scout\n-Driver + Passenger</font>", 		 cost="350")
	NodVehicleMenuData2(1)			= (BlockType=EPBT_VEHICLE, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_APC', iconID=18, hotkey="2", title="ARMOURED PERSONNEL CARRIER", desc="<font size='10'>-M134 Minigun\n-Heavy Armour\n-Troop Transport\n-Driver + 4 Passengers</font>", 					 cost="500")
	NodVehicleMenuData2(2)			= (BlockType=EPBT_VEHICLE, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_Artillery', iconID=19, hotkey="3", title="MOBILE ARTILLERY", 			desc="<font size='10'>\n-155mm Howitzer\n-Light Armour\n-Long Range Ballistics\n-Driver + Passenger</font>", 			 cost="450")
	NodVehicleMenuData2(3)			= (BlockType=EPBT_VEHICLE, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_FlameTank', iconID=21, hotkey="4", title="FLAME TANK", 				desc="<font size='10'>\n-2x Flame Throwers\n-Heavy Armour\n-Close Range Suppressor\n-Driver + Passenger</font>", 		 cost="800")
	NodVehicleMenuData2(4)			= (BlockType=EPBT_VEHICLE, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_LightTank', iconID=22, hotkey="5", title="LIGHT TANK", 				desc="<font size='10'>\n-75mm Cannon\n-Heavy Armour\n-Main Battle Tank\n-Driver + Passenger</font>", 					 cost="600")
	NodVehicleMenuData2(5)			= (BlockType=EPBT_VEHICLE, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_StealthTank', iconID=23, hotkey="6", title="STEALTH TANK", 				desc="<font size='10'>-2x TOW Missiles\n-Heavy Armour\n-Guerilla Combat Vehicle\n-Active Camouflage\n-Drive Only</font>", cost="900")
	NodVehicleMenuData2(6)			= (BlockType=EPBT_VEHICLE, id=6, PTIconTexture=Texture2D'FortPurchaseMenu.bike_2', iconID=78, hotkey="7", title="RECON BIKE", 		desc="<font size='10'>\n-2x Dragon TOW Launchers\n-Light Armour\n-Fast Attack Scout\n-Driver Only</font>", 				 cost="1000")
	NodVehicleMenuData2(7)			= (BlockType=EPBT_VEHICLE, id=7, PTIconTexture=Texture2D'FortPurchaseMenu.buggy_2', iconID=79, hotkey="8", title="BUGGY", 					desc="<font size='10'>-Raider Cannon\n-Heavy Armour\n-Anti-Infantry/Air Scout\n-Driver + Passenger</font>", 	 cost="1000")
	NodVehicleMenuData2(8)			= (BlockType=EPBT_VEHICLE, id=8, PTIconTexture=Texture2D'FortPurchaseMenu.ticktank_2', iconID=80, hotkey="9", title="TICK TANK", 					desc="<font size='10'>-90mm APDS Cannon\n-Heavy Armour \n-Increased Defence When Deployed  \n-Driver + Passenger</font>", 	 cost="1500")
	
	GDIVehicleMenuData2(0) 			= (BlockType=EPBT_VEHICLE, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Humvee', iconID=9,  hotkey="1",title="HUMVEE",								desc="<font size='10'>-.50 Calibre Machine Gun\n-Light Armour\n-Fast Attack Scout\n-Driver + Passenger</font>",				cost="350")
	GDIVehicleMenuData2(1) 			= (BlockType=EPBT_VEHICLE, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_APC', iconID=7,  hotkey="2",title="ARMOURED PERSONNEL CARRIER",			desc="<font size='10'>-M134 Minigun\n-Heavy Armour\n-Troop Transport\n-Driver + 4 Passengers</font>",						cost="500")
	GDIVehicleMenuData2(2) 			= (BlockType=EPBT_VEHICLE, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MRLS', iconID=12, hotkey="3",title="MOBILE ROCKET LAUNCHER SYSTEM",		desc="<font size='10'>-M269 Missiles\n-Light Armour\n-Long Range Ballistics\n-Driver + Passenger</font>",					cost="450")
	GDIVehicleMenuData2(3) 			= (BlockType=EPBT_VEHICLE, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MediumTank', iconID=11, hotkey="4",title="MEDIUM TANK",							desc="<font size='10'>-105mm Cannon\n-Heavy Armour\n-Main Battle Tank\n-Driver + Passenger</font>",							cost="800")
	GDIVehicleMenuData2(4) 			= (BlockType=EPBT_VEHICLE, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MammothTank', iconID=10, hotkey="5",title="MAMMOTH TANK",						desc="<font size='10'>-2x 120mm Cannons\n-4x Tusk Missiles\n-Heavy Armour\n-Heavy Battle Tank\n-Driver + Passenger</font>",	cost="1500")
	GDIVehicleMenuData2(5) 			= (BlockType=EPBT_VEHICLE, id=5, PTIconTexture=Texture2D'FortPurchaseMenu.hovermrls_2', iconID=75, hotkey="6",title="HOVER MRLS",				desc="<font size='10'>-M269 Missiles\n-Light Armour\n-Long Range Ballistics\n-Driver + Passenger</font>",					cost="1000")
	GDIVehicleMenuData2(6) 			= (BlockType=EPBT_VEHICLE, id=6, PTIconTexture=Texture2D'FortPurchaseMenu.wolverine_2', iconID=76, hotkey="7",title="WOLVERINE",						desc="<font size='10'>-2x M134 Miniguns\n-Anti-Infantry\n-Heavy Armour\n-Driver Only</font>",		cost="1000")
	GDIVehicleMenuData2(7) 			= (BlockType=EPBT_VEHICLE, id=7, PTIconTexture=Texture2D'FortPurchaseMenu.titan_2', iconID=77, hotkey="8",title="TITAN",							desc="<font size='10'>-120mm Cannon\n-Heavy Armour\n-Heavy Battle Walker\n-Driver + Passenger</font>",							cost="1500")
	GDIVehicleMenuData2(8) 			= (BlockType=EPBT_VEHICLE, id=8, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MediumTank', iconID=77, hotkey="9",title="TITAN",							desc="<font size='10'>-105mm Cannon\n-Heavy Armour\n-Main Battle Tank\n-Driver + Passenger</font>",							cost="1500")
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// VEHICLES END
	////////////////////////////////////////////////////////////////////////////////////////////
	
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// CLASSES START
	////////////////////////////////////////////////////////////////////////////////////////////
	
	NodClassMenuData2(0)				= (BlockType=EPBT_CLASS, id=5,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Chaingun', iconID=28, hotkey="1", title="OFFICER",				desc="Armour: Kevlar\nSpeed: 110\nSide: Silenced Pistol\nSmoke Grenade\n+Anti-Infantry",	cost="175",  type=2, damage=1, range=3, rateOfFire=6, magCap=6)
	NodClassMenuData2(1)				= (BlockType=EPBT_CLASS, id=6,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MissileLauncher', iconID=42, hotkey="2", title="ROCKET SOLDIER",		desc="Armour: Flak\nSpeed: 105\nSide: Machine Pistol\nAnti-Tank Mines\n+Anti-Armour\n+Anti-Aircraft",						cost="225",  type=2, damage=4, range=5, rateOfFire=1, magCap=1)
	NodClassMenuData2(2)				= (BlockType=EPBT_CLASS, id=7,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ChemicalThrower', iconID=29, hotkey="3", title="CHEMICAL TROOPER",	desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nFrag Grenades\n+Anti-Everything",						cost="150",  type=2, damage=3, range=1, rateOfFire=4, magCap=4)
	NodClassMenuData2(3)				= (BlockType=EPBT_CLASS, id=8,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle', iconID=54, hotkey="4", title="BLACK HAND SNIPER",	desc="Armour: Kevlar\nSpeed: 90\nSide: Heavy Pistol\nSmoke Grenade\n+Anti-Infantry",						cost="500",  type=2, damage=4, range=6, rateOfFire=1, magCap=2)
	NodClassMenuData2(4)				= (BlockType=EPBT_CLASS, id=9,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserRifle', iconID=39, hotkey="5", title="STEALTH BLACK HAND",	desc="Armour: Lazarus\nSpeed: 110\nSide: S. M. Pistol\nActive Camouflage\n+Anti-Everything",						cost="400",  type=2, damage=3, range=4, rateOfFire=4, magCap=3)
	NodClassMenuData2(5)				= (BlockType=EPBT_CLASS, id=10, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserChaingun', iconID=38, hotkey="6", title="LASER CHAINGUNNER",	desc="Armour: Flak\nSpeed: 80\nEMP Grenade\nAnti-Tank Mines\n+Anti-Everything\n+Heavy Infantry",						cost="450",  type=2, damage=3, range=3, rateOfFire=5, magCap=5)
	NodClassMenuData2(6)				= (BlockType=EPBT_CLASS, id=11, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle', iconID=48, hotkey="7", title="SAKURA",				desc="Armour: Kevlar\nSpeed: 90\nSide: S. Carbine\nSmoke Grenade\n+Anti-Infantry",						cost="1000", type=2, damage=5, range=6, rateOfFire=2, magCap=2)
	NodClassMenuData2(7)				= (BlockType=EPBT_CLASS, id=12, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Railgun', iconID=47, hotkey="8", title="RAVESHAW",			desc="Armour: Flak\nSpeed: 100\nSide: Heavy Pistol\nEMP Grenade\nAnti-Tank Mines\n+Anti-Armour",						cost="1000", type=2, damage=6, range=4, rateOfFire=1, magCap=2)
	NodClassMenuData2(8)				= (BlockType=EPBT_CLASS, id=13, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=59, hotkey="9", title="MENDOZA",				desc="Armour: Kevlar\nSpeed: 110\nSide: Heavy Pistol\n+Anti-Everything",						cost="1000", type=2, damage=3, range=3, rateOfFire=6, magCap=4)
	NodClassMenuData2(9)				= (BlockType=EPBT_CLASS, id=14, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="0", title="TECHNICIAN",			desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nRemote C4\nProximity Mines\n+Anti-Building\n+Repair/Support",	cost="350",  type=2, damage=6, range=1, rateOfFire=6, magCap=6)
	
	GDIClassMenuData2(0) 			= (BlockType=EPBT_CLASS, id=5,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Chaingun', iconID=28, hotkey="1", title="OFFICER"		 ,desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\nSmoke Grenade\n+Anti-Infantry",	cost="175", type=2,damage=1,range=3,rateOfFire=6,magCap=6)
	GDIClassMenuData2(1) 			= (BlockType=EPBT_CLASS, id=6,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MissileLauncher', iconID=42, hotkey="2", title="ROCKET SOLDIER",desc="Armour: Flak\nSpeed: 95\nSide: Machine Pistol\nAnti-Tank Mines\n+Anti-Armour\n+Anti-Aircraft", cost="225", type=2,damage=4,range=5,rateOfFire=1,magCap=1)
	GDIClassMenuData2(2) 			= (BlockType=EPBT_CLASS, id=7,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FlakCannon', iconID=31, hotkey="3", title="MCFARLAND"	 ,desc="Armour: Kevlar\nSpeed: 105\nSide: Silenced Pistol\nFrag Grenades\n+Anti-Infantry",						cost="150", type=2,damage=3,range=1,rateOfFire=3,magCap=3)
	GDIClassMenuData2(3) 			= (BlockType=EPBT_CLASS, id=8,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle', iconID=54, hotkey="4", title="DEADEYE"		 ,desc="Armour: Kevlar\nSpeed: 90\nSide: Heavy Pistol\nSmoke Grenade\n+Anti-Infantry",					cost="500", type=2,damage=4,range=6,rateOfFire=1,magCap=2)
	GDIClassMenuData2(4) 			= (BlockType=EPBT_CLASS, id=9,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RocketLauncher', iconID=51, hotkey="5", title="GUNNER"		 ,desc="Armour: Flak\nSpeed: 95\nSide: Carbine\nEMP Grenade\nAT Mines\n+Anti-Armour\n+Anti-Structure",					cost="400", type=2,damage=4,range=5,rateOfFire=3,magCap=2)
	GDIClassMenuData2(5) 			= (BlockType=EPBT_CLASS, id=10, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TacticalRifle', iconID=55, hotkey="6", title="PATCH"		 ,desc="Armour: Kevlar\nSpeed: 112.5\nSide: Heavy Pistol\nFrag Grenades\n+Anti-Infantry",						cost="450", type=2,damage=3,range=4,rateOfFire=4,magCap=3)
	GDIClassMenuData2(6) 			= (BlockType=EPBT_CLASS, id=11, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle', iconID=48, hotkey="7", title="HAVOC"		 ,desc="Armour: Kevlar\nSpeed: 90\nSide: Carbine\nSmoke Grenade\n+Anti-Infantry",					cost="1000",type=2,damage=5,range=6,rateOfFire=2,magCap=2)
	GDIClassMenuData2(7) 			= (BlockType=EPBT_CLASS, id=12, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_PIC', iconID=44, hotkey="8", title="SYDNEY"		 ,desc="Armour: Flak\nSpeed: 100\nSide: Heavy Pistol\nEMP Grenade\nAnti-Tank Mines\n+Anti-Armour",					cost="1000",type=2,damage=6,range=4,rateOfFire=1,magCap=2)
	GDIClassMenuData2(8) 			= (BlockType=EPBT_CLASS, id=13, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_VoltAutoRifle', iconID=59, hotkey="9", title="MOBIUS"		 ,desc="Armour: Kevlar\nSpeed: 100\nSide: Heavy Pistol\n+Anti-Everything",					cost="1000",type=2,damage=3,range=3,rateOfFire=6,magCap=4)
	GDIClassMenuData2(9) 			= (BlockType=EPBT_CLASS, id=14, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="0", title="HOTWIRE"		 ,desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nRemote C4\nProximity Mines\n+Anti-Building\n+Repair/Support",	cost="350", type=2,damage=6,range=1,rateOfFire=6,magCap=6)
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// CLASSES END
	////////////////////////////////////////////////////////////////////////////////////////////
}