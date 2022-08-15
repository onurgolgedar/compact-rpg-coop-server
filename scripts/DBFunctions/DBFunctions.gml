function _db_init() {
	global.DB_columnNames = ds_map_create()
}

function db_add_row(table, row) {
	ds_list_add(table.rows, row)
}

function db_create_row(primaryValue) {
	var row = ds_map_create()
	row[? 0] = primaryValue

	return row
}

function db_create_table(tableName, tableID) {
	return { rows: ds_list_create(), name: tableName, ID: tableID*100 }
}

function db_delete_row(table, primaryValue) {
	var rowIndex = -1
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		if (table.rows[| i][? 0] == primaryValue) {
			ds_map_destroy(table.rows[| i])
			ds_list_delete(table.rows, i)
			rowIndex = i
			break
		}
	}
	
	return rowIndex
}

function db_get_column_name(table, column) {
	return global.DB_columnNames[? table.ID+column]
}

function db_get_row(table, primaryValue) {
	var row = undefined
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		var _row = table.rows[| i]
	
		if (_row[? 0] == primaryValue) {
			row = _row
			break
		}
	}

	return row
}

function db_get_row_index(table, primaryValue) {
	var rowIndex = -1
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		if (table.rows[| i][? 0] == primaryValue) {
			rowIndex = i
			break
		}
	}

	return rowIndex
}

function db_get_value_by_key(table, primaryValue, column) {
	var row = undefined
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		var _row = table.rows[| i]
	
		if (_row[? 0] == primaryValue) {
			row = _row
			break
		}
	}

	return row != undefined ? row[? column] : undefined
}

function db_find_value(table, valueColumn, filterColumn, filterValue) {
	var row = undefined
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		var _row = table.rows[| i]
	
		if (_row[? filterColumn] == filterValue) {
			row = _row
			break
		}
	}

	return row != undefined ? row[? valueColumn] : undefined
}
	
function db_find_row(table, filterColumn, filterValue) {
	var row = undefined
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		var _row = table.rows[| i]
	
		if (_row[? filterColumn] == filterValue) {
			row = _row
			break
		}
	}

	return row
}
	
function db_get_value_by_index(table, index, column) {
	var row = table.rows[| index]

	return row != undefined ? row[? column] : undefined
}

function db_get_row_by_index(table, index) {
	var row = table.rows[| index]

	return row
}
	
function db_get_table_size(table) {
	return ds_list_size(table.rows)
}
	
function db_set_column_name(table, column, columnName) {
	ds_map_add(global.DB_columnNames, table.ID+column, columnName)
}

function db_set_row_value(table, primaryValue, column, value) {
	var row = undefined
	var ds_size = ds_list_size(table.rows)
	for (var i = 0; i < ds_size; i++) {
		var _row = table.rows[| i]
	
		if (_row[? 0] == primaryValue) {
			row = _row
			break
		}
	}
	
	if (row != undefined)
		row[? column] = value
}

function db_draw_table(table_x, table_y, table, columnCount) {
	var gHeight = ds_list_size(table.rows)

	draw_set_color(c_ltgray)
	//draw_text(table_x, table_y, table.name)
	table_y += 30

	draw_set_color(c_white)
	for (var i = 0; i < columnCount; i++) {
		draw_text(table_x+i*200, table_y, db_get_column_name(table, i))
		draw_line_width(table_x+i*200, table_y+30, table_x+200+i*200, table_y+30, 3)
	}

	for (var j = 0; j < gHeight; j++) {
		for (var i = 0; i < columnCount; i++) {
			var row = table.rows[| j]
			
			draw_text(table_x+i*200, table_y+40+j*30, row[? i])
			draw_line(table_x+i*200, table_y+40+j*30+30, table_x+200+i*200, table_y+40+j*30+30)
		}
	}
	draw_set_color(c_black)
}
	
function db_convert_row_to_parameters(row) {
	var parameters = ""
	var i = 0
	while (true) {
		var value = row[? i]
		if (value != undefined)
			parameters += string(row[? i])+"|"
		else {
			if (string_length(parameters) != 0)
				parameters = string_delete(parameters, string_length(parameters), 1)
				
			break
		}
		
		i++	
	}
	
	return parameters
}

function db_save_table(table) {
	var copy = ds_list_create()
	ds_list_copy(copy, table.rows)
		
	var ds_size = ds_list_size(copy)
	for (var i = 0; i < ds_size; i++)
		copy[| i] = ds_map_write(copy[| i])
		
	ini_open(table.name+".dbfile")
		ini_write_string(table.name, "Rows", ds_list_write(copy))
	ini_close()
	
	ds_list_destroy(copy)
}

function db_load_table(tableName, tableID) {
	var loadedTable = db_create_table(tableName, tableID)
	ini_open(tableName+".dbfile")
		ds_list_read(loadedTable.rows, ini_read_string(tableName, "Rows", ""))

		var ds_size = ds_list_size(loadedTable.rows)
		for (var i = 0; i < ds_size; i++) {
			var value = loadedTable.rows[| i]
			loadedTable.rows[| i] = ds_map_create()
			ds_map_read(loadedTable.rows[| i], value)
		}
	ini_close()
	
	return loadedTable
}