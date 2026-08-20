#define ROLE_DEFAULT_OVERRIDE_ROLE_WIDE "role_wide"
// Max entries kept in cached_role_preview_renders before it's cleared - see
// regenerate_character_preview(). Each entry holds 5 base64-encoded icon
// renders (icon/front/left/right/back), so this bounds memory growth across
// a long customization session.
#define PREVIEW_RENDER_CACHE_MAX_SIZE 24
GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_EMPTY(chosen_names)

GLOBAL_LIST_INIT(role_selection_blacklist, list(
	"Tribal Rabble",
	"Tribal Villager",
	"Tribal Guard",
	"Tribal Shaman",
	"Chieftain",
	"Lunatic",
	"Vagabond",
	"Tapster",
	"Cook",
	"Palace Slave",
	"Wretch",
	"Enslaved Adventurer",
	"Gnoll",
	"Keeper",
	"Master Warden",
	"Slave Master",
	"Azeb",
	"Vanguard",
	"Watch Captain",
	"Janissary",
	"Janissary Sergeant",
	"Azeb Agha",
	"Sergeant",
	"Rookie",
	"Cataphract",
	"Knight Captain",
	"Palace Knight",
	"Court Chaplain",
	"Palace Chaplain",
	"Head Slave",
	"Councillor",
	"Warden",
	"Veteran",
	"City Guard",
	"Martyr",
	"Orthodoxist",
	"Seneschal",
	"Court Agent",
	"Archivist",
))

// Pointbuy system constants
#define POINTBUY_MIN 4
#define POINTBUY_MAX 18
#define POINTBUY_DEFAULT_STAT 6
#define POINTBUY_POOL_BASE 37 // Pointbuy pool for a character with 0 PQ
#define POINTBUY_POOL_MAX 39 // Pointbuy pool for a character with 100+ PQ
#define POINTBUY_THRESHOLD_LOW 13
#define POINTBUY_THRESHOLD_HIGH 15

// Tattoo system constants. The plain BODY_ZONE_* / BODY_ZONE_PRECISE_*
// defines (see code/__DEFINES/medical.dm) cover every targetable body part
// except anatomy that only exists on some characters (breasts, penis) and
// the buttocks (not a separate combat zone, but visible from behind when
// looking at the groin, same as in-game).
#define TATTOO_LOC_L_BREAST "l_breast"
#define TATTOO_LOC_R_BREAST "r_breast"
#define TATTOO_LOC_L_NIPPLE "l_nipple"
#define TATTOO_LOC_R_NIPPLE "r_nipple"
#define TATTOO_LOC_PENIS "penis_tattoo"
#define TATTOO_LOC_VAGINA "vagina_tattoo"
#define TATTOO_LOC_L_BUTTCHEEK "l_buttcheek"
#define TATTOO_LOC_R_BUTTCHEEK "r_buttcheek"
#define TATTOO_LOC_ASSHOLE "asshole"
#define TATTOO_LOC_ABDOMEN "abdomen"
#define MAX_TATTOO_DESIGN_LEN 200
#define TATTOO_DEFAULT_COLOR "2a4a56"

// Returns the pointbuy pool available to a character, scaled by PQ.
// 0 PQ = 21 points, 1 PQ = 22 points, then +1 for every additional 10 PQ, capped at 32 points (100+ PQ).
/proc/get_pointbuy_pool(pq)
	if(pq <= 0)
		return POINTBUY_POOL_BASE
	return min(POINTBUY_POOL_MAX, POINTBUY_POOL_BASE + 1 + round(pq / 10))

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 60

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.
	var/triumphs = 0
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds
	// Commend variable on prefs instead of client to prevent reconnect abuse (is persistant on prefs, opposed to not on client)
	var/commendedsomeone = FALSE

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/buttons_locked = TRUE
	var/hotkeys = TRUE

	var/chat_on_map = TRUE
	var/showrolls = TRUE
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	var/see_chat_non_mob = TRUE

	// Custom Keybindings
	var/list/key_bindings = list()

	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/tgui_theme = "azure_default"
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/floating_text_toggles = TOGGLES_TEXT_DEFAULT
	var/admin_chat_toggles = TOGGLES_DEFAULT_CHAT_ADMIN
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/pda_style = MONO
	var/pda_color = "#808000"
	var/prefer_old_chat = FALSE

	var/uses_glasses_colour = 0

	//character preferences
	var/slot_randomized					//keeps track of round-to-round randomization of the character slot, prevents overwriting
	var/real_name						//our character's name
	var/surname	= ""						//our character's surname
	var/list/persistent_tattoos = list()	//persistent tattoo data across rounds
	var/defaultmood = "Calm"
	var/moodcol = "#ffffff"
	var/gender = MALE					//gender of character (well duh)
	var/pronouns = HE_HIM				// LETHALSTONE EDIT: character's pronouns (well duh)
	var/voice_type = VOICE_TYPE_MASC	// LETHALSTONE EDIT: the type of soundpack the mob should use
	// LETHALSTONE EDIT: statpack kept only to gate the "Virtuous" second-virtue
	// slot (see set_virtue_two) - no longer generated/applied for stats,
	// pointbuy handles that instead.
	var/datum/statpack/statpack	= new /datum/statpack/wildcard/fated
	var/datum/virtue/virtue = new /datum/virtue/none // LETHALSTONE EDIT: the virtue we get for not picking a statpack
	var/datum/virtue/virtuetwo = new /datum/virtue/none
	var/age = AGE_ADULT						//age of character
	var/origin = "Default"
	var/accessory = "Nothing"
	var/detail = "Nothing"
	var/backpack = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hairstyle = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hairstyle = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "000"				//Eye color
	var/extra_language = "None" // Extra language
	var/voice_color = "a0a0a0"
	var/voice_pitch = 1
	var/detail_color = "000"
	var/datum/species/pref_species = new /datum/species/human/northern()	//Mutant race
	var/static/datum/species/default_species = new /datum/species/human/northern()
	var/datum/faith/selected_faith
	var/datum/patron/selected_patron
	var/static/datum/patron/default_patron = /datum/patron/godless
	var/list/features = MANDATORY_FEATURE_LIST
	var/list/randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SOCKS = TRUE, RANDOM_BACKPACK = TRUE, RANDOM_JUMPSUIT_STYLE = FALSE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
	var/list/friendlyGenders = list("male" = "masculine", "female" = "feminine")
	var/phobia = "spiders"
	var/shake = TRUE
	var/sexable = FALSE
	var/compliance_notifs = TRUE

	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM

	//Quirk list
	var/list/all_quirks = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = RETURNTOLOBBY  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 100//0 is sync

	var/parallax

	var/ambientocclusion = TRUE
	var/auto_fit_viewport = FALSE
	var/widescreenpref = TRUE

	var/musicvol = 50
	var/mastervol = 50

	var/anonymize = TRUE
	var/masked_examine = FALSE
	var/mute_animal_emotes = FALSE
	var/autoconsume = FALSE
	var/runmode = FALSE
	var/no_examine_blocks = FALSE

	var/lastclass

	var/uplink_spawn_loc = UPLINK_PDA

	var/list/exp = list()
	var/list/menuoptions

	var/datum/migrant_pref/migrant
	var/next_special_trait = null

	var/action_buttons_screen_locs = list()

	var/domhand = 2
	var/virgin = FALSE
	var/citizen = 1
	var/nickname = "Please Change Me"
	var/highlight_color = "#FF0000"
	var/datum/charflaw/charflaw

	var/static/default_cmusic_type = /datum/combat_music/default
	var/datum/combat_music/combat_music
	var/combat_music_helptext_shown = FALSE

	var/family = FAMILY_NONE

	var/crt = FALSE
	var/grain = TRUE
	var/dnr_pref = FALSE

	var/list/customizer_entries = list()
	var/list/list/body_markings = list()
	var/update_mutant_colors = TRUE

	var/headshot_link = ""
	var/nsfw_headshot_link = ""
	var/chatheadshot = FALSE
	var/ooc_extra_link
	var/ooc_extra = ""
	var/song_artist
	var/song_title
	var/list/descriptor_entries = list()
	var/list/custom_descriptors = list()
	/// List of tattoo entries, each a list("location" = zone_key, "design" = text, "color" = hex).
	var/list/tattoos = list()

	var/char_accent = "No accent"

	// Vocal bark prefs
	var/bark_id = "mutedc3"
	var/bark_speed = 4
	var/bark_pitch = 1
	var/bark_variance = 0.2
	COOLDOWN_DECLARE(bark_previewing)
	var/hear_barks = TRUE

	// PATREON
	// Vrell - I fucking hate how inconsistent the variable style is for this shit. underscores? all lowercase? camelcase?
	var/patreon_say_color = "ff7a05"
	var/patreon_say_color_enabled = FALSE
	// END PATREON


	var/datum/loadout_item/loadout
	var/datum/loadout_item/loadout2
	var/datum/loadout_item/loadout3
	var/datum/loadout_item/loadout4
	var/datum/loadout_item/loadout5
	var/datum/loadout_item/loadout6
	var/datum/loadout_item/loadout7
	var/datum/loadout_item/loadout8
	var/datum/loadout_item/loadout9
	var/datum/loadout_item/loadout10

	var/loadout_1_hex
	var/loadout_2_hex
	var/loadout_3_hex
	var/loadout_4_hex
	var/loadout_5_hex
	var/loadout_6_hex
	var/loadout_7_hex
	var/loadout_8_hex
	var/loadout_9_hex
	var/loadout_10_hex

	var/loadout_1_name
	var/loadout_2_name
	var/loadout_3_name
	var/loadout_4_name
	var/loadout_5_name
	var/loadout_6_name
	var/loadout_7_name
	var/loadout_8_name
	var/loadout_9_name
	var/loadout_10_name

	var/loadout_1_desc
	var/loadout_2_desc
	var/loadout_3_desc
	var/loadout_4_desc
	var/loadout_5_desc
	var/loadout_6_desc
	var/loadout_7_desc
	var/loadout_8_desc
	var/loadout_9_desc
	var/loadout_10_desc

	// JSON-serialized snapshots of loadout/vice/language selections, saved via save_preset()
	var/list/loadout_preset_1
	var/list/loadout_preset_2
	var/list/loadout_preset_3

	// Undo history for the unified customization menu (list of snapshot lists, most recent first)
	var/list/customization_history

	// Currently selected item awaiting confirmation in the loadout select popup
	var/datum/loadout_item/temp_loadout_selection

	// Unified loadout/vices/language customization popup menu
	var/datum/loadout_menu/loadout_menu

	// Character vices (charflaws), up to 5 selectable slots
	var/datum/charflaw/vice1
	var/datum/charflaw/vice2
	var/datum/charflaw/vice3
	var/datum/charflaw/vice4
	var/datum/charflaw/vice5

	// Additional selectable languages beyond the base extra_language pick
	var/extra_language_1 = "None"
	var/extra_language_2 = "None"

	var/flavortext
	var/flavortext_display
	
	var/is_legacy = FALSE

	var/ooc_notes
	
	// Cached character preview icons - regenerated only when appearance changes
	var/cached_preview_icon
	var/cached_preview_front
	var/cached_preview_left
	var/cached_preview_right
	var/cached_preview_back
	var/ooc_notes_display

	// Per-player data cached once when the preferences UI first opens.
	// These are expensive to compute (ban checks are I/O, PQ may be a DB
	// call) and do not change meaningfully during a single UI session, so
	// they are computed once in build_ui_caches() rather than on every
	// TGUI poll inside ui_data().
	var/list/ui_cached_job_bans = null     // null = uninitialized; empty list = no jobs cached (safe for `in` checks)
	var/cached_ui_player_pq = -1           // player quality score; -1 = not yet built
	var/list/ui_cached_sorted_jobs = null  // sorted /datum/job list; null = not yet built

	var/nsfwflavortext

	var/erpprefs
	
	// Pointbuy system variables - these map directly onto the mob's real stats
	// (STASTR, STACON, STAINT, STASPD, STAWIL, STAPER) when the character is spawned.
	var/PBSTR = POINTBUY_DEFAULT_STAT
	var/PBCON = POINTBUY_DEFAULT_STAT
	var/PBINT = POINTBUY_DEFAULT_STAT
	var/PBSPD = POINTBUY_DEFAULT_STAT
	var/PBWIL = POINTBUY_DEFAULT_STAT
	var/PBPER = POINTBUY_DEFAULT_STAT

	var/CanStrTrait1 = FALSE
	var/CanStrTrait2 = FALSE
	var/CanConTrait = FALSE
	var/CanIntTrait1 = FALSE
	var/CanIntTrait2 = FALSE
	var/CanSpdTrait = FALSE
	var/CanWilTrait = FALSE
	var/CanPerTrait1 = FALSE
	var/CanPerTrait2 = FALSE

	var/RaceTrait
	/// Optional negative trait picked alongside the racial trait (None/Cyclops/Permamute).
	var/NegRaceTrait
	var/StrTrait1
	var/StrTrait2
	var/ConTrait
	var/IntTrait1
	var/IntTrait2
	var/SpdTrait
	var/WilTrait
	var/PerTrait1
	var/PerTrait2

	var/unused_points = POINTBUY_POOL_BASE

	// Loadout system - replaces the old fixed 3-slot "class slots" model.
	// The set of roles a player has added is simply every job title present
	// in job_preferences (this doubles as the round-start role preference
	// list, since the Loadout tab now fully replaces that separate menu).
	// Chosen subclass per role, ex: "Sergeant" = /datum/advclass/whatever (or null)
	var/list/role_subclasses = list()
	// Chosen loadout item per equipment slot category, per role, ex:
	// "Sergeant" = list("Weapon" = /obj/item/rogueweapon/whatever)
	var/list/role_loadout_selections = list()
	// Chosen dye color per equipment slot category, per role, ex:
	// "Sergeant" = list("Armor" = "#ff0000") - see dye_role_loadout_item().
	var/list/role_loadout_dye_selections = list()
	// Cache of get_role_base_outfit_items() results, keyed by a string
	// combining everything that can change what a role's default gear looks
	// like (see get_role_base_outfit_items for the exact key). Avoids paying
	// for a throwaway dummy mob + pre_equip() per added role on every single
	// Loadout tab data refresh.
	var/list/cached_role_base_outfit_items = list()
	// Cache of fully rendered mannequin previews (see
	// regenerate_character_preview()), keyed by a fingerprint of every
	// role/appearance field that affects the rendered image (see
	// build_preview_cache_key()). Switching back and forth between
	// already-visited roles (or repeat pokes that don't actually change
	// anything) previously paid for a brand new dummy mob + equip pass +
	// 4-direction icon render every single time - this lets an exact
	// repeat of a previously seen state reuse the base64 images outright.
	var/list/cached_role_preview_renders = list()
	// Cache of the last get_loadout_ui_data() result plus the key it was
	// built from (see get_loadout_ui_data() for what the key covers).
	// ui_data() is polled by tgui every ~second for as long as the
	// Preferences window is open, and get_loadout_ui_data() re-walks every
	// added role's full item pool/paper doll categories - without this
	// cache that happened on every single poll for every player with the
	// window open, even when nothing loadout-related had changed since the
	// last poll, which was a major source of server lag.
	var/cached_loadout_ui_data_key
	var/list/cached_loadout_ui_data
	// Cache of the skin_tone_name lookup in ui_data() (see there for why),
	// keyed on species type + skin_tone.
	var/cached_skin_tone_name_key
	var/cached_skin_tone_name
	// Dressup Mode - when enabled, clicking a Loadout tab paper doll slot
	// (see pick_role_loadout_item()) offers every matching item in the whole
	// game for that slot, rather than just the role's own loadout pool. This
	// is purely a preview/export tool: picks made in Dressup Mode still only
	// ever get applied to the dummy shown in the character creator and to
	// the exported outfit text (see export_dressup_outfit()) - they're never
	// actually equipped on the real character at round start, since
	// apply_loadout_selections() only ever equips selections that also
	// appear in the role's normal (non-dressup) item pool.
	var/dressup_mode = FALSE
	// Whether the client currently has the Occupation Preferences modal
	// (OccupationMenu in Preferences.tsx) open. That modal is the only
	// consumer of ui_data()'s "jobs" list, which is expensive to build
	// (loops every joinable job, each doing playtime/PQ/ban/availability
	// checks). Gating the build behind this flag - set via the
	// "open_occupation_menu"/"close_occupation_menu" ui_act actions the
	// client sends when the modal opens/closes - avoids redoing that work
	// on every single TGUI poll (~1/sec) while the modal is closed, which
	// is true for the vast majority of time the Preferences window is open.
	var/showing_occupation_menu = FALSE
	// Which role's outfit the Loadout tab's character preview currently
	// shows. Set whenever the player selects/edits a role in the Loadout
	// tab (see the "set_preview_role" ui_act action and the various
	// role_loadout_* ui_act handlers), so the preview always follows
	// whichever role the player is actively looking at/dressing up, rather
	// than being locked to whichever role happens to be HIGH priority.
	// Falls back to the HIGH priority role (then the first added role) if
	// unset or no longer valid - see get_preview_role_title().
	var/loadout_preview_role

	// Stock Market Portfolio
	// Format: list(short_name = list("shares" = X, "avg_price" = Y))
	var/list/stock_portfolio = list()
	var/stock_portfolio_last_reduction_round = 0  // Track which round the 10% reduction was last applied

	var/list/img_gallery = list()

	var/list/nsfw_img_gallery = list()

	var/datum/familiar_prefs/familiar_prefs

	var/taur_type = null
	var/taur_color = "ffffff"
	var/taur_markings = "ffffff"
	var/taur_tertiary = "ffffff"

	/// Assoc list of culinary preferences, where the key is the type of the culinary preference, and value is food/drink typepath
	var/list/culinary_preferences = list()

	var/datum/advclass/preview_subclass

	var/tgui_pref = TRUE

	var/race_bonus

	var/datum/gnoll_prefs/gnoll_prefs

	// Audio sliders
	var/combatmusicvol = 50
	var/lobbymusicvol = 50
	var/ambiencevol = 50

	// Misc toggles
	var/ghost_protection = FALSE
	var/nsfw_examine_always = FALSE
	var/wildshape_name = TRUE
	var/no_autopunctuate = FALSE
	var/no_language_fonts = FALSE
	var/no_language_icon = FALSE
	var/hide_unavailable_emotes = FALSE
	var/hide_tongue_noise_warnings = FALSE
	var/skillcap_notifs = TRUE

	// ERP/Chastity related toggles
	var/chastenable = FALSE
	var/chastity_hardmode = CHASTITY_HARDMODE_DISABLED
	var/extreme_erp = FALSE
	var/edging = FALSE

	// Accessibility - colorblind HUD palette
	var/hud_colorblind_palette = HUD_COLORBLIND_NONE

	// Voice pack used for this character's vocal barks
	var/voice_pack = "Default"

	// Identity-related savefile fields
	var/gender_choice = ANY_GENDER
	var/setspouse
	var/xenophobe_pref = 0
	var/restricted_species_pref
	var/selected_title

	// OOC extra images
	var/ooc_extra_img
	var/ooc_extra_img_link
	var/nsfw_ooc_extra_img
	var/nsfw_ooc_extra_img_link
	var/rumour
	var/noble_gossip

/datum/preferences/New(client/C)
	parent = C
	migrant  = new /datum/migrant_pref(src)
	familiar_prefs = new /datum/familiar_prefs(src)
	gnoll_prefs = new /datum/gnoll_prefs(src)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots = 100
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			if(check_nameban(C.ckey) || (C.blacklisted() == 1))
				real_name = pref_species.random_name(gender,1)
			return
	//Set the race to properly run race setter logic
	set_new_race(pref_species, null)
	if(!charflaw)
		charflaw = pick(GLOB.character_flaws)
		charflaw = GLOB.character_flaws[charflaw]
		charflaw = new charflaw()
	if(!selected_patron)
		selected_patron = GLOB.patronlist[default_patron]
	if(!combat_music)
		combat_music = GLOB.cmode_tracks_by_type[default_cmusic_type]
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C.update_movement_keys()
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

/datum/preferences/proc/set_new_race(datum/species/new_race, user)
	pref_species = new_race
	real_name = pref_species.random_name(gender,1)
	ResetJobs()
	if(user)
		if(pref_species.desc)
			to_chat(user, "[pref_species.desc]")
		if(pref_species.expanded_desc)
			to_chat(user, "<a href='?src=[REF(user)];view_species_info=[pref_species.expanded_desc]'>Read More</a>")
		to_chat(user, "<font color='red'>Classes reset.</font>")
	random_character(gender, FALSE, FALSE)
	accessory = "Nothing"

	if(pref_species.forced_taur && pref_species.allowed_taur_types.len)
		taur_type = pick(pref_species.allowed_taur_types)
	else
		taur_type = null

	customizer_entries = list()
	validate_customizer_entries()
	reset_all_customizer_accessory_colors()
	randomize_all_customizer_accessories()
	reset_descriptors()


/datum/preferences/proc/ShowChoices(mob/user, tabchoice)
	if(!user || !user.client)
		return

	// Always use TGUI interface
	show_character_creator_tgui(user, tabchoice)

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybinds;task=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/noclose/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/SetChoices(mob/user, limit = 14, list/splitJobs = list("Court Magician", "Knight Captain", "Bishop", "Merchant", "Archivist", "Towner", "Grenzelhoft Mercenary", "Beggar", "Prisoner", "Goblin King"), widthPerColumn = 295, height = 620) //295 620
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
//		HTML += "The job SSticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.

	else
//		HTML += "<b>Choose class preferences</b><br>"
//		HTML += "<div align='center'>Left-click to raise a class preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center>" // Easier to press up here.
		if(joblessrole != RETURNTOLOBBY && joblessrole != BERANDOMJOB) // this is to catch those that used the previous definition and reset.
			joblessrole = RETURNTOLOBBY
		HTML += "<i>Click on an unlocked Class to get more information</i><br>"
		HTML += "<b>If Role Unavailable:</b><font color='purple'><a href='?_src_=prefs;preference=job;task=nojob'>[joblessrole]</a></font><BR>"
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob
		for(var/datum/job/job in sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))
			if(!job.spawn_positions)
				continue
			if(job.title in GLOB.role_selection_blacklist)
				continue
			index += 1
