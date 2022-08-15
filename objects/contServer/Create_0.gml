_db_init()
_server_init()

global.DB_TABLE_clients = db_create_table("Clients", 7541)
db_set_column_name(global.DB_TABLE_clients, CLIENTS_SOCKETID, "SocketID")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_IP, "IP")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_COOPID, "CoopID")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_HOST, "Host")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_SOCKETID_ON_COOP, "SocketID (COOP-SV)")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_SOCKETID_ON_SERVER, "SocketID (SV)")

_db_event_table_creation()
_db_event_table_column_names()

global.drawEventEnabled = true