//= require dps-utils
function melee_order() {
    var xp_diff_table = [
        0, 83, 91, 102, 112, 124, 138, 151, 168, 185, 204, 226, 249, 274, 304,
        335, 369, 408, 450, 497, 548, 606, 667, 737, 814, 898, 990, 1094, 1207,
        1332, 1470, 1623, 1791, 1977, 2182, 2409, 2658, 2935, 3240, 3576, 3947,
        4358, 4810, 5310, 5863, 6471, 7144, 7887, 8707, 9612, 10612, 11715, 12934,
        14278, 15764, 17404, 19214, 21212, 23420, 25856, 28546, 31516, 34795, 38416,
        42413, 46826, 51699, 57079, 63019, 69576, 76818, 84812, 93638, 103383,
        114143, 126022, 139138, 153619, 169608, 187260, 206750, 228269, 252027,
        278259, 307221, 339198, 374502, 413482, 456519, 504037, 556499, 614422,
        678376, 748985, 826944, 913019, 1008052, 1112977, 1228825, 0
    ];

    function getAttributeValue(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.value : 0;
    }

    function getAttributeChecked(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.checked : false;
    }

    function melee_order_results() {
        var start_attack_level1 = Math.min(Math.abs(Number(getAttributeValue("start_attack_level"))),99);
        var start_strength_level1 = Math.min(Math.abs(Number(getAttributeValue("start_strength_level"))),99);
        var end_attack_level1 = Math.min(Math.abs(Number(getAttributeValue("end_attack_level"))),99);
        var end_strength_level1 = Math.min(Math.abs(Number(getAttributeValue("end_strength_level"))),99);

        var attack_prayer_name = getAttributeValue("attack_prayer");
        var strength_prayer_name = getAttributeValue("strength_prayer");

        var skill_boost = getAttributeValue('skill_boost');

        var onhand_slot = getAttributeValue("onhand_slot");
        var neck_slot = getAttributeValue("neck_slot");
        var feet_slot = getAttributeValue("feet_slot");
        //var weapon_progression_setting = getAttributeChecked("weapon_progression_setting");

        var target_name = getAttributeValue("target_name");
        var custom_target_stats = getAttributeChecked('custom_target_stats');
        var pvp_setting = getAttributeChecked('pvp');

        var custom_health = Number(getAttributeValue("target_health"));
        var custom_defence_level = Number(getAttributeValue("target_defence_level"));
        var custom_defence_bonus = Number(getAttributeValue("target_defence_bonus"));

        var custom_player_stats = getAttributeChecked('custom_player_stats');
        var custom_attack_bonus = Number(getAttributeValue("custom_attack_bonus"));
        var custom_strength_bonus = Number(getAttributeValue("custom_strength_bonus"));
        var custom_attack_speed = Number(getAttributeValue("custom_attack_speed"));
        var customDmgMult = Number(getAttributeValue("dmg_mult"));
        var custom_combat_level = Number(getAttributeValue("combat_level"));

        //just incase they set start level higher than end level
        var start_attack_level = Math.min(start_attack_level1, end_attack_level1);
        var start_strength_level = Math.min(start_strength_level1, end_strength_level1);

        var end_attack_level = Math.max(start_attack_level1, end_attack_level1);
        var end_strength_level = Math.max(start_strength_level1, end_strength_level1);

        var xp_multiplier = 1.0;
        if (custom_combat_level >= 20 && custom_combat_level <= 39) {
            xp_multiplier = 1.025;
        } else if (custom_combat_level >= 40 && custom_combat_level <= 59) {
            xp_multiplier = 1.05;
        } else if (custom_combat_level >= 60 && custom_combat_level <= 79) {
            xp_multiplier = 1.075;
        } else if (custom_combat_level >= 80 && custom_combat_level <= 99) {
            xp_multiplier = 1.1;
        } else if (custom_combat_level >= 100 && custom_combat_level <= 126) {
            xp_multiplier = 1.125;
        }

        // Prayers
        var attackPrayerBonuses = {
            "Clarity of Thought (+5%)": 1.05,
            "Improved Reflexes (+10%)": 1.10,
            "Incredible Reflexes (+15%)": 1.15,
        };

        var strengthPrayerBonuses = {
            "Burst of Strength (+5%)": 1.05,
            "Superhuman Strength (+10%)": 1.10,
            "Ultimate Strength (+15%)": 1.15,
        };

        var attack_prayer = attackPrayerBonuses[attack_prayer_name] || 1;
        var strength_prayer = strengthPrayerBonuses[strength_prayer_name] || 1;

        // Skill boosts
        var strength_boost_factor = 0;
        var strength_boost_addend = 0;
        var attack_boost_factor = 0;
        var attack_boost_addend = 0;
        var boost_collection_rate = Infinity;
        var boost_sips = 4;
        switch (skill_boost) {
            case "Strength potion":
                strength_boost_factor = 0.1;
                strength_boost_addend = 3;
                boost_collection_rate = Infinity;
                boost_sips = 4;
                break;
            case "Strength potion (IM)":
                strength_boost_factor = 0.1;
                strength_boost_addend = 3;
                boost_collection_rate = 350;
                boost_sips = 4;
                break;
            case "Strength potion (UIM)":
                strength_boost_factor = 0.1;
                strength_boost_addend = 3;
                boost_collection_rate = 100;
                boost_sips = 4;
                break;
            case "Castlewars brew":
                strength_boost_factor = 0.15;
                strength_boost_addend = 5;
                attack_boost_factor = 0.15;
                attack_boost_addend = 5;
                boost_collection_rate = Infinity;
                boost_sips = 4;
                break;
            case "Beer":
                strength_boost_factor = 0.02;
                strength_boost_addend = 1;
                attack_boost_factor = -0.06;
                attack_boost_addend = -1;
                boost_sips = 1;
                boost_collection_rate = Infinity;
                break;
            default:
                break;
        }

        // Equipment bonuses
        var attack_requirement = 1;
        var attack_bonus = 0;
        var strength_bonus = 0;
        var attack_speed = 4;
        var attack_style = "Crush";
        var dmgMult = 1;

        if (!custom_player_stats) {
            var equipmentBonuses = {
                "Rune scimitar": {
                    attack_requirement: 40,
                    attack_bonus: 45,
                    strength_bonus: 44,
                    attack_speed: 4,
                    attack_style: "Slash",
                },
                "Rune sword": {
                    attack_requirement: 40,
                    attack_bonus: 38,
                    strength_bonus: 39,
                    attack_speed: 4,
                    attack_style: "Stab",
                },
                "Barronite mace": {
                    attack_requirement: 40,
                    attack_bonus: 40,
                    strength_bonus: 40,
                    attack_speed: 4,
                    attack_style: "Crush",
                },
                "Rune longsword": {
                    attack_requirement: 40,
                    attack_bonus: 47,
                    strength_bonus: 49,
                    attack_speed: 5,
                    attack_style: "Slash",
                },
                "Rune battleaxe": {
                    attack_requirement: 40,
                    attack_bonus: 48,
                    strength_bonus: 64,
                    attack_speed: 6,
                    attack_style: "Slash",
                },
                "Rune 2h sword": {
                    attack_requirement: 40,
                    attack_bonus: 69,
                    strength_bonus: 70,
                    attack_speed: 7,
                    attack_style: "Slash",
                },
                "Hill giant club": {
                    attack_requirement: 40,
                    attack_bonus: 65,
                    strength_bonus: 70,
                    attack_speed: 7,
                    attack_style: "Crush",
                },
                "Adamant scimitar": {
                    attack_requirement: 30,
                    attack_bonus: 29,
                    strength_bonus: 28,
                    attack_speed: 4,
                    attack_style: "Slash",
                },
                "Adamant sword": {
                    attack_requirement: 30,
                    attack_bonus: 23,
                    strength_bonus: 24,
                    attack_speed: 4,
                    attack_style: "Stab",
                },
                "Adamant 2h sword": {
                    attack_requirement: 30,
                    attack_bonus: 43,
                    strength_bonus: 44,
                    attack_speed: 7,
                    attack_style: "Slash",
                },
            };

            var neckBonuses = {
                "Amulet of power": {
                    attack_bonus: 6,
                    strength_bonus: 6,
                },
                "Amulet of strength": {
                    strength_bonus: 10,
                },
                "Amulet of accuracy": {
                    attack_bonus: 4,
                },
            };

            var feetBonuses = {
                "Decorative boots (gold)": {
                    strength_bonus: 1,
                },
                "None": {
                    strength_bonus: 0,
                }
            };
            // Retrieve the bonuses for a specific onhand slot
            function getEquipmentBonuses(equipment) {
                return equipmentBonuses[equipment] || {
                    attack_requirement: 1,
                    attack_bonus: 0,
                    strength_bonus: 0,
                    attack_speed: 4,
                    attack_style: "Crush",
                };
            }

            // Retrieve the bonuses for a specific neck slot
            function getNeckBonuses(neckItem) {
                return neckBonuses[neckItem] || {};
            }

            // Retrieve the bonuses for a specific feet slot
            function getFeetBonuses(feetItem) {
                return feetBonuses[feetItem] || {};
            }
            var onhandEquipment = getEquipmentBonuses(onhand_slot);
            attack_requirement = onhandEquipment.attack_requirement;
            attack_bonus += onhandEquipment.attack_bonus;
            strength_bonus += onhandEquipment.strength_bonus;
            attack_speed = onhandEquipment.attack_speed;
            attack_style = onhandEquipment.attack_style;

            var neckEquipment = getNeckBonuses(neck_slot);
            attack_bonus += neckEquipment.attack_bonus || 0;
            strength_bonus += neckEquipment.strength_bonus || 0;

            var feetEquipment = getFeetBonuses(feet_slot);
            strength_bonus += feetEquipment.strength_bonus || 0;

            //console.log("Strength bonus: ", strength_bonus, "Attack bonus: ", attack_bonus);
        } else if (custom_player_stats) {
            attack_bonus = custom_attack_bonus;
            strength_bonus = custom_strength_bonus;
            attack_speed = custom_attack_speed;
            dmgMult = customDmgMult;
        }
        // Target stats
        var target_defence_level = 0;
        var target_health = 0;
        var target_defence_bonus = 0;
        var isGolem = false;

        if (!custom_target_stats) {
            var targetStats = {
                "Flawed Golem": {
                    defence_level: 6,
                    health: 25,
                    defence_bonus: (attack_style === "Crush" ? 0 : 5),
                    isGolem: true,
                },
                "Mind Golem": {
                    defence_level: 25,
                    health: 40,
                    defence_bonus: (attack_style === "Crush" ? 0 : 5),
                    isGolem: true,
                },
                "Body Golem": {
                    defence_level: 45,
                    health: 60,
                    defence_bonus: (attack_style === "Crush" ? 0 : 5),
                    isGolem: true,
                },
                "Ogress Warrior": {
                    defence_level: 82,
                    health: 82,
                    defence_bonus: (attack_style === "Stab" ? 10 : 12),
                },
                "Ogress Shaman": {
                    defence_level: 82,
                    health: 82,
                    defence_bonus: (attack_style === "Stab" ? 12 : 14),
                },
                "Obor": {
                    defence_level: 60,
                    health: 120,
                    defence_bonus: attack_style === "Stab" ? 35 : attack_style === "Slash" ? 40 : 45,
                },
                "Bryophyta": {
                    defence_level: 100,
                    health: 115,
                    defence_bonus: 0,
                },
                "Lesser demon": {
                    defence_level: 71,
                    health: 81,
                },
                "Moss giant": {
                    defence_level: 30,
                    health: 60,
                },
                "Hill giant": {
                    defence_level: 26,
                    health: 35,
                },
                "Giant spider": {
                    defence_level: 31,
                    health: 50,
                    defence_bonus: 10,
                },
                "Flesh crawler": {
                    defence_level: 10,
                    health: 25,
                    defence_bonus: 15,
                },
                "Ice Giant": {
                    defence_level: 40,
                    health: 70,
                    defence_bonus: attack_style === "Stab" ? 0 : attack_style === "Slash" ? 3 : 2,
                },
                "Dark Wizard (Level 20)": {
                    defence_level: 14,
                    health: 24,
                }
            };

            function getTargetStats(targetName) {
                return targetStats[targetName] || null;
            }
            var targetStats = getTargetStats(target_name);
            if (targetStats) {
                target_defence_level = targetStats.defence_level;
                target_health = targetStats.health;
                target_defence_bonus = targetStats.defence_bonus || 0;
                isGolem = targetStats.isGolem || false;
            }
        } else if (custom_target_stats) {
            target_defence_level = custom_defence_level;
            target_health = custom_health;
            target_defence_bonus = custom_defence_bonus;
        }

        // apply bonus multiplier if its golem, and wep is mace
        if (isGolem && !custom_player_stats && onhand_slot == "Barronite mace") {
            dmgMult = 1.15;
        }

        function calc_time_to_next_level(attack_level, strength_level, focus) {
            // check focus
            var attack_level_addend = 0;
            var strength_level_addend = 0;
            var xp_needed = 0;
            switch (focus) {
                case 1:
                    xp_needed = xp_diff_table[Number(attack_level)];
                    attack_level_addend = 3;
                    break;
                case 2:
                    xp_needed = xp_diff_table[Number(strength_level)];
                    strength_level_addend = 3;
                    break;
            }

            var accuracy = 0;
            var max_hit = 0;
            var effective_attack_level = 0;
            var effective_strength_level = 0;
            var ticks_to_kill = 0;

            var xp_per_hour = 0;
            var best_xp_per_hour = 0;
            var prev_xp_per_hour = 0;
            var best_drink_level = strength_level;
            var temp_strength_level = Math.floor(strength_level * (1 + strength_boost_factor) + strength_boost_addend);
            var temp_attack_level = Math.floor(attack_level * (1 + attack_boost_factor) + attack_boost_addend);

            var boost_minutes = 1;
            do {
                effective_attack_level = calc_effective_level(Math.max(temp_attack_level, attack_level), attack_prayer, 0, 0, attack_level_addend);
                effective_strength_level = calc_effective_level(Math.max(temp_strength_level, strength_level), strength_prayer, 0, 0, strength_level_addend);
                max_hit = calc_max_hit(effective_strength_level, strength_bonus);
                accuracy = calc_accuracy(effective_attack_level, attack_bonus, target_defence_level, target_defence_bonus);
                
                if (pvp_setting) {
                    attack_roll = (effective_attack_level + 8) * (attack_bonus + 64);
                    defence_roll = (target_defence_level) * (target_defence_bonus + 64);
                    if (attack_roll > defence_roll) {
                        accuracy = 1 - (defence_roll + 2) / (2 * (attack_roll + 1));
                    } else {
                        accuracy = attack_roll / (2 * (defence_roll + 1));
                    }
                    xp_per_hour = 6000 / attack_speed * accuracy * max_hit * 2 * (max_hit / (max_hit + 1)) * (1 - 60 / (boost_sips * boost_minutes) / boost_collection_rate) * xp_multiplier;
                } else {
                    ticks_to_kill = calc_ticks_to_kill(target_health, max_hit, accuracy, attack_speed);
                    xp_per_hour = 6000 / ticks_to_kill * target_health * 4 * (1 - 60 / (boost_sips * boost_minutes) / (boost_collection_rate));
                }

                if (prev_xp_per_hour != 0) {
                    xp_per_hour = (prev_xp_per_hour + xp_per_hour)/2 // average all the previous loops
                }
                prev_xp_per_hour = xp_per_hour;

                if (xp_per_hour > best_xp_per_hour) {
                    best_xp_per_hour = xp_per_hour;
                    best_drink_level = temp_strength_level - 1; // only str for now
                }

                // console.log(style + attack_level + ": " + strength_level + ": " + xp_per_hour + ": " + temp_strength_level + ": " + max_hit);
                boost_minutes += 1;
                temp_strength_level -= 1;
                temp_attack_level -= 1;
            } while ((strength_level < temp_strength_level || attack_level < temp_attack_level) && boost_minutes < 30);
            var time_to_next_level = xp_needed / best_xp_per_hour;
            return [time_to_next_level, best_xp_per_hour, best_drink_level];
        }

        function format_overview(order) {
            var prev_attack_level = Number(start_attack_level);
            var prev_strength_level = Number(start_strength_level);
            var first_attack_level = start_attack_level;
            var first_strength_level = start_strength_level;
            var formatted_overview = [];
            var total_hours = 0;
            var total_boosts = 0;

            for (var index = 0; index < order.length; index++) {
                var node = order[index].split(',');
                var current_attack_level = Number(node[0]);
                var current_strength_level = Number(node[1]);

                var prev_prev_node = order[Math.max(index - 2, 0)].split(',');
                var prev_prev_attack_level = Number(prev_prev_node[0]);
                var prev_prev_strength_level = Number(prev_prev_node[1]);

                var progression = '';
                var hours = 0;
                var boosts = 0;
                var strength_data;
                var attack_data;

                if (
                    current_attack_level !== prev_attack_level &&
                    prev_strength_level !== prev_prev_strength_level
                ) {
                    first_attack_level = prev_attack_level;
                    progression = first_strength_level + ' - ' + current_strength_level + ' Strength';
                    strength_data = calc_strength_hours(first_strength_level, current_strength_level, prev_attack_level);
                    hours = strength_data[0];
                    boosts = strength_data[1]; 
                } else if (
                    current_strength_level !== prev_strength_level &&
                    prev_attack_level !== prev_prev_attack_level
                ) {
                    first_strength_level = prev_strength_level;
                    progression = first_attack_level + ' - ' + current_attack_level + ' Attack';
                    attack_data = calc_attack_hours(first_attack_level, current_attack_level, prev_strength_level);
                    hours = attack_data[0];
                    boosts = attack_data[1]; 
                } else if (
                    prev_attack_level === end_attack_level &&
                    current_strength_level === end_strength_level
                ) {
                    progression = first_strength_level + ' - ' + current_strength_level + ' Strength';
                    strength_data = calc_strength_hours(first_strength_level, current_strength_level, prev_attack_level);
                    hours = strength_data[0];
                    boosts = strength_data[1]; 
                } else if (
                    prev_strength_level === end_strength_level &&
                    current_attack_level === end_attack_level
                ) {
                    progression = first_attack_level + ' - ' + current_attack_level + ' Attack';
                    attack_data = calc_attack_hours(first_attack_level, current_attack_level, prev_strength_level);
                    hours = attack_data[0];
                    boosts = attack_data[1]; 
                }
                total_hours += hours;
                total_boosts += boosts;

                if (progression) {
                    formatted_overview.push(progression);
                    formatted_overview.push(Math.round(hours * 1000) / 1000 + ' Hours');
                }
                // for 98-99
                if (index === order.length - 1 && first_strength_level === end_strength_level - 1 && current_attack_level == prev_attack_level) {
                    progression = first_strength_level + ' - ' + current_strength_level + ' Strength';
                    strength_data = calc_strength_hours(first_strength_level, current_strength_level, prev_attack_level);
                    hours = strength_data[0];
                    boosts = strength_data[1]; 
                    total_hours += hours;
                    total_boosts += boosts;
                    formatted_overview.push(progression);
                    formatted_overview.push(Math.round(hours * 1000) / 1000 + ' Hours');
                } else if (index === order.length - 1 && first_attack_level == end_attack_level - 1 && current_strength_level == prev_strength_level) {
                    progression = first_attack_level + ' - ' + current_attack_level + ' Attack';
                    attack_data = calc_attack_hours(first_attack_level, current_attack_level, prev_strength_level);
                    hours = attack_data[0];
                    boosts = attack_data[1];
                    total_hours += hours;
                    total_boosts += boosts;
                    formatted_overview.push(progression);
                    formatted_overview.push(Math.round(hours * 1000) / 1000 + ' Hours');
                }

                prev_attack_level = current_attack_level;
                prev_strength_level = current_strength_level;
            }

            formatted_overview.push(Math.round(total_boosts * 1000) / 1000 + ' Total Boosts');
            formatted_overview.push('');
            formatted_overview.push(Math.round(total_hours * 1000) / 1000 + ' Total Hours');
            formatted_overview.push('');
            return formatted_overview;
        }

        function format_detailed(order) {
            var formatted_detailed = [];
            var best = [];
            var best_xp_per_hour = 0;
            var best_wait = 0;
            for (var index = 0; index < order.length; index++) {
                var node = order[index].split(',');
                var current_attack_level = Number(node[0]);
                var current_strength_level = Number(node[1]);

                var next_node = order[Math.min(index + 1, order.length - 1)].split(',');
                var next_attack_level = Number(next_node[0]);
                var next_strength_level = Number(next_node[1]);

                //if attack is trained, assume the accuracy style is used
                if (next_attack_level === current_attack_level + 1) {
                    best = calc_time_to_next_level(current_attack_level, current_strength_level, 1);
                    best_xp_per_hour = Math.round(best[1]);
                    best_wait = best[2];
                } else {
                    best = calc_time_to_next_level(current_attack_level, current_strength_level, 2);
                    best_xp_per_hour = Math.round(best[1]);
                    best_wait = best[2];
                }

                formatted_detailed.push(current_attack_level);
                formatted_detailed.push(current_strength_level);
                formatted_detailed.push(best_xp_per_hour);
                formatted_detailed.push(best_wait);
            }
            return formatted_detailed;
        }


        // calc the hours between 2 attack levels
        function calc_attack_hours(start_attack_level, end_attack_level, strength_level) {
            var total_hours = 0;
            var hours_to_level = 0;
            var best_drink_level = 0;
            var boosts_to_level = 0;
            var total_boosts = 0;
            var boosted_strength = Math.floor(strength_level * (1 + strength_boost_factor) + strength_boost_addend);
            var level_data;
            for (; start_attack_level < end_attack_level; start_attack_level++) {
                level_data = calc_time_to_next_level(start_attack_level, strength_level, 1);
                hours_to_level = level_data[0];
                best_drink_level = level_data[2];
                if (best_drink_level > strength_level) {
                    console.log(best_drink_level + ", " + strength_level);
                    boosts_to_level = hours_to_level * 60 / ((boosted_strength - best_drink_level) * boost_sips);
                }

                total_boosts = total_boosts + boosts_to_level; 
                total_hours = total_hours + hours_to_level;
            }
            return [total_hours, total_boosts];
        }
        // calc the hours between 2 strength levels
        function calc_strength_hours(start_strength_level, end_strength_level, attack_level) {
            var total_hours = 0;
            var hours_to_level = 0;
            var best_drink_level = 0;
            var boosts_to_level = 0;
            var total_boosts = 0;
            var boosted_strength = Math.floor(end_strength_level * (1 + strength_boost_factor) + strength_boost_addend);
            var level_data;
            for (; start_strength_level < end_strength_level; start_strength_level++) {
                level_data = calc_time_to_next_level(attack_level, start_strength_level, 2);
                hours_to_level = level_data[0];
                best_drink_level = level_data[2];
                if (best_drink_level > start_strength_level) {
                    console.log(best_drink_level + ", " + start_strength_level);
                    boosts_to_level = hours_to_level * 60 / ((boosted_strength - best_drink_level) * boost_sips);
                }
                
                //console.log(boosts_to_level + ", " + best_drink_level + ", " + boosted_strength + ", " + boost_sips);
                total_boosts = total_boosts + boosts_to_level; 
                total_hours = total_hours + hours_to_level;
            }
            return [total_hours, total_boosts];
        }


        function createGraph(start_attack_level, end_attack_level, start_strength_level, end_strength_level) {
            var graph = {};

            function addEdge(nodeA, nodeB, weight) {
                if (!graph[nodeA]) {
                    graph[nodeA] = [];
                }
                if (!graph[nodeB]) {
                    graph[nodeB] = [];
                }
                graph[nodeA].push({
                    node: nodeB,
                    weight: weight
                });
                graph[nodeB].push({
                    node: nodeA,
                    weight: weight
                });
            }

            for (var attack_level = start_attack_level; attack_level <= end_attack_level; attack_level++) {
                for (var strength_level = start_strength_level; strength_level <= end_strength_level; strength_level++) {
                    var node = attack_level + ',' + strength_level;

                    if (attack_level < end_attack_level) {
                        var next_attack_node = (attack_level + 1) + ',' + strength_level;
                        var attack_level_time = Math.max(calc_time_to_next_level(attack_level, strength_level, 1)[0],0);
                        addEdge(node, next_attack_node, attack_level_time);
                    }

                    if (strength_level < end_strength_level) {
                        var next_strength_node = attack_level + ',' + (strength_level + 1);
                        var strength_level_time = Math.max(calc_time_to_next_level(attack_level, strength_level, 2)[0],0);
                        addEdge(node, next_strength_node, strength_level_time);
                    }
                }
            }

            return graph;
        }

        function calculateShortestOrder(graph, start_node, target_node) {
            var distances = {};
            var previous = {};
            var unvisited = Object.keys(graph);

            unvisited.forEach(function(node) {
                distances[node] = Infinity;
            });

            distances[start_node] = 0;

            while (unvisited.length > 0) {
                var current_node = null;
                var shortest_distance = Infinity;

                for (var i = 0; i < unvisited.length; i++) {
                    var node = unvisited[i];
                    if (distances[node] < shortest_distance) {
                        current_node = node;
                        shortest_distance = distances[node];
                    }
                }

                var index = -1;
                for (var j = 0; j < unvisited.length; j++) {
                    if (unvisited[j] === current_node) {
                        index = j;
                        break;
                    }
                }

                unvisited.splice(index, 1);
                graph[current_node].forEach(function(neighbor) {
                    var node = neighbor.node;
                    var weight = neighbor.weight;
                    var distance = distances[current_node] + weight;
                    if (distance < distances[node]) {
                        distances[node] = distance;
                        previous[node] = current_node;
                    }
                });
            }

            var order = [];
            var current_node = target_node;

            while (current_node !== start_node) {
                order.unshift(current_node);
                current_node = previous[current_node];
            }
            order.unshift(start_node);

            return order;
        }

        var graph = createGraph(start_attack_level, end_attack_level, start_strength_level, end_strength_level);
        var shortestOrder = calculateShortestOrder(graph, start_attack_level + ',' + start_strength_level, end_attack_level + ',' + end_strength_level);

        var formatted_overview = format_overview(shortestOrder);
        var formatted_detailed = format_detailed(shortestOrder);
        $(document).ready(function() {
            var $overviewTable = $("#overview-table tbody");
            $overviewTable.empty(); // Clear the overview table body before populating with new data

            // Add new rows with the overview results to the table
            for (var i = 0; i < formatted_overview.length; i += 2) {
                var $row = $("<tr>");
                var $cell1 = $("<td>").text(formatted_overview[i]);
                var $cell2 = $("<td>").text(formatted_overview[i + 1]);

                $row.append($cell1, $cell2);
                $overviewTable.append($row);
            }

            var $detailedTable = $("#detailed-table tbody");
            $detailedTable.empty(); // Clear the detailed table body before populating with new data

            // Add new rows with the detailed results to the table
            for (var j = 0; j < formatted_detailed.length; j += 4) {
                var $row = $("<tr>");
                var $cell1 = $("<td>").text(formatted_detailed[j]);
                var $cell2 = $("<td>").text(formatted_detailed[j + 1]);
                var $cell3 = $("<td>").text(formatted_detailed[j + 2]);
                var $cell4 = $("<td>").text(formatted_detailed[j + 3]);

                $row.append($cell1, $cell2, $cell3, $cell4);
                $detailedTable.append($row);
            }

            var $boostsTable = $("#boosts-table tbody");
            $boostsTable.empty(); // Clear the detailed table body before populating with new data

            // Add new rows with the detailed results to the table
            for (var j = 0; j < formatted_detailed.length; j += 4) {
                var $row = $("<tr>");
                var $cell1 = $("<td>").text(formatted_detailed[j + 1]);
                var $cell2 = $("<td>").text(formatted_detailed[j + 3]);

                $row.append($cell1, $cell2);
                $boostsTable.append($row);
            }
        });

    }
    if ($('#body-melee_order').length) {
        $("#calculate-button").on("click", function(event) {
            event.preventDefault();
            melee_order_results();
        });

        $(document).ready(function() {
            $(".tab-link").on("click", function(e) {
                e.preventDefault();

                var target = $(this).attr("href");

                $(".tab-link").removeClass("active");
                $(".tab-pane").removeClass("active");

                $(target).addClass("active");
                $(this).addClass("active");

            });
        });


    }

}

$(document).ready(melee_order);
$(document).on('page:load', melee_order);