//			if((index >= limit) || (job.title in splitJobs))
			if(index >= limit)
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='#000000'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			if(job.title in splitJobs)
				HTML += "<tr bgcolor='#000000'><td width='60%' align='right'><hr></td></tr>"

			HTML += "<tr bgcolor='#000000'><td width='60%' align='right'>"
			var/rank = job.title
			var/used_name = job.display_title || job.title
			if((pronouns == SHE_HER || pronouns == THEY_THEM_F) && job.f_title)
				used_name = "[job.f_title]"
			lastJob = job
			if(is_banned_from(user.ckey, rank))
				HTML += "[used_name]</td> <td><a href='?_src_=prefs;bancheck=[rank]'> BANNED</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "[used_name]</td> <td><font color=red> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \] </font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "[used_name]</td> <td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			#ifdef USES_PQ
			if(!job.required && !isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
				HTML += "<font color=#a59461>[used_name] (Min PQ: [job.min_pq])</font></td> <td> </td></tr>"
				continue
			#endif
			if(!job.required && !isnull(job.max_pq) && (get_playerquality(user.ckey) > job.max_pq))
				HTML += "<font color=#a59461>[used_name] (Max PQ: [job.max_pq])</font></td> <td> </td></tr>"
				continue
			if(length(job.virtue_restrictions) && length(job.vice_restrictions))
				var/name
				if(virtue.type in job.virtue_restrictions)
					name = virtue.name
				if(virtuetwo?.type in job.virtue_restrictions)
					if(name)
						name += ", "
						name += virtuetwo.name
					else
						name = virtuetwo.name
				if(charflaw.type in job.vice_restrictions)
					if(name)
						name += ", "
						name += charflaw.name
					else
						name += charflaw.name
				if(!isnull(name))
					HTML += "<font color='#a561a5'>[used_name] (Disallowed by Virtues / Vice: [name])</font></td> <td> </td></tr>"
			if(length(job.virtue_restrictions))
				var/name
				if(virtue.type in job.virtue_restrictions)
					name = virtue.name
				if(virtuetwo?.type in job.virtue_restrictions)
					if(name)
						name += ", "
						name += virtuetwo.name
					else
						name = virtuetwo.name
				if(!isnull(name))
					HTML += "<font color='#a59461'>[used_name] (Disallowed by Virtue: [name])</font></td> <td> </td></tr>"
					continue
			if(length(job.vice_restrictions))
				if(charflaw.type in job.vice_restrictions)
					HTML += "<font color='#a56161'>[used_name] (Disallowed by Vice: [charflaw.name])</font></td> <td> </td></tr>"
					continue
			var/job_unavailable = JOB_AVAILABLE
			if(isnewplayer(parent?.mob))
				var/mob/dead/new_player/new_player = parent.mob
				job_unavailable = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
			var/static/list/acceptable_unavailables = list(
				JOB_AVAILABLE,
				JOB_UNAVAILABLE_SLOTFULL,
			)
			if(!(job_unavailable in acceptable_unavailables))
				HTML += "<font color=#a36c63>[used_name]</font></td> <td> </td></tr>"
				continue

			var/job_display = used_name
			//job_display += " <a href='?src=[REF(job)];explainjob=1'>{?}</a></span>"
//			if((job_preferences[SSjob.overflow_role] == JP_LOW) && (rank != SSjob.overflow_role) && !is_banned_from(user.ckey, SSjob.overflow_role))
//				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
//				continue
/*			if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
				HTML += "<b><span class='dark'><a href='?_src_=prefs;preference=job;task=tutorial;tut='[job.tutorial]''>[used_name]</a></span></b>"
			else
				HTML += span_dark("<a href='?_src_=prefs;preference=job;task=tutorial;tut='[job.tutorial]''>[used_name]</a>")*/

			HTML += {"

<style>


.tutorialhover {
	position: relative;
	display: inline-block;
	border-bottom: 1px dotted black;
}

.tutorialhover .tutorial {

	visibility: hidden;
	width: 280px;
	background-color: black;
	color: #e3c06f;
	text-align: center;
	border-radius: 6px;
	padding: 5px 0;

	position: absolute;
	z-index: 1;
	top: 100%;
	left: 50%;
	margin-left: -140px;
}

.tutorialhover:hover .tutorial{
	visibility: visible;
}

</style>

<div class="tutorialhover"> [job.class_setup_examine ? "<a href='?src=[REF(job)];explainjob=1'><font>[job_display]</font></a>" : "<font>[job_display]</font>"]</span>
<span class="tutorial">[job.tutorial]<br>
Slots: [job.spawn_positions] [job.round_contrib_points ? "RCP: +[job.round_contrib_points]" : ""]</span>
</div>

			"}

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			switch(job_preferences[job.title])
				if(JP_HIGH)
					prefLevelLabel = "High"
					prefLevelColor = "slateblue"
					prefUpperLevel = 4
					prefLowerLevel = 2
					var/mob/dead/new_player/P = user
					if(istype(P))
						P.topjob = job.title
				if(JP_MEDIUM)
					prefLevelLabel = "Medium"
					prefLevelColor = "green"
					prefUpperLevel = 1
					prefLowerLevel = 3
				if(JP_LOW)
					prefLevelLabel = "Low"
					prefLevelColor = "orange"
					prefUpperLevel = 2
					prefLowerLevel = 4
				else
					prefLevelLabel = "NEVER"
					prefLevelColor = "red"
					prefUpperLevel = 3
					prefLowerLevel = 1

			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

//			if(rank == SSjob.overflow_role)//Overflow is special
//				if(job_preferences[SSjob.overflow_role] == JP_LOW)
//					HTML += "<font color=green>Yes</font>"
//				else
//					HTML += "<font color=red>No</font>"
//				HTML += "</a></td></tr>"
//				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='000000'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table><br>"

//		var/message = "Be an [SSjob.overflow_role] if preferences unavailable"
//		if(joblessrole == BERANDOMJOB)
//			message = "Get random job if preferences unavailable"
//		else if(joblessrole == RETURNTOLOBBY)
//			message = "Return to lobby if preferences unavailable"
//		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		if(user.client.prefs.lastclass)
			HTML += "<center><a href='?_src_=prefs;preference=job;task=triumphthing'>PLAY AS [user.client.prefs.lastclass] AGAIN</a></center>"
		else
			HTML += "<br>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset</a></center>"

	var/datum/browser/noclose/popup = new(user, "mob_occupation", "<div align='center'>Class Selection</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
				break // Only one job can be HIGH at a time

	job_preferences[job.title] = level
	return TRUE

/datum/preferences/proc/GetHighPriorityJob()
	// Returns the title of the job set to HIGH priority, or null if none
	if(!job_preferences)
		return null
	for(var/j in job_preferences)
		if(job_preferences[j] == JP_HIGH)
			return j
	return null

/// Returns the title of the role the character preview/Loadout tab should
/// currently show. Prefers loadout_preview_role (whatever the player last
/// selected/edited in the Loadout tab), falling back to the HIGH priority
/// role, then the first added role, if the preview role was never set or
/// is no longer one of the player's added roles (ex: it was removed).
/datum/preferences/proc/get_preview_role_title()
	if(!job_preferences)
		return null
	if(loadout_preview_role && (loadout_preview_role in job_preferences))
		return loadout_preview_role
	var/high_job = GetHighPriorityJob()
	if(high_job)
		return high_job
	for(var/title in job_preferences)
		return title
	return null

/// Cheap fingerprint of every field that can change what
/// regenerate_character_preview() renders for the given previewed role:
/// the role's own subclass/item/dye picks, plus every appearance field
/// copy_to() pulls onto the mannequin (species/pronouns/gender/skin tone/
/// body & hair customization/markings). Used as regenerate_character_preview()'s
/// cache key - see cached_role_preview_renders. json_encode() is fine here
/// (unlike build_loadout_cache_key(), which runs on every ~1s poll) since
/// this only runs once per actual preview regeneration, not on every poll.
/datum/preferences/proc/build_preview_cache_key(job_title)
	// ASCII Unit Separator (0x1F/31) - same choice/rationale as
	// build_loadout_cache_key()'s unit_sep: job titles/typepaths/category
	// ids could in principle contain any normal punctuation character, but
	// never a control character, so this can't collide with real data.
	var/static/unit_sep = ascii2text(31)
	var/list/parts = list(
		job_title,
		role_subclasses[job_title] || "none",
		pronouns,
		gender,
		pref_species?.type || "none",
		skin_tone,
		age,
		domhand,
		json_encode(features),
		json_encode(body_markings),
	)
	var/list/selections = role_loadout_selections[job_title]
	if(selections)
		for(var/category in selections)
			parts += "[category][unit_sep][selections[category]]"
	var/list/dyes = role_loadout_dye_selections[job_title]
	if(dyes)
		for(var/category in dyes)
			parts += "[category][unit_sep][dyes[category]]"
	return parts.Join(unit_sep)

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user,4)
		return

	if (!isnum(desiredLvl))
		to_chat(user, span_danger("UpdateJobPreference - desired level was not a number. Please notify coders!"))
		ShowChoices(user,4)
		return

	var/jpval = null
	switch(desiredLvl)
		if(3)
			jpval = JP_LOW
		if(2)
			jpval = JP_MEDIUM
		if(1)
			jpval = JP_HIGH

	#ifdef USES_PQ
	if(job.required && !isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
		if(job_preferences[job.title] == JP_LOW)
			jpval = null
		else
			var/used_name = job.display_title || job.title
			if((pronouns == SHE_HER || pronouns == THEY_THEM_F) && job.f_title)
				used_name = "[job.f_title]"
			to_chat(user, "<font color='red'>You have too low PQ for [used_name] (Min PQ: [job.min_pq]), you may only set it to low.</font>")
			jpval = JP_LOW
	#endif

	SetJobPreferenceLevel(job, jpval)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()
	job_preferences = list()
	role_subclasses = list()
	role_loadout_selections = list()
	role_loadout_dye_selections = list()

/datum/preferences/proc/ResetLastClass(mob/user)
	if(user.client?.prefs)
		if(!user.client.prefs.lastclass)
			return
	var/choice = tgalert(user, "Use 2 Triumphs to play as this class again?", "Reset LastPlayed", "Do It", "Cancel")
	if(choice == "Cancel")
		return
	if(!choice)
		return
	if(user.client?.prefs)
		if(user.client.prefs.lastclass)
			if(user.get_triumphs() < 2)
				to_chat(user, span_warning("I haven't TRIUMPHED enough."))
				return
			user.adjust_triumphs(-2)
			user.client.prefs.lastclass = null
			user.client.prefs.save_preferences()

/datum/preferences/proc/SetKeybinds(mob/user)
	var/list/dat = list()
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)

	var/list/kb_categories = list()
	// Group keybinds by category
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

	dat += "<center><a href='?_src_=prefs;preference=keybinds;task=close'>Done</a></center><br>"
	for (var/category in kb_categories)
		for (var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			if(!length(user_binds[kb.name]))
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
//						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
//						if(LAZYLEN(default_keys))
//							dat += "| Default: [default_keys.Join(", ")]"
				dat += "<br>"
			else
				var/bound_key = user_binds[kb.name][1]
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				for(var/bound_key_index in 2 to length(user_binds[kb.name]))
					bound_key = user_binds[kb.name][bound_key_index]
					dat += " | <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
					dat += "| <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
				dat += "<br>"

	dat += "<br><br>"
	dat += "<a href ='?_src_=prefs;preference=keybinds;task=keybindings_reset'>\[Reset to default\]</a>"
	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "keybind_setup", "<div align='center'>Keybinds</div>", 600, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/SetAntag(mob/user)
	var/list/dat = list()

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

	dat += "<center><a href='?_src_=prefs;preference=antag;task=close'>Done</a></center><br>"


	if(is_banned_from(user.ckey, ROLE_SYNDICATE))
		dat += "<font color=red><b>I am banned from antagonist roles.</b></font><br>"
		src.be_special = list()


	for (var/i in GLOB.special_roles_rogue)
		if(is_banned_from(user.ckey, i))
			dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;bancheck=[i]'>BANNED</a><br>"
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
				days_remaining = get_remaining_days(user.client)

			if(days_remaining)
				dat += "<b>[capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
			else
				dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;preference=antag;task=be_special;be_special_type=[i]'>[(i in be_special) ? "Enabled" : "Disabled"]</a><br>"


	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "antag_setup", "<div align='center'>Special Role</div>", 250, 300) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)


/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["bancheck"])
		var/list/ban_details = is_banned_from_with_details(user.ckey, user.client.address, user.client.computer_id, href_list["bancheck"])
		var/admin = FALSE
		if(GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey])
			admin = TRUE
		for(var/i in ban_details)
			if(admin && !text2num(i["applies_to_admins"]))
				continue
			ban_details = i
			break //we only want to get the most recent ban's details
		if(ban_details && ban_details.len)
			var/expires = "This is a permanent ban."
			if(ban_details["expiration_time"])
				expires = " The ban is for [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)] and expires on [ban_details["expiration_time"]] (server time)."
			to_chat(user, span_danger("You, or another user of this computer or connection ([ban_details["key"]]) is banned from playing [href_list["bancheck"]].<br>The ban reason is: [ban_details["reason"]]<br>This ban (BanID #[ban_details["id"]]) was applied by [ban_details["admin_key"]] on [ban_details["bantime"]] during round ID [ban_details["round_id"]].<br>[expires]"))
			return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user,4)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("triumphthing")
				ResetLastClass(user)
			if("nojob")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("tutorial")
				if(href_list["tut"])
					testing("[href_list["tut"]]")
					to_chat(user, span_info("* ----------------------- *"))
					to_chat(user, href_list["tut"])
					to_chat(user, span_info("* ----------------------- *"))
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(is_banned_from(user.ckey, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BERANDOMJOB
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = BERANDOMJOB
				SetChoices(user)
			if("setJobLevel")
				if(SSticker.job_change_locked)
					return 1
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	else if(href_list["preference"] == "antag")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=antag_setup")
				ShowChoices(user)
			if("be_special")
				var/be_special_type = href_list["be_special_type"]
				if(be_special_type in be_special)
					be_special -= be_special_type
				else
					be_special += be_special_type
				SetAntag(user)
			if("update")
				SetAntag(user)
			else
				SetAntag(user)
	else if(href_list["preference"] == "tgui_ui_prefs")
		tgui_pref = !tgui_pref
	else if(href_list["preference"] == "triumphs")
		user.show_triumphs_list()

	else if(href_list["preference"] == "playerquality")
		check_pq_menu(user.ckey)

	else if(href_list["preference"] == "agevet")
		if(!user.check_agevet())
			to_chat(usr, span_info("- You are a whitelisted player with full access to the server's features. If you'd also like to show others that you've been <b>AGE-VERIFIED</b> with a censored ID, you can open a ticket in Azure Peak's <b>#vet-here</b> channel. Note that this is a purely optional process, and - besides awarding a special header for your flavortext - doesn't affect you in any other way."))
		else
			to_chat(usr, span_love("- You have been successfully <b>AGE-VERIFIED!</b>"))

	else if(href_list["preference"] == "culinary")
		show_culinary_ui(user)
		return
	else if(href_list["preference"] == "markings")
		ShowMarkings(user)
		return
	else if(href_list["preference"] == "descriptors")
		show_descriptors_ui(user)
		return

	else if(href_list["preference"] == "customizers")
		ShowCustomizers(user)
		return
	else if(href_list["preference"] == "triumph_buy_menu")
		SStriumphs.startup_triumphs_menu(user.client)

	else if(href_list["preference"] == "keybinds")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=keybind_setup")
				ShowChoices(user)
			if("update")
				SetKeybinds(user)
			if("keybindings_capture")
				var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
				var/old_key = href_list["old_key"]
				CaptureKeybinding(user, kb, old_key)
				return

			if("keybindings_set")
				var/kb_name = href_list["keybinding"]
				if(!kb_name)
					user << browse(null, "window=capturekeypress")
					SetKeybinds(user)
					return

				var/clear_key = text2num(href_list["clear_key"])
				var/old_key = href_list["old_key"]
				if(clear_key)
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					user << browse(null, "window=capturekeypress")
					save_preferences()
					SetKeybinds(user)
					return

				var/new_key = uppertext(href_list["key"])
				var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
				var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
				var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
				var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
				// var/key_code = text2num(href_list["key_code"])

				if(GLOB._kbMap[new_key])
					new_key = GLOB._kbMap[new_key]

				var/full_key
				switch(new_key)
					if("Alt")
						full_key = "[new_key][CtrlMod][ShiftMod]"
					if("Ctrl")
						full_key = "[AltMod][new_key][ShiftMod]"
					if("Shift")
						full_key = "[AltMod][CtrlMod][new_key]"
					else
						full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
				if(key_bindings[old_key])
					key_bindings[old_key] -= kb_name
					if(!length(key_bindings[old_key]))
						key_bindings -= old_key
				key_bindings[full_key] += list(kb_name)
				key_bindings[full_key] = sortList(key_bindings[full_key])

				user << browse(null, "window=capturekeypress")
				user.client.update_movement_keys()
				save_preferences()
				SetKeybinds(user)

			if("keybindings_reset")
				var/choice = tgalert(user, "Do you really want to reset your keybindings?", "Setup keybindings", "Do It", "Cancel")
				if(choice == "Cancel")
					ShowChoices(user,3)
					return
				hotkeys = (choice == "Do It")
				key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
				user.client.update_movement_keys()
				SetKeybinds(user)
			else
				SetKeybinds(user)
		return TRUE

	switch(href_list["task"])
		if("change_customizer")
			handle_customizer_topic(user, href_list)
			ShowChoices(user)
			ShowCustomizers(user)
			return
		if("change_marking")
			handle_body_markings_topic(user, href_list)
			ShowChoices(user)
			ShowMarkings(user)
			return
		if("change_descriptor")
			handle_descriptors_topic(user, href_list)
			show_descriptors_ui(user)
			return
		if("change_culinary_preferences")
			handle_culinary_topic(user, href_list)
			show_culinary_ui(user)
			return
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = pick(pref_species.possible_ages)
				if("eyes")
					eye_color = random_eye_color()
				if("s_tone")
					var/list/skins = pref_species.get_skin_list()
					skin_tone = skins[pick(skins)]
				if("species")
					random_species()
				if("bag")
					backpack = pick(GLOB.backpacklist)
				if("suit")
					jumpsuit_style = PREF_SUIT
				if("all")
					random_character(gender, FALSE, FALSE)

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])

			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = input(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_forms
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = input(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND", null) as null|anything in GLOB.ghost_orbits
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = tgui_input_text(user, "The name of this vessel?", "IDENTITY", encode = FALSE)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,.</font>")

				if("nickname")
					var/new_name = tgui_input_text(user, "Choose your character's nickname (For Highlighting):", "NICKNAME",  encode = FALSE)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							nickname = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,.</font>")

				if("subclassoutfit")
					var/list/choices = list("None")
					var/datum/job/highest_pref
					for(var/job in job_preferences)
						if(job_preferences[job] > highest_pref)
							highest_pref = SSjob.GetJob(job)
					if(isnull(highest_pref))
						to_chat(user, "<b>I don't have a Class set to High!</b>")
					if(length(highest_pref.job_subclasses))
						for(var/adv in highest_pref.job_subclasses)
							var/datum/advclass/advpath = adv
							var/datum/advclass/advref = SSrole_class_handler.get_advclass_by_name(initial(advpath.name))
							choices[advref.name] = advref
					if(length(choices))
						var/new_choice = input(user, "Choose an outfit preview:", "Outfit Preview")  as anything in choices|null
						if(new_choice && new_choice != "None")
							preview_subclass = choices[new_choice]
							update_preview_icon()
						else
							preview_subclass = null
							update_preview_icon(jobOnly = TRUE)

//				if("age")
//					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Years Dead") as num|null
//					if(new_age)
//						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("age")
					var/new_age = tgui_input_list(user, "Choose your character's age (18-[pref_species.max_age])", "YILS LIVED", pref_species.possible_ages)
					if(new_age)
						age = new_age
						var/list/hairs
						if((age == AGE_OLD) && (OLDGREY in pref_species.species_traits))
							hairs = pref_species.get_oldhc_list()
						else
							hairs = pref_species.get_hairc_list()
						hair_color = hairs[pick(hairs)]
						facial_hair_color = hair_color
						// LETHALSTONE EDIT: let players know what this shit does stats-wise
						switch (age)
							if (AGE_ADULT)
								to_chat(user, "You preside in your 'prime', whatever this may be, and gain no bonus nor endure any penalty for your time spent alive.")
							if (AGE_MIDDLEAGED)
								to_chat(user, "Muscles ache and joints begin to slow as Aeon's grasp begins to settle upon your shoulders. (-1 SPD, +1 WIL)")
							if (AGE_OLD)
								to_chat(user, "In a place as lethal as PSYDONIA, the elderly are all but marvels... or beneficiaries of the habitually privileged. (-1 STR, -2 SPE, -1 PER, -2 CON, +2 INT, +1 FOR)")
						// LETHALSTONE EDIT END
						ResetJobs()
						to_chat(user, "<font color='red'>Classes reset.</font>")

				// LETHALSTONE EDIT: add pronouns
				if ("pronouns")
					var pronouns_input = tgui_input_list(user, "Choose your character's pronouns", "PRONOUNS", GLOB.pronouns_list)
					if(pronouns_input)
						pronouns = pronouns_input
						ResetJobs()
						to_chat(user, "<font color='red'>Your character's pronouns are now [pronouns].</font>")
						to_chat(user, "<font color='red'><b>Your classes have been reset.</b></font>")

				// LETHALSTONE EDIT: add voice type selection
				if ("voicetype")
					var voicetype_input = tgui_input_list(user, "Choose your character's voice type", "VOICE TYPE", GLOB.voice_types_list)
					if(voicetype_input)
						voice_type = voicetype_input
						to_chat(user, "<font color='red'>Your character will now vocalize with a [lowertext(voice_type)] affect.</font>")

				if("taur_type")
					var/list/species_taur_list = pref_species.get_taur_list()
					if(!LAZYLEN(species_taur_list))
						taur_type = null
						to_chat(user, span_bad("There are no available taur bodies for this species."))
						return

					var/list/taur_selection
					if(pref_species.forced_taur)
						taur_selection = list()
					else
						taur_selection = list("None")

					for(var/obj/item/bodypart/taur/tt as anything in pref_species.get_taur_list())
						taur_selection[tt::name] = tt

					var/new_taur_type = tgui_input_list(user, "Choose your character's taur body", "TAUR BODY", taur_selection)
					if(!new_taur_type)
						return

					if(new_taur_type == "None")
						taur_type = null
					else
						taur_type = taur_selection[new_taur_type]

					var/obj/item/bodypart/taur/tt = taur_type
					to_chat(user, span_red("Your character now has [tt ? tt::name : "no taurtype."]."))

				if("faith")
					var/list/faiths_named = list()
					for(var/path as anything in GLOB.preference_faiths)
						var/datum/faith/faith = GLOB.faithlist[path]
						if(!faith.name)
							continue
						faiths_named[faith.name] = faith
					var/faith_input = tgui_input_list(user, "The world rots. Which truth you bear?", "FAITH", faiths_named)
					if(faith_input)
						var/datum/faith/faith = faiths_named[faith_input]
						to_chat(user, "<font color='yellow'>Faith: [faith.name]</font>")
						to_chat(user, "Background: [faith.desc]")
						to_chat(user, "<font color='red'>Likely Worshippers: [faith.worshippers]</font>")
						selected_patron = GLOB.patronlist[faith.godhead] || GLOB.patronlist[pick(GLOB.patrons_by_faith[faith_input])]

				if("patron")
					var/list/patrons_named = list()
					for(var/path as anything in GLOB.patrons_by_faith[selected_patron?.associated_faith || initial(default_patron.associated_faith)])
						var/datum/patron/patron = GLOB.patronlist[path]
						if(!patron.name)
							continue
						if(patron.disabled_patron)
							continue
						patrons_named[patron.name] = patron
					var/god_input = tgui_input_list(user, "The first amongst many.", "PATRON", patrons_named)
					if(god_input)
						selected_patron = patrons_named[god_input]
						to_chat(user, "<font color='yellow'>Patron: [selected_patron]</font>")
						to_chat(user, "<font color='#FFA500'>Domain: [selected_patron.domain]</font>")
						to_chat(user, "Background: [selected_patron.desc]")
						to_chat(user, "<font color='red'>Likely Worshippers: [selected_patron.worshippers]</font>")

				if("combat_music") // if u change shit here look at /client/verb/combat_music() too
					if(!combat_music_helptext_shown)
						to_chat(user, span_notice("<span class='bold'>Combat Music Override</span>\n") + \
						"Options other than \"Default\" override whatever the game dynamically sets for you, \
						which is influenced by your job class, villain status, or certain events.\n\
						You can change this later through \"Combat Mode Music\" in the Options tab.\"</span>")
						combat_music_helptext_shown = TRUE
					var/track_select = tgui_input_list(user, "To you, the Signal sounds like:", "COMBAT MUSIC", GLOB.cmode_tracks_by_name, combat_music?.name)
					if(track_select)
						combat_music = GLOB.cmode_tracks_by_name[track_select]
						to_chat(user, span_notice("Selected track: <b>[track_select]</b>."))
						if(combat_music.desc)
							to_chat(user, "<i>[combat_music.desc]</i>")
						if(combat_music.credits)
							to_chat(user, span_info("Song name: <b>[combat_music.credits]</b>"))

				if("bdetail")
					var/list/loly = list("Not yet.","Work in progress.","Don't click me.","Stop clicking this.","Nope.","Be patient.","Sooner or later.")
					to_chat(user, "<font color='red'>[pick(loly)]</font>")
					return

				if("voice")
					var/new_voice = input(user, "Choose your character's voice color:", "Character Preference","#"+voice_color) as color|null
					if(new_voice)
						if(color_hex2num(new_voice) < 230)
							to_chat(user, "<font color='red'>This voice color is too dark for mortals.</font>")
							return
						voice_color = sanitize_hexcolor(new_voice)

				if("extra_language")
					var/static/list/selectable_languages = list(
						/datum/language/elvish,
						/datum/language/dwarvish,
						/datum/language/orcish,
						/datum/language/hellspeak,
						/datum/language/draconic,
						/datum/language/celestial,
						/datum/language/canilunzt,
						/datum/language/grenzelhoftian,
						/datum/language/kazengunese,
						/datum/language/etruscan,
						/datum/language/gronnic,
						/datum/language/otavan,
						/datum/language/aavnic,
						/datum/language/merar
					)
					var/list/choices = list("None")
					for(var/language in selectable_languages)
						if(language in pref_species.languages)
							continue
						var/datum/language/a_language = new language()
						choices[a_language.name] = language

					var/chosen_language = tgui_input_list(user, "Choose your character's extra language:", "EXTRA LANGUAGE", choices)
					if(chosen_language)
						if(chosen_language == "None")
							extra_language = "None"
						else
							extra_language = choices[chosen_language]

				if("voice_pitch")
					var/new_voice_pitch = tgui_input_number(user, "Choose your character's voice pitch ([MIN_VOICE_PITCH] to [MAX_VOICE_PITCH], lower is deeper):", "Voice Pitch", 1, 1.35, 0.8, round_value = FALSE)
					if(new_voice_pitch)
						if(new_voice_pitch < MIN_VOICE_PITCH || new_voice_pitch > MAX_VOICE_PITCH)
							to_chat(user, "<font color='red'>Value must be between [MIN_VOICE_PITCH] and [MAX_VOICE_PITCH].</font>")
							return
						voice_pitch = new_voice_pitch

				if("barksound")
					var/list/woof_woof = list()
					for(var/path in GLOB.bark_list)
						var/datum/bark/B = GLOB.bark_list[path]
						if(initial(B.ignore))
							continue
						if(initial(B.ckeys_allowed))
							var/list/allowed = initial(B.ckeys_allowed)
							if(!allowed.Find(user.client.ckey))
								continue
						woof_woof[initial(B.name)] = initial(B.id)
					var/new_bork = input(user, "Choose your desired vocal bark", "Character Preference") as null|anything in woof_woof
					if(new_bork)
						bark_id = woof_woof[new_bork]
						var/datum/bark/B = GLOB.bark_list[bark_id] //Now we need sanitization to take into account bark-specific min/max values
						bark_speed = round(clamp(bark_speed, initial(B.minspeed), initial(B.maxspeed)), 1)
						bark_pitch = clamp(bark_pitch, initial(B.minpitch), initial(B.maxpitch))
						bark_variance = clamp(bark_variance, initial(B.minvariance), initial(B.maxvariance))

				if("barkspeed")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired bark speed (Higher is slower, lower is faster). Min: [initial(B.minspeed)]. Max: [initial(B.maxspeed)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_speed = round(clamp(borkset, initial(B.minspeed), initial(B.maxspeed)), 1)

				if("barkpitch")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired baseline bark pitch. Min: [initial(B.minpitch)]. Max: [initial(B.maxpitch)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_pitch = clamp(borkset, initial(B.minpitch), initial(B.maxpitch))

				if("barkvary")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired baseline bark pitch. Min: [initial(B.minvariance)]. Max: [initial(B.maxvariance)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_variance = clamp(borkset, initial(B.minvariance), initial(B.maxvariance))

				if("barkpreview")
					if(SSticker.current_state == GAME_STATE_STARTUP) //Timers don't tick at all during game startup, so let's just give an error message
						to_chat(user, "<span class='warning'>Bark previews can't play during initialization!</span>")
						return
					if(!COOLDOWN_FINISHED(src, bark_previewing))
						return
					if(!parent || !parent.mob)
						return
					COOLDOWN_START(src, bark_previewing, (5 SECONDS))
					var/atom/movable/barkbox = new(get_turf(parent.mob))
					barkbox.set_bark(bark_id)
					var/total_delay = 0
					for(var/i in 1 to (round((32 / bark_speed)) + 1))
						addtimer(CALLBACK(barkbox, TYPE_PROC_REF(/atom/movable, bark), list(parent.mob), 7, 70, BARK_DO_VARY(bark_pitch, bark_variance)), total_delay)
						total_delay += rand(DS2TICKS(bark_speed/4), DS2TICKS(bark_speed/4) + DS2TICKS(bark_speed/4)) TICKS
					QDEL_IN(barkbox, total_delay)

				if("highlight_color")
					var/new_color = color_pick_sanitized(user, "Choose your character's nickname highlight color:", "Character Preference","#"+highlight_color)
					if(new_color)
						highlight_color = sanitize_hexcolor(new_color)

				if("headshot")
					to_chat(user, "<span class='notice'>Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
					to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
					to_chat(user, "<span class='notice'>Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look.</span>")
					var/new_headshot_link = tgui_input_text(user, "Input the headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Headshot", headshot_link,  encode = FALSE)
					if(new_headshot_link == null)
						return
					if(new_headshot_link == "")
						headshot_link = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_headshot_link))
						headshot_link = null
						ShowChoices(user)
						return
					headshot_link = new_headshot_link
					to_chat(user, "<span class='notice'>Successfully updated headshot picture</span>")
					log_game("[user] has set their Headshot image to '[headshot_link]'.")
				if("legacyhelp")
					var/list/dat = list()
					dat += "This slot was around since before major Flavortext / OOC changes.<br>"
					dat += "Due to this, it's been grandfathered in to keep its old profile layout and formatting, including html.<br>"
					dat += "If you wish to keep it as it is, <b>you cannot edit it anymore.</b><br><br>"
					dat += "ANY edit (Even pressing OK on an unchanged Flavortext / OOC notes) will <font color ='red'><b>irreversibly</b></font> override all html, and remove the legacy status of the slot.<br>"
					dat += "There are no exceptions. Have fun!"
					dat += "(You can still add an OOC Extra)"
					var/datum/browser/popup = new(user, "Legacy Help", nwidth = 450, nheight = 250)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("formathelp")
					var/list/dat = list()
					dat +="You can use backslash (\\) to escape special characters.<br>"
					dat += "<br>"
					dat += "# text : Defines a header.<br>"
					dat += "|text| : Centers the text.<br>"
					dat += "**text** : Makes the text <b>bold</b>.<br>"
					dat += "*text* : Makes the text <i>italic</i>.<br>"
					dat += "^text^ : Increases the <font size = \"4\">size</font> of the text.<br>"
					dat += "((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>"
					dat += "* item : An unordered list item.<br>"
					dat += "--- : Adds a horizontal rule.<br>"
					dat += "-=FFFFFFtext=- : Adds a specific <font color = '#FFFFFF'>colour</font> to text.<br><br>"
					dat += "Minimum Flavortext: <b>[MINIMUM_FLAVOR_TEXT]</b> characters.<br>"
					dat += "Minimum OOC Notes: <b>[MINIMUM_OOC_NOTES]</b> characters."
					var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 350)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("skin_color_ref_list")
					var/list/dat = list()
					dat +="Skin color codes reference list<br>"
					dat += "<br>"
					for(var/tone in pref_species.get_skin_list_tooltip())
						dat += "[tone]<br>"
					var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 450)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("flavortext")
					to_chat(user, "<span class='notice'>["<span class='bold'>Flavortext should not include nonphysical nonsensory attributes such as backstory or the character's internal thoughts.</span>"]</span>")
					var/new_flavortext = tgui_input_text(user, "Input your character description:", "Flavortext", flavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_flavortext == null)
						return
					if(new_flavortext == "")
						flavortext = null
						ShowChoices(user)
						return
					flavortext = new_flavortext
					to_chat(user, "<span class='notice'>Successfully updated flavortext</span>")
					log_game("[user] has set their flavortext'.")
				if("ooc_notes")
					to_chat(user, "<span class='notice'>["<span class='bold'>OOC notes should be used for roleplay hooks and general information about your character.</span>"]</span>")
					var/new_ooc_notes = tgui_input_text(user, "Input your OOC preferences:", "OOC notes", ooc_notes, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_ooc_notes == null)
						return
					if(new_ooc_notes == "")
						ooc_notes = null
						ShowChoices(user)
						return
					ooc_notes = new_ooc_notes
					to_chat(user, "<span class='notice'>Successfully updated OOC notes.</span>")
					log_game("[user] has set their OOC notes'.")
				if("nsfwflavortext")
					to_chat(user, "<span class='notice'>["<span class='bold'>NSFW Flavortext can be used for setting things like body descriptions and other physical details that may be conisdered explicit.</span>"]</span>")
					to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear.</font>")
					var/new_nsfwflavortext = tgui_input_text(user, "Input your character description:", "NSFW Flavortext", nsfwflavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_nsfwflavortext == null)
						return
					if(new_nsfwflavortext == "")
						new_nsfwflavortext = null
						nsfwflavortext = null
						to_chat(user, "<span class='notice'>Successfully deleted NSFW Flavor Text.</span>")
						ShowChoices(user)
						return
					nsfwflavortext = new_nsfwflavortext
					to_chat(user, "<span class='notice'>Successfully updated NSFW flavortext</span>")
					log_game("[user] has set their NSFW flavortext'.")
				if("erpprefs")
					to_chat(user, "<span class='notice'>["<span class='bold'>Erotic Roleplay preferences. If you put 'anything goes' or 'no limits' here, do not be surprised if people take you up on it.</span>"]</span>")
					to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear.</font>")
					var/new_erpprefs = tgui_input_text(user, "Input your preferences:", "ERP Preferences", erpprefs, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_erpprefs == null)
						return
					if(new_erpprefs == "")
						new_erpprefs = null
						erpprefs = null
						to_chat(user, "<span class='notice'>Successfully deleted ERP preferences.</span>")
						ShowChoices(user)
						return
					erpprefs = new_erpprefs
					to_chat(user, "<span class='notice'>Successfully updated ERP Preferences.</span>")
					log_game("[user] has set their ERP preferences'.")

				if("img_gallery")

					if(img_gallery.len >= 3)
						to_chat(user, "You already have three images in your gallery!")
						return

					to_chat(user, "<span class='notice'>Please use an image ["<span class='bold'>of your character</span>"] to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
					to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
					to_chat(user, "<span class='notice'>Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best.</span>")
					to_chat(user, "<span class='notice'>You can only have a maximum of ["<span class='bold'>THREE IMAGES</span>"] in your gallery at a time.</span>")

					var/new_galleryimg = tgui_input_text(user, "Input the image link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Gallery Image",  encode = FALSE)

					if(new_galleryimg == null)
						return
					if(new_galleryimg == "")
						new_galleryimg = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_galleryimg))
						to_chat(user, "<span class='notice'>Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox).</span>")
						new_galleryimg = null
						ShowChoices(user)
						return
					img_gallery += new_galleryimg
					to_chat(user, "<span class='notice'>Successfully added image to gallery.</span>")
					log_game("[user] has added an image to their gallery: '[new_galleryimg]'.")

				if("nsfw_img_gallery")

					if(nsfw_img_gallery.len >= 3)
						to_chat(user, "You already have three images in your gallery!")
						return

					to_chat(user, "<span class='notice'>Please use an image ["<span class='bold'>of your character</span>"] to maintain immersion level. Lastly, ["<span class='bold'>do not use a real life photo or use any image that is less than serious.</span>"]</span>")
					to_chat(user, "<span class='notice'>If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser.</span>")
					to_chat(user, "<span class='notice'>Keep in mind that all three images are displayed next to eachother and justified to fill a horizontal rectangle. As such, vertical images work best.</span>")
					to_chat(user, "<span class='notice'>You can only have a maximum of ["<span class='bold'>THREE IMAGES</span>"] in your gallery at a time.</span>")

					var/new_galleryimg = tgui_input_text(user, "Input the image link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Gallery Image",  encode = FALSE)

					if(new_galleryimg == null)
						return
					if(new_galleryimg == "")
						new_galleryimg = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_galleryimg))
						to_chat(user, "<span class='notice'>Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox).</span>")
						new_galleryimg = null
						ShowChoices(user)
						return
					nsfw_img_gallery += new_galleryimg
					to_chat(user, "<span class='notice'>Successfully added image to nsfw gallery.</span>")
					log_game("[user] has added an image to their nsfw gallery: '[new_galleryimg]'.")

				if("clear_gallery")
					if(!img_gallery.len)
						to_chat(user, "You don't have any images in your gallery to clear!")
						return
					var/dachoice = tgui_alert(user, "Do you really want to clear your image gallery?", "Clear Gallery", list("Yae", "Nae"))
					if(dachoice == "Nae")
						ShowChoices(user)
						return
					img_gallery = list()
					to_chat(user, "<span class='notice'>Successfully cleared image gallery.</span>")
					log_game("[user] has cleared their image gallery.")

				if("clear_nsfw_gallery")
					if(!nsfw_img_gallery.len)
						to_chat(user, "You don't have any images in your nsfw gallery to clear!")
						return
					var/dachoice = tgui_alert(user, "Do you really want to clear your nsfw image gallery?", "Clear nsfw Gallery", list("Yae", "Nae"))
					if(dachoice == "Nae")
						ShowChoices(user)
						return
					nsfw_img_gallery = list()
					to_chat(user, "<span class='notice'>Successfully cleared their nsfw image gallery.</span>")
					log_game("[user] has cleared their nsfw image gallery.")

				if("ooc_preview")
					var/datum/examine_panel/preview_examine_panel = new(user)
					preview_examine_panel.pref = src
					preview_examine_panel.holder = user
					preview_examine_panel.viewing = user
					preview_examine_panel.ui_interact(user)

				if("ooc_extra")
					to_chat(user, "<span class='notice'>Add a link from a suitable host (catbox, etc) to an mp3 to embed in your flavor text.</span>")
					to_chat(user, "<span class='notice'>If the song doesn't  play properly, ensure that it's a direct link that opens properly in a browser.</span>")
					to_chat(user, "<font color = '#d6d6d6'>Leave blank to clear your current song.</font>")
					to_chat(user, "<font color ='red'>Abuse of this will get you banned.</font>")
					var/new_extra_link = tgui_input_text(user, "Input the accessory link (https, hosts: discord, catbox):", "Song URL", ooc_extra, encode = FALSE)
					if(new_extra_link == null)
						return
					if(new_extra_link == "")
						new_extra_link = null
						ooc_extra = null
						to_chat(user, "<span class='notice'>Successfully deleted OOC Extra.</span>")
						ShowChoices(user)
						return
					var/static/list/valid_extensions = list("mp3")
					if(!valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
						new_extra_link = null
						ShowChoices(user)
						return

					var/list/value_split = splittext(new_extra_link, ".")

					// extension will always be the last entry
					var/extension = value_split[length(value_split)]
					if((extension in valid_extensions))
						ooc_extra = new_extra_link
						to_chat(user, "<span class='notice'>Successfully updated Song URL.</span>")
						log_game("[user] has set their Song URL to '[ooc_extra]'.")

				if("change_artist")
					var/new_artist = tgui_input_text(user, "Input your song's artist:", "Song Artist", song_artist,  encode = FALSE)
					if(new_artist == null)
						return
					if(new_artist == "")
						ShowChoices(user)
						return
					song_artist = new_artist
					to_chat(user, "<span class='notice'>Successfully updated song artist.</span>")
					log_game("[user] has set their song artist.")

				if("change_title")
					var/new_title = tgui_input_text(user, "Input your song's title:", "Song title", song_title,  encode = FALSE)
					if(new_title== null)
						return
					if(new_title == "")
						ShowChoices(user)
						return
					song_title = new_title
					to_chat(user, "<span class='notice'>Successfully updated song title.</span>")
					log_game("[user] has set their song title.")

				if("familiar_prefs")
					familiar_prefs.fam_show_ui()

				if("loadout_item")
					var/list/loadouts_available = list("None")
					for (var/path as anything in GLOB.loadout_items)
						var/datum/loadout_item/loadout = GLOB.loadout_items[path]
						var/donoritem = loadout.donoritem
						if(donoritem && !loadout.donator_ckey_check(user.ckey))
							continue
						if (!loadout.name)
							continue
						loadouts_available[loadout.name] = loadout

					var/loadout_input = tgui_input_list(user, "Choose your character's loadout item. RMB a tree, statue or clock to collect. I cannot stress this enough. YOU DON'T SPAWN WITH THESE. YOU HAVE TO MANUALLY PICK THEM UP!!", "LOADOUT THAT YOU GET FROM A TREE OR STATUE OR CLOCK", loadouts_available)
					if(loadout_input)
						if(loadout_input == "None")
							loadout = null
							to_chat(user, "Who needs stuff anyway?")
						else
							loadout = loadouts_available[loadout_input]
							to_chat(user, "<font color='yellow'><b>[loadout.name]</b></font>")
							if(loadout.desc)
								to_chat(user, "[loadout.desc]")
				if("loadout_item2")
					var/list/loadouts_available = list("None")
					for (var/path as anything in GLOB.loadout_items)
						var/datum/loadout_item/loadout2 = GLOB.loadout_items[path]
						var/donoritem = loadout2.donoritem
						if(donoritem && !loadout2.donator_ckey_check(user.ckey))
							continue
						if (!loadout2.name)
							continue
						loadouts_available[loadout2.name] = loadout2

					var/loadout_input2 = tgui_input_list(user, "Choose your character's loadout item. RMB a tree, statue or clock to collect. I cannot stress this enough. YOU DON'T SPAWN WITH THESE. YOU HAVE TO MANUALLY PICK THEM UP!!", "LOADOUT THAT YOU GET FROM A TREE OR STATUE OR CLOCK", loadouts_available)
					if(loadout_input2)
						if(loadout_input2 == "None")
							loadout2 = null
							to_chat(user, "Who needs stuff anyway?")
						else
							loadout2 = loadouts_available[loadout_input2]
							to_chat(user, "<font color='yellow'><b>[loadout2.name]</b></font>")
							if(loadout2.desc)
								to_chat(user, "[loadout2.desc]")
				if("loadout_item3")
					var/list/loadouts_available = list("None")
					for (var/path as anything in GLOB.loadout_items)
						var/datum/loadout_item/loadout3 = GLOB.loadout_items[path]
						var/donoritem = loadout3.donoritem
						if(donoritem && !loadout3.donator_ckey_check(user.ckey))
							continue
						if (!loadout3.name)
							continue
						loadouts_available[loadout3.name] = loadout3

					var/loadout_input3 = tgui_input_list(user, "Choose your character's loadout item. RMB a tree, statue or clock to collect. I cannot stress this enough. YOU DON'T SPAWN WITH THESE. YOU HAVE TO MANUALLY PICK THEM UP!!", "LOADOUT THAT YOU GET FROM A TREE OR STATUE OR CLOCK", loadouts_available)
					if(loadout_input3)
						if(loadout_input3 == "None")
							loadout3 = null
							to_chat(user, "Who needs stuff anyway?")
						else
							loadout3 = loadouts_available[loadout_input3]
							to_chat(user, "<font color='yellow'><b>[loadout3.name]</b></font>")
							if(loadout3.desc)
								to_chat(user, "[loadout3.desc]")
				if("loadout1hex")
					var/choice = input(user, "Choose a color.", "Loadout Item One Colour") as null|anything in GLOB.colorlist
					if (choice && GLOB.colorlist[choice])
						loadout_1_hex = GLOB.colorlist[choice]
						if (loadout)
							to_chat(user, "The colour for your [loadout::name] has been set to <b>[choice]</b>.")
					else
						loadout_1_hex = null
						to_chat(user, "The colour for your <b>first</b> loadout item has been cleared.")
				if("loadout2hex")
					var/choice = input(user, "Choose a color.", "Loadout Item Two Colour") as null|anything in GLOB.colorlist
					if (choice && GLOB.colorlist[choice])
						loadout_2_hex = GLOB.colorlist[choice]
						if (loadout2)
							to_chat(user, "The colour for your [loadout2::name] has been set to <b>[choice]</b>.")
					else
						loadout_2_hex = null
						to_chat(user, "The colour for your <b>second</b> loadout item has been cleared.")
				if("loadout3hex")
					var/choice = input(user, "Choose a color.", "Loadout Item Three Colour") as null|anything in GLOB.colorlist
					if (choice && GLOB.colorlist[choice])
						loadout_3_hex = GLOB.colorlist[choice]
						if (loadout3)
							to_chat(user, "The colour for your [loadout3::name] has been set to <b>[choice]</b>.")
					else
						loadout_3_hex = null
						to_chat(user, "The colour for your <b>third</b> loadout item has been cleared.")

				if("species")
					var/list/species = list()
					// get_selectable_species() lazily populates GLOB.roundstart_races
					// the first time it's called - reading GLOB.roundstart_races
					// directly here could hand back an empty list (and thus an
					// empty/never-opening selector) if nothing else has triggered
					// that population yet.
					for(var/A in get_selectable_species())
						var/datum/species/race = GLOB.species_list[A]
						race = new race()
						if(user.client)
							if(race.patreon_req > user.client.patreonlevel())
								continue
						else
							continue
						species += race

					species = sortNames(species)

					var/result = tgui_input_list(user, "By what shape are you bound?", "RACE", species)

					if(result)
						set_new_race(result, user)

				if("update_mutant_colors")
					update_mutant_colors = !update_mutant_colors

				if("dnr")
					dnr_pref = !dnr_pref

				if("virtue")
					var/list/virtue_choices = list()
					for (var/path as anything in GLOB.virtues)
						var/datum/virtue/V = GLOB.virtues[path]
						if (!V.name)
							continue
						if ((V.name == virtue.name || V.name == virtuetwo.name) && !istype(V, /datum/virtue/none))
							continue
						if (istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
							continue
						if(length(pref_species.restricted_virtues) && (V.type in pref_species.restricted_virtues))
							continue
						virtue_choices[V.name] = V
					virtue_choices = sort_list(virtue_choices)
					var/result = tgui_input_list(user, "What strength shall you wield?", "VIRTUES",virtue_choices)

					if (result)
						var/datum/virtue/virtue_chosen = virtue_choices[result]
						virtue = virtue_chosen
						to_chat(user, process_virtue_text(virtue_chosen))

				if("virtuetwo")
					var/list/virtue_choices = list()
					for (var/path as anything in GLOB.virtues)
						var/datum/virtue/V = GLOB.virtues[path]
						if (!V.name)
							continue
						if ((V.name == virtue.name || V.name == virtuetwo.name) && !istype(V, /datum/virtue/none))
							continue
						if(length(pref_species.restricted_virtues) && (V.type in pref_species.restricted_virtues))
							continue
						if (istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
							continue
						virtue_choices[V.name] = V
					virtue_choices = sort_list(virtue_choices)
					var/result = tgui_input_list(user, "What strength shall you wield?", "VIRTUES",virtue_choices)

					if (result)
						var/datum/virtue/virtue_chosen = virtue_choices[result]
						virtuetwo = virtue_chosen
						to_chat(user, process_virtue_text(virtue_chosen))
					/*	if (statpack.type != /datum/statpack/wildcard/virtuous)
							statpack = new /datum/statpack/wildcard/virtuous
							to_chat(user, span_purple("Your statpack has been set to virtuous (no stats) due to selecting a virtue.")) */

				if("charflaw")
					var/list/coom = GLOB.character_flaws.Copy()
					var/result = tgui_input_list(user, "What burden will you bear?", "FLAWS",coom)
					if(result)
						result = coom[result]
						var/datum/charflaw/C = new result()
						charflaw = C
						if(charflaw.desc)
							to_chat(user, "<span class='info'>[charflaw.desc]</span>")

				if("race_bonus_select")
					if(length(pref_species.custom_selection))
						var/choice = tgui_input_list(user, "What has fate blessed your race with?", "BONUS", pref_species.custom_selection)
						if(choice)
							race_bonus = pref_species.custom_selection[choice]

				if("body_size")
					var/new_body_size = tgui_input_number(user, "Choose your desired sprite size:\n([BODY_SIZE_MIN*100]%-[BODY_SIZE_MAX*100]%), Warning: May make your character look distorted", "Character Preference", features["body_size"]*100)
					if(new_body_size)
						new_body_size = clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX)
						features["body_size"] = new_body_size

				if("taur_color")
					var/new_taur_color = color_pick_sanitized(user, "Choose your character's taur color:", "Character Preference", "#"+taur_color)
					if(new_taur_color)
						taur_color = sanitize_hexcolor(new_taur_color)

				if("taur_markings")
					var/new_taur_markings = color_pick_sanitized(user, "Choose your character's taur markings color:", "Character Preference", "#"+taur_markings)
					if(new_taur_markings)
						taur_markings = sanitize_hexcolor(new_taur_markings)

				if("taur_tertiary")
					var/new_taur_tertiary = color_pick_sanitized(user, "Choose your character's taur tertiary markings color:", "Character Preference", "#"+taur_tertiary)
					if(new_taur_tertiary)
						taur_tertiary = sanitize_hexcolor(new_taur_tertiary)

				if("mutant_color")
					var/new_mutantcolor = color_pick_sanitized(user, "Choose your character's mutant #1 color:", "Character Preference","#"+features["mcolor"])
					if(new_mutantcolor)

						features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("mutant_color2")
					var/new_mutantcolor = color_pick_sanitized(user, "Choose your character's mutant #2 color:", "Character Preference","#"+features["mcolor2"])
					if(new_mutantcolor)
						features["mcolor2"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("mutant_color3")
					var/new_mutantcolor = color_pick_sanitized(user, "Choose your character's mutant #3 color:", "Character Preference","#"+features["mcolor3"])
					if(new_mutantcolor)
						features["mcolor3"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("skin_choice_pick")
					var/prompt = alert(user, "Choose skin/scales color",, "Custom", "Predefined")
					if(prompt == "Custom")
						var/new_mutantcolor = color_pick_sanitized(user, "Choose your character's skin/scale color:", "Character Preference","#"+features["mcolor"])
						if(new_mutantcolor)
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
							try_update_mutant_colors()
					if(prompt == "Predefined")
						var/listy = pref_species.get_skin_list()
						var/new_mutantcolor = input(user, "Choose your character's skin tone:", "Sun")  as null|anything in listy
						if(new_mutantcolor)
							features["mcolor"] = listy[new_mutantcolor]
							try_update_mutant_colors()

/*
				if("color_ethereal")
					var/new_etherealcolor = input(user, "Choose your ethereal color", "Character Preference") as null|anything in GLOB.color_list_ethereal
					if(new_etherealcolor)
						features["ethcolor"] = GLOB.color_list_ethereal[new_etherealcolor]

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs
*/
				if("s_tone")
					var/listy = pref_species.get_skin_list()
					var/new_s_tone = tgui_input_list(user, "Choose your character's skin tone:", "SKINTONE", listy)
					if(new_s_tone)
						skin_tone = listy[new_s_tone]
						try_update_mutant_colors()

				if("charflaw")
					var/selectedflaw
					selectedflaw = tgui_input_list(user, "Choose your character's flaw:", "FLAWS", GLOB.character_flaws)
					if(selectedflaw)
						charflaw = GLOB.character_flaws[selectedflaw]
						charflaw = new charflaw()
						if(charflaw.desc)
							to_chat(user, span_info("[charflaw.desc]"))

				if("char_accent")
					var/selectedaccent = tgui_input_list(user, "Choose your character's accent:", "Character Preference", GLOB.character_accents)
					if(selectedaccent)
						char_accent = selectedaccent

				if("ooccolor")
					var/new_ooccolor = color_pick_sanitized(user, "Choose your OOC colour:", "Game Preference",ooccolor)
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("asaycolor")
					var/new_asaycolor = color_pick_sanitized(user, "Choose your ASAY color:", "Game Preference",asaycolor)
					if(new_asaycolor)
						asaycolor = new_asaycolor

				if("bag")
					var/new_backpack = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in GLOB.backpacklist
					if(new_backpack)
						backpack = new_backpack

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SUIT
					else
						jumpsuit_style = PREF_SUIT

				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("ai_core_icon")
					var/ai_core_icon = input(user, "Choose your preferred AI core display screen:", "AI Core Display Screen Selection") as null|anything in GLOB.ai_core_display_screens
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = input(user, "Choose your preferred security department:", "Security Departments") as null|anything in GLOB.security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						if(!VM.votable)
							continue
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = input(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference")  as null|anything in sortList(maplist)
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps. (0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						parent.fps = desiredfps
				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference", UI_style)  as null|anything in sortList(GLOB.available_ui_styles)
					if(pickedui)
						UI_style = "Rogue"
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))
				if("pda_style")
					var/pickedPDAStyle = input(user, "Choose your PDA style.", "Character Preference", pda_style)  as null|anything in GLOB.pda_styles
					if(pickedPDAStyle)
						pda_style = pickedPDAStyle
				if("pda_color")
					var/pickedPDAColor = input(user, "Choose your PDA Interface color.", "Character Preference", pda_color) as color|null
					if(pickedPDAColor)
						pda_color = pickedPDAColor

				if("phobia")
					var/phobiaType = input(user, "What are you scared of?", "Character Preference", phobia) as null|anything in SStraumas.phobia_types
					if(phobiaType)
						phobia = phobiaType

		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Character Preference", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)
				if("gender")
					var/pickedGender = "male"
					if(gender == "male")
						pickedGender = "female"
					if(pickedGender && pickedGender != gender)
						gender = pickedGender
						to_chat(user, "<font color='red'>Your character will now use a [friendlyGenders[pickedGender]] sprite.</font>")
						//random_character(gender)
					genderize_customizer_entries()
				if("domhand")
					if(domhand == 1)
						domhand = 2
					else
						domhand = 1
				if("family")
					var/list/loly = list("Not yet.","Work in progress.","Don't click me.","Stop clicking this.","Nope.","Be patient.","Sooner or later.")
					to_chat(user, "<font color='red'>[pick(loly)]</font>")
					return
				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED]  input.text-color = #EEEEEE")
					else
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_DISABLED]  input.text-color = #ad9eb4")

				if("keybindings_capture")
					var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
					var/old_key = href_list["old_key"]
					CaptureKeybinding(user, kb, old_key)
					return

				if("keybindings_set")
					var/kb_name = href_list["keybinding"]
					if(!kb_name)
						user << browse(null, "window=capturekeypress")
						ShowChoices(user, 3)
						return

					var/clear_key = text2num(href_list["clear_key"])
					var/old_key = href_list["old_key"]
					if(clear_key)
						if(key_bindings[old_key])
							key_bindings[old_key] -= kb_name
							if(!length(key_bindings[old_key]))
								key_bindings -= old_key
						user << browse(null, "window=capturekeypress")
						save_preferences()
						ShowChoices(user, 3)
						return

					var/new_key = uppertext(href_list["key"])
					var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
					var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
					var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
					var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
					// var/key_code = text2num(href_list["key_code"])

					if(GLOB._kbMap[new_key])
						new_key = GLOB._kbMap[new_key]

					var/full_key
					switch(new_key)
						if("Alt")
							full_key = "[new_key][CtrlMod][ShiftMod]"
						if("Ctrl")
							full_key = "[AltMod][new_key][ShiftMod]"
						if("Shift")
							full_key = "[AltMod][CtrlMod][new_key]"
						else
							full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					key_bindings[full_key] += list(kb_name)
					key_bindings[full_key] = sortList(key_bindings[full_key])

					user << browse(null, "window=capturekeypress")
					user.client.update_movement_keys()
					save_preferences()

				if("keybindings_reset")
					var/choice = tgalert(user, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", "Hotkey", "Classic", "Cancel")
					if(choice == "Cancel")
						ShowChoices(user)
						return
					hotkeys = (choice == "Hotkey")
					key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
					user.client.update_movement_keys()
				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("tgui_theme")
					setTguiStyle()
				if("winflash")
					windowflashing = !windowflashing

				//here lies the badmins
				if("hear_adminhelps")
					user.client.toggleadminhelpsound()
				if("hear_prayers")
					user.client.toggle_prayer_sound()
				if("announce_login")
					user.client.toggleannouncelogin()
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("toggle_radio_chatter")
					user.client.toggle_hear_radio()
				if("toggle_prayers")
					user.client.toggleprayers()
				if("toggle_deadmin_always")
					toggles ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					toggles ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					toggles ^= DEADMIN_POSITION_HEAD


				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("toggle_random")
					var/random_type = href_list["random_type"]
					if(randomise[random_type])
						randomise -= random_type
					else
						randomise[random_type] = TRUE

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(parent && parent.screen && parent.screen.len)
						var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_above) in parent.screen
						PM.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.change_view(CONFIG_GET(string/default_view))

				if("schizo_voice")
					toggles ^= SCHIZO_VOICE
					if(toggles & SCHIZO_VOICE)
						to_chat(user, "<span class='warning'>You are now a voice.\n\
										As a voice, you will receive meditations from players asking about game mechanics!\n\
										Good voices will be rewarded with PQ for answering meditations, while bad ones are punished at the discretion of The Management.</span>")
					else
						to_chat(user, span_warning("You are no longer a voice."))

				if("migrants")
					migrant.show_ui()
					return

				if("manifest")
					parent.view_actors_manifest()
					return

				if("observe")
					var/mob/dead/new_player/P = user
					P.make_me_an_observer()
					return

				if("finished")
					user << browse(null, "window=latechoices") //closes late choices window
					user << browse(null, "window=playersetup") //closes the player setup window
					user << browse(null, "window=preferences") //closes job selection
					user << browse(null, "window=mob_occupation")
					user << browse(null, "window=latechoices") //closes late job selection
					user << browse(null, "window=migration") // Closes migrant menu

					SStriumphs.remove_triumph_buy_menu(user.client)

					winshow(user, "preferencess_window", FALSE)
					user << browse(null, "window=preferences_browser")
					user << browse(null, "window=lobby_window")
					return

				if("save")
					save_preferences()
					save_character()
					to_chat(user, span_notice("CHARACTER SAVED."))

				if("load")
					load_preferences()
					load_character()

				if("changeslot")
					var/list/choices = list()
					if(path)
						var/savefile/S = new /savefile(path)
						if(S)
							for(var/i=1, i<=max_save_slots, i++)
								var/name
								S.cd = "/character[i]"
								S["real_name"] >> name
								if(!name)
									name = "Slot [i]"
								choices[name] = i
					var/choice = tgui_input_list(user, "CHOOSE A HERO","ROGUETOWN", choices)
					if(choice)
						choice = choices[choice]
						if(!load_character(choice))
							random_character(null, FALSE, FALSE)
							save_character()

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

	ShowChoices(user)
	return 1

/datum/preferences/proc/resolve_loadout_to_color(item_path)
	for(var/i = 1 to 10)
		var/datum/loadout_item/slot_item = vars[i == 1 ? "loadout" : "loadout[i]"]
		var/hex = vars["loadout_[i]_hex"]
		if(slot_item && (item_path == slot_item.path) && hex)
			return hex

	return FALSE

/datum/preferences/proc/resolve_loadout_to_name(item_path)
	for(var/i = 1 to 10)
		var/datum/loadout_item/slot_item = vars[i == 1 ? "loadout" : "loadout[i]"]
		var/custom_name = vars["loadout_[i]_name"]
		if(slot_item && (item_path == slot_item.path) && custom_name)
			return custom_name

	return FALSE

/datum/preferences/proc/resolve_loadout_to_desc(item_path)
	for(var/i = 1 to 10)
		var/datum/loadout_item/slot_item = vars[i == 1 ? "loadout" : "loadout[i]"]
		var/custom_desc = vars["loadout_[i]_desc"]
		if(slot_item && (item_path == slot_item.path) && custom_desc)
			return custom_desc

	return FALSE

/// Returns the shared triumph-based point pool used by the loadout and language customization menus.
/datum/preferences/proc/get_total_points()
	if(!parent || !parent.ckey)
		return 0
	return SStriumphs.get_triumphs(parent.ckey)

/// Returns the total number of points currently spent across all 10 loadout slots.
/datum/preferences/proc/get_loadout_points_spent()
	var/spent_points = 0
	for(var/i = 1 to 10)
		var/datum/loadout_item/slot_item = vars[i == 1 ? "loadout" : "loadout[i]"]
		if(slot_item && slot_item.triumph_cost)
			spent_points += slot_item.triumph_cost
	return spent_points

/// Returns the roguehud icon file, adjusted for the player's chosen colorblind palette.
/datum/preferences/proc/get_roguehud_icon()
	return roguehud_icon_for_palette(hud_colorblind_palette)

/// Returns the rogueheat icon file, adjusted for the player's chosen colorblind palette.
/datum/preferences/proc/get_rogueheat_icon()
	return rogueheat_icon_for_palette(hud_colorblind_palette)

/// Sets the player's colorblind HUD palette, validating the supplied value first.
/datum/preferences/proc/set_hud_colorblind_palette(palette)
	if(!is_hud_colorblind_palette(palette))
		return FALSE
	hud_colorblind_palette = palette
	return TRUE

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, skip_normal_prefs = FALSE)
	if(randomise[RANDOM_SPECIES] && !character_setup && !skip_normal_prefs)
		random_species()

	if((randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG] && antagonist) && !character_setup && !skip_normal_prefs)
		slot_randomized = TRUE
		random_character(null, antagonist)

	// Bandaid to undo no arm flaw prosthesis
	if(charflaw)
		var/obj/item/bodypart/O = character.get_bodypart(BODY_ZONE_R_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		O = character.get_bodypart(BODY_ZONE_L_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		character.regenerate_limb(BODY_ZONE_R_ARM)
		character.regenerate_limb(BODY_ZONE_L_ARM)

	var/datum/species/chosen_species
	chosen_species = pref_species.type
	// Only reset species to default if invalid AND not during character setup/preview generation
	if(!(pref_species.name in GLOB.roundstart_races) && !character_setup)
		set_new_race(new /datum/species/human/northern)

		random_character(null, FALSE, FALSE)
	if(parent && !character_setup)
		if(pref_species.patreon_req > parent.patreonlevel())
			set_new_race(new /datum/species/human/northern)
			random_character(null, FALSE, FALSE)

	character.age = age
	character.dna.features = features.Copy()
	character.gender = gender
	character.set_species(chosen_species, icon_update = FALSE, pref_load = src)
	character.dna.update_body_size()

	if((randomise[RANDOM_NAME] || randomise[RANDOM_NAME_ANTAG] && antagonist) && !character_setup)
		slot_randomized = TRUE
		real_name = pref_species.random_name(gender)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && ((pref_species.id == "human") || (pref_species.id == "humen")))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	if(real_name in GLOB.chosen_names)
		character.real_name = pref_species.random_name(gender)
	else
		character.real_name = real_name
	character.name = character.real_name

	character.domhand = domhand
	character.cmode_music_override = combat_music.musicpath
	character.cmode_music_override_name = combat_music.name
	character.highlight_color = highlight_color
	character.nickname = nickname

	character.eye_color = eye_color
	if(extra_language && extra_language != "None")
		character.grant_language(extra_language)
	character.voice_color = voice_color
	character.voice_pitch = voice_pitch
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.eye_color))
			organ_eyes.eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.skin_tone = skin_tone
	character.hairstyle = hairstyle
	character.facial_hairstyle = facial_hairstyle
	character.detail = detail
	character.set_patron(selected_patron)
	character.backpack = backpack

	character.jumpsuit_style = jumpsuit_style

	if(charflaw)
		character.charflaw = new charflaw.type()
		character.charflaw.on_mob_creation(character)

	character.dna.real_name = character.real_name

	character.headshot_link = headshot_link

	character.flavortext = flavortext

	character.ooc_notes = ooc_notes

	character.nsfwflavortext = nsfwflavortext

	character.erpprefs = erpprefs

	character.img_gallery = img_gallery

	character.nsfw_img_gallery = nsfw_img_gallery

	character.ooc_extra = ooc_extra

	character.song_title = song_title

	character.song_artist = song_artist
	// LETHALSTONE ADDITION BEGIN: additional customizations

	character.pronouns = pronouns
	character.voice_type = voice_type

	// LETHALSTONE ADDITION END

	character.set_bark(bark_id)
	character.vocal_speed = bark_speed
	character.vocal_pitch = bark_pitch
	character.vocal_pitch_range = bark_variance

	//if(parent)
	//	var/list/L = get_player_curses(parent.ckey)
	//	if(L)
	//		for(var/X in L)
	//			ADD_TRAIT(character, curse2trait(X), TRAIT_GENERIC)

	if(taur_type)
		character.Taurize(taur_type, "#[taur_color]", "#[taur_markings]", "#[taur_tertiary]")
	else if(character_setup)
		// This should only ever ~do~ anything for previews
		character.ensure_not_taur()

	// Apply pointbuy stats and traits (will be re-applied after roll_stats() for fresh spawns)
	apply_pointbuy_stats(character)
	apply_pointbuy_traits(character)

	if(!character_setup)
		apply_loadout_selections(character)

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts(redraw = TRUE)

	character.char_accent = char_accent

	if(culinary_preferences)
		apply_culinary_preferences(character)
