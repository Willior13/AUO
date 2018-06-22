SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	flags = SS_NO_FIRE
	var/list/cache = list()
	var/list/preload = list()

/datum/controller/subsystem/assets/Initialize(timeofday)
	var/list/priority_assets = list(
		/datum/asset/simple/oui_theme_nano,
		/datum/asset/simple/goonchat,
		/datum/asset/HTML_interface
		)

	for(var/type in priority_assets)
		var/datum/asset/A = new type()
		A.register()

	for(var/type in typesof(/datum/asset) - (priority_assets | list(/datum/asset, /datum/asset/simple)))
		var/datum/asset/A = new type()
		A.register()

	preload = cache.Copy() //don't preload assets generated during the round

	for(var/client/C in GLOB.clients)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/getFilesSlow, C, preload, FALSE), 10)
	..()