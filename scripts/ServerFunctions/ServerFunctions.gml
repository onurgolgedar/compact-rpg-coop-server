function _server_init() {
	global.server = network_create_server(network_socket_tcp, PORT_TCP_COOP, MAX_CLIENTS)
	//global.socket_udp = network_create_socket_ext(network_socket_udp, PORT_UDP_COOP)
}

/// @param socketID
function server_add_client() {
	var socketID = argument[0]

	var playerRow = db_create_row(socketID)
	db_add_row(global.DB_TABLE_clients, playerRow)
	
	return playerRow
}

/// @param primaryValue
/// @param column
/// @param data
function server_edit_client() {
	var primaryValue = argument[0]
	var column = argument[1]
	var data = argument[2]

	var row = db_get_row(global.DB_TABLE_clients, primaryValue)
	if (row != undefined)
		row[? column] = data
}

/// @param primaryValue
/// @param table
/// @param column
/// @param data
function server_edit_table() {
	var primaryValue = argument[0]
	var table = argument[1]
	var column = argument[2]
	var data = argument[3]

	var row = db_get_row(table, primaryValue)
	if (row != undefined)
		row[? column] = data
}

/// @param primaryValue
/// @param column
function server_get_from_client() {
	var row = db_get_row(global.DB_TABLE_clients, argument[0])
	return row[? argument[1]]
}


/// @param socketID
function server_remove_client() {
	var socketID = argument[0]

	var rowIndex = db_delete_row(global.DB_TABLE_clients, socketID)
	if (rowIndex != -1)
		show_debug_message("A player has been removed. {SocketID: " + string(socketID) + "}")
}
