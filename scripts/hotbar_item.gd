extends PanelContainer


var id: int = 0
var amount: int = 0

func use():
	for i in Game.hotbar:
		if i.id == id:
			i.amount -= 1
			if i.amount <= 0:
				Game.hotbar.erase(i)
	Main.refresh_inventory()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match id:
			1: # Flash bomb
				Main.player.flash_bomb()
				use()
			3: # Shadow block
				Main.player.shadow_block()
				use()
			4: # Shadow cloak
				Main.player.shadow_cloak()
				use()
			5: # Banisher
				Main.player.banisher()
