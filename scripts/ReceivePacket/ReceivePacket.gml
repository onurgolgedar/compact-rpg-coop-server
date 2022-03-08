function _net_receive_packet(code, pureData, socketID_sender, redirection, bufferType) {
	var data
	#region PARSE PARAMETERS
	var parameterCount = 0
	if (is_string(pureData)) {
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
		code != 3005 and code != 3000 and code != 3001 and code != 3002 and code != 3003 and code != 3004)
		show_debug_message(string(code)+": "+string(data))

	try {
		switch(code) {
			case CODE_HOST_COOP:
				var row = db_get_row(global.DB_TABLE_clients, socketID_sender)
				row[? CLIENTS_HOST] = true
				row[? CLIENTS_COOPID] = data
				
				net_server_send(socketID_sender, CODE_HOST_COOP, data, BUFFER_TYPE_FLOAT64)
				break
				
			case CODE_JOIN_COOP:
				var row = undefined
				var ds_size = ds_list_size(table.rows)
				for (var i = 0; i < ds_size; i++) {
					var _row = table.rows[| i]
	
					if (_row[? CODE_HOST_COOP] == true and _row[? CLIENTS_COOPID] == data) {
						row = _row
						break
					}
				}
				
				if (row != undefined)
					net_server_send(socketID_sender, CODE_JOIN_COOP, data, BUFFER_TYPE_FLOAT64)
				break
				
			default:
				net_server_send(2, code, data, bufferType, false, undefined, 2)
				break
		}
	}
	catch (error) {
		show_debug_message(error)
	}
}