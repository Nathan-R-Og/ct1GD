extends Control


const cat = ["upgrades","lore","cosmetics","options"]

var catPer = []



var catINDEX = 1



func _ready():
	textRender()
	var shopUpgrades = [
	#title, price, currentiteration, max, desc
	["high jump", 40, 0, 1, "gives you a higher jump", 0, 1],
	["longer tongue", 30, 0, 5, "gives you a longer tongue", 1, 2],
	["high vault", 40, 0, 1, "gives you a higher vault", 2, 3],
	["wall vault", 30, 0, 1, "gives you a wall vault after latching", 3, 4],
	["pole position", 40, 0, 1, "gives you the ability to switch directions after twisting", 4, 5],
	["long vault", 30, 0, 5, "gives you a longer vault length", 5, 6],
	["vault still jump", 40, 0, 1, "gives you the ability to jump after performing a stand still vault", 6, 7],
	["WRAP", 30, 0, 5, "kill", 7, 8]
	
	]
	catPer.append(shopUpgrades)
	var shopLore = [
	#title, price, currentiteration, max, desc
	["perfect cord", 40, 0, 1, "can charge anything", 0, 9],
	["pihrana enemy", 30, 0, 5, "never to be seen again", 1, 10],
	["oldie", 40, 0, 1, "orb man", 2, 11],
	["long vault", 30, 0, 1, "oh yeah that WAS a thing", 3, 12]
	
	]
	catPer.append(shopLore)
	var shopCosmetics = [
	#title, price, currentiteration, max, desc
	["swag shoes", 40, 0, 1, "swaggy", 0, 13],
	["swag backpack", 30, 0, 5, "where you goin with that old thing",  1, 14],
	["swag gloves", 40, 0, 1, "god just so swag", 2, 15],
	["swag glasses", 30, 0, 1, "we literally only sell swag things", 3, 16]
	
	]
	catPer.append(shopCosmetics)
	var shopOptions = [
	#title, price, currentiteration, max, desc
	["Old Font", 40, 0, 1, "nice crusty bitmap action", 0, 17],
	["restraint", 30, 0, 5, "its accurate!", 1, 18]
	
	]
	catPer.append(shopOptions)
	_shopAssetRender()



func _process(delta):
	$self_bones/bones.text = String(data.money)
	
	if Input.is_action_just_pressed("move_right"):
		catINDEX = clamp(catINDEX + 1, 1, catPer.size())
		_shopAssetRender()
	
	
	if Input.is_action_just_pressed("move_left"):
		catINDEX = clamp(catINDEX - 1, 1, catPer.size())
		_shopAssetRender()

func textRender():
	var i = 0 
	while i < $category.get_child_count():
		$category.get_child(i).text = cat[i]
		i += 1

func _shopAssetRender():
	var MAX = $Contents/The.get_child_count()
	while MAX > 0:
		$Contents/The.get_child(MAX - 1).queue_free()
		MAX -= 1

	var category = catINDEX - 1
	var inside = 0
	while inside < catPer[category].size():
		var set = catPer[category][inside]
		var shopAsset = preload("res://scenes/shop/ShopAsset.tscn").instance()
		shopAsset.get_node("buyButton").connect("pressed", self, "assetClick", [category, inside, set[6]])
		#shopAsset.get_node("icon").animation = set[5]
		shopAsset.get_node("bones").text = String(set[1])
		shopAsset.get_node("desc").text = set[4]
		shopAsset.get_node("name").text = set[0]
		$Contents/The.add_child(shopAsset)
		inside += 1


func assetClick(category, index, id):
	var set = catPer[category][index]
	if data.money >= set[1]:
		data.money -= set[1]
		match id:
			#ID EFFECTS
			1:
				pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
