GAME_PHASE = { DAY: 0, NIGHT: 1, PENDING_START: 2 }
PLAYER_ROLE = { VILLAGER: 0, MAFIOSO: 1, DETECTIVE: 2, DOCTOR: 3 }
FACTIONS = { VILLAGERS: 0, MAFIOSI: 1 }
VILLAGER_STR = "Villager"
MAFIOSO_STR = "Mafioso"
DETECTIVE_STR = "Detective"
DOCTOR_STR = "Doctor"
SLOT_TYPES = {
  MODE_OF_TRANSIT: 0, # Must have methods "description", "short_name"
  WEATHER: 1,         # Must have methods "description", "short_name"
  WITNESSES: 2,       # Must have methods "description", "short_name"
  ACTIVITY: 3         # Must have methods "description", "preparation_description", "short_name"
}
TAGS = { PUBLIC: 0, IN_TRANSIT: 1, OUTDOORS: 2, FIREARM: 3, RANGE: 4, POISON: 5, NO_WITNESSES: 6, CONSUMABLE: 7,
         GOOD_VISIBILITY: 8, BAD_VISIBILITY: 9, HAND_TO_HAND: 10, BLADE: 11, CROWDED: 12, DOMESTIC: 13, PRIVATE: 14,
         INDOORS: 15, SOLO: 16, SMALL_GROUP: 17, QUIET: 18, CALM: 19, AUTOMOBILE: 20, PEDESTRIAN: 21, RAIN: 22,
         THUNDER: 23, RESTAURANT: 24, GAMING: 25, ACCOMPANIED_IN_CROWD: 26 }
FLAVOR_TEXT_TYPE = { MAFIA_HIT: 0, DETECTIVE_ARREST: 1, VILLAGER_VOTE_RESULT: 2 }
