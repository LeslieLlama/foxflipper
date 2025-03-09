extends Panel

var itemPool = [] 
var itemPoolRarities = []
@export var itemContainers: Array[ItemContainer] = []
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemPool = $ItemPool.get_children()
	_reset_item_pool_rarities()
	Signals.ResetTable.connect(reset_table)
	Signals.RemoveItem.connect(item_removed)
	for i in itemContainers:
		i.itemBought.connect(add_purchase)
	RefreshItems()

func _reset_item_pool_rarities():
	itemPoolRarities.clear()
	for i in itemPool:
		itemPoolRarities.append(i.rarity)

func _add_coin():
	Signals.emit_signal("PurchaseCoin")
	
func _add_weight():
	Signals.emit_signal("PurchaseWeight")
	
func _add_points():
	Signals.emit_signal("PurchasePoints")

func add_purchase():
	Globals.purchases += 1
	update_purchase_ui()
		
func update_purchase_ui():
	$PurchaseCount.text = str("Purchases: ",Globals.purchases,"/",Globals.maxPurchases)
	if Globals.purchases >= Globals.maxPurchases:
		disable_buy_buttons(true)
	
func item_removed(_item):
	update_purchase_ui()

func disable_buy_buttons(disable_value : bool):
	$VBoxContainer/BuyPointsPanel/Button.disabled = disable_value
	$VBoxContainer/BuyCoinsPanel/Button.disabled = disable_value
	$VBoxContainer/BuyWeight/Button.disabled = disable_value
	$VBoxContainer2/Item1/Button.disabled = disable_value
	$VBoxContainer2/Item2/Button.disabled = disable_value
	
func reset_table():
	disable_buy_buttons(false)
	_reset_item_pool_rarities()
	Globals.purchases = 0
	update_purchase_ui()
	RefreshItems()
	
func RandomPickItem():
	var sum_of_weight = 0
	for i in itemPoolRarities.size():
		sum_of_weight += itemPoolRarities[i]
	var rnd = rng.randi_range(0, sum_of_weight-1)
	for i in itemPool.size():
		if rnd < itemPoolRarities[i]:
			return itemPool[i];
		rnd -= itemPoolRarities[i]
func RefreshItems():
	print(str("item rarities : ", itemPoolRarities))
	var previousItem
	for i in itemContainers:
		#var newItem = itemPool[rng.randi_range(0, itemPool.size()-1)]
		var newItem = RandomPickItem()
		if itemPool.size() <= 1:
			SetItem(i,newItem)
			return
		while newItem == previousItem:
			newItem = RandomPickItem()
		previousItem = newItem
		SetItem(i,newItem)
	
func SetItem(container : ItemContainer, item : LuckyCharm):
	container.NewItem(item)
