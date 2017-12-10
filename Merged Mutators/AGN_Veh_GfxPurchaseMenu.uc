class AGN_Veh_GfxPurchaseMenu extends Rx_GFxPurchaseMenu;

function Initialize(LocalPlayer player, Rx_BuildingAttachment_PT PTOwner)
{	
	`log("[AGN-PT] Super has been poked");
	Super.Initialize(player, PTOwner);
}

DefaultProperties
{
}