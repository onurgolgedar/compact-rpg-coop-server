function _server_init() {
	global.server = network_create_server(network_socket_tcp, PORT_TCP_COOP, MAX_CLIENTS)
}

function server_add_client(socketID) {
	var playerRow = db_create_row(socketID)
	db_add_row(global.DB_TABLE_clients, playerRow)
	
	return playerRow
}

function server_edit_client(primaryValue, column, data) {
	var row = db_get_row(global.DB_TABLE_clients, primaryValue)
	if (row != undefined)
		row[? column] = data
}

function server_edit_table(primaryValue, table, column, data) {
	var row = db_get_row(table, primaryValue)
	if (row != undefined)
		row[? column] = data
}

function server_get_from_client(primaryValue, column) {
	var row = db_get_row(global.DB_TABLE_clients, primaryValue)
	return row[? column]
}


function server_remove_client(socketID) {
	var rowIndex = db_delete_row(global.DB_TABLE_clients, socketID)
	if (rowIndex != -1)
		show_debug_message("A player has been removed. {SocketID: " + string(socketID) + "}")
}
