extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.ResetTable.connect(reset_table)

func _add_coin():
	Signals.emit_signal("PurchaseCoin")
	
func _add_weight():
	Signals.emit_signal("PurchaseWeight")
	
func _add_points():
	Signals.emit_signal("PurchasePoints")

func add_purchase():
	Globals.purchases += 1
	$PurchaseCount.text = str("Purchases: ",Globals.purchases,"/",Globals.maxPurchases)
	if Globals.purchases >= Globals.maxPurchases:
		disable_buy_buttons(true)

func disable_buy_buttons(disable_value : bool):
	$VBoxContainer/BuyPointsPanel/Button.disabled = disable_value
	$VBoxContainer/BuyCoinsPanel/Button.disabled = disable_value
	$VBoxContainer/BuyWeight/Button.disabled = disable_value
	
func reset_table():
	disable_buy_buttons(false)
	Globals.purchases = 0
	$PurchaseCount.text = str("Purchases: ",Globals.purchases,"/",Globals.maxPurchases)
