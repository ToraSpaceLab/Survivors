class_name MetaUpgradeCard extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel


var _upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	_upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = Utility.get_nested(MetaProgression.save_data, 0, ["meta_upgrades", _upgrade.id, "quantity"])
	var is_maxed = current_quantity == _upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / _upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "Max"
	progress_label.text = "%d/%d" %[currency, _upgrade.experience_cost]
	count_label.text = "x%d" % current_quantity


func select_card():
	$AnimationPlayer.play("selected")


func on_purchase_pressed():
	if(_upgrade == null):
		return
	MetaProgression.add_meta_upgrade(_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= _upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
