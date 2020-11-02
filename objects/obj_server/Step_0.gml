/// @description Insert description here
switch(global.gamestate){
	
	case gameisstarting:
	
	
	break
	
	
	case shuffel:
		//shuffel
		
		
		
		
		//stuur kaarten naar spelers
		
		var player = ds_list_find_value(socket_list,0)
		
		var i = 0
		repeat(ds_list_size(socket_list)){
		
			var _sock = ds_list_find_value(socket_list,i)
		
			buffer_seek(server_buffer,buffer_seek_start,0)
			buffer_write(server_buffer,buffer_u8,playersturn);
			buffer_write(server_buffer,buffer_u8,player);
			network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
		i++
		}
		

		
	break
	
}