/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
		if("religion")
			return DEFAULT_RELIGION
		if("deity")
			return DEFAULT_DEITY
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "Choose your character's [namedata["qdesc"]]:","Character Preference") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' and .</font>")
			return
		else
			custom_names[name_id] = sanitized_name

/// Resets the client's keybindings. Asks them for which
/datum/preferences/proc/force_reset_keybindings()
	var/choice = tgalert(parent.mob, "Your basic keybindings need to be reset, the custom keybinds you've set will remain. Would you prefer 'hotkey' or 'classic TG' mode? DO NOT CLICK CLASSIC UNLESS YOU KNOW WHAT YOU'RE DOING.", "Reset keybindings", "Hotkey", "Classic")
	hotkeys = (choice != "Classic")
	force_reset_keybindings_direct(hotkeys)

/// Does the actual reset
/datum/preferences/proc/force_reset_keybindings_direct(hotkeys = TRUE)
	var/list/oldkeys = key_bindings
	key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	parent?.ensure_keys_set(src)

/datum/preferences/proc/try_update_mutant_colors()
	if(update_mutant_colors)
		reset_body_marking_colors()
		reset_all_customizer_accessory_colors()

/// Debug helper for diagnosing skin-tone-based default gear overrides (see
/// GLOB.role_skin_tone_default_items in preferences_loadout.dm). Dumps every
/// piece of state that feeds into apply_role_skin_tone_default_overrides()/
/// get_matching_skin_tone_default_override() straight to `user`'s chat, so a
/// tester can immediately see whether the override lookup is resolving the
/// way they expect right after picking a new skin tone in the Appearance
/// tab, without having to dig through server logs.
/datum/preferences/proc/debug_skin_tone_selection(mob/user)
	if(!user)
		return

	var/list/skin_name_lookup = pref_species ? pref_species.get_skin_list() : list()
	var/skin_tone_name = "Unknown"
	for(var/name in skin_name_lookup)
		if(skin_name_lookup[name] == skin_tone)
			skin_tone_name = name
			break

	// Same "which role is being previewed" resolution used by
	// regenerate_character_preview() - see get_preview_role_title().
	var/preview_job_title = get_preview_role_title()
	var/datum/job/job = preview_job_title ? SSjob.GetJob(preview_job_title) : null
	var/subclass_path = (job && preview_job_title) ? role_subclasses[preview_job_title] : null

	var/list/subclass_map = job ? GLOB.role_skin_tone_default_items[job.type] : null
	var/has_role_entry = !isnull(subclass_map)

	// Mirrors apply_role_skin_tone_default_overrides()'s own role-wide
	// (ROLE_DEFAULT_OVERRIDE_ROLE_WIDE key) then subclass-specific merge
	// order, so what's printed here always matches what the
	// mannequin/spawned character will actually end up with.
	var/list/matched_overrides = list()
	var/list/skin_map_keys_seen = list()
	if(subclass_map)
		var/list/keys_to_check = list(ROLE_DEFAULT_OVERRIDE_ROLE_WIDE)
		if(subclass_path)
			keys_to_check += subclass_path
		for(var/lookup_key in keys_to_check)
			var/list/skin_map = subclass_map[lookup_key]
			if(!skin_map)
				continue
			for(var/skin_key in skin_map)
				// Quote every key raw so any stray whitespace/case/"#" prefix
				// mismatch against the selected skin_tone is visible instead
				// of silently swallowed by string interpolation.
				skin_map_keys_seen += "\"[skin_key]\"[skin_key == skin_tone ? " (EXACT MATCH)" : ""]"
			var/list/match = get_matching_skin_tone_default_override(skin_map, pref_species, skin_tone)
			if(match)
				for(var/category in match)
					matched_overrides[category] = match[category]

	to_chat(user, span_notice("=== SKIN TONE DEBUG ==="))
	to_chat(user, span_notice("Selected skin_tone: \"[skin_tone]\" (length [length(skin_tone)]) ([skin_tone_name])"))
	to_chat(user, span_notice("Species: [pref_species ? "[pref_species.type]" : "None"]"))
	to_chat(user, span_notice("Preview role (get_preview_role_title): [preview_job_title || "None"]"))
	to_chat(user, span_notice("Loadout preview role override (loadout_preview_role): [loadout_preview_role || "None"]"))
	to_chat(user, span_notice("Job type path: [job ? "[job.type]" : "None"]"))
	to_chat(user, span_notice("Selected subclass: [subclass_path ? "[subclass_path]" : "None"]"))
	to_chat(user, span_notice("job_preferences: [job_preferences && length(job_preferences) ? json_encode(job_preferences) : "None"]"))
	to_chat(user, span_notice("Has role_skin_tone_default_items entry for this job: [has_role_entry ? "YES" : "NO"]"))
	if(length(skin_map_keys_seen))
		to_chat(user, span_notice("Skin tone keys available for this job/subclass combo:"))
		for(var/key_text in skin_map_keys_seen)
			to_chat(user, span_notice("  [key_text]"))
	if(length(matched_overrides))
		to_chat(user, span_notice("Matched skin tone overrides:"))
		for(var/category in matched_overrides)
			to_chat(user, span_notice("  [category] -> [matched_overrides[category]]"))
	else
		to_chat(user, span_warning("No skin tone overrides matched for this skin_tone/job/subclass combo."))
	to_chat(user, span_notice("=== END SKIN TONE DEBUG ==="))

