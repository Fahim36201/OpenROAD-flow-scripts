proc custom_mac {macro_name x0 y0 or place_status} {
 set block [ord::get_db_block]
 set inst [$block findInst $macro_name]
 $inst setOrient $or
 $inst setOrigin $x0 $y0
 $inst setPlacementStatus $place_status
}
