var port = async_load[? "port"]
if (port == PORT_TCP_COOP or port == PORT_UDP_COOP or port == PORT_TCP or port == PORT_UDP) {
	load_buffer = async_load[? "buffer"]
	load_id = async_load[? "id"]
	load_type = async_load[? "type"]
	load_socketID = async_load[? "socket"]
	load_ip = async_load[? "ip"]
	
	switch(load_type)
	{		
		case network_type_data:
			var data = net_buffer_read(load_buffer)
			if (data != undefined)
				_net_receive_packet(data[0], data[1], load_id, data[2], net_buffer_get_type_reverse(data[3]), port == PORT_TCP or port == PORT_UDP, false, load_ip)
			break
		
		case network_type_connect:
			server_add_client(load_socketID)
			server_edit_client(load_socketID, CLIENTS_IP, load_ip)
			_net_event_connect(load_buffer, load_id, load_socketID, load_ip)
			
			net_server_send(load_socketID, CODE_CONNECT_COOP, load_socketID, BUFFER_TYPE_INT16)
			break
		
		case network_type_disconnect:
			_net_event_disconnect(load_buffer, load_id, load_socketID, load_ip)
			server_remove_client(load_socketID)
			
			net_server_send(load_socketID, CODE_DISCONNECT, load_socketID, BUFFER_TYPE_INT16)
			break
		
		case network_type_non_blocking_connect:
			_net_event_non_blocking_connect(load_buffer, load_id, load_socketID, load_ip)
			break
	}
}