/proc/valid_headshot_link(mob/user, value, silent = FALSE, list/valid_extensions = list("jpg", "png", "jpeg"))
	var/static/link_regex = regex(@"i\.gyazo.com|.\.l3n\.co|images2\.imgbox\.com|thumbs2\.imgbox\.com|files\.catbox\.moe") //gyazo, discord, lensdump, imgbox, catbox

	if(!length(value))
		return FALSE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		if(!silent)
			to_chat(user, "<span class='warning'>Your link must be https!</span>")
		return FALSE

	if(!findtext(value, ".") || findtext(value, "<") || findtext(value, ">") || findtext(value, "]") || findtext(value, "\["))	//there is no link in the world that would ever need < or >
		if(!silent)
			to_chat(user, "<span class='warning'>Invalid link!</span>")
		return FALSE
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		if(!silent)
			to_chat(usr, "<span class='warning'>The link must be one of the following extensions: '[english_list(valid_extensions)]'</span>")
		return FALSE

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		if(!silent)
			to_chat(usr, "<span class='warning'>The link must be hosted on one of the following sites: 'Gyazo, Lensdump, Imgbox, Catbox'</span>")
		return FALSE
	return TRUE

/datum/preferences/proc/is_active_migrant()
	if(!migrant)
		return FALSE
	if(!migrant.active)
		return FALSE
	return TRUE

/datum/preferences/proc/process_virtue_text(datum/virtue/V)
	var/dat
	if(V.desc)
		dat += "<font size = 3>[span_purple(V.desc)]</font><br>"
	if(length(V.added_skills))
		dat += "<font color = '#a3e2ff'><font size = 3>This Virtue adds the following skills: <br>"
		for(var/list/L in V.added_skills)
			var/name
			if(ispath(L[1],/datum/skill))
				var/datum/skill/S = L[1]
				name = initial(S.name)
			dat += "["\Roman[L[2]]"] level[L[2] > 1 ? "s" : ""] of <b>[name]</b>[L[3] ? ", up to <b>[SSskills.level_names_plain[L[3]]]</b>" : ""] <br>"
		dat += "</font>"
	if(length(V.added_traits))
		dat += "<font color = '#a3ffe0'><font size = 3>This Virtue grants the following traits: <br>"
		for(var/TR in V.added_traits)
			dat += "[TR] — <font size = 2>[GLOB.roguetraits[TR]]</font><br>"
		dat += "</font>"
	if(length(V.added_stashed_items))
		dat += "<font color = '#eeffa3'><font size = 3>This Virtue adds the following items to your stash: <br>"
		for(var/I in V.added_stashed_items)
			dat += "<i>[I]</i> <br>"
		dat += "</font>"
	if(V.custom_text)
		dat += "<font color = '#ffffff'><font size = 3>This Virtue has this special behaviour: <br>"
		dat += "[V.custom_text]"
		dat += "</font>"
	return dat

// === POINTBUY SYSTEM (from dossier_style_preferences.dm) ===

// Global cost functions
/proc/pointbuy_cost_next(score)
	if (score >= POINTBUY_MAX) return 0
	if (score < POINTBUY_THRESHOLD_LOW) return 1
	if (score < POINTBUY_THRESHOLD_HIGH) return 2
	return 3

/proc/pointbuy_refund_prev(score)
	if (score <= POINTBUY_MIN) return 0
	if (score <= POINTBUY_THRESHOLD_LOW) return 1
	if (score <= POINTBUY_THRESHOLD_HIGH) return 2
	return 3

// Preferences pointbuy procs
// A single, fixed dark fantasy palette used by the character creator and its sub-menus.
// There is no theme selector - the creator always looks like this. Cached in a
// global (built once, first call) rather than allocating a fresh list every
// single TGUI poll (ui_data() is polled ~1/sec for as long as any of the
// Preferences/BodyMarkings/Customizers/Descriptors/Tattoos windows are open) -
// the list is never mutated by any caller, so sharing one instance is safe.
GLOBAL_LIST_EMPTY(creator_theme_cache)
/datum/preferences/proc/get_creator_theme()
	if(!GLOB.creator_theme_cache.len)
		GLOB.creator_theme_cache = list(
			"bg" = "#0b0906",
			"panel_bg" = "#150f0a",
			"border" = "#5c4425",
			"text" = "#d9c9a3",
			"text_dim" = "#8a7a5c",
			"text_base50" = "#a8956f",
			"text_base70" = "#c2b190",
			"accent" = "#8a1f1f",
			"link" = "#b8860b",
			"highlight_bg" = "#241b12",
			"highlight_text" = "#c9a13b"
		)
	return GLOB.creator_theme_cache

/// Builds the per-player caches used by ui_data() to avoid repeating expensive
/// operations (ban checks, PQ lookups) on every single TGUI poll. Called once
/// when the preferences UI first opens. The cached values are intentionally
/// held for the lifetime of the session - ban status and PQ do not change
/// meaningfully while the preferences window is open. If a player closes and
/// reopens the window the caches are rebuilt from scratch.
/datum/preferences/proc/build_ui_caches(mob/user)
	// A fresh window open always starts with the Occupation Preferences
	// modal closed client-side, so make sure the server agrees - otherwise
	// a stale TRUE from a previous session (closed without ever sending
	// "close_occupation_menu", e.g. the window was force-closed) would
	// keep building the expensive jobs list every poll for nothing.
	showing_occupation_menu = FALSE
	// Reset all caches - ui_cached_job_bans is always initialized to a list
	// (never null) so the `in` check in ui_data() is always safe without a
	// null guard. An empty list means "no cached data" and causes ui_data()
	// to fall back to a fresh is_banned_from() call for every job, which is
	// correct when e.g. SSjob is not ready at open time.
	ui_cached_job_bans = list()
	ui_cached_sorted_jobs = null
	cached_ui_player_pq = -1

	// Early return is intentional and safe: the caches stay in their reset
	// state (empty list / null / -1), which causes ui_data() to fall back
	// to fresh per-poll calls instead of using stale or missing values.
	if(!SSjob || !user?.ckey)
		return

	if(SSjob.occupations.len)
		ui_cached_sorted_jobs = sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc))

	// Single PQ lookup for the entire session instead of once per job per poll.
	cached_ui_player_pq = get_playerquality(user.ckey)

	// One ban check per job at open time instead of one per job per poll.
	// Use the same sorted list that ui_data() will iterate so both always
	// cover identical jobs.
	var/list/jobs_for_cache = ui_cached_sorted_jobs || SSjob.occupations
	for(var/datum/job/job in jobs_for_cache)
		if(!job.spawn_positions)
			continue
		if(job.title in GLOB.role_selection_blacklist)
			continue
		ui_cached_job_bans[job.title] = is_banned_from(user.ckey, job.title)

