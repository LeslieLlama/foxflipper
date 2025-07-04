extends Panel

var itemPool = [] 
var itemPoolRarities = []
@export var itemContainerPrefab : PackedScene 
@export var itemContainers: Array[ItemContainer] = []
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemPool = $ItemPool.get_children()
	_reset_item_pool_rarities()
	Signals.ResetTable.connect(reset_table)
	Signals.ResetGame.connect(reset_game)
	Signals.RemoveItem.connect(item_removed)
	Signals.Mouse_Over_Shop.connect(_tool_tip_on)
	Signals.Mouse_End_Shop.connect(_tool_tip_off)
	Signals.AddItemPurchaseSlot.connect(_folded_bill_reciver)
	for i in 2:
		_create_item_container()
	RefreshItems()
	get_tree().get_root().size_changed.connect(resize)

func _tool_tip_on(iname, desc):
	return
	#The dealer now describes items via textbox, so this is a legacy function. keeping it here incase it needs to be used again
	$Tooltip.show()
	$Tooltip/VBoxContainer/itemName.text = iname
	$Tooltip/VBoxContainer/itemDescription.text = desc
	
func _tool_tip_off():
	$Tooltip.hide()
	
func _folded_bill_reciver(add : bool):
	if add == true:
		_create_item_container()
	else: 
		_remove_item_container()
	
func _create_item_container():
	var child_node = itemContainerPrefab.instantiate()
	$BoxContainer/ItemPurchase.add_child(child_node)
	itemContainers.append(child_node)
	child_node.itemBought.connect(add_purchase)
	var newItem = RandomPickItem()
	SetItem(child_node,newItem)
	
func _remove_item_container():
	var child_node = $BoxContainer/ItemPurchase.get_child(itemContainers.size()-1)
	itemContainers.pop_back()
	child_node.queue_free()
	


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
	$BoxContainer/PurchaseCount.text = str("Purchases: ",Globals.purchases,"/",Globals.maxPurchases)
	if Globals.purchases >= Globals.maxPurchases:
		disable_buy_buttons(true)
	
func item_removed(_item):
	update_purchase_ui()

func disable_buy_buttons(disable_value : bool):
	$BoxContainer/StatPurchase/BuyPointsPanel/Button.disabled = disable_value
	$BoxContainer/StatPurchase/BuyCoinsPanel/Button.disabled = disable_value
	$BoxContainer/StatPurchase/BuyWeight/Button.disabled = disable_value
	for i in itemContainers:
		i._disable_buy_button(disable_value)
	
func resize():
	var ensize = get_viewport_rect().size
	if ensize.x > (ensize.y-400): #horizontal 
		$BoxContainer.vertical = true
	else:
		$BoxContainer.vertical = false
	
func reset_table():
	disable_buy_buttons(false)
	_reset_item_pool_rarities()
	Globals.purchases = 0
	update_purchase_ui()
	RefreshItems()
func reset_game():
	for i in itemContainers.size():
		_remove_item_container()
	#await get_tree().create_timer(0.01).timeout
	for i in 2:
		_create_item_container()
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
