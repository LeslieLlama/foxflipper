extends Panel

var itemPool = [] 
@export var itemContainers: Array[ItemContainer] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemPool = $ItemPool.get_children()
	print(itemPool)
	Signals.ResetTable.connect(reset_table)
	RefreshItems()

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
	RefreshItems()
	
func RefreshItems():
	var rng = RandomNumberGenerator.new()
	for i in itemContainers:
		var newItem = itemPool[rng.randi_range(0, itemPool.size()-1)]
		SetItem(i,newItem)
	
func SetItem(container : ItemContainer, item : LuckyCharm):
	container.NewItem(item)
