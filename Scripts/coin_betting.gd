extends Panel

@export var AddTails : Button
@export var AddHeads : Button
@export var TotalPoints : Label
@export var SplitPoints : RichTextLabel

var CoinHistorySprites = []

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

func _ready() -> void:
	Signals.ResetTable.connect(_reset_table)
	Signals.FlippedCoin.connect(_flipped_coin)
	Signals.PurchasePoints.connect(_add_points)
	Signals.UpdateScoreUI.connect(update_coin_betting_ui)
	update_coin_betting_ui()

func _reset_table():
	update_coin_betting_ui()
	AddTails.disabled = false
	AddHeads.disabled = false
	
	
func _flipped_coin(coinCount : int):
	if coinCount > 0:
		AddTails.disabled = true
		AddHeads.disabled = true
		
func update_coin_betting_ui():
	TotalPoints.text = str("Total Points: ",Globals.totalValue)
	SplitPoints.text = str("[center][color=#65A7C1]",Globals.tailsValue,"[/color]/",Globals.headsValue,"[/center]")
	_divy_points()
		
func _on_add_tails_button_up() -> void:
	AddHeads.disabled = false
	Globals.tailsValue += 10
	Globals.headsValue -= 10
	if Globals.tailsValue >= Globals.totalValue:
		AddTails.disabled = true
	else: AddTails.disabled = false
	update_coin_betting_ui()

func _on_add_heads_button_up() -> void:
	AddTails.disabled = false
	Globals.tailsValue -= 10
	Globals.headsValue += 10
	if Globals.headsValue >= Globals.totalValue:
		AddHeads.disabled = true
	else: AddHeads.disabled = false
	update_coin_betting_ui()
	
func _add_points():
	Globals.totalValue += 50 
	if Globals.headsValue > Globals.tailsValue:
		Globals.headsValue += 40
		Globals.tailsValue += 10
	elif Globals.headsValue == Globals.tailsValue:
		Globals.headsValue += 30
		Globals.tailsValue += 20
	else:
		Globals.headsValue += 10
		Globals.tailsValue += 40
	update_coin_betting_ui()
	
func _divy_points(): #evenly in base 10
	var glob = Globals.totalValue/10
	var glob_remainder = glob%2
	var even_glob = glob + glob_remainder
	var divy_glob = even_glob/2
	print(str("heads = ",divy_glob*10))
	print(str("tails = ",(divy_glob-glob_remainder)*10))
