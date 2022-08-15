function _net_receive_packet(code, pureData, socketID_sender, bufferInfo = BUFFER_INFO_DEFAULT, bufferType, asyncMap) {
	var port = asyncMap[? "port"]
	var fromHost = port == PORT_TCP or port == PORT_UDP
	var isUDP = false
	var ip = asyncMap[? "ip"]
	
	var data
	var dataWillBeDeleted = false
	#region PARSE PARAMETERS
	var parameterCount = 0
	if (bufferInfo == BUFFER_INFO_DEFAULT and !fromHost and is_string(pureData)) {
		if (string_char_at(pureData, 0) == "{" or string_char_at(pureData, 0) == "[") {
			dataWillBeDeleted = true
			data = json_parse(pureData)
		}
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

	try {
		switch(code) {
			case CODE_HOST_COOP:
				var row = db_get_row(global.DB_TABLE_clients, socketID_sender)
				row[? CLIENTS_HOST] = true
				row[? CLIENTS_COOPID] = data
				
				net_server_send(socketID_sender, CODE_HOST_COOP, data, BUFFER_TYPE_FLOAT64)
				break
				
			case CODE_CONNECT:
				var socketID = db_find_value(global.DB_TABLE_clients, CLIENTS_SOCKETID, CLIENTS_SOCKETID_ON_COOP, socketID_sender)
				db_set_row_value(global.DB_TABLE_clients, socketID, CLIENTS_SOCKETID_ON_SERVER, data)
				
				net_server_send(socketID, CODE_CONNECT, data, BUFFER_TYPE_FLOAT64)
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
					var socketID_on_coop = network_create_socket(network_socket_tcp)
					
					if (network_connect(socketID_on_coop, serverIP, PORT_TCP) >= 0) {
						db_set_row_value(global.DB_TABLE_clients, socketID_sender, CLIENTS_SOCKETID_ON_COOP, socketID_on_coop)
						db_set_row_value(global.DB_TABLE_clients, socketID_sender, CLIENTS_COOPID, data)
						db_set_row_value(global.DB_TABLE_clients, socketID_sender, CLIENTS_HOST, false)
					}
				}
				break
				
			default:
				if (fromHost) {
					if (code != CODE_CONNECT) {
						var to = bufferInfo
						if (to == BUFFER_INFO_DEFAULT)
							to = db_find_value(global.DB_TABLE_clients, CLIENTS_SOCKETID, CLIENTS_SOCKETID_ON_COOP, socketID_sender)
						if (to != undefined)
							net_server_send(to, code, data, bufferType, false)
					}
				}
				else {
					var socketID_on_coop = db_get_value_by_key(global.DB_TABLE_clients, socketID_sender, CLIENTS_SOCKETID_ON_COOP)
					if (socketID_on_coop != undefined) 
						net_client_send(code, data, bufferType, isUDP ? ip_sender : false, socketID_on_coop, socketID_sender)
				}
				break
		}
		
		if (dataWillBeDeleted)
			delete data
	}
	catch (error) {
		show_debug_message(error)
	}
}