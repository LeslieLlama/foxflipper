extends Panel

@export var WeightSlider : HSlider
@export var AvailableWeightLabel : Label
@export var startingMax : float = 0.55;
@export var startingMin : float = 0.45;
var adjustDuringPlay = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.PurchaseWeight.connect(_add_total_weight)
	Signals.ResetGame.connect(_reset_game)
	Signals.ResetTable.connect(_reset_table)
	Signals.FlipCoin.connect(_flip_coin)
	Signals.HoldingTrainStub.connect(_holding_train_stub)
	WeightSlider.max_value = startingMax;
	WeightSlider.min_value = startingMin;
	#$OddsLabel.text = str("[center]",((1-Globals.headsThreshhold)*100),"/[color=#65A7C1]",Globals.headsThreshhold*100,"[/color][/center]")
	_update_weight_ui()

func _reset_table():
	WeightSlider.editable = true

func _flip_coin(coinCount : int):
	if adjustDuringPlay == true:
		return
	if coinCount > 0:
		WeightSlider.editable = false
		
func _holding_train_stub(val : bool):
	adjustDuringPlay = val

func _update_weight_ui():
	$AvailableWeightLabel.text = str("Available Weight: ",Globals.totalWeight*100,"%")
	$OddsLabel.text = str("[center][color=#65A7C1]",Globals.headsThreshhold*100,"[/color]/",((1-Globals.headsThreshhold)*100),"[/center]")

func _add_total_weight():
	Globals.totalWeight += 0.05
	$AvailableWeightLabel.text = str("Available Weight: ",Globals.totalWeight*100,"%")
	WeightSlider.max_value += 0.05
	WeightSlider.min_value -= 0.05

func _on_h_slider_value_changed(value: float) -> void:
	Globals.headsThreshhold = value
	_update_weight_ui()
	
func _reset_game():
	Globals.totalWeight = 0.05;
	WeightSlider.value = 0.50;
	WeightSlider.max_value = startingMax;
	WeightSlider.min_value = startingMin;
	adjustDuringPlay = false
	_update_weight_ui()
