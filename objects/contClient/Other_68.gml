if (async_load[? "port"] == PORT_TCP or async_load[? "port"] == PORT_UDP) {
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
				_net_receive_packet(data[0], data[1], load_id)
			break
		
		case network_type_connect:
			_net_event_connect(load_buffer, load_id, load_socketID, load_ip)
			break
		
		case network_type_disconnect:
			_net_event_disconnect(load_buffer, load_id, load_socketID, load_ip)
			break
		
		case network_type_non_blocking_connect:
			_net_event_non_blocking_connect(load_buffer, load_id, load_socketID, load_ip)
			break
	}
}