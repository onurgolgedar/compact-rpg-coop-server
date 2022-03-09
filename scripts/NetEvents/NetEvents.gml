function _net_event_connect(load_buffer, load_id, load_socketID, load_ip) {

}

function _net_event_disconnect(load_buffer, load_id, load_socketID, load_ip) {
	var socketID_on_server = db_get_value_by_key(global.DB_TABLE_clients, load_socketID, CLIENTS_SOCKETID_ON_SERVER)
	if (socketID_on_server != undefined)
		network_destroy(socketID_on_server)
}

function _net_event_non_blocking_connect(load_buffer, load_id, load_socketID, load_ip) {

}