/datum/preferences/proc/pointbuy_init()
	PBSTR = POINTBUY_DEFAULT_STAT
	PBCON = POINTBUY_DEFAULT_STAT
	PBINT = POINTBUY_DEFAULT_STAT
	PBSPD = POINTBUY_DEFAULT_STAT
	PBWIL = POINTBUY_DEFAULT_STAT
	PBPER = POINTBUY_DEFAULT_STAT
	pointbuy_recompute_pool()
	update_available_traits()

/datum/preferences/proc/get_stat(stat)
	switch(stat)
		if ("STRENGTH")      return PBSTR
		if ("CONSTITUTION")  return PBCON
		if ("INTELLIGENCE")  return PBINT
		if ("SPEED")         return PBSPD
		if ("WILL")          return PBWIL
		if ("PERCEPTION")    return PBPER
	return null

/datum/preferences/proc/set_stat(stat, val)
	switch(stat)
		if ("STRENGTH")      PBSTR = val
		if ("CONSTITUTION")  PBCON = val
		if ("INTELLIGENCE")  PBINT = val
		if ("SPEED")         PBSPD = val
		if ("WILL")          PBWIL = val
		if ("PERCEPTION")    PBPER = val

/datum/preferences/proc/pointbuy_adjust(stat, delta)
	if (!delta) return
	var/current = get_stat(stat)
	if (isnull(current)) return

	if (delta > 0)
		if (current >= POINTBUY_MAX) return
		var/cost = pointbuy_cost_next(current)
		if (unused_points < cost) return
		set_stat(stat, current + 1)
		unused_points -= cost
	else
		if (current <= POINTBUY_MIN) return
		var/refund = pointbuy_refund_prev(current)
		set_stat(stat, current - 1)
		unused_points += refund
	update_available_traits()

// Helper function to check if character has a specific trait
/datum/preferences/proc/has_trait(trait_name)
	return (RaceTrait == trait_name || WilTrait == trait_name || IntTrait1 == trait_name || IntTrait2 == trait_name || SpdTrait == trait_name || StrTrait1 == trait_name || StrTrait2 == trait_name || ConTrait == trait_name || PerTrait1 == trait_name || PerTrait2 == trait_name)

/datum/preferences/proc/update_available_traits()
	CanStrTrait1 = PBSTR >= 12 ? TRUE : FALSE
	CanStrTrait2 = PBSTR >= 16 ? TRUE : FALSE
	CanConTrait = PBCON >= 14 ? TRUE : FALSE
	CanIntTrait1 = PBINT >= 12 ? TRUE : FALSE
	CanIntTrait2 = PBINT >= 16 ? TRUE : FALSE
	CanSpdTrait = PBSPD >= 14 ? TRUE : FALSE
	CanWilTrait = PBWIL >= 14 ? TRUE : FALSE
	CanPerTrait1 = PBPER >= 12 ? TRUE : FALSE
	CanPerTrait2 = PBPER >= 16 ? TRUE : FALSE

	// Track traits that are about to be cleared for exploit prevention
	var/had_ascendant_worshipper = has_trait(TRAIT_ASCENDANT_WORSHIPPER)
	var/had_transvestite = has_trait(TRAIT_TRANSVESTITE)

	if (!CanStrTrait1) StrTrait1 = null
	if (!CanStrTrait2) StrTrait2 = null
	if (!CanConTrait) ConTrait = null
	if (!CanIntTrait1) IntTrait1 = null
	if (!CanIntTrait2) IntTrait2 = null
	if (!CanSpdTrait) SpdTrait = null
	if (!CanWilTrait) WilTrait = null
	if (!CanPerTrait1) PerTrait1 = null
	if (!CanPerTrait2) PerTrait2 = null

	// Exploit prevention: reset religion/patron if the ascendant worshipper trait was lost
	if(had_ascendant_worshipper && !has_trait(TRAIT_ASCENDANT_WORSHIPPER))
		// Lost the ascendant worshipper trait - if patron is from an ascendant faith, reset to default
		if(selected_patron?.associated_faith)
			var/datum/faith/F = GLOB.faithlist[selected_patron.associated_faith]
			if(F && (F.type in GLOB.ascendant_faiths))
				selected_patron = GLOB.patronlist[default_patron]

	// Exploit prevention: reset gender-locked job preferences if transvestite trait was lost
	if(had_transvestite && !has_trait(TRAIT_TRANSVESTITE))
		validate_gender_locked_jobs()

/// Returns a description string for a given trait name
/proc/get_trait_description(trait_name)
	var/static/list/trait_descriptions = list(
		"Strong Bite" = "Your bite attacks deal more damage.",
		"Strong Kick" = "Your kick attacks deal more damage.",
		"Maille Training" = "Grants proficiency wearing medium armor.",
		"Plate Training" = "Grants proficiency wearing heavy armor.",
		"Blessing of Abyssor" = "Less base fatigue drain when swimming.",
		"Strength Unbound" = "Ignores the normal strength softcap.",
		"Big Guy" = "You are unusually large and imposing.",
		"Bed Breaker" = "Increased pelvis-crushing power and pain in the bedroom.",
		"Beautiful" = "You are unusually attractive.",
		"Ignore Damage Slowdown" = "Injuries slow you down less.",
		"Battleready" = "You recover from combat exertion faster.",
		"Critical Resistance" = "Reduced chance to suffer critical hits.",
		"Shock Immunity" = "Immune to electric shocks.",
		"Blessing of Baotha" = "You will never overdose.",
		"Fabled Lover" = "Heal from sex.",
		"Apricity" = "Decreased stamina regen time during the day, and less so at night.",
		"Hard Dismemberment" = "Your limbs are harder to sever.",
		"Painless" = "You feel less pain from injuries.",
		"Poison Immune" = "Immune to poison.",
		"Steelhearted" = "No bad mood from dismembering or witnessing dismemberment.",
		"Dead Nose" = "You have no sense of smell.",
		"Tolerant" = "Reduced impact from disliked things.",
		"Night Owl" = "You suffer less from staying awake at night.",
		"Beastly Digestion" = "Can eat raw and rotten food and drink murky water.",
		"Fortitude" = "Increased resistance to being staggered or knocked down.",
		"Better Sleep" = "Recover more energy when sleeping.",
		"Enduring" = "Reduced chance to be stunned by pain.",
		"Adrenaline Rush" = "Gain a burst of stamina when badly hurt.",
		"Literacy" = "You can read and write.",
		"Ritualist" = "Allows use of ritual chalk.",
		"Appraiser" = "Can roughly tell the value of items.",
		"Skilled Appraiser" = "Can precisely tell the value of items.",
		"Empath" = "Can sense the emotions of those around you.",
		"Bewitched" = "Prevents spellcasting.",
		"Anti-Magic" = "Immune to most forms of magic.",
		"Intellectual" = "You are unusually knowledgeable.",
		"Sentinel of Wits" = "Resistant to mental effects and manipulation.",
		"Good Trainer" = "Trains skills onto others more effectively.",
		"Nutcracker" = "Your grip strength lets you crack tough things open.",
		"Deceiving Meekness" = "Others underestimate your combat prowess.",
		"Combat Aware" = "Harder to catch off guard in combat.",
		"Unleechable" = "Leeches won't attach in bog squares.",
		"Huntmaster" = "Will always find any tracks and analyze them perfectly.",
		"Longstrider" = "Increased movement speed while tracking.",
		"Sharper Blades" = "Weapons lose less blade integrity.",
		"Dual Wielder" = "Better at fighting with a weapon in each hand.",
		"Keen Ears" = "Hear faint or distant sounds more clearly.",
		"Eyes of Matthios" = "Examine to see the most expensive item someone has.",
		"Blackleg" = "Can rig coin flips and dice.",
		"Leaper" = "Jump further and more reliably.",
		"Ignore Slow" = "Reduced movement slowdown from status effects.",
		"Expert Dodger" = "Increased dodge chance.",
		"Light Step" = "Footsteps are quieter, making you harder to detect.",
		"Woodwalker" = "Move through forests and undergrowth unimpeded.",
		"Speed Unbound" = "Ignores the normal speed softcap.",
		"Brittle Form" = "Bones break more easily.",
		"Leprosy" = "A disfiguring, chronic disease.",
		"Critical Weakness" = "Increased chance to suffer critical hits.",
		"Limp Dick" = "Cannot perform in the bedroom.",
		"Ugly" = "You are unusually unattractive.",
		"Easy Dismemberment" = "Your limbs are severed more easily.",
		"Jesterphobic" = "Deeply unsettled by jesters and clowns.",
		"Xenophobic" = "Uncomfortable around unfamiliar races.",
		"Bad Mood" = "You are prone to sour moods.",
		"Nudist" = "You cannot wear most clothes.",
		"Fatal Insomnia" = "You suffer badly from a lack of sleep.",
		"Simple Speech" = "You can only say the 1000 most common words; other words get garbled.",
		"Psychosis" = "Replaces all ambience with creepy hallucinations.",
		"Decayed Flesh" = "Cannot run.",
		"Cyclops (Left)" = "Missing your left eye.",
		"Cyclops (Right)" = "Missing your right eye.",
		"Permanent Mute" = "You cannot speak.",
		"Transvestite" = "Wear clothes of the opposite gender, use the opposite-gender role title, and ignore gender-locked role restrictions.",
		"Ascendant Worshipper" = "You may worship the Ascendants as your patron. Unlocks ascendant faiths.",
		"Civilized" = "Ignores race-based role restrictions up to Tolerated races, but nullifies your race's stat bonuses on spawn.",
	)
	return trait_descriptions[trait_name]

/// Reset gender-locked job preferences to NEVER if the character no longer qualifies
/datum/preferences/proc/validate_gender_locked_jobs()
	if(!SSjob)
		return
	var/is_transvestite = has_trait(TRAIT_TRANSVESTITE)
	for(var/datum/job/job in SSjob.occupations)
		if(!length(job.allowed_sexes))
			continue
		// Check if the player's gender is allowed for this job
		var/gender_allowed = FALSE
		if(gender == MALE && (MALE in job.allowed_sexes))
			gender_allowed = TRUE
		else if(gender == FEMALE && (FEMALE in job.allowed_sexes))
			gender_allowed = TRUE
		// Transvestite trait bypasses gender lock
		if(is_transvestite)
			gender_allowed = TRUE
		// If not allowed, set preference to never
		if(!gender_allowed && job_preferences[job.title])
			job_preferences[job.title] = null

/datum/preferences/proc/pointbuy_total_spent()
	var/total = 0
	for (var/score in list(PBSTR, PBCON, PBINT, PBSPD, PBWIL, PBPER))
		var/s = clamp(score, POINTBUY_MIN, POINTBUY_MAX)
		for (var/i = POINTBUY_MIN to s-1)
			total += pointbuy_cost_next(i)
	return total

/datum/preferences/proc/pointbuy_recompute_pool()
	var/pq = parent ? get_playerquality(parent.ckey) : 0
	unused_points = max(0, get_pointbuy_pool(pq) - pointbuy_total_spent())

/// Luck cannot be bought with points - it is shown as a range so the player knows what to expect at spawn.
/datum/preferences/proc/get_luck_range_text()
	var/base = 10
	if(pref_species?.race_bonus && pref_species.race_bonus[STAT_FORTUNE])
		base += pref_species.race_bonus[STAT_FORTUNE]
	return "[max(1, base - 2)] - [min(20, base + 2)]"

/// Applies the pointbuy stat scores onto the character's real stats, preserving whatever
/// species/age modifiers were already layered on top of the default baseline of 10.
/// TRAIT_CIVILIZED characters have their racial stat modifier nullified as the price of
/// ignoring their race's usual role restrictions.
/datum/preferences/proc/apply_pointbuy_stats(mob/living/carbon/human/character)
	if(!character)
		return
	var/nullify_race_bonus = has_trait(TRAIT_CIVILIZED)
	character.STASTR = clamp(PBSTR + (nullify_race_bonus ? 0 : (character.STASTR - 10)), 1, 20)
	character.STACON = clamp(PBCON + (nullify_race_bonus ? 0 : (character.STACON - 10)), 1, 20)
	character.STAINT = clamp(PBINT + (nullify_race_bonus ? 0 : (character.STAINT - 10)), 1, 20)
	character.STASPD = clamp(PBSPD + (nullify_race_bonus ? 0 : (character.STASPD - 10)), 1, 20)
	character.STAWIL = clamp(PBWIL + (nullify_race_bonus ? 0 : (character.STAWIL - 10)), 1, 20)
	character.STAPER = clamp(PBPER + (nullify_race_bonus ? 0 : (character.STAPER - 10)), 1, 20)

/// Grants the traits chosen through stat thresholds (and the innate racial trait) to the character.
/datum/preferences/proc/apply_pointbuy_traits(mob/living/carbon/human/character)
	if(!character)
		return
	var/list/traits_to_apply = list(RaceTrait, NegRaceTrait, StrTrait1, StrTrait2, ConTrait, IntTrait1, IntTrait2, SpdTrait, WilTrait, PerTrait1, PerTrait2)
	traits_to_apply += get_pointbuy_penalty_traits()
	for(var/trait_name in traits_to_apply)
		if(!trait_name)
			continue
		if(character.dna?.species?.banned_traits && (trait_name in character.dna.species.banned_traits))
			continue
		ADD_TRAIT(character, trait_name, ADVENTURER_TRAIT)

/// Returns the negative traits automatically incurred by dumping a stat to
/// 5 or below. These are not player-selectable - they're the drawback of
/// having a low stat, on top of (not replacing) the positive threshold traits.
/datum/preferences/proc/get_pointbuy_penalty_traits()
	var/list/penalty_traits = list()
	if(PBSTR <= 5)
		penalty_traits += TRAIT_SHATTER_WEAKNESS
	if(PBCON <= 5)
		penalty_traits += list(TRAIT_LEPROSY, TRAIT_CRITICAL_WEAKNESS, TRAIT_LIMPDICK, TRAIT_UNSEEMLY, TRAIT_EASYDISMEMBER)
	if(PBWIL <= 5)
		penalty_traits += list(TRAIT_JESTERPHOBIA, TRAIT_XENOPHOBIC, TRAIT_BAD_MOOD, TRAIT_NUDIST, TRAIT_NOSLEEP)
	if(PBINT <= 5)
		penalty_traits += TRAIT_SIMPLESPEECH
	if(PBPER <= 5)
		penalty_traits += TRAIT_PSYCHOSIS
	if(PBSPD <= 5)
		penalty_traits += TRAIT_NORUN
	return penalty_traits

// === END POINTBUY SYSTEM ===

// TGUI Character Creator Interface
/datum/preferences/proc/show_character_creator_tgui(mob/user)
	if(!user || !user.client)
		return
	ui_interact(user)

// Regenerate character preview icons - call this when appearance changes
/datum/preferences/proc/regenerate_character_preview()
	// Whichever role the player last selected/edited in the Loadout tab
	// (see get_preview_role_title()), not necessarily the HIGH priority one.
	var/preview_job_title = get_preview_role_title()

	// Every added role's tab (and every appearance tab) routes through this
	// same proc on basically every single edit, and switching back and
	// forth between already-configured roles to compare their loadouts is
	// extremely common - but re-rendering was previously unconditional, so
	// every switch paid for a brand new dummy mob, a full outfit/subclass/
	// loadout/dye equip pass, and 4 direction icon renders even when
	// nothing about that exact role/appearance combination had changed
	// since the last time it was rendered. Reuse the exact match if one
	// exists instead of redoing all of that work.
	var/preview_cache_key = build_preview_cache_key(preview_job_title)
	var/list/cached_render = cached_role_preview_renders[preview_cache_key]
	if(cached_render)
		cached_preview_icon = cached_render["icon"]
		cached_preview_front = cached_render["front"]
		cached_preview_left = cached_render["left"]
		cached_preview_right = cached_render["right"]
		cached_preview_back = cached_render["back"]
		return

	// A throwaway (non-pooled) dummy is used here rather than the shared
	// generate_or_wait_for_human_dummy() pool: that pool is a single mob
	// shared across every preview regeneration, and every caller UNTIL()-waits
	// for it to be free. If a single role/subclass's outfit ever misbehaves
	// mid-render, the shared dummy would stay marked in_use forever, wedging
	// every future preview (for any role, any player) behind that wait. A
	// fresh dummy per call can never block anything else, and this proc is
	// only ever called from discrete user actions (not a hot per-tick path),
	// so the extra dummy setup cost here is negligible.
	var/mob/living/carbon/human/dummy/mannequin = new()
	// Use character_setup = TRUE to prevent randomization during preview generation.
	// icon_updates = FALSE: copy_to() would otherwise immediately rebuild
	// body/hair/bodypart icons here, before any gear is equipped below - all
	// of that work is thrown away the moment mannequin.regenerate_icons()
	// runs further down (after equipping), so skip it entirely up front.
	copy_to(mannequin, FALSE, FALSE, TRUE)

	// Equip the currently previewed role's job outfit, plus its chosen
	// subclass outfit on top (if any), so every piece of equipment tied to
	// that role's loadout is visible in the preview.
	if(SSjob && job_preferences && preview_job_title)
		var/datum/job/selected_job = SSjob.GetJob(preview_job_title)
		if(selected_job && selected_job.outfit)
			mannequin.equipOutfit(selected_job.outfit, TRUE)

		var/subclass_path = role_subclasses[preview_job_title]
		if(subclass_path)
			var/datum/advclass/adv_path = subclass_path
			var/datum/advclass/adv_ref = SSrole_class_handler.get_advclass_by_name(initial(adv_path.name))
			if(adv_ref)
				adv_ref.equipme(mannequin, dummy = TRUE)

	// Force in whatever race/skin tone specific default gear overrides
	// apply to this role/subclass (see role_race_default_items/
	// role_skin_tone_default_items in preferences_loadout.dm) - the outfit
	// equips above never consult those overrides on their own, so without
	// this the mannequin would keep showing the outfit's raw default gear
	// even after changing to a skin tone/race that should replace it.
	apply_role_default_overrides(mannequin, preview_job_title)

	// Layer on top whatever loadout gear the player actually selected
	// (weapon/head/etc. picks), scoped to only the currently previewed
	// role - each added role's loadout is fully independent, so picks
	// made on one role's tab must never bleed onto another role's
	// preview (see only_job_title on apply_loadout_selections()).
	apply_loadout_selections(mannequin, is_preview = TRUE, only_job_title = preview_job_title)
	// Strip back out anything the player explicitly emptied a slot of - the
	// preview's outfit was already equipped above, so this can run right
	// away rather than needing a separate pass like the real spawn does.
	apply_loadout_removals(mannequin, only_job_title = preview_job_title)
	// Recolor whatever's left with any dye choices made in the Loadout tab.
	// skip_icon_update = TRUE: apply_loadout_dyes() would otherwise
	// immediately regenerate_icons() itself if anything got dyed, but the
	// mannequin.regenerate_icons() call right below redoes that same
	// rebuild unconditionally anyway - so let that one call cover it
	// instead of paying for it twice.
	apply_loadout_dyes(mannequin, only_job_title = preview_job_title, skip_icon_update = TRUE)

	mannequin.rebuild_obscured_flags()
	mannequin.regenerate_icons()
	// A lot of worn slots (pants, shirt, armor, gloves, shoes, belt, back,
	// cloak) only queue their icon update for the next SSiconupdates tick
	// instead of applying it immediately. Since this dummy is never actually
	// processed by that subsystem, those overlays would never appear in the
	// generated preview unless we force the pending updates through right now.
	mannequin.process_pending_icon_updates()

	// The overlays regenerate_icons() builds above (body/hair/all worn
	// slots) use standard 4-directional icon states and never key off
	// mannequin.dir while building them - BYOND itself picks the correct
	// per-direction frame out of those overlays at render/getFlatIcon()
	// time based on whatever setDir() was last called. So only one
	// regenerate_icons() call is needed for all four views; re-running it
	// again after each setDir() below used to redo the exact same overlay
	// work for no visual difference, quadrupling the cost of every preview
	// regeneration.

	// Front view (SOUTH)
	mannequin.setDir(SOUTH)
	var/icon/preview_front = getFlatIcon(mannequin, no_anim = TRUE)
	cached_preview_icon = icon2base64(preview_front)
	cached_preview_front = icon2base64(preview_front)

	// Left view (EAST)
	mannequin.setDir(EAST)
	var/icon/preview_left = getFlatIcon(mannequin, no_anim = TRUE)
	cached_preview_left = icon2base64(preview_left)

	// Right view (WEST)
	mannequin.setDir(WEST)
	var/icon/preview_right = getFlatIcon(mannequin, no_anim = TRUE)
	cached_preview_right = icon2base64(preview_right)

	// Back view (NORTH)
	mannequin.setDir(NORTH)
	var/icon/preview_back = getFlatIcon(mannequin, no_anim = TRUE)
	cached_preview_back = icon2base64(preview_back)

	qdel(mannequin)

	// Save this exact render so the next time this same role/appearance
	// combination is previewed (ex: switching back to a role tab already
	// visited this session) it can be served instantly - see
	// cached_role_preview_renders above. Capped to avoid unbounded growth
	// across a long customization session (each entry holds 5 base64
	// icons); once the cap is hit the whole cache is cleared rather than
	// tracking per-entry age, since this is a rare event in normal play
	// (a handful of roles/subclasses/dyes per session).
	if(length(cached_role_preview_renders) >= PREVIEW_RENDER_CACHE_MAX_SIZE)
		cached_role_preview_renders = list()
	cached_role_preview_renders[preview_cache_key] = list(
		"icon" = cached_preview_icon,
		"front" = cached_preview_front,
		"left" = cached_preview_left,
		"right" = cached_preview_right,
		"back" = cached_preview_back,
	)


/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// Build per-player caches once to avoid expensive I/O on every poll.
		build_ui_caches(user)
		// Generate initial preview when UI first opens
		// Start with clothed preview (stats tab), naked preview will be generated when needed
		regenerate_character_preview()
		ui = new(user, src, "Preferences")
		ui.open()

/datum/preferences/ui_close(mob/user)
	. = ..()
	// Safety net for showing_occupation_menu: Preferences.tsx normally sends
	// "close_occupation_menu" when the OccupationMenu overlay closes, but if
	// the player closes the whole Preferences window (or disconnects) while
	// that overlay happens to still be open - bypassing the overlay's own
	// close button/backdrop click - that act() never fires and the flag
	// would otherwise stay stuck TRUE for the rest of this preferences
	// datum's lifetime. Since the flag gates the single most expensive
	// thing ui_data() builds (see showing_occupation_menu), a stuck flag
	// would silently re-enable that full per-poll rebuild for every future
	// time this player reopens Preferences, defeating the whole point of
	// gating it. Resetting here whenever the window fully closes guarantees
	// it can never leak past a single Preferences session.
	showing_occupation_menu = FALSE

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_static_data(mob/user)
	var/list/data = list()

	// Vocal bark list (static)
	var/list/bark_list = list()
	for(var/bark_key in GLOB.bark_list)
		var/datum/bark/B = GLOB.bark_list[bark_key]
		bark_list += list(list("id" = bark_key, "name" = initial(B.name)))
	data["bark_list"] = bark_list
	
	return data

