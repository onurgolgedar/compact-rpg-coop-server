/// @param buffer
function net_buffer_read() {
	var buffer = argument[0]

	buffer_seek(buffer, buffer_seek_start, 0)
	var bufferType = net_buffer_get_type(buffer_read(buffer, buffer_u8))
	var code = buffer_read(buffer, buffer_u16)

	if (bufferType != undefined and code != undefined) {
		var returned
		returned[0] = code
		returned[1] = buffer_read(buffer, bufferType)
		returned[2] = buffer_read(buffer, buffer_u16)
		returned[3] = bufferType
		
		return returned
	}
	else
		return undefined
}

/// @param code
/// @param data* (req: bufferType)
/// @param bufferType*
/// @param isUDP*
/// @param socketID*
/// @param bufferInfo*
function net_client_send() {
	var code = argument[0]
	var bufferInfo = argument_count < 6 ? BUFFER_INFO_DEFAULT : argument[5]
	var data = argument_count == 1 ? 0 : argument[1]
	var bufferType = argument_count == 1 ? BUFFER_TYPE_BOOL : argument[2]
	var isUDP = argument_count < 4 ? false : argument[3]
	var socketID = argument_count < 5 ? undefined : argument[4]

	var buffer = net_make_buffer(code, data, bufferType, bufferInfo)

	if (isUDP != false)
		network_send_udp(socketID, isUDP, PORT_UDP, buffer, buffer_tell(buffer))
	else
		network_send_packet(socketID, buffer, buffer_tell(buffer))
			
	buffer_delete(buffer)
}

/// @param socketID
/// @param code
/// @param data* (req: bufferType)
/// @param bufferType*
/// @param isUDP*
/// @param location*
/// @param bufferInfo*
function net_server_send() {
	var socketID = argument[0]
	var code = argument[1]
	var bufferInfo = argument_count < 6 ? BUFFER_INFO_DEFAULT : argument[5]
	var data = argument_count < 3 ? 0 : argument[2]
	var buffer = undefined
	
	var bufferType = argument_count < 4 ? BUFFER_TYPE_BOOL : argument[3]
	var isUDP = argument_count < 5 ? false : argument[4]

	var buffer = net_make_buffer(code, data, bufferType, bufferInfo)
			
	if (isUDP) {
		var _playerRow = db_get_row(global.DB_TABLE_clients, socketID)
		if (_playerRow != undefined)
			network_send_udp(socketID, _playerRow[? CLIENTS_IP], PORT_UDP_COOP, buffer, buffer_tell(buffer))
	}
	else
		network_send_packet(socketID, buffer, buffer_tell(buffer))

	if (buffer != undefined)
		buffer_delete(buffer)
}

function net_make_buffer(code, data, bufferType, bufferInfo) {
	var buffer = buffer_create(36, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, bufferType)
	buffer_write(buffer, buffer_u16, code)
	buffer_write(buffer, net_buffer_get_type(bufferType), data)
	buffer_write(buffer, buffer_u16, bufferInfo)
	return buffer
}

function net_buffer_get_type() {
	switch (argument[0]) {
		case BUFFER_TYPE_BOOL:
			return buffer_bool
		case BUFFER_TYPE_BYTE:
			return buffer_u8
		case BUFFER_TYPE_INT16:
			return buffer_s16
		case BUFFER_TYPE_INT32:
			return buffer_s32
		case BUFFER_TYPE_FLOAT16:
			return buffer_f16
		case BUFFER_TYPE_FLOAT32:
			return buffer_f32
		case BUFFER_TYPE_FLOAT64:
			return buffer_f64
		case BUFFER_TYPE_STRING:
			return buffer_string
	}
}

function net_buffer_get_type_reverse() {
	switch (argument[0]) {
		case buffer_bool:
			return BUFFER_TYPE_BOOL
		case buffer_u8:
			return BUFFER_TYPE_BYTE
		case buffer_s16:
			return BUFFER_TYPE_INT16
		case buffer_s32:
			return BUFFER_TYPE_INT32
		case buffer_f16:
			return BUFFER_TYPE_FLOAT16
		case buffer_f32:
			return BUFFER_TYPE_FLOAT32
		case buffer_f64:
			return BUFFER_TYPE_FLOAT64
		case buffer_string:
			return BUFFER_TYPE_STRING
	}
}