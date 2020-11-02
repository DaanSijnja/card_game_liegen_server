/// @description SetUp server
port = 64198;
max_clients = 8;
readyneeded = 2

network_create_server(network_socket_tcp,port,max_clients);

server_buffer = buffer_create(1024,buffer_fixed,1)
socket_list = ds_list_create();

macros();
global.gamestate = lobby;


socket_to_instance_id = ds_map_create();

playerspawn_x = 16;
playerspawn_y = 16;


alarm[0] = 1*room_speed