/datum/preferences/ui_data(mob/user)
	var/list/data = list()

	// Fixed dark fantasy theme - there is no theme selector.
	data["theme"] = get_creator_theme()
	
	// Return cached character preview icons (regenerated only when appearance changes)
	data["preview_icon"] = cached_preview_icon
	data["preview_front"] = cached_preview_front
	data["preview_left"] = cached_preview_left
	data["preview_right"] = cached_preview_right
	data["preview_back"] = cached_preview_back
	
	// Identity data
	data["real_name"] = real_name
	data["surname"] = surname
	data["nickname"] = nickname
	data["gender"] = gender == MALE ? MALE : FEMALE
	data["pronouns"] = gender == MALE ? HE_HIM : SHE_HER
	data["species"] = pref_species.name
	data["body_type"] = gender == MALE ? "Masculine" : "Feminine"
	data["voice_type"] = voice_type
	data["age"] = age
	data["extra_language"] = extra_language
	data["char_accent"] = char_accent
	data["citizen"] = citizen
	data["virgin"] = virgin
	data["domhand"] = domhand
	data["voice_pitch"] = voice_pitch
	data["voice_color"] = voice_color
	data["headshot_link"] = headshot_link
	data["nsfw_headshot_link"] = nsfw_headshot_link
	data["ooc_extra"] = ooc_extra
	
	// Vocal bark data (current settings, not the list which is static)
	data["bark_id"] = bark_id
	data["bark_speed"] = bark_speed
	data["bark_pitch"] = bark_pitch
	data["bark_variance"] = bark_variance
	
	// Appearance data
	data["hair_style"] = hairstyle
	data["hair_color"] = hair_color
	data["facial_hair_style"] = facial_hairstyle
	data["facial_hair_color"] = facial_hair_color
	data["skin_tone"] = skin_tone
	// Get the skin tone name from the species' skin list - cached since this
	// is otherwise a linear scan of the species' full skin list repeated on
	// every single TGUI poll (~1/sec) for as long as Preferences is open,
	// even though the result only ever changes when species/skin_tone does.
	var/skin_tone_cache_key = "[pref_species ? pref_species.type : "none"]|[skin_tone]"
	if(cached_skin_tone_name_key != skin_tone_cache_key)
		cached_skin_tone_name = ""
		if(pref_species)
			var/list/skin_list = pref_species.get_skin_list()
			for(var/name in skin_list)
				if(skin_list[name] == skin_tone)
					cached_skin_tone_name = name
					break
		cached_skin_tone_name_key = skin_tone_cache_key
	data["skin_tone_name"] = cached_skin_tone_name
	// Species-specific label for the skin tone field (e.g. "Clan" for
	// orcs, "Tribal Identity" for elves) instead of a hardcoded "Ethnicity".
	data["skin_tone_wording"] = pref_species.skin_tone_wording
	data["eye_color"] = eye_color
	
	// Virtues & flaws
	data["virtue"] = virtue.name
	data["virtue_two"] = virtuetwo.name
	data["charflaw"] = charflaw.name
	data["patron"] = selected_patron.name
	data["pantheon"] = selected_patron?.associated_faith ? get_faith_name_for_prefs(selected_patron.associated_faith) : "None"
	
	// Pointbuy system stats - unused_points is maintained directly by
	// pointbuy_adjust() so there is no need to recompute it here on every
	// poll (which would call get_playerquality() redundantly).
	data["PBSTR"] = PBSTR
	data["PBCON"] = PBCON
	data["PBINT"] = PBINT
	data["PBSPD"] = PBSPD
	data["PBWIL"] = PBWIL
	data["PBPER"] = PBPER
	data["unused_points"] = unused_points
	data["luck_range"] = get_luck_range_text()

	// Trait availability flags
	data["CanStrTrait1"] = CanStrTrait1
	data["CanStrTrait2"] = CanStrTrait2
	data["CanConTrait"] = CanConTrait
	data["CanIntTrait1"] = CanIntTrait1
	data["CanIntTrait2"] = CanIntTrait2
	data["CanSpdTrait"] = CanSpdTrait
	data["CanWilTrait"] = CanWilTrait
	data["CanPerTrait1"] = CanPerTrait1
	data["CanPerTrait2"] = CanPerTrait2

	// Selected traits
	data["RaceTrait"] = RaceTrait
	data["NegRaceTrait"] = NegRaceTrait
	data["StrTrait1"] = StrTrait1
	data["StrTrait2"] = StrTrait2
	data["ConTrait"] = ConTrait
	data["IntTrait1"] = IntTrait1
	data["IntTrait2"] = IntTrait2
	data["SpdTrait"] = SpdTrait
	data["WilTrait"] = WilTrait
	data["PerTrait1"] = PerTrait1
	data["PerTrait2"] = PerTrait2

	// Loadout system
	data["loadout"] = get_loadout_ui_data()
	data["dressup_mode"] = dressup_mode

	
	// Game settings
	data["current_tab"] = current_tab
	data["tgui_fancy"] = tgui_fancy
	data["tgui_lock"] = tgui_lock
	data["hotkeys"] = hotkeys
	data["chat_on_map"] = chat_on_map
	data["showrolls"] = showrolls
	data["windowflashing"] = windowflashing
	
	// NOTE: Body markings, customizers, and descriptors data are
	// intentionally NOT built here. They are only consumed by the
	// dedicated /datum/body_markings_ui, /datum/customizers_ui, and
	// /datum/descriptors_ui popup windows (opened via set_markings /
	// set_features / set_description), which already compute this data
	// themselves in their own ui_data(). Preferences.tsx never reads
	// these fields, so recomputing them here was pure wasted work
	// (multiple nested loops + datum lookups) repeated on every single
	// TGUI poll for every player with the Preferences window open -
	// a major, easily avoidable source of server lag.
	
	// Ready state for spawning
	var/mob/dead/new_player/N = user
	if(istype(N))
		data["ready"] = N.ready
		data["is_pregame"] = (SSticker.current_state <= GAME_STATE_PREGAME)
		data["is_active_migrant"] = is_active_migrant()
	else
		data["ready"] = 0
		data["is_pregame"] = FALSE
		data["is_active_migrant"] = FALSE
	
	// Job/Occupation preferences
	data["job_preferences"] = job_preferences
	data["joblessrole"] = joblessrole
	
	// Build job list - only when the Occupation Preferences modal
	// (Preferences.tsx's OccupationMenu) is actually open. This list is
	// the single most expensive thing ui_data() builds (every joinable
	// job gets a playtime/PQ/ban/availability check), so building it on
	// every ~1s poll regardless of whether anyone can even see it was a
	// major, easily avoidable source of server lag. See
	// showing_occupation_menu for how the flag gets set.
	var/list/jobs_data = list()
	if(showing_occupation_menu && SSjob && !SSjob.occupations.len)
		SSjob.SetupOccupations()
	if(showing_occupation_menu && SSjob)
		// Use the pre-sorted cached list built at UI-open time (avoids
		// re-sorting every poll); fall back to a fresh sort if somehow
		// not yet built (e.g. jobs were not ready at open time).
		var/list/jobs_to_iterate = ui_cached_sorted_jobs || sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc))
		// PQ is the same for every job in the loop - compute it once
		// outside rather than calling get_playerquality() N times per poll.
		// If the cache wasn't built, fetch it now and save it so subsequent
		// polls don't repeat the call.
		#ifdef USES_PQ
		if(cached_ui_player_pq < 0)
			cached_ui_player_pq = get_playerquality(user.ckey)
		var/pq_for_jobs = cached_ui_player_pq
		#endif
		for(var/datum/job/job in jobs_to_iterate)
			if(!job.spawn_positions)
				continue
			if(job.title in GLOB.role_selection_blacklist)
				continue
			var/job_info = list(
				"title" = job.title,
				"path" = "[job.type]",
				"display_title" = job.display_title || job.title,
				"f_title" = job.f_title,
				"tutorial" = job.tutorial,
				"spawn_positions" = job.spawn_positions,
				"round_contrib_points" = job.round_contrib_points,
				"min_pq" = job.min_pq,
				"max_pq" = job.max_pq,
				"required" = job.required,
				"class_setup_examine" = job.class_setup_examine,
				"job_group" = job.get_faction_group()
			)
			
			// Use cached ban status (built once on UI open) to avoid a
			// per-job file/DB read on every poll. ui_cached_job_bans is
			// always a list (never null) after build_ui_caches() so the
			// `in` check is always safe. An empty/missing entry falls back
			// to a fresh is_banned_from() call (covers jobs added after
			// the cache was built, or when SSjob wasn't ready on open).
			var/banned
			if(job.title in ui_cached_job_bans)
				banned = ui_cached_job_bans[job.title]
			else
				banned = is_banned_from(user.ckey, job.title)
			job_info["banned"] = banned
			
			// Check PQ requirements using the pre-computed pq_for_jobs
			var/meets_min_pq = TRUE
			var/meets_max_pq = TRUE
			#ifdef USES_PQ
			if(!isnull(job.min_pq) && job.min_pq > 0 && pq_for_jobs < job.min_pq)
				meets_min_pq = FALSE
			if(!isnull(job.max_pq) && job.max_pq > 0 && pq_for_jobs > job.max_pq)
				meets_max_pq = FALSE
			#endif
			job_info["meets_min_pq"] = meets_min_pq
			job_info["meets_max_pq"] = meets_max_pq
			
			var/required_playtime = job.required_playtime_remaining(user.client)
			job_info["required_playtime"] = required_playtime
			
			var/old_enough = job.player_old_enough(user.client)
			job_info["old_enough"] = old_enough
			if(!old_enough)
				job_info["available_in_days"] = job.available_in_days(user.client)
			
			// Check virtue/vice restrictions
			var/list/virtue_restrictions_text = list()
			if(length(job.virtue_restrictions))
				if(virtue.type in job.virtue_restrictions)
					virtue_restrictions_text += virtue.name
				if(virtuetwo?.type in job.virtue_restrictions)
					virtue_restrictions_text += virtuetwo.name
			if(length(job.vice_restrictions))
				if(charflaw.type in job.vice_restrictions)
					virtue_restrictions_text += charflaw.name
			job_info["virtue_restrictions"] = virtue_restrictions_text.Join(", ")
			
			// Check job availability
			var/job_unavailable = JOB_AVAILABLE
			if(isnewplayer(parent?.mob))
				var/mob/dead/new_player/new_player = parent.mob
				job_unavailable = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
			job_info["available_status"] = job_unavailable
			job_info["already_role"] = (job.title in job_preferences)
			
			jobs_data += list(job_info)
	data["jobs"] = jobs_data

	return data

