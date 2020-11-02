// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_card_sprite(){
	switch(type){
	
		case notype:
			sprite_index = spr_cards_back
		break
	
		case shoppen:
			sprite_index = spr_cards_shoppen
		break
	
		case harten:
			sprite_index = spr_cards_harten
		break
	
		case ruiten:
			sprite_index = spr_cards_ruiten
		break
	
		case klaveren:
			sprite_index = spr_cards_klaveren
		break
	}
	
	image_index = index - 1


}