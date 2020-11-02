// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function recieved_packet(buffer,socket){
	var message_id = buffer_read(buffer,buffer_u8)

	switch(message_id){
		
		case ready:		
			buffer_seek(server_buffer,buffer_seek_start,0)
			buffer_write(server_buffer,buffer_u8,ready)
			network_send_packet(socket,server_buffer,buffer_tell(server_buffer))
			
			with(obj_player){
				if(playersocket == socket)	
				{
					playerready = true		
				}
			}
			
			var i = 0
			repeat(ds_list_size(socket_list)){
			
			var _sock = ds_list_find_value(socket_list,i)
				if(_sock != socket){
				
					var _otherplayer = ds_map_find_value(socket_to_instance_id,_sock)
				
					buffer_seek(server_buffer,buffer_seek_start,0)
					buffer_write(server_buffer,buffer_u8,otherready)
					buffer_write(server_buffer,buffer_u8,socket)
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
				} 
				i++;
			}
			
			
		break
		
		case unready:		
			buffer_seek(server_buffer,buffer_seek_start,0)
			buffer_write(server_buffer,buffer_u8,unready)
			network_send_packet(socket,server_buffer,buffer_tell(server_buffer))
			
			with(obj_player){
				if(playersocket == socket)	
				{
					playerready = false		
				}
			}
			
			var i = 0
			repeat(ds_list_size(socket_list)){
			
			var _sock = ds_list_find_value(socket_list,i)
				if(_sock != socket){
				
					var _otherplayer = ds_map_find_value(socket_to_instance_id,_sock)
				
					buffer_seek(server_buffer,buffer_seek_start,0)
					buffer_write(server_buffer,buffer_u8,otherunready)
					buffer_write(server_buffer,buffer_u8,socket)
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
				} 
				i++;
			}
		break	
	}
}