/// Returns the display name of a faith given its associated_faith typepath, or null if not found.
/datum/preferences/proc/get_faith_name_for_prefs(faith_path)
	var/datum/faith/F = GLOB.faithlist[faith_path]
	return F?.name

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	
	var/mob/user = ui.user
	
	switch(action)
		// Identity actions
		if("set_name")
			var/new_name = tgui_input_text(user, "Enter your character's name:", "Character Name", real_name, MAX_NAME_LEN)
			if(new_name)
				real_name = new_name
			. = TRUE
			
		if("set_nickname")
			var/new_nickname = tgui_input_text(user, "Enter your character's nickname:", "Nickname", nickname)
			if(new_nickname)
				nickname = new_nickname
			. = TRUE
		
		if("set_gender")
			gender = gender == MALE ? FEMALE : MALE
			// Keep pronouns in sync with the new gender (matches the
			// gender == MALE ? HE_HIM : SHE_HER mapping ui_data() uses to
			// display "pronouns"). Without this, the mannequin's dummy
			// character keeps its old pronouns after a gender switch, and
			// since some outfits' pre_equip() gate gendered gear on
			// should_wear_femme_clothes(H)/should_wear_masc_clothes(H)
			// (which check H.pronouns, not H.gender), the preview would
			// keep showing the old gender's clothing style.
			pronouns = gender == MALE ? HE_HIM : SHE_HER
			// Validate gender-locked job preferences after gender change
			validate_gender_locked_jobs()
			// Re-sync gender-locked organ customizers (penis/vagina/breasts,
			// which are all auto-enabled/disabled based on gender) so
			// anatomy-dependent features (like tattoo/brand locations)
			// reflect the character's current gender instead of stale
			// state left over from before the switch.
			genderize_customizer_entries()
			. = TRUE
			
		if("set_species")
			var/list/species = list()
			// Use get_selectable_species() rather than reading
			// GLOB.roundstart_races directly - the list is only populated
			// lazily on first use, so a returning player whose preferences
			// loaded from an existing save (skipping the New() code path
			// that primes it) could otherwise see an empty list here,
			// which makes tgui_input_list() return immediately without
			// ever opening the race selector.
			for(var/A in get_selectable_species())
				var/datum/species/race = GLOB.species_list[A]
				race = new race()
				if(user.client)
					if(race.patreon_req > user.client.patreonlevel())
						continue
				else
					continue
				species += race
			species = sortNames(species)
			var/result = tgui_input_list(user, "Select species:", "Species", species)
			if(result)
				set_new_race(result, user)
			. = TRUE
			
		if("set_voice_type")
			var/list/voice_choices = list(VOICE_TYPE_MASC, VOICE_TYPE_FEM, VOICE_TYPE_ANDR)
			var/choice = tgui_input_list(user, "Select voice type:", "Voice Type", voice_choices)
			if(choice)
				voice_type = choice
			. = TRUE
			
		if("set_age")
			var/new_age = tgui_input_list(user, "Enter age:", "Age", list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD))
			if(new_age)
				age = new_age
			. = TRUE
			
		if("set_surname")
			var/new_surname = tgui_input_text(user, "Enter your character's surname:", "Surname", surname, MAX_NAME_LEN)
			// A surname is optional - allow the player to clear it entirely
			// by submitting a blank value. Only a cancelled prompt (null)
			// should leave the existing surname untouched.
			if(!isnull(new_surname))
				surname = new_surname
			. = TRUE
		
		if("set_extra_language")
			var/list/language_choices = list("None", "Imperial", "Dwarvish", "Elvish", "Orcish", "Canilunzt", "Grenzelhoftian Imperial", "Etrusco", "Gronnic", "Otavais", "Abyssal", "Infernal", "Thieves' Cant")
			var/choice = tgui_input_list(user, "Select extra language:", "Extra Language", language_choices)
			if(choice)
				extra_language = choice
			. = TRUE
			
		if("set_accent")
			var/new_accent = tgui_input_list(user, "Choose your character's accent:", "Accent", GLOB.character_accents)
			if(new_accent)
				char_accent = new_accent
			. = TRUE
			
		if("toggle_citizen")
			citizen = !citizen
			. = TRUE
			
		if("toggle_virgin")
			virgin = !virgin
			. = TRUE
			
		if("set_domhand")
			if(domhand == 2)
				domhand = 1
			else
				domhand = 2
			. = TRUE
			
		if("set_voice_pitch")
			var/new_pitch = tgui_input_number(user, "Enter voice pitch (0.5-2.0):", "Voice Pitch", voice_pitch, 2.0, 0.5)
			if(new_pitch)
				voice_pitch = new_pitch
			. = TRUE
			
		if("set_voice_color")
			var/new_color = color_pick_sanitized(user, "Choose voice color:", "Voice Color", "#"+voice_color)
			if(new_color)
				voice_color = sanitize_hexcolor(new_color)
			. = TRUE
			
		if("set_headshot")
			var/new_link = tgui_input_text(user, "Enter headshot image URL:", "Headshot Link", headshot_link, 500)
			if(new_link != null)
				headshot_link = new_link
			. = TRUE
			
		if("set_nsfw_headshot")
			var/new_link = tgui_input_text(user, "Enter confidential photo URL:", "Confidential Photo Link", nsfw_headshot_link, 500)
			if(new_link != null)
				nsfw_headshot_link = new_link
			. = TRUE
			
		if("set_ooc_notes")
			var/new_notes = tgui_input_text(user, "Enter OOC notes:", "OOC Notes", ooc_extra, 2000, TRUE)
			if(new_notes != null)
				ooc_extra = new_notes
			. = TRUE
		
		// Vocal bark actions
		if("set_bark_id")
			var/list/bark_choices = list()
			for(var/bark_key in GLOB.bark_list)
				var/datum/bark/B = GLOB.bark_list[bark_key]
				bark_choices[initial(B.name)] = bark_key
			var/choice = tgui_input_list(user, "Select bark sound:", "Bark Sound", bark_choices)
			if(choice)
				bark_id = bark_choices[choice]
			. = TRUE
			
		if("increase_bark_speed")
			bark_speed = min(bark_speed + 1, 10)
			. = TRUE
			
		if("decrease_bark_speed")
			bark_speed = max(bark_speed - 1, 1)
			. = TRUE
			
		if("increase_bark_pitch")
			bark_pitch = min(bark_pitch + 0.1, 2)
			. = TRUE
			
		if("decrease_bark_pitch")
			bark_pitch = max(bark_pitch - 0.1, 0.5)
			. = TRUE
			
		if("increase_bark_variance")
			bark_variance = min(bark_variance + 0.05, 1)
			. = TRUE
			
		if("decrease_bark_variance")
			bark_variance = max(bark_variance - 0.05, 0)
			. = TRUE
			
		if("preview_bark")
			if(SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(user, span_warning("Bark previews can't play during initialization!"))
				. = TRUE
				return
			if(!COOLDOWN_FINISHED(src, bark_previewing))
				. = TRUE
				return
			if(!parent || !parent.mob)
				. = TRUE
				return
			COOLDOWN_START(src, bark_previewing, 5 SECONDS)
			var/atom/movable/barkbox = new(get_turf(parent.mob))
			barkbox.set_bark(bark_id)
			var/total_delay = 0
			for(var/i in 1 to (round((32 / bark_speed)) + 1))
				addtimer(CALLBACK(barkbox, TYPE_PROC_REF(/atom/movable, bark), list(parent.mob), 7, 70, BARK_DO_VARY(bark_pitch, bark_variance)), total_delay)
				total_delay += rand(DS2TICKS(bark_speed/4), DS2TICKS(bark_speed/4) + DS2TICKS(bark_speed/4)) TICKS
			QDEL_IN(barkbox, total_delay)
			. = TRUE
		
		// Appearance actions
		if("set_hair_style")
			var/list/hair_styles = list()
			for(var/path in subtypesof(/datum/sprite_accessory/hair/head))
				var/datum/sprite_accessory/hair/head/H = path
				if(initial(H.name))
					hair_styles[initial(H.name)] = path
			var/new_style = tgui_input_list(user, "Select hair style:", "Hair Style", hair_styles)
			if(new_style)
				hairstyle = new_style
			. = TRUE
			
		if("set_hair_color")
			var/new_color = color_pick_sanitized(user, "Choose hair color:", "Hair Color", "#"+hair_color)
			if(new_color)
				hair_color = sanitize_hexcolor(new_color)
			. = TRUE
			
		if("set_facial_hair_style")
			var/list/facial_hair_styles = list()
			for(var/path in subtypesof(/datum/sprite_accessory/hair/facial))
				var/datum/sprite_accessory/hair/facial/F = path
				if(initial(F.name))
					facial_hair_styles[initial(F.name)] = path
			var/new_style = tgui_input_list(user, "Select facial hair style:", "Facial Hair", facial_hair_styles)
			if(new_style)
				facial_hairstyle = new_style
			. = TRUE
			
		if("set_facial_hair_color")
			var/new_color = color_pick_sanitized(user, "Choose facial hair color:", "Facial Hair Color", "#"+facial_hair_color)
			if(new_color)
				facial_hair_color = sanitize_hexcolor(new_color)
			. = TRUE
			
		if("set_skin_tone")
			var/listy = pref_species.get_skin_list()
			var/new_tone = tgui_input_list(user, "Select skin tone:", "Skin Tone", listy)
			if(new_tone)
				skin_tone = listy[new_tone]
				try_update_mutant_colors()
				debug_skin_tone_selection(user)
			. = TRUE
			
		if("set_eye_color")
			var/new_color = color_pick_sanitized(user, "Choose eye color:", "Eye Color", "#"+eye_color)
			if(new_color)
				eye_color = sanitize_hexcolor(new_color)
			. = TRUE
		
		if("set_markings")
			// Open body markings TGUI interface
			show_body_markings_tgui(user)
			. = TRUE
		
		if("set_features")
			// Open customizers TGUI interface
			show_customizers_tgui(user)
			. = TRUE
		
		if("set_description")
			// Open descriptors TGUI interface
			show_descriptors_tgui(user)
			. = TRUE
		
		// Virtues & flaws actions
		if("set_virtue")
			var/list/virtue_choices = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(!V.name)
					continue
				if((V.name == virtue.name || V.name == virtuetwo.name) && !istype(V, /datum/virtue/none))
					continue
				if(istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
					continue
				if(length(pref_species.restricted_virtues) && (V.type in pref_species.restricted_virtues))
					continue
				virtue_choices[V.name] = V
			virtue_choices = sort_list(virtue_choices)
			var/result = tgui_input_list(user, "Select virtue:", "Virtue", virtue_choices)
			if(result)
				var/datum/virtue/virtue_chosen = virtue_choices[result]
				virtue = virtue_chosen
				to_chat(user, process_virtue_text(virtue_chosen))
			. = TRUE
			
		if("set_virtue_two")
			if(statpack.name == "Virtuous")
				var/list/virtue_choices = list()
				for(var/path as anything in GLOB.virtues)
					var/datum/virtue/V = GLOB.virtues[path]
					if(!V.name)
						continue
					if((V.name == virtue.name || V.name == virtuetwo.name) && !istype(V, /datum/virtue/none))
						continue
					if(length(pref_species.restricted_virtues) && (V.type in pref_species.restricted_virtues))
						continue
					if(istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
						continue
					virtue_choices[V.name] = V
				virtue_choices = sort_list(virtue_choices)
				var/result = tgui_input_list(user, "Select second virtue:", "Second Virtue", virtue_choices)
				if(result)
					var/datum/virtue/virtue_chosen = virtue_choices[result]
					virtuetwo = virtue_chosen
					to_chat(user, process_virtue_text(virtue_chosen))
			. = TRUE
			
		if("set_charflaw")
			var/list/coom = GLOB.character_flaws.Copy()
			var/result = tgui_input_list(user, "Select vice:", "Vice", coom)
			if(result)
				result = coom[result]
				var/datum/charflaw/C = new result()
				charflaw = C
				if(charflaw.desc)
					to_chat(user, "<span class='info'>[charflaw.desc]</span>")
			. = TRUE
			
		if("set_patron")
			// Select from current pantheon's patrons
			var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
			if(selected_faith)
				var/list/patron_choices = list()
				for(var/patron_path in GLOB.patrons_by_faith[selected_faith.type])
					var/datum/patron/P = GLOB.patronlist[patron_path]
					if(P)
						patron_choices[P.name] = P
				var/result = tgui_input_list(user, "Select patron deity:", "Patron", patron_choices)
				if(result && patron_choices[result])
					selected_patron = patron_choices[result]
			. = TRUE
			
		if("set_pantheon")
			// Select pantheon/religion, then set patron to godhead
			var/list/available_faiths = list()
			
			// Add regular faiths (atheist, christian, hindu, voodoo, jewish, shinto)
			for(var/faith_path in GLOB.regular_faiths)
				var/datum/faith/F = GLOB.faithlist[faith_path]
				if(F)
					available_faiths[F.name] = faith_path
			
			// Add ascendant faiths only if the character has the ascendant worshipper trait
			if(has_trait(TRAIT_ASCENDANT_WORSHIPPER))
				for(var/faith_path in GLOB.ascendant_faiths)
					var/datum/faith/F = GLOB.faithlist[faith_path]
					if(F)
						available_faiths[F.name] = faith_path
			
			var/result = tgui_input_list(user, "Select pantheon/religion:", "Pantheon", available_faiths)
			if(result && available_faiths[result])
				var/selected_faith_path = available_faiths[result]
				var/datum/faith/selected_faith = GLOB.faithlist[selected_faith_path]
				if(selected_faith)
					// Set patron to godhead of the selected faith
					selected_patron = GLOB.patronlist[selected_faith.godhead]
					// Now allow selecting specific patron from this pantheon
					var/list/patron_choices = list()
					for(var/patron_path in GLOB.patrons_by_faith[selected_faith.type])
						var/datum/patron/P = GLOB.patronlist[patron_path]
						if(P)
							patron_choices[P.name] = P
					var/patron_result = tgui_input_list(user, "Select patron deity:", "Patron", patron_choices)
					if(patron_result && patron_choices[patron_result])
						selected_patron = patron_choices[patron_result]
			. = TRUE
		
		// Pointbuy stat system
		if("increase_stat")
			var/stat_name = params["stat"]
			if(stat_name)
				pointbuy_adjust(stat_name, 1)
			// Don't regenerate for stat changes - they don't change visual appearance
			return TRUE
			
		if("decrease_stat")
			var/stat_name = params["stat"]
			if(stat_name)
				pointbuy_adjust(stat_name, -1)
			// Don't regenerate for stat changes - they don't change visual appearance
			return TRUE
		
		if("select_trait")
			var/trait_key = params["trait_key"]
			if(!trait_key)
				. = TRUE
				return
				
			// Define trait pools for each stat. Strength/Intelligence/Perception each
			// have two selectable slots that both draw from the same pool for that
			// stat (a trait already chosen in one slot won't show up in the other).
			var/list/speed_traits = list(
				TRAIT_LEAPER,
				TRAIT_IGNORESLOWDOWN,
				TRAIT_DODGEEXPERT,
				TRAIT_LIGHT_STEP,
				TRAIT_WOODWALKER,
				TRAIT_UNCAPPED_SPEED
			)

			var/list/constitution_traits = list(
				TRAIT_BEAUTIFUL,
				TRAIT_IGNOREDAMAGESLOWDOWN,
				TRAIT_BREADY,
				TRAIT_CRITICAL_RESISTANCE,
				TRAIT_SHOCKIMMUNE,
				TRAIT_CRACKHEAD,
				TRAIT_GOODLOVER,
				TRAIT_APRICITY,
				TRAIT_HARDDISMEMBER,
				TRAIT_NOPAIN,
				TRAIT_TOXIMMUNE
			)

			var/list/strength_traits = list(
				TRAIT_STRONGBITE,
				TRAIT_STRONGKICK,
				TRAIT_MEDIUMARMOR,
				TRAIT_HEAVYARMOR,
				TRAIT_ABYSSOR_SWIM,
				TRAIT_STRENGTH_UNCAPPED,
				TRAIT_BIGGUY,
				TRAIT_DEATHBYSNUSNU
			)

			var/list/will_traits = list(
				TRAIT_STEELHEARTED,
				TRAIT_NOSTINK,
				TRAIT_TOLERANT,
				TRAIT_NIGHT_OWL,
				TRAIT_WILD_EATER,
				TRAIT_FORTITUDE,
				TRAIT_BETTER_SLEEP,
				TRAIT_NOPAINSTUN,
				TRAIT_ADRENALINE_RUSH,
				TRAIT_TRANSVESTITE
			)

			var/list/intelligence_traits = list(
				TRAIT_LITERACY,
				TRAIT_RITUALIST,
				TRAIT_SEEPRICES_SHITTY,
				TRAIT_SEEPRICES,
				TRAIT_EMPATH,
				TRAIT_SPELLCOCKBLOCK,
				TRAIT_ANTIMAGIC,
				TRAIT_INTELLECTUAL,
				TRAIT_SENTINELOFWITS,
				TRAIT_GOODTRAINER
			)

			var/list/perception_traits = list(
				TRAIT_NUTCRACKER,
				TRAIT_DECEIVING_MEEKNESS,
				TRAIT_COMBAT_AWARE,
				TRAIT_LEECHIMMUNE,
				TRAIT_PERFECT_TRACKER,
				TRAIT_LONGSTRIDER,
				TRAIT_SHARPER_BLADES,
				TRAIT_DUALWIELDER,
				TRAIT_KEENEARS,
				TRAIT_MATTHIOS_EYES,
				TRAIT_BLACKLEG
			)

			// Some traits require another trait from the same pool to already be
			// picked before they can be selected.
			var/static/list/trait_requisites = list(
				TRAIT_HEAVYARMOR = TRAIT_MEDIUMARMOR,
				TRAIT_BIGGUY = TRAIT_STRENGTH_UNCAPPED,
				TRAIT_DEATHBYSNUSNU = TRAIT_STRENGTH_UNCAPPED,
				TRAIT_SEEPRICES = TRAIT_SEEPRICES_SHITTY,
				TRAIT_ANTIMAGIC = TRAIT_SPELLCOCKBLOCK,
				TRAIT_SENTINELOFWITS = TRAIT_INTELLECTUAL,
				TRAIT_GOODTRAINER = TRAIT_INTELLECTUAL,
				TRAIT_LONGSTRIDER = TRAIT_LEECHIMMUNE
			)

			var/trait_var_to_set = null
			var/list/trait_choices = list()

			// Determine which trait variable to set based on trait_key
			switch(trait_key)
				if("strength1")
					if(CanStrTrait1)
						trait_var_to_set = "StrTrait1"
						trait_choices = strength_traits.Copy()
				if("strength2")
					if(CanStrTrait2)
						trait_var_to_set = "StrTrait2"
						trait_choices = strength_traits.Copy()
				if("constitution")
					if(CanConTrait)
						trait_var_to_set = "ConTrait"
						trait_choices = constitution_traits.Copy()
				if("intelligence1")
					if(CanIntTrait1)
						trait_var_to_set = "IntTrait1"
						trait_choices = intelligence_traits.Copy()
				if("intelligence2")
					if(CanIntTrait2)
						trait_var_to_set = "IntTrait2"
						trait_choices = intelligence_traits.Copy()
				if("speed")
					if(CanSpdTrait)
						trait_var_to_set = "SpdTrait"
						trait_choices = speed_traits.Copy()
				if("will")
					if(CanWilTrait)
						trait_var_to_set = "WilTrait"
						trait_choices = will_traits.Copy()
				if("perception1")
					if(CanPerTrait1)
						trait_var_to_set = "PerTrait1"
						trait_choices = perception_traits.Copy()
				if("perception2")
					if(CanPerTrait2)
						trait_var_to_set = "PerTrait2"
						trait_choices = perception_traits.Copy()
				if("neg_race")
					// Optional negative trait, shown beside the racial trait slot.
					trait_var_to_set = "NegRaceTrait"
					trait_choices = list(
						"None",
						TRAIT_CYCLOPS_LEFT,
						TRAIT_CYCLOPS_RIGHT,
						TRAIT_PERMAMUTE
					)
				if("race")
					// Racial traits - species-specific.
					// TRAIT_ASCENDANT_WORSHIPPER is available to every race - it unlocks
					// Ascendant faiths as patrons (this replaces the old separate
					// TRAIT_IDOLIST/TRAIT_CULTIST traits).
					var/list/racial_traits = list(TRAIT_ASCENDANT_WORSHIPPER)

					// TRAIT_CIVILIZED is only offered to races that are shunned or
					// despised by wider society - it lets them ignore race-based role
					// restrictions up to Tolerated races, at the cost of losing their
					// innate racial stat bonuses on spawn.
					if((pref_species.type in RACES_SHUNNED) || (pref_species.type in RACES_DESPISED))
						racial_traits += TRAIT_CIVILIZED

					// Define race-specific racial traits. Subrace checks (gnome, drow,
					// half-elf, half-orc) are placed before their parent race's check
					// since istype() matches subtypes too.
					if(istype(pref_species, /datum/species/dwarf/gnome))
						racial_traits += list(
							TRAIT_ARCYNE_T1,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/dwarf))
						racial_traits += list(
							TRAIT_DRUNK_HEALING,
							TRAIT_DWARF_REPAIR,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/elf))
						// Covers both the Elf and Drow subraces
						racial_traits += list(
							TRAIT_DARKVISION,
							TRAIT_ARCYNE_T1,
							TRAIT_NOBLE,
							TRAIT_KEENEARS
						)
					else if(istype(pref_species, /datum/species/human/halfelf))
						racial_traits += list(
							TRAIT_DARKVISION,
							TRAIT_KEENEARS
						)
					else if(istype(pref_species, /datum/species/halforc))
						racial_traits += list(
							TRAIT_DEATHBYSNUSNU,
							TRAIT_STRENGTH_UNCAPPED,
							TRAIT_NOPAINSTUN
						)
					else if(istype(pref_species, /datum/species/tieberian))
						// Tiefling
						racial_traits += list(
							TRAIT_HELLSPAWN,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/kobold))
						racial_traits += TRAIT_DARKVISION
					else if(istype(pref_species, /datum/species/anthromorph))
						racial_traits += list(
							TRAIT_NATURALARMOR,
							TRAIT_STRONGBITE,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/dracon))
						racial_traits += TRAIT_SCALEARMOR
					else if(istype(pref_species, /datum/species/goblin))
						racial_traits += TRAIT_DARKVISION
					else if(istype(pref_species, /datum/species/harpy))
						racial_traits += TRAIT_WING_BOUND
					else if(istype(pref_species, /datum/species/lamia))
						racial_traits += list(
							TRAIT_VENOMOUS,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/lizardfolk))
						racial_traits += list(
							TRAIT_SCALEARMOR,
							TRAIT_STRONGBITE
						)
					else if(istype(pref_species, /datum/species/akula))
						racial_traits += list(
							TRAIT_SEA_DRINKER,
							TRAIT_STRONGBITE
						)
					else if(istype(pref_species, /datum/species/anthromorphsmall))
						racial_traits += list(
							TRAIT_ZJUMP,
							TRAIT_DARKVISION
						)
					else if(istype(pref_species, /datum/species/human))
						// Humen
						racial_traits += TRAIT_HUMEN_INGENUITY

					trait_var_to_set = "RaceTrait"
					trait_choices = racial_traits.Copy()
			
			// For the pointbuy stat trait pools, drop any trait that's already
			// chosen in the pool's other slot (no picking the same trait twice)
			// and any trait whose requisite hasn't been picked yet.
			if(trait_var_to_set && (trait_var_to_set != "RaceTrait") && (trait_var_to_set != "NegRaceTrait"))
				var/current_value = vars[trait_var_to_set]
				var/list/filtered_choices = list()
				for(var/candidate in trait_choices)
					if(has_trait(candidate) && (candidate != current_value))
						continue
					var/requisite = trait_requisites[candidate]
					if(requisite && !has_trait(requisite))
						continue
					filtered_choices += candidate
				trait_choices = filtered_choices

			if(!trait_var_to_set || !length(trait_choices))
				. = TRUE
				return
			
			// Show trait selection dialog
			var/result = tgui_input_list(user, "Select a trait:", "Trait Selection", trait_choices)
			if(result && (result in trait_choices))
				// Track what traits we had before the change for exploit prevention
				var/had_ascendant_worshipper = has_trait(TRAIT_ASCENDANT_WORSHIPPER)
				var/had_transvestite = has_trait(TRAIT_TRANSVESTITE)

				vars[trait_var_to_set] = (result == "None") ? null : result
				to_chat(user, span_notice("Trait selected: [result]"))
				// Output trait description to chat
				var/trait_desc = get_trait_description(result)
				if(trait_desc)
					to_chat(user, "<span class='info'>[trait_desc]</span>")
				// If the transvestite trait changed, update genital customizers
				if(trait_var_to_set == "WilTrait" && result == TRAIT_TRANSVESTITE)
					genderize_customizer_entries()

				// Exploit prevention: reset religion/patron if the ascendant worshipper trait was changed
				if(had_ascendant_worshipper && !has_trait(TRAIT_ASCENDANT_WORSHIPPER))
					if(selected_patron?.associated_faith)
						var/datum/faith/F = GLOB.faithlist[selected_patron.associated_faith]
						if(F && (F.type in GLOB.ascendant_faiths))
							selected_patron = GLOB.patronlist[default_patron]

				// Exploit prevention: reset gender-locked jobs if transvestite trait was changed
				if(had_transvestite && !has_trait(TRAIT_TRANSVESTITE))
					validate_gender_locked_jobs()

			. = TRUE
		
		// Tab change - switching tabs never changes the character's
		// appearance/loadout by itself, so there is nothing to
		// regenerate here. The preview is already up to date from
		// whichever action last actually changed a visual preference
		// (each of those already regenerates it exactly once via the
		// trailing "if(.) regenerate_character_preview()" below). This
		// used to unconditionally call regenerate_character_preview()
		// here too, which - on top of that same trailing catch-all -
		// meant every single tab switch paid for a full 4-direction
		// mannequin re-render TWICE for no reason, which is why
		// switching to the Appearance/Loadout tabs felt so slow.
		if("change_tab")
			var/new_tab = text2num(params["tab"])
			if(!isnull(new_tab))
				current_tab = new_tab
			// Don't regenerate for change_tab - it doesn't change visual prefs
			return TRUE

		// Loadout system - roles
		//
		// NOTE: None of the loadout branches below call
		// regenerate_character_preview() themselves anymore - they all
		// fall through to the trailing "if(.) regenerate_character_preview()"
		// at the end of this proc (since they all set `. = TRUE`), which
		// already regenerates the preview exactly once for every one of
		// them. Calling it again here as well as there used to double
		// the cost of every loadout action (each one is a full
		// 4-direction mannequin re-render) for nothing.
		if("add_role_loadout")
			var/job_path = text2path(params["job_path"])
			if(job_path)
				add_role_loadout(job_path, user)
				var/datum/job/added_job = job_path
				loadout_preview_role = initial(added_job.title)
			. = TRUE

		if("remove_role_loadout")
			var/job_title = params["job_title"]
			if(job_title)
				remove_role_loadout(job_title)
				if(loadout_preview_role == job_title)
					loadout_preview_role = null
			. = TRUE

		// Switches which added role's outfit the Loadout tab preview shows,
		// without changing any preference (see loadout_preview_role).
		if("set_preview_role")
			var/job_title = params["job_title"]
			if(job_title && (job_title in job_preferences))
				loadout_preview_role = job_title
			. = TRUE

		if("set_role_priority")
			var/job_title = params["job_title"]
			var/level = text2num(params["level"])
			if(job_title && (level == JP_HIGH || level == JP_MEDIUM || level == JP_LOW))
				set_role_priority(job_title, level)
				loadout_preview_role = job_title
			. = TRUE

		if("set_role_subclass")
			var/job_title = params["job_title"]
			var/subclass_path = text2path(params["subclass_path"])
			if(job_title)
				set_role_subclass(job_title, subclass_path)
				loadout_preview_role = job_title
			. = TRUE

		if("select_role_loadout_item")
			var/job_title = params["job_title"]
			var/item_path = text2path(params["item_path"])
			var/category = params["category"]
			if(job_title && item_path && category)
				select_role_loadout_item(job_title, item_path, category)
				loadout_preview_role = job_title
			. = TRUE

		// Opens a tgui list popup (same style as the patron/vice pickers) so
		// the player can pick which item fills a paper doll slot directly,
		// rather than clicking through every option one at a time.
		if("pick_role_loadout_item")
			var/job_title = params["job_title"]
			var/category = params["category"]
			if(job_title && category)
				pick_role_loadout_item(user, job_title, category)
				loadout_preview_role = job_title
			. = TRUE

		// Opens a tgui list popup (same style as the Dye Station) so the
		// player can dye whatever item currently fills a paper doll slot.
		// Dyeing is only ever offered here, in the Loadout tab - never on
		// the live in-game paper doll.
		if("dye_role_loadout_item")
			var/job_title = params["job_title"]
			var/category = params["category"]
			if(job_title && category)
				dye_role_loadout_item(user, job_title, category)
				loadout_preview_role = job_title
			. = TRUE

		// Dressup Mode - toggles whether pick_role_loadout_item() offers
		// every matching item in the game for a slot, instead of just the
		// role's own loadout pool. Preview/export tool only, see the
		// dressup_mode var above for why this can never affect what
		// actually gets equipped at round start.
		if("toggle_dressup_mode")
			dressup_mode = !dressup_mode
			. = TRUE

		// Occupation Preferences modal open/close - see
		// showing_occupation_menu for why ui_data() needs to know this.
		if("open_occupation_menu")
			showing_occupation_menu = TRUE
			. = TRUE

		if("close_occupation_menu")
			showing_occupation_menu = FALSE
			. = TRUE

		// Exports the currently displayed role's fully-equipped paper doll
		// as a text file formatted as ready-to-paste outfit datum var
		// assignments (ex: "shirt = /obj/item/..."), so it can be pasted
		// straight into a /datum/outfit's body to recreate the look.
		if("export_dressup_outfit")
			var/job_title = params["job_title"]
			if(job_title)
				export_dressup_outfit(user, job_title)
			. = TRUE
		
		// Edit tattoos
		if("view_tattoos")
			show_tattoos_tgui(user)
			. = TRUE

		// Game Settings toggles
		if("toggle_tgui_fancy")
			tgui_fancy = !tgui_fancy
			. = TRUE
			
		if("toggle_tgui_lock")
			tgui_lock = !tgui_lock
			. = TRUE
			
		if("toggle_hotkeys")
			hotkeys = !hotkeys
			parent.update_movement_keys()
			. = TRUE
			
		if("toggle_chat_on_map")
			chat_on_map = !chat_on_map
			. = TRUE
			
		if("toggle_showrolls")
			showrolls = !showrolls
			. = TRUE
			
		if("toggle_windowflashing")
			windowflashing = !windowflashing
			. = TRUE
		
		// Job/Occupation preference actions
		if("set_job_preference")
			var/job_title = params["job"]
			var/level = text2num(params["level"])
			if(!job_title || isnull(level))
				return
			
			if(!SSjob || SSjob.occupations.len <= 0)
				return
			
			var/datum/job/job = SSjob.GetJob(job_title)
			if(!job)
				return
			
			// Convert level to JP constant (1=High, 2=Medium, 3=Low, 4=Never)
			var/jpval = null
			switch(level)
				if(1)
					jpval = JP_HIGH
				if(2)
					jpval = JP_MEDIUM
				if(3)
					jpval = JP_LOW
				if(4)
					jpval = null
			
			#ifdef USES_PQ
			// PQ check
			if(job.required && !isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
				if(jpval != JP_LOW && jpval != null)
					to_chat(user, span_danger("You have too low PQ for this role. You may only set it to low."))
					jpval = JP_LOW
			#endif
			
			// Preview now follows whichever role the player just set a
			// preference level for (rather than only ever the HIGH priority
			// role), so always regenerate here.
			SetJobPreferenceLevel(job, jpval)
			loadout_preview_role = job_title
			. = TRUE
		
		if("toggle_joblessrole")
			if(joblessrole == RETURNTOLOBBY)
				joblessrole = BERANDOMJOB
			else
				joblessrole = RETURNTOLOBBY
			// Don't regenerate for joblessrole toggle - it doesn't change visual appearance
			return TRUE
		
		if("reset_job_preferences")
			ResetJobs()
			. = TRUE
		
		// Character management actions
		if("save_character")
			save_preferences()
			save_character()
			to_chat(user, span_notice("CHARACTER SAVED."))
			. = TRUE
			
		if("randomize_character")
			random_character(gender, FALSE, FALSE)
			. = TRUE
			
		if("load_character")
			var/list/choices = list()
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					for(var/i=1, i<=max_save_slots, i++)
						var/name
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Slot [i]"
						choices[name] = i
			var/choice = tgui_input_list(user, "Choose a character:", "Load Character", choices)
			if(choice)
				choice = choices[choice]
				if(!load_character(choice))
					random_character(null, FALSE, FALSE)
					save_character()
			. = TRUE
		
		if("toggle_ready")
			var/mob/dead/new_player/N = user
			if(istype(N))
				// Only allow toggling during pregame
				if(SSticker.current_state <= GAME_STATE_PREGAME)
					var/new_ready = N.ready == PLAYER_READY_TO_PLAY ? PLAYER_NOT_READY : PLAYER_READY_TO_PLAY
					if(new_ready == PLAYER_READY_TO_PLAY)
						// Check requirements before allowing ready
						if(length(flavortext) < MINIMUM_FLAVOR_TEXT)
							to_chat(user, span_boldwarning("You need a minimum of [MINIMUM_FLAVOR_TEXT] characters in your flavor text in order to play."))
							return TRUE
						if(length(ooc_notes) < MINIMUM_OOC_NOTES)
							to_chat(user, span_boldwarning("You need at least a few words in your OOC notes in order to play."))
							return TRUE
					N.ready = new_ready
					if(new_ready == PLAYER_READY_TO_PLAY)
						log_game("([user || "NO KEY"]) readied as ([real_name])")
						to_chat(user, span_notice("You are now READY to spawn at round start."))
					else
						to_chat(user, span_notice("You are now UNREADY. You will not spawn at round start."))
			// Don't regenerate for toggle_ready - it doesn't change visual prefs
			return TRUE
		
		if("late_join")
			var/mob/dead/new_player/N = user
			if(istype(N))
				// Trigger the late join by calling the Topic handler
				N.Topic("", list("late_join" = "1"))
			// Don't regenerate for late_join - it doesn't change prefs
			return TRUE
		
		if("join_as_job")
			var/mob/dead/new_player/N = user
			if(istype(N))
				var/selected_job = params["job"]
				if(selected_job)
					// Trigger the job selection by calling the Topic handler
					N.Topic("", list("SelectedJob" = selected_job))
			// Don't regenerate for join_as_job - it doesn't change prefs
			return TRUE

	if(.)
		regenerate_character_preview()
		// Note: Preferences are only saved when the user presses the 💾 SAVE FILE button (save_character action)
		// This prevents unnecessary disk I/O and allows users to experiment with changes before committing

// ===== BODY MARKINGS TGUI INTERFACE =====
/datum/preferences/proc/show_body_markings_tgui(mob/user)
	var/datum/body_markings_ui/ui_datum = new(src)
	ui_datum.ui_interact(user)

/datum/body_markings_ui
	var/datum/preferences/preferences

/datum/body_markings_ui/New(datum/preferences/prefs)
	. = ..()
	preferences = prefs

/datum/body_markings_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyMarkings")
		ui.open()

/datum/body_markings_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/body_markings_ui/ui_data(mob/user)
	var/list/data = list()
	
	// Fixed dark fantasy theme - there is no theme selector.
	data["theme"] = preferences.get_creator_theme()
	
	// Body markings data organized by zone
	var/list/zones_data = list()
	for(var/zone in GLOB.marking_zones)
		var/list/markings_in_zone = list()
		if(preferences.body_markings[zone])
			var/marking_count = length(preferences.body_markings[zone])
			var/index = 1
			for(var/marking_name in preferences.body_markings[zone])
				markings_in_zone += list(list(
					"name" = marking_name,
					"color" = preferences.body_markings[zone][marking_name],
					"index" = index,
					"can_move_up" = (index > 1),
					"can_move_down" = (index < marking_count)
				))
				index++
		
		var/list/available_markings = marking_list_of_zone_for_species(zone, preferences.pref_species)
		if(preferences.body_markings[zone])
			for(var/existing in preferences.body_markings[zone])
				available_markings -= existing
		
		zones_data += list(list(
			"zone" = zone,
			"zone_name" = get_zone_name(zone),
			"markings" = markings_in_zone,
			"can_add" = (!preferences.body_markings[zone] || length(preferences.body_markings[zone]) < MAXIMUM_MARKINGS_PER_LIMB),
			"available_markings" = available_markings
		))
	
	data["zones"] = zones_data
	data["presets"] = marking_sets_for_species(preferences.pref_species)
	
	return data

/datum/body_markings_ui/proc/get_zone_name(zone)
	switch(zone)
		if(BODY_ZONE_R_ARM)
			return "Right Arm"
		if(BODY_ZONE_L_ARM)
			return "Left Arm"
		if(BODY_ZONE_HEAD)
			return "Head"
		if(BODY_ZONE_CHEST)
			return "Chest"
		if(BODY_ZONE_R_LEG)
			return "Right Leg"
		if(BODY_ZONE_L_LEG)
			return "Left Leg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "Right Hand"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "Left Hand"
	return zone

/datum/body_markings_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	
	var/zone = params["zone"]
	var/marking_name = params["name"]
	
	switch(action)
		if("move_up")
			if(!preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			var/list/marking_list = preferences.body_markings[zone]
			var/current_index = LAZYFIND(marking_list, marking_name)
			if(!current_index || --current_index < 1)
				return TRUE
			var/marking_content = marking_list[marking_name]
			marking_list -= marking_name
			marking_list.Insert(current_index, marking_name)
			marking_list[marking_name] = marking_content
			. = TRUE
			
		if("move_down")
			if(!preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			var/list/marking_list = preferences.body_markings[zone]
			var/current_index = LAZYFIND(marking_list, marking_name)
			if(!current_index || ++current_index > length(marking_list))
				return TRUE
			var/marking_content = marking_list[marking_name]
			marking_list -= marking_name
			marking_list.Insert(current_index, marking_name)
			marking_list[marking_name] = marking_content
			. = TRUE
			
		if("change_marking")
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, preferences.pref_species)
			if(preferences.body_markings[zone])
				for(var/keyed_name in preferences.body_markings[zone])
					possible_candidates -= keyed_name
			if(!length(possible_candidates))
				return TRUE
			var/desired_marking = tgui_input_list(usr, "Choose a marking to change to:", "Change Marking", possible_candidates)
			if(!desired_marking || !preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			var/held_index = LAZYFIND(preferences.body_markings[zone], marking_name)
			var/datum/body_marking/BD = GLOB.body_markings[desired_marking]
			var/marking_content = BD.get_default_color(preferences.features, preferences.pref_species)
			preferences.body_markings[zone] -= marking_name
			preferences.body_markings[zone].Insert(held_index, desired_marking)
			preferences.body_markings[zone][desired_marking] = marking_content
			. = TRUE
			
		if("change_color")
			if(!preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			var/color = preferences.body_markings[zone][marking_name]
			var/new_color = input(usr, "Choose marking color:", "Marking Color", "#[color]") as color|null
			if(!new_color || !preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			preferences.body_markings[zone][marking_name] = sanitize_hexcolor(new_color, 6)
			. = TRUE
			
		if("reset_color")
			if(!preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			var/datum/body_marking/BM = GLOB.body_markings[marking_name]
			preferences.body_markings[zone][marking_name] = BM.get_default_color(preferences.features, preferences.pref_species)
			. = TRUE
			
		if("remove_marking")
			if(!preferences.body_markings[zone] || !(marking_name in preferences.body_markings[zone]))
				return TRUE
			preferences.body_markings[zone] -= marking_name
			if(!length(preferences.body_markings[zone]))
				preferences.body_markings -= zone
			. = TRUE
			
		if("add_marking")
			if(!GLOB.body_markings_per_limb[zone])
				return TRUE
			var/list/possible_candidates = marking_list_of_zone_for_species(zone, preferences.pref_species)
			if(preferences.body_markings[zone])
				if(length(preferences.body_markings[zone]) >= MAXIMUM_MARKINGS_PER_LIMB)
					return TRUE
				for(var/keyed_name in preferences.body_markings[zone])
					possible_candidates -= keyed_name
			if(!length(possible_candidates))
				return TRUE
			var/desired_marking = tgui_input_list(usr, "Choose a marking to add:", "Add Marking", possible_candidates)
			if(!desired_marking)
				return TRUE
			var/datum/body_marking/BD = GLOB.body_markings[desired_marking]
			if(!preferences.body_markings[zone])
				preferences.body_markings[zone] = list()
			preferences.body_markings[zone][BD.name] = BD.get_default_color(preferences.features, preferences.pref_species)
			. = TRUE
			
		if("use_preset")
			var/list/candidates = marking_sets_for_species(preferences.pref_species)
			if(!length(candidates))
				return TRUE
			var/desired_set = tgui_input_list(usr, "Choose a markings preset (This will clear existing markings):", "Markings Preset", candidates)
			if(!desired_set)
				return TRUE
			var/datum/body_marking_set/BMS = GLOB.body_marking_sets[desired_set]
			preferences.body_markings = assemble_body_markings_from_set(BMS, preferences.features, preferences.pref_species)
			. = TRUE
			
		if("reset_all_colors")
			preferences.reset_body_marking_colors()
			. = TRUE
	
	if(.)
		preferences.regenerate_character_preview()
		preferences.save_preferences()
		SStgui.update_uis(preferences)

// ===== CUSTOMIZERS TGUI INTERFACE =====
/datum/preferences/proc/show_customizers_tgui(mob/user)
	var/datum/customizers_ui/ui_datum = new(src)
	ui_datum.ui_interact(user)

/datum/customizers_ui
	var/datum/preferences/preferences

/datum/customizers_ui/New(datum/preferences/prefs)
	. = ..()
	preferences = prefs

/datum/customizers_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Customizers")
		ui.open()

/datum/customizers_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/customizers_ui/ui_data(mob/user)
	var/list/data = list()
	
	// Fixed dark fantasy theme - there is no theme selector.
	data["theme"] = preferences.get_creator_theme()
	
	// Build list of allowed customizers
	var/list/allowed_customizers = list()
	if(preferences.pref_species)
		var/list/customizers = preferences.pref_species.customizers
		if(customizers)
			for(var/customizer_type in customizers)
				var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
				if(!customizer.is_allowed(preferences))
					continue
				var/datum/customizer_entry/entry = preferences.get_customizer_entry_for_customizer_type(customizer_type)
				if(!entry)
					continue
				allowed_customizers += customizer_type
	
	// Customizer entries data with full details
	var/list/customizers_data = list()
	var/total_count = length(allowed_customizers)
	for(var/i in 1 to total_count)
		var/customizer_type = allowed_customizers[i]
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		var/datum/customizer_entry/entry = preferences.get_customizer_entry_for_customizer_type(customizer_type)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		
		// Get available choices
		var/list/available_choices = list()
		for(var/choice_type in customizer.customizer_choices)
			var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
			available_choices += list(list(
				"name" = iter_choice.name,
				"type" = "[choice_type]"
			))
		
		// Get accessory details if applicable
		var/accessory_name = null
		var/list/accessory_colors = list()
		var/list/available_accessories = list()
		if(choice.sprite_accessories && entry.accessory_type)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
			accessory_name = accessory.name
			if(choice.allows_accessory_color_customization && !accessory.color_disabled)
				var/list/color_list = color_string_to_list(entry.accessory_colors)
				for(var/color_index in 1 to accessory.color_keys)
					var/named_index = (accessory.color_keys == 1) ? accessory.color_key_name : accessory.color_key_names[color_index]
					accessory_colors += list(list(
						"name" = named_index,
						"color" = color_list[color_index],
						"index" = color_index
					))
			// Get available accessories
			for(var/acc_type in choice.sprite_accessories)
				var/datum/sprite_accessory/acc = SPRITE_ACCESSORY(acc_type)
				available_accessories += list(list(
					"name" = acc.name,
					"type" = "[acc_type]"
				))
		
		// Special handling for hair and eye colors
		var/hair_color = null
		var/eye_color = null
		if(istype(entry, /datum/customizer_entry/hair))
			var/datum/customizer_entry/hair/hair_entry = entry
			hair_color = hair_entry.hair_color
		if(istype(entry, /datum/customizer_entry/organ/eyes))
			var/datum/customizer_entry/organ/eyes/eyes_entry = entry
			eye_color = eyes_entry.eye_color
		
		customizers_data += list(list(
			"name" = customizer.name,
			"choice" = choice.name,
			"type" = "[customizer_type]",
			"choice_type" = "[entry.customizer_choice_type]",
			"disabled" = entry.disabled,
			"allows_disabling" = customizer.allows_disabling,
			"index" = i,
			"can_move_up" = (i > 1),
			"can_move_down" = (i < total_count),
			"available_choices" = available_choices,
			"has_multiple_choices" = (length(customizer.customizer_choices) > 1),
			"accessory_name" = accessory_name,
			"accessory_colors" = accessory_colors,
			"available_accessories" = available_accessories,
			"has_multiple_accessories" = (length(available_accessories) > 1),
			"hair_color" = hair_color,
			"eye_color" = eye_color
		))
	data["customizers"] = customizers_data
	
	return data

/datum/customizers_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	
	var/customizer_type = text2path(params["customizer_type"])
	var/datum/customizer_entry/entry = preferences.get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return TRUE
	
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	
	switch(action)
		if("move_up")
			// Find current index in customizer_entries
			var/current_index = preferences.customizer_entries.Find(entry)
			if(current_index && current_index > 1)
				preferences.customizer_entries.Swap(current_index, current_index - 1)
			. = TRUE
			
		if("move_down")
			var/current_index = preferences.customizer_entries.Find(entry)
			if(current_index && current_index < length(preferences.customizer_entries))
				preferences.customizer_entries.Swap(current_index, current_index + 1)
			. = TRUE
			
		if("toggle_disabled")
			if(customizer.allows_disabling)
				entry.disabled = !entry.disabled
			. = TRUE
			
		if("change_choice")
			var/new_choice_type = text2path(params["new_choice_type"])
			if(new_choice_type == entry.customizer_choice_type)
				return TRUE
			preferences.customizer_entries -= entry
			preferences.customizer_entries += customizer.create_customizer_entry(preferences, new_choice_type)
			. = TRUE
			
		if("choose_accessory")
			var/new_accessory_type = text2path(params["accessory_type"])
			if(!choice.sprite_accessories || !(new_accessory_type in choice.sprite_accessories))
				return TRUE
			choice.set_accessory_type(preferences, new_accessory_type, entry)
			. = TRUE
		
		if("choose_accessory_from_list")
			if(!choice.sprite_accessories)
				return TRUE
			var/list/accessory_list = list()
			for(var/acc_type in choice.sprite_accessories)
				var/datum/sprite_accessory/acc = SPRITE_ACCESSORY(acc_type)
				accessory_list[acc.name] = acc_type
			if(!length(accessory_list))
				return TRUE
			var/chosen_name = tgui_input_list(usr, "Select [lowertext(customizer.name)] style:", "Character Features", accessory_list)
			if(!chosen_name)
				return TRUE
			var/chosen_type = accessory_list[chosen_name]
			choice.set_accessory_type(preferences, chosen_type, entry)
			. = TRUE
			
		if("rotate_accessory")
			if(!choice.sprite_accessories)
				return TRUE
			var/current_index
			var/i = 0
			for(var/accessory_type in choice.sprite_accessories)
				i++
				if(entry.accessory_type != accessory_type)
					continue
				current_index = i
				break
			var/target_index = current_index
			var/direction = params["direction"]
			if(direction == "next")
				target_index++
			else if(direction == "prev")
				target_index--
			if(target_index > length(choice.sprite_accessories))
				target_index = 1
			else if(target_index <= 0)
				target_index = length(choice.sprite_accessories)
			choice.set_accessory_type(preferences, choice.sprite_accessories[target_index], entry)
			. = TRUE
			
		if("change_accessory_color")
			if(!choice.sprite_accessories || !choice.allows_accessory_color_customization)
				return TRUE
			var/color_index = text2num(params["color_index"])
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
			if(color_index > accessory.color_keys)
				return TRUE
			var/list/color_list = color_string_to_list(entry.accessory_colors)
			var/new_color = input(usr, "Choose accessory color:", "Accessory Color", "[color_list[color_index]]") as color|null
			if(!new_color)
				return TRUE
			color_list[color_index] = sanitize_hexcolor(new_color, 6, TRUE)
			entry.accessory_colors = color_list_to_string(color_list)
			. = TRUE
			
		if("reset_accessory_colors")
			if(!choice.sprite_accessories || !choice.allows_accessory_color_customization)
				return TRUE
			choice.reset_accessory_colors(preferences, entry)
			. = TRUE
		
		if("change_hair_color")
			if(!istype(entry, /datum/customizer_entry/hair))
				return TRUE
			var/datum/customizer_entry/hair/hair_entry = entry
			var/new_color = input(usr, "Choose hair color:", "Hair Color", hair_entry.hair_color) as color|null
			if(!new_color)
				return TRUE
			hair_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
			. = TRUE
		
		if("change_eye_color")
			if(!istype(entry, /datum/customizer_entry/organ/eyes))
				return TRUE
			var/datum/customizer_entry/organ/eyes/eyes_entry = entry
			var/new_color = input(usr, "Choose eye color:", "Eye Color", eyes_entry.eye_color) as color|null
			if(!new_color)
				return TRUE
			eyes_entry.eye_color = sanitize_hexcolor(new_color, 6, TRUE)
			. = TRUE
	
	if(.)
		preferences.regenerate_character_preview()
		preferences.save_preferences()
		SStgui.update_uis(preferences)
		if(ishuman(usr))
			var/mob/living/carbon/human/humanized = usr
			humanized.update_body_parts(TRUE)

// ===== DESCRIPTORS TGUI INTERFACE =====
/datum/preferences/proc/show_descriptors_tgui(mob/user)
	var/datum/descriptors_ui/ui_datum = new(src)
	ui_datum.ui_interact(user)

/datum/descriptors_ui
	var/datum/preferences/preferences

/datum/descriptors_ui/New(datum/preferences/prefs)
	. = ..()
	preferences = prefs

/datum/descriptors_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Descriptors")
		ui.open()

/datum/descriptors_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/descriptors_ui/ui_data(mob/user)
	var/list/data = list()
	
	// Fixed dark fantasy theme - there is no theme selector.
	data["theme"] = preferences.get_creator_theme()
	
	// Descriptor entries data with available options
	var/list/descriptors_data = list()
	if(preferences.pref_species)
		var/descriptor_count = length(preferences.descriptor_entries)
		var/i = 1
		for(var/choice_type in preferences.pref_species.descriptor_choices)
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			var/datum/descriptor_entry/entry = preferences.get_descriptor_entry_for_choice(choice_type)
			if(!entry)
				continue
			var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(entry.descriptor_type)
			
			// Get available descriptors for this choice
			var/list/available_descriptors = list()
			for(var/desc_type in choice.descriptors)
				var/datum/mob_descriptor/desc = MOB_DESCRIPTOR(desc_type)
				available_descriptors += list(list(
					"name" = desc.name,
					"type" = "[desc_type]"
				))
			
			descriptors_data += list(list(
				"choice_name" = choice.name,
				"descriptor_name" = descriptor.name,
				"choice_type" = "[choice_type]",
				"descriptor_type" = "[entry.descriptor_type]",
				"index" = i,
				"can_move_up" = (i > 1),
				"can_move_down" = (i < descriptor_count),
				"available_descriptors" = available_descriptors
			))
			i++
	data["descriptors"] = descriptors_data
	
	// Custom descriptors data
	var/static/list/prefix_translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/static/list/prefix_input_list = CUSTOM_PREFIX_INPUT_LIST
	var/list/custom_descriptors_data = list()
	for(var/i in 1 to length(preferences.custom_descriptors))
		// Check if this custom descriptor is visible
		var/show_custom = FALSE
		if(i == 1 && preferences.has_descriptor_type_in_entries(/datum/mob_descriptor/prominent/custom/one))
			show_custom = TRUE
		else if(i == 2 && preferences.has_descriptor_type_in_entries(/datum/mob_descriptor/prominent/custom/two))
			show_custom = TRUE
		
		if(!show_custom)
			continue
			
		var/datum/custom_descriptor_entry/custom_entry = preferences.custom_descriptors[i]
		custom_descriptors_data += list(list(
			"index" = i,
			"prefix" = custom_entry.prefix_type,
			"prefix_text" = prefix_translation["[custom_entry.prefix_type]"],
			"content" = custom_entry.content_text,
			"available_prefixes" = prefix_input_list
		))
	data["custom_descriptors"] = custom_descriptors_data
	
	return data

/datum/descriptors_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	
	switch(action)
		if("move_up")
			var/index = text2num(params["index"])
			if(index && index > 1 && index <= length(preferences.descriptor_entries))
				preferences.descriptor_entries.Swap(index, index - 1)
			. = TRUE
			
		if("move_down")
			var/index = text2num(params["index"])
			if(index && index < length(preferences.descriptor_entries))
				preferences.descriptor_entries.Swap(index, index + 1)
			. = TRUE
			
		if("change_descriptor")
			var/choice_type = text2path(params["choice_type"])
			if(!(choice_type in preferences.pref_species.descriptor_choices))
				return TRUE
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			var/new_descriptor_type = text2path(params["descriptor_type"])
			if(!new_descriptor_type)
				// No specific descriptor_type was supplied by the client -
				// open a selection list of every available descriptor for
				// this choice, same as clicking a marking name does.
				var/list/descriptor_choices = list()
				for(var/desc_type in choice.descriptors)
					var/datum/mob_descriptor/desc = MOB_DESCRIPTOR(desc_type)
					descriptor_choices[desc.name] = desc_type
				if(!length(descriptor_choices))
					return TRUE
				var/result = tgui_input_list(usr, "Choose [choice.name]:", "Select Descriptor", descriptor_choices)
				if(!result)
					return TRUE
				new_descriptor_type = descriptor_choices[result]
			if(!(new_descriptor_type in choice.descriptors))
				return TRUE
			var/datum/descriptor_entry/entry = preferences.get_descriptor_entry_for_choice(choice_type)
			if(!entry)
				return TRUE
			entry.descriptor_type = new_descriptor_type
			. = TRUE

		if("rotate_descriptor")
			var/choice_type = text2path(params["choice_type"])
			var/direction = params["direction"]
			if(!(choice_type in preferences.pref_species.descriptor_choices))
				return TRUE
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			if(!length(choice.descriptors))
				return TRUE
			var/datum/descriptor_entry/entry = preferences.get_descriptor_entry_for_choice(choice_type)
			if(!entry)
				return TRUE
			var/current_index = choice.descriptors.Find(entry.descriptor_type)
			if(!current_index)
				current_index = 1
			if(direction == "next")
				current_index = current_index >= length(choice.descriptors) ? 1 : current_index + 1
			else
				current_index = current_index <= 1 ? length(choice.descriptors) : current_index - 1
			entry.descriptor_type = choice.descriptors[current_index]
			. = TRUE
			
		if("change_custom_prefix")
			var/index = text2num(params["index"])
			var/new_prefix = text2num(params["prefix"])
			if(index > 0 && index <= length(preferences.custom_descriptors))
				var/datum/custom_descriptor_entry/custom_entry = preferences.custom_descriptors[index]
				custom_entry.prefix_type = sanitize_integer(new_prefix, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
			. = TRUE
			
		if("change_custom_content")
			var/index = text2num(params["index"])
			var/new_content = params["content"]
			if(index > 0 && index <= length(preferences.custom_descriptors))
				var/datum/custom_descriptor_entry/custom_entry = preferences.custom_descriptors[index]
				custom_entry.content_text = STRIP_HTML_SIMPLE(lowertext(new_content), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			. = TRUE
	
	if(.)
		// Note: Descriptors don't affect visual appearance, so no preview regeneration or UI update needed
		preferences.save_preferences()

// ===== TATTOOS TGUI INTERFACE =====

/// Returns TRUE if the character currently has an enabled organ customizer
/// entry descending from base_customizer_type (e.g. checking for breasts,
/// a penis, a vagina, etc. before the equivalent tattoo body-part is
/// offered as a valid tattoo location).
/datum/preferences/proc/has_active_organ_customizer(base_customizer_type)
	if(!pref_species)
		return FALSE
	for(var/customizer_type in pref_species.customizers)
		if(!ispath(customizer_type, base_customizer_type))
			continue
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(entry && !entry.disabled)
			return TRUE
	return FALSE

/// Builds the full list of tattooable body locations for the current
/// character, keyed by their display name and pointing at the same body
/// zone defines used for combat/markings targeting - i.e. these are all
/// real, targetable body parts, not made-up tattoo-only zones. Locations
/// tied to specific anatomy (breasts, penis, etc.) are only included when
/// the character actually has that anatomy.
/datum/preferences/proc/get_available_tattoo_locations()
	var/list/locations = list()
	locations["Head"] = BODY_ZONE_HEAD
	locations["Forehead"] = BODY_ZONE_PRECISE_SKULL
	locations["Mouth"] = BODY_ZONE_PRECISE_MOUTH
	locations["Left Eye"] = BODY_ZONE_PRECISE_L_EYE
	locations["Right Eye"] = BODY_ZONE_PRECISE_R_EYE
	locations["Chest"] = BODY_ZONE_CHEST
	locations["Left Arm"] = BODY_ZONE_L_ARM
	locations["Right Arm"] = BODY_ZONE_R_ARM
	locations["Left Hand"] = BODY_ZONE_PRECISE_L_HAND
	locations["Right Hand"] = BODY_ZONE_PRECISE_R_HAND
	locations["Left Leg"] = BODY_ZONE_L_LEG
	locations["Right Leg"] = BODY_ZONE_R_LEG
	locations["Left Foot"] = BODY_ZONE_PRECISE_L_FOOT
	locations["Right Foot"] = BODY_ZONE_PRECISE_R_FOOT
	locations["Abdomen"] = TATTOO_LOC_ABDOMEN
	locations["Groin"] = BODY_ZONE_PRECISE_GROIN
	locations["Left Buttcheek"] = TATTOO_LOC_L_BUTTCHEEK
	locations["Right Buttcheek"] = TATTOO_LOC_R_BUTTCHEEK
	locations["Asshole"] = TATTOO_LOC_ASSHOLE

	// Nipples exist on every human-ish chest regardless of breast size,
	// so they're only gated on having a chest at all (i.e. not on the
	// breasts organ customizer specifically) - this makes them available
	// to male characters too, not just characters with breasts enabled.
	locations["Left Nipple"] = TATTOO_LOC_L_NIPPLE
	locations["Right Nipple"] = TATTOO_LOC_R_NIPPLE
	if(has_active_organ_customizer(/datum/customizer/organ/breasts))
		locations["Left Breast"] = TATTOO_LOC_L_BREAST
		locations["Right Breast"] = TATTOO_LOC_R_BREAST
	if(has_active_organ_customizer(/datum/customizer/organ/penis))
		locations["Penis"] = TATTOO_LOC_PENIS
	if(has_active_organ_customizer(/datum/customizer/organ/vagina))
		locations["Vagina"] = TATTOO_LOC_VAGINA

	return locations

/// Human-readable name for a tattoo location key, for UI display.
/datum/preferences/proc/get_tattoo_location_name(location)
	var/list/all_locations = get_available_tattoo_locations()
	var/name = find_key_by_value(all_locations, location)
	return name || location

/// Drops any saved tattoos that are no longer valid for the character
/// (e.g. the location doesn't exist anymore, or the species/anatomy
/// changed and no longer has the relevant body part), and any duplicate
/// entries sharing a location.
/datum/preferences/proc/validate_tattoos()
	if(!islist(tattoos))
		tattoos = list()
		return
	var/list/all_locations = get_available_tattoo_locations()
	var/list/location_values = list()
	for(var/location_name in all_locations)
		location_values += all_locations[location_name]
	var/list/seen_locations = list()
	for(var/i = length(tattoos), i >= 1, i--)
		var/list/tattoo = tattoos[i]
		if(!islist(tattoo) || !tattoo["location"] || !tattoo["design"])
			tattoos.Cut(i, i + 1)
			continue
		if(!(tattoo["location"] in location_values))
			tattoos.Cut(i, i + 1)
			continue
		if(tattoo["location"] in seen_locations)
			tattoos.Cut(i, i + 1)
			continue
		seen_locations += tattoo["location"]
		tattoo["design"] = trim(tattoo["design"], MAX_TATTOO_DESIGN_LEN)
		tattoo["color"] = sanitize_hexcolor(tattoo["color"], 6, 0)

/datum/preferences/proc/show_tattoos_tgui(mob/user)
	var/datum/tattoos_ui/ui_datum = new(src)
	ui_datum.ui_interact(user)

/datum/tattoos_ui
	var/datum/preferences/preferences

/datum/tattoos_ui/New(datum/preferences/prefs)
	. = ..()
	preferences = prefs

/datum/tattoos_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Tattoos")
		ui.open()

/datum/tattoos_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/tattoos_ui/ui_data(mob/user)
	var/list/data = list()

	data["theme"] = preferences.get_creator_theme()

	var/list/all_locations = preferences.get_available_tattoo_locations()
	var/list/used_locations = list()

	var/list/tattoos_data = list()
	var/index = 1
	for(var/list/tattoo in preferences.tattoos)
		used_locations += tattoo["location"]
		tattoos_data += list(list(
			"index" = index,
			"location" = tattoo["location"],
			"location_name" = preferences.get_tattoo_location_name(tattoo["location"]),
			"design" = tattoo["design"],
			"color" = tattoo["color"],
			"is_brand" = !!tattoo["is_brand"]
		))
		index++
	data["tattoos"] = tattoos_data

	var/list/available_locations = list()
	for(var/location_name in all_locations)
		if(all_locations[location_name] in used_locations)
			continue
		available_locations += location_name
	data["available_locations"] = available_locations
	data["can_add"] = length(available_locations) > 0

	return data

/datum/tattoos_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/index = text2num(params["index"])

	switch(action)
		if("add_tattoo", "add_brand")
			var/is_brand = (action == "add_brand")
			var/list/all_locations = preferences.get_available_tattoo_locations()
			var/list/used_locations = list()
			for(var/list/tattoo in preferences.tattoos)
				used_locations += tattoo["location"]
			var/list/available_locations = list()
			for(var/location_name in all_locations)
				if(all_locations[location_name] in used_locations)
					continue
				available_locations[location_name] = all_locations[location_name]
			if(!length(available_locations))
				return TRUE
			var/chosen_name = tgui_input_list(usr, "Choose a body part for the [is_brand ? "brand" : "tattoo"]:", "[is_brand ? "Brand" : "Tattoo"] Location", available_locations)
			if(!chosen_name)
				return TRUE
			var/design = tgui_input_text(usr, "What is the [is_brand ? "brand" : "tattoo"] eg. 'a skull', 'the number 42' or 'live, laugh, love':", "[is_brand ? "Brand" : "Tattoo"] Design", "", MAX_TATTOO_DESIGN_LEN)
			if(isnull(design) || !length(trim(design)))
				return TRUE
			preferences.tattoos += list(list(
				"location" = available_locations[chosen_name],
				"design" = trim(design),
				"color" = TATTOO_DEFAULT_COLOR,
				"is_brand" = is_brand
			))
			. = TRUE

		if("remove_tattoo")
			if(index > 0 && index <= length(preferences.tattoos))
				preferences.tattoos.Cut(index, index + 1)
			. = TRUE

		if("change_location")
			if(!(index > 0 && index <= length(preferences.tattoos)))
				return TRUE
			var/list/tattoo = preferences.tattoos[index]
			var/list/all_locations = preferences.get_available_tattoo_locations()
			var/list/used_locations = list()
			for(var/i in 1 to length(preferences.tattoos))
				if(i == index)
					continue
				used_locations += preferences.tattoos[i]["location"]
			var/list/available_locations = list()
			for(var/location_name in all_locations)
				if(all_locations[location_name] in used_locations)
					continue
				available_locations[location_name] = all_locations[location_name]
			if(!length(available_locations))
				return TRUE
			var/chosen_name = tgui_input_list(usr, "Move [tattoo["is_brand"] ? "brand" : "tattoo"] to which body part?", "[tattoo["is_brand"] ? "Brand" : "Tattoo"] Location", available_locations)
			if(!chosen_name)
				return TRUE
			tattoo["location"] = available_locations[chosen_name]
			. = TRUE

		if("change_design")
			if(!(index > 0 && index <= length(preferences.tattoos)))
				return TRUE
			var/list/tattoo = preferences.tattoos[index]
			var/design = tgui_input_text(usr, "What is the [tattoo["is_brand"] ? "brand" : "tattoo"] eg. 'a skull', 'the number 42' or 'live, laugh, love':", "[tattoo["is_brand"] ? "Brand" : "Tattoo"] Design", tattoo["design"], MAX_TATTOO_DESIGN_LEN)
			if(isnull(design) || !length(trim(design)))
				return TRUE
			tattoo["design"] = trim(design)
			. = TRUE

		if("change_color")
			if(!(index > 0 && index <= length(preferences.tattoos)))
				return TRUE
			var/list/tattoo = preferences.tattoos[index]
			if(tattoo["is_brand"])
				return TRUE
			var/new_color = color_pick_sanitized(usr, "Choose tattoo ink color:", "Tattoo Color", "#[tattoo["color"]]")
			if(!new_color)
				return TRUE
			tattoo["color"] = sanitize_hexcolor(new_color, 6)
			. = TRUE

	if(.)
		preferences.save_preferences()
