function _net_receive_packet(code, pureData, socketID_sender, redirection, bufferType, fromHost = false) {
	var data
	#region PARSE PARAMETERS
	var parameterCount = 0
	if (redirection == 65535 and !fromHost and is_string(pureData)) {
		if (string_char_at(pureData, 0) == "{" or string_char_at(pureData, 0) == "[")
			data = json_parse(pureData)
		else {
			parameterCount = 1
			data = pureData
		}
	}
	else {
		parameterCount = 1
		data = pureData
	}
	#endregion

	if (code != 2002 and code != 2001 and code != 2005 and code != 2003 and code != 2004 and
		code != 3005 and code != 3000 and code != 3001 and code != 3002 and code != 3003 and
		code != 3004 and code != 5002 and code != 15002 and code != 10302)
		show_debug_message(string(code)+": "+string(data))

	//try {
		switch(code) {
			case CODE_HOST_COOP:
				var row = db_get_row(global.DB_TABLE_clients, socketID_sender)
				row[? CLIENTS_HOST] = true
				row[? CLIENTS_COOPID] = data
				
				net_server_send(socketID_sender, CODE_HOST_COOP, data, BUFFER_TYPE_FLOAT64)
				break
				
			case CODE_JOIN_COOP:
				var row = undefined
				var ds_size = ds_list_size(global.DB_TABLE_clients.rows)
				for (var i = 0; i < ds_size; i++) {
					var _row = global.DB_TABLE_clients.rows[| i]
	
					if (_row[? CLIENTS_HOST] == true and _row[? CLIENTS_COOPID] == data) {
						row = _row
						break
					}
				}
				
				if (row != undefined) {
					var serverIP = row[? CLIENTS_IP]
					var socketID_on_server = network_create_socket(network_socket_tcp)
					
					if (network_connect(socketID_on_server, serverIP, PORT_TCP) >= 0) {
						net_server_send(socketID_sender, CODE_CONNECT, socketID_on_server, BUFFER_TYPE_FLOAT64)
						db_set_row_value(global.DB_TABLE_clients, socketID_sender, CLIENTS_SOCKETID_ON_SERVER, socketID_on_server)
					}
				}
				break
				
			default:
				if (fromHost)
					net_server_send(redirection, code, data, bufferType, false, undefined)
				else {
					var socketID_on_server = db_get_value_by_key(global.DB_TABLE_clients, socketID_sender, CLIENTS_SOCKETID_ON_SERVER)
					net_client_send(socketID_on_server, code, data, bufferType, false, undefined, socketID_sender)
				}
				break
		}
	/*}
	catch (error) {
		show_debug_message(error)
	}*/
}