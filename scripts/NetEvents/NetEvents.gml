function _net_event_connect(load_buffer, load_id, load_socketID, load_ip) {

}

function _net_event_disconnect(load_buffer, load_id, load_socketID, load_ip) {
	var socketID_on_coop = db_get_value_by_key(global.DB_TABLE_clients, load_socketID, CLIENTS_SOCKETID_ON_COOP)
	if (socketID_on_coop != undefined)
		network_destroy(socketID_on_coop)
}

function _net_event_non_blocking_connect(load_buffer, load_id, load_socketID, load_ip) {

}