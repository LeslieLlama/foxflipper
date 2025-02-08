extends Panel

@export var WeightSlider : HSlider
@export var AvailableWeightLabel : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.PurchaseWeight.connect(_add_total_weight)
	Signals.ResetGame.connect(_reset_game)
	#$OddsLabel.text = str("[center]",((1-Globals.headsThreshhold)*100),"/[color=#65A7C1]",Globals.headsThreshhold*100,"[/color][/center]")
	_update_weight_ui()


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
	WeightSlider.max_value = 0.55;
	WeightSlider.min_value = 0.45;
	_update_weight_ui()
