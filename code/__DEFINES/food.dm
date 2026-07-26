#define MEAT 		(1<<0)
#define VEGETABLES 	(1<<1)
#define RAW 		(1<<2)
#define JUNKFOOD 	(1<<3)
#define GRAIN 		(1<<4)
#define FRUIT 		(1<<5)
#define DAIRY 		(1<<6)
#define FRIED 		(1<<7)
#define ALCOHOL 	(1<<8)
#define SUGAR 		(1<<9)
#define GROSS 		(1<<10)
#define TOXIC 		(1<<11)
#define PINEAPPLE	(1<<12)
#define BREAKFAST	(1<<13)
#define CLOTH 		(1<<14)

#define DRINK_NICE	1
#define DRINK_GOOD	2
#define DRINK_VERYGOOD	3
#define DRINK_FANTASTIC	4
#define FOOD_AMAZING 5

#define FARE_IMPOVERISHED 1
#define FARE_POOR 2
#define FARE_NEUTRAL 3
#define FARE_FINE 4
#define FARE_LAVISH 5

#define CULINARY_FAVOURITE_FOOD "Favourite Food"
#define CULINARY_FAVOURITE_DRINK "Favourite Drink"
#define CULINARY_HATED_FOOD "Hated Food"
#define CULINARY_HATED_DRINK "Hated Drink"

#define CAN_GRIND			(1<<0)
#define CAN_DRY				(1<<1)
#define CAN_CANDY			(1<<2)
#define CAN_PRESERVE_SPREAD	(1<<3)
#define CAN_CURE			(1<<4)
#define CAN_SMOKE			(1<<5)
#define CAN_FERMENT			(1<<6)
#define CAN_RISE			(1<<7)
#define CAN_STUFF			(1<<8)
#define CAN_SLOW_ROAST		(1<<9)
#define CAN_SEAR			(1<<10)
#define CAN_BOIL			(1<<11)
#define CAN_STEAM			(1<<12)
#define CAN_BAKE			(1<<13)
#define CAN_PICKLE			(1<<14)

#define FLAVOR_AFFIX_BRIGHTENING	"brightening"
#define FLAVOR_AFFIX_WARMING		"warming"
#define FLAVOR_AFFIX_EARTHY		"earthy"
#define FLAVOR_AFFIX_RICH			"rich"
#define FLAVOR_AFFIX_SHARP			"sharp"
#define FLAVOR_AFFIX_SWEET_COUNTER	"sweet_counter"
#define GENERIC_GRIND_GAME_MINUTES	10
#define GENERIC_DRY_GAME_MINUTES	30
#define GENERIC_CANDY_GAME_MINUTES		240 // 4 in-game hours
#define GENERIC_PRESERVE_GAME_MINUTES	360 // 6 in-game hours
#define GENERIC_FERMENT_GAME_MINUTES	1440 // 1 in-game day
#define GENERIC_CURE_GAME_MINUTES		4320 // 3 in-game days
#define GENERIC_SMOKE_GAME_MINUTES		720 // 12 in-game hours
#define GENERIC_MIXIN_GAME_MINUTES		2 // 2 in-game minutes
#define GENERIC_PICKLE_GAME_MINUTES	2880 // 2 in-game days
#define GENERIC_SLOW_ROAST_GAME_MINUTES	180 // 3 in-game hours

// ------------------------------------------------------------------------
#define DONENESS_RAW			0
#define DONENESS_BLUE_RARE		1
#define DONENESS_RARE			2
#define DONENESS_MEDIUM_RARE	3
#define DONENESS_MEDIUM			4
#define DONENESS_MEDIUM_WELL	5
#define DONENESS_WELL_DONE		6
#define DONENESS_BURNT			7
