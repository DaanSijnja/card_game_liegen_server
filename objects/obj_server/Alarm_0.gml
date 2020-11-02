/// @description check for ready players
var allready = true

with(obj_player){
	if(playerready == false){
		allready = false	
	}
}

if(allready == true and (ds_list_size(socket_list) > readyneeded) and global.gamestate == lobby)
{
	global.gamestate = shuffel;	
	
	var i = 0
	repeat(ds_list_size(socket_list)){
		
		var _sock = ds_list_find_value(socket_list,i)
		
		buffer_seek(server_buffer,buffer_seek_start,0)
		buffer_write(server_buffer,buffer_u8,gameshuffel) //aanpassen voor een timer
		network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
		i++
	}
	
	show_debug_message("all ready!")
}

alarm[0] = 1*room_speed

