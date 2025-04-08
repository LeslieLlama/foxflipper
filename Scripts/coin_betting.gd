extends Panel

@export var AddTails : Button
@export var AddHeads : Button
@export var TotalPoints : Label
var VirtualValue : int
@export var SplitPoints : RichTextLabel
@export var double_limit = false
var CoinHistorySprites = []

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

func _ready() -> void:
	Signals.ResetTable.connect(_reset_table)
	Signals.ResetGame.connect(_reset_game)
	Signals.FlippedCoin.connect(_flipped_coin)
	Signals.PurchasePoints.connect(_add_points)
	Signals.UpdateScoreUI.connect(update_coin_betting_ui)
	Signals.HoldingHotelSoap.connect(_holding_hotel_soap)
	update_coin_betting_ui()
	VirtualValue = Globals.totalValue

func _reset_table():
	update_coin_betting_ui()
	AddTails.disabled = false
	AddHeads.disabled = false
	
	
func _holding_hotel_soap(val : bool):
	if val == false:
		_divy_points()
		update_coin_betting_ui()
	double_limit = val
	if double_limit == true:
		VirtualValue = Globals.totalValue*2
	else:
		VirtualValue = Globals.totalValue
	
func _flipped_coin(coinCount : int):
	if coinCount > 0:
		AddTails.disabled = true
		AddHeads.disabled = true
		
func update_coin_betting_ui():
	if double_limit == true:
		TotalPoints.text = str("Total Points: ",Globals.totalValue,"x2")
	else: 
		TotalPoints.text = str("Total Points: ",VirtualValue)
	if Globals.tailsValue + Globals.headsValue != Globals.totalValue:
		SplitPoints.text = str("[center][color=#b487d0]",Globals.tailsValue,"/",Globals.headsValue,"[/color][/center]")
	else:
		SplitPoints.text = str("[center][color=#65A7C1]",Globals.tailsValue,"[/color]/",Globals.headsValue,"[/center]")
		
func _on_add_tails_button_up() -> void:
	AddHeads.disabled = false
	Globals.tailsValue += 10
	Globals.headsValue -= 10
	if Globals.tailsValue >= VirtualValue:
		AddTails.disabled = true
	else: AddTails.disabled = false
	update_coin_betting_ui()

func _on_add_heads_button_up() -> void:
	AddTails.disabled = false
	Globals.tailsValue -= 10
	Globals.headsValue += 10
	if Globals.headsValue >= VirtualValue:
		AddHeads.disabled = true
	else: AddHeads.disabled = false
	update_coin_betting_ui()
	
func _add_points():
	Globals.totalValue += 50 
	if double_limit == true:
		VirtualValue = Globals.totalValue*2
	else:
		VirtualValue = Globals.totalValue
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
	
func _divy_points(): #function to divide points evenly between heads and tails based on the global
	var glob = Globals.totalValue/10
	var glob_remainder = glob%2
	var even_glob = glob + glob_remainder
	var divy_glob = even_glob/2
	Globals.headsValue = divy_glob*10
	Globals.tailsValue = (divy_glob-glob_remainder)*10
	
func _reset_game():
	Globals.headsValue = 50
	Globals.tailsValue = 50
	Globals.totalValue = 100
	VirtualValue = Globals.totalValue
	double_limit = false
