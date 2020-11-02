
/// @description
type_event = ds_map_find_value(async_load,"type")

switch(type_event){
	
	case network_type_connect:
		var socket = ds_map_find_value(async_load,"socket")
		show_debug_message("player connected")
		
		var num = ds_map_size(socket_to_instance_id)
		// maak een nieuwe speler aan
		var playerobject = instance_create_depth(playerspawn_x + num*64,playerspawn_y,0,obj_player)
		playerobject.playersocket = socket
		playerobject.number = num
		playerobject.image_index = num
		ds_map_add(socket_to_instance_id,socket,playerobject)
		
		//stuur naar de speler dat hij succesvol gejoined is
		buffer_seek(server_buffer,buffer_seek_start,0)
		buffer_write(server_buffer,buffer_u8,playerjoinsucces)
		buffer_write(server_buffer,buffer_u8,socket)
		buffer_write(server_buffer,buffer_u8,num)
		network_send_packet(socket,server_buffer,buffer_tell(server_buffer))
		
		//stuur alle andere spelers die al eerder gejoined waren naar de speler
		var i = 0
		repeat(ds_list_size(socket_list)){
			
			var _sock = ds_list_find_value(socket_list,i)
			if(_sock != socket){
				
				var _otherplayer = ds_map_find_value(socket_to_instance_id,_sock)
				
				buffer_seek(server_buffer,buffer_seek_start,0)
				buffer_write(server_buffer,buffer_u8,newplayerjoined)
				buffer_write(server_buffer,buffer_u8,_otherplayer.playersocket)
				buffer_write(server_buffer,buffer_u8,_otherplayer.number)
				buffer_write(server_buffer,buffer_u8,_otherplayer.playerready)
				network_send_packet(socket,server_buffer,buffer_tell(server_buffer))
			} 
			i++;
		}
		
		
		//stuur de speler die gejoind is naar de andere spelers
		var i = 0
		repeat(ds_list_size(socket_list)){
			
			var _sock = ds_list_find_value(socket_list,i)
			if(_sock != socket){
				
				var playerid;
				with(obj_player){
					if(playersocket == socket)	
					{
						playerid = id	
					}
				}
				
				buffer_seek(server_buffer,buffer_seek_start,0)
				buffer_write(server_buffer,buffer_u8,newplayerjoined)
				buffer_write(server_buffer,buffer_u8,socket)
				buffer_write(server_buffer,buffer_u8,num)
				buffer_write(server_buffer,buffer_u8,playerid.playerready)
				network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
			} 
			i++;
		}
		
		
		
		ds_list_add(socket_list,socket)	
	break;
	
	case network_type_disconnect:
	
		var socket = ds_map_find_value(async_load,"socket")
		
		with(ds_map_find_value(socket_to_instance_id,socket)){
			instance_destroy(self);	
		}
		
		
		//stuur naar iedereen dat er iemand gediconnect is
		var i = 0
		repeat(ds_list_size(socket_list)){
			
			var _sock = ds_list_find_value(socket_list,i)
			if(_sock != socket){
				
				buffer_seek(server_buffer,buffer_seek_start,0)
				buffer_write(server_buffer,buffer_u8,playerdisconnected)
				buffer_write(server_buffer,buffer_u8,socket)
				network_send_packet(_sock,server_buffer,buffer_tell(server_buffer))
			} 
			i++;
		}
		
		
		
		
		//delete de speler die gedisconnect is
		ds_map_delete(socket_to_instance_id,socket)
		ds_list_delete(socket_list,ds_list_find_index(socket_list,socket))	
		
		var i = 0
		repeat(ds_list_size(socket_list)){
			var _sock = ds_list_find_value(socket_list,i)		
			var num = i;
			
			with(obj_player){
				if(playersocket == _sock)
				{
					number = num
					image_index = num
					x = obj_server.playerspawn_x + num*64
				}
				
			}
				var j = 0
				//selecteer de speler met het de juiste socket

				repeat(ds_list_size(socket_list)){
					
					var otherplayersock = ds_list_find_value(socket_list,j)
					buffer_seek(server_buffer,buffer_seek_start,0)
					buffer_write(server_buffer,buffer_u8,newnumber)
					buffer_write(server_buffer,buffer_u8,_sock)
					buffer_write(server_buffer,buffer_u8,num)
					network_send_packet(otherplayersock,server_buffer,buffer_tell(server_buffer))
				j++
				}
			i++;
		}
		
		
	break;
	
	case network_type_data:
		var socket = ds_map_find_value(async_load,"id")
		var buffer = ds_map_find_value(async_load,"buffer")
		
		buffer_seek(buffer,buffer_seek_start,0)
		recieved_packet(buffer,socket)
	
	break;
	
	
}


