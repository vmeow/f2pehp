function melee_order() {
    function calculate_factorial(n) {
        if (n === 0 || n === 1) {
            return 1;
        } else {
            var factorial = 1;
            for (var i = 2; i <= n; i++) {
                factorial *= i;
            }
            return factorial;
        }
    }
    // function to calc the accurate hits (damage above 0) needed to kill a monster.
    // This function is based on a formula by GeChallengeM
    // https://twitter.com/GeChallengeM/status/1155239680578859009
    function calc_hits_to_kill(target_health, max_hit) {
        var sum = 0;
        var floorValue = Math.floor(target_health / (max_hit + 1));

        for (var n = 0; n <= floorValue; n++) {
            var product = 1;

            for (var i = 0; i <= n - 1; i++) {
                product *= n - (target_health + i) / (max_hit + 1);
            }

          var factorial = calculate_factorial(n);
          var exponent = target_health - n * max_hit;
          var base = (max_hit + 1) / max_hit;

          sum += Math.pow(base, exponent) * (1 / factorial) * product;
        }

        return sum;
    }

    function calc_ticks_to_kill(target_health, max_hit, accuracy, attack_speed) {
        return (calc_hits_to_kill(target_health, max_hit)/accuracy * attack_speed);
    }

    function calc_max_hit(effective_strength_level, strength_bonus) {
        var max_hit = Math.floor(0.5 + (effective_strength_level + 8) * (strength_bonus + 64) / 640);
        return max_hit;
    }

    function calc_accuracy(effective_attack_level, attack_bonus, target_defence_level, target_defence_bonus) {
        var attack_roll = (effective_attack_level + 8) * (attack_bonus + 64);
        var defence_roll = (target_defence_level + 9) * (target_defence_bonus + 64);
        var accuracy = 0;

        if (attack_roll > defence_roll) {
            accuracy = 1 - (defence_roll + 2)/(2 * (attack_roll + 1));
        } else {
            accuracy = attack_roll/(2 * (defence_roll + 1));
        }
        return accuracy;
    }

    function calc_effective_level(level, prayer, skill_boost_factor, skill_boost_addend) {
        var effective_level = Math.floor(Math.floor(level * (1 + skill_boost_factor) + skill_boost_addend) * prayer);
        return effective_level;
    }
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
    ]
    function getAttributeValue(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.value : 0;
    }

    function getAttributeChecked(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.checked : false;
    }
      console.log("melee_order_results");
    function melee_order_results() {
        console.log("getattributes");
        var start_attack_level = getAttributeValue("start_attack_level");
        var start_strength_level = getAttributeValue("start_strength_level");
        var end_attack_level = getAttributeValue("end_attack_level");
        var end_strength_level = getAttributeValue("end_strength_level");
        start_attack_level = Number(start_attack_level);
        start_strength_level = Number(start_strength_level);
        end_attack_level = Number(end_attack_level);
        end_strength_level = Number(end_strength_level);

        var attack_prayer_name = getAttributeValue("attack_prayer");
        var strength_prayer_name = getAttributeValue("strength_prayer");

        var skill_boost = getAttributeValue('skill_boost');

        var onhand_slot = getAttributeValue("onhand_slot");
        var neck_slot = getAttributeValue("neck_slot");
        var feet_slot = getAttributeValue("feet_slot");
        var weapon_progression_setting = getAttributeChecked("weapon_progression_setting");

        var target_name = getAttributeValue("target_name");
        var custom_target_stats = getAttributeChecked('custom_target_stats');
        var custom_health = getAttributeValue("target_health");
        var custom_defence_level = getAttributeValue("target_defence_level");
        var custom_defence_bonus = getAttributeValue("target_defence_bonus");

        var custom_player_stats = getAttributeChecked('custom_player_stats');
        var custom_attack_bonus = getAttributeValue("custom_attack_bonus");
        var custom_strength_bonus = getAttributeValue("custom_strength_bonus");
        var custom_attack_speed = getAttributeValue("custom_attack_speed");
        var customDmgMult = getAttributeValue("dmg_mult");
        console.log("prayers");
        // Prayers
        var attack_prayer = 1;
        switch(attack_prayer_name){
            case "Clarity of Thought (+5%)":
                attack_prayer = 1.05;
                break;
            case "Improved Reflexes (+10%)":
                attack_prayer = 1.10;
                break;
            case "Incredible Reflexes (+15%)":
                attack_prayer = 1.15;
                break;
            default:
                break;
        }
        var strength_prayer = 1;
        switch(strength_prayer_name) {
            case "Burst of Strength (+5%)":
                strength_prayer = 1.05;
                break;
            case "Superhuman Strength (+10%)":
                strength_prayer = 1.10;
                break;
            case "Ultimate Strength (+15%)":
                strength_prayer = 1.15;
                break;
            default:
                break;
        }
        console.log("skill boost");
        // Skill boosts
        var strength_boost_factor = 0;
        var strength_boost_addend = 0;
        var attack_boost_factor = 0;
        var attack_boost_addend = 0;
        var boost_collection_rate = Infinity;
        switch(skill_boost) {
            case "Strength potion":
                strength_boost_factor = 0.1;
                strength_boost_addend = 3;
                boost_collection_rate = 350;
                break;
            case "Castlewars brew":
                strength_boost_factor = 0.15;
                strength_boost_addend = 5;
                attack_boost_factor = 0.15;
                attack_boost_addend = 5;
                boost_collection_rate = Infinity;
                break;
            case "Beer":
                strength_boost_factor = 0.02;
                strength_boost_addend = 1;
                attack_boost_factor = -0.06;
                attack_boost_addend = -1;
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
        var attack_style = "Slash";
        var dmgMult = 1;
        console.log("equip bonus");
        if (!custom_player_stats) {
            switch(onhand_slot) {
                case "Rune scimitar":
                    attack_requirement = 40;
                    attack_bonus += 45;
                    strength_bonus += 44;
                    attack_speed = 4;
                    attack_style = "Slash";
                    break;
                case "Rune sword":
                    attack_requirement = 40;
                    attack_bonus += 38;
                    strength_bonus += 39;
                    attack_speed = 4;
                    attack_style = "Stab";
                    break;
                case "Barronite mace":
                    attack_requirement = 40;
                    attack_bonus += 40;
                    strength_bonus += 40;
                    attack_speed = 4;
                    attack_style = "Crush";
                    dmgMult = 1.15;
                    break;
                case "Rune longsword":
                    attack_requirement = 40;
                    attack_bonus += 47;
                    strength_bonus += 49;
                    attack_speed = 5;
                    attack_style = "Slash";
                    break;
                case "Rune battleaxe":
                    attack_requirement = 40;
                    attack_bonus += 48;
                    strength_bonus += 64;
                    attack_speed = 6;
                    attack_style = "Slash";
                    break;
                case "Rune 2h sword":
                    attack_requirement = 40;
                    attack_bonus += 69;
                    strength_bonus += 70;
                    attack_speed = 7;
                    attack_style = "Slash";
                    break;
                case "Hill giant club":
                    attack_requirement = 40;
                    attack_bonus += 65;
                    strength_bonus += 70;
                    attack_speed = 7;
                    attack_style = "Crush";
                    break;
                case "Adamant scimitar":
                    attack_requirement = 30;
                    attack_bonus += 29;
                    strength_bonus += 28;
                    attack_speed = 4;
                    attack_style = "Slash";
                    break;
                case "Adamant sword":
                    attack_requirement = 30;
                    attack_bonus += 23;
                    strength_bonus += 24;
                    attack_speed = 4;
                    attack_style = "Stab";
                    break;
                case "Adamant 2h sword":
                    attack_requirement = 30;
                    attack_bonus += 43;
                    strength_bonus += 44;
                    attack_speed = 7;
                    attack_style = "Slash";
                    break;
                case "None":
                    attack_requirement = 1;
                    attack_speed = 4;
                    attack_style = "Crush";
                    break;
                case "Event rpg":
                    attack_requirement = 1;
                    attack_speed = 3;
                    attack_style = "Crush";
                    break;
                default:
                    attack_requirement = 1;
                    attack_speed = 4;
                    attack_style = "Crush";
                    break;
            }

            switch(neck_slot) {
                case "Amulet of power":
                    attack_bonus += 6;
                    strength_bonus += 6;
                    break;
                case "Amulet of strength":
                    strength_bonus += 10;
                    break;
                case "Amulet of accuracy":
                    attack_bonus += 4;
                    break;
                default:
                    break;
            }

            switch(feet_slot) {
                case "Decorative boots (gold)":
                    strength_bonus += 1;
                    break;
                default:
                    break;
            }
        } else if (custom_player_stats) {
            attack_bonus = custom_attack_bonus;
            strength_bonus = custom_strength_bonus;
            attack_speed = custom_attack_speed;
            dmgMult = customDmgMult;
        }
        console.log("target stats");
        // Target stats
        var target_defence_level = 0;
        var target_health = 0;
        var target_defence_bonus = 0;
        var isGolem = false;
        if (!custom_target_stats) {
            switch(target_name){
                case "Flawed Golem":
                    target_defence_level = 6;
                    target_health = 25;
                    if(attack_style == "Crush") {
                        target_defence_bonus = 0;
                    } else {
                        target_defence_bonus = 5;
                    }
                    isGolem = true;
                    break;
                case "Mind Golem":
                    target_defence_level = 25;
                    target_health = 40;
                    if(attack_style == "Crush"){
                        target_defence_bonus = 0;
                    } else {
                        target_defence_bonus = 5;
                    }
                    isGolem = true;
                    break;
                case "Body Golem":
                    target_defence_level = 45;
                    target_health = 60;
                    if(attack_style == "Crush") {
                        target_defence_bonus = 0;
                    } else {
                        target_defence_bonus = 5;
                    }
                    isGolem = true;
                    break;
                case "Ogress Warrior":
                    target_defence_level = 82;
                    target_health = 82;
                    if(attack_style == "Stab") {
                        target_defence_bonus = 10;
                    } else {
                        target_defence_bonus = 12;
                    }
                    break;
                case "Ogress Shaman":
                    target_defence_level = 82;
                    target_health = 82;
                    if(attack_style == "Stab") {
                        target_defence_bonus = 12;
                    } else {
                        target_defence_bonus = 14;
                    }
                    break;
                case "Obor":
                    target_defence_level = 60;
                    target_health = 120;
                    if(attack_style == "Stab") {
                        target_defence_bonus = 35;
                    } else if(attack_style == "Slash") {
                        target_defence_bonus = 40;
                    } else{
                        target_defence_bonus = 45;
                    }
                    break;
                case "Bryophyta":
                    target_defence_level = 100;
                    target_health = 115;
                    target_defence_bonus = 0;
                    break;
                case "Lesser demon":
                    target_defence_level = 71;
                    target_health = 81;
                    break;
                case "Moss giant":
                    target_defence_level = 30;
                    target_health = 60;
                    break;
                case "Hill giant":
                    target_defence_level = 26;
                    target_health = 35;
                    break;
                case "Giant spider":
                    target_defence_level = 31;
                    target_health = 50;
                    target_defence_bonus = 10;
                    break;
                case "Flesh crawler":
                    target_defence_level = 10;
                    target_health = 25;
                    target_defence_bonus = 15;
                    break;
                case "Ice Giant":
                    target_defence_level = 40;
                    target_health = 70;
                    if(attack_style == "Stab"){
                        target_defence_bonus = 0;
                    } else if(attack_style == "Slash"){
                        target_defence_bonus = 3;
                    } else{
                        target_defence_bonus = 2;
                    }
                    break;
                case "Dark Wizard (Level 20)":
                    target_defence_level = 14;
                    target_health = 24;
                    break;
                default:
                    break;
            }
        } else if (custom_target_stats) {
            target_defence_level = custom_defence_level;
            target_health = custom_health;
            target_defence_bonus = custom_defence_bonus;
        }
        console.log("calc_time_to_next_level");
        function calc_time_to_next_level(attack_level, strength_level, focus) {
            console.log("calc_time_to_next_level");
            var effective_attack_level = attack_level;
            var effective_strength_level = strength_level;
            var attack_level_addend = 0;
            var strength_level_addend = 0;
            var xp_needed = 0;
            // check focus
            switch(focus){
                case 1:
                    xp_needed = xp_diff_table[Number(attack_level)];
                    attack_level_addend = 3;
                    break;
                case 2:
                    xp_needed = xp_diff_table[Number(strength_level)];
                    strength_level_addend = 3;
                    break;
            }
            // accuracy
            var accuracy = calc_accuracy(effective_attack_level, attack_bonus, target_defence_level, target_defence_bonus);
            // max hit
            var max_hit = calc_max_hit(effective_strength_level, strength_bonus);
            // check for best time to use skill boosts
            var strength_boost_length = Math.abs(Math.floor(strength_level * (1 + strength_boost_factor) + strength_boost_addend) - strength_level);
            var attack_boost_length = Math.abs(Math.floor(attack_level * (1 + attack_boost_factor) + attack_boost_addend) - attack_level);
            var max_boost_length = Math.max(strength_boost_length, attack_boost_length);

            // calc xp rate, for initialization. Also just incase theres no boost used i think this is required
            var ticks_to_kill = calc_ticks_to_kill(target_health, max_hit, accuracy, attack_speed);
            //console.log(strength_boost_length, attack_boost_length, max_boost_length);
            var xp_per_hour = 6000/ ticks_to_kill * target_health * 4;

            var best_xp_per_hour = xp_per_hour;
            for (x = 1; x <= max_boost_length; x++) {
                // define effective levels
                // only recalc accuracy if attack boost is used
                // only recalc max hit if strength boost is used (future proofing xd)
                // i need these if statements since strength and attack boost length's wont always be the same
                if (x < attack_boost_length) {
                    effective_attack_level = calc_effective_level(attack_level, attack_prayer, attack_boost_factor, attack_boost_addend);
                    accuracy = calc_accuracy(effective_attack_level, attack_bonus, target_defence_level, target_defence_bonus);
                } else {
                    effective_attack_level = calc_effective_level(attack_level-x, attack_prayer, attack_boost_factor, attack_boost_addend);
                    accuracy = calc_accuracy(effective_attack_level, attack_bonus, target_defence_level, target_defence_bonus);
                }
                if (x < strength_boost_length) {
                    effective_strength_level = calc_effective_level(strength_level, strength_prayer, strength_boost_factor, strength_boost_addend);
                    max_hit = calc_max_hit(effective_strength_level, strength_bonus);
                } else {
                    effective_strength_level = calc_effective_level(strength_level-x, strength_prayer, strength_boost_factor, strength_boost_addend);
                    max_hit = calc_max_hit(effective_strength_level, strength_bonus);
                }
                // recalc ticks to kill
                var ticks_to_kill = calc_ticks_to_kill(target_health, max_hit, accuracy, attack_speed);
                // recalc xp per hour
                var xp_per_hour = 6000/ ticks_to_kill * target_health * 4 * (1-60/(4*x)/(boost_collection_rate));
                if (xp_per_hour > best_xp_per_hour) {
                    best_xp_per_hour = xp_per_hour;
                }
            }
            var time_to_next_level = xp_needed / best_xp_per_hour;
            console.log(time_to_next_level, effective_attack_level, effective_strength_level, max_hit, accuracy, best_xp_per_hour, ticks_to_kill, max_boost_length);
            return time_to_next_level;
        }

        // Function to add an edge between two nodes in the graph
        console.log("addEdge");
        var graph = {};
        function addEdge(nodeA, nodeB, weight) {
            console.log("addEdge");
            if (!graph[nodeA]) {
                graph[nodeA] = [];
            }
            if (!graph[nodeB]) {
                graph[nodeB] = [];
            }
            graph[nodeA].push({ node: nodeB, weight });
            graph[nodeB].push({ node: nodeA, weight });
        }

        // Function to calculate the shortest Order using Dijkstra's algorithm
        console.log("shortestOrder");
        function shortest_order(start_node, target_node) {
            var distances = {};
            var visited = new Set();
            var previous = {};

            Object.keys(graph).forEach((node) => {
                distances[node] = Infinity;
            });

            distances[start_node] = 0;

            while (visited.size < Object.keys(graph).length) {
                var current_node = null;
                var shortest_distance = Infinity;

                // Find the node with the shortest distance
                Object.keys(graph).forEach((node) => {
                    if (!visited.has(node) && distances[node] < shortest_distance) {
                        current_node = node;
                        shortest_distance = distances[node];
                    }
                });
                // Mark the current node as visited
                visited.add(current_node);

                // Update distances to neighboring nodes
                graph[current_node].forEach((neighbor) => {
                    var { node, weight } = neighbor;
                    var distance = distances[current_node] + weight;
                    if (distance < distances[node]) {
                        distances[node] = distance;
                        previous[node] = current_node;
                    }
                });
                console.log(`Visited Node: ${current_node}`);
            }
            // Revarruct the shortest Order
            var Order = [];
            var current_node = target_node;
            while (current_node !== start_node) {
                Order.unshift(current_node);
                current_node = previous[current_node];
            }
            Order.unshift(start_node);

            return Order;
        }
        console.log("format_order");
        function format_order(order) {
            var prev_attack_level = Number(start_attack_level);
            var prev_strength_level = Number(start_strength_level);
            var first_attack_level = start_attack_level;
            var first_strength_level = start_strength_level;
            var formatted_order = [];
            var hours = 0;
            var total_hours = 0;
            for (var index = 0; index < order.length; index++) {
                var node = order[index].split(',');
                var current_attack_level = Number(node[0]);
                var current_strength_level = Number(node[1]);

                var prev_prev_node = order[Math.max(index-2,0)].split(',');
                var prev_prev_attack_level = Number(prev_prev_node[0]);
                var prev_prev_strength_level = Number(prev_prev_node[1]);
                console.log(current_attack_level, current_strength_level, prev_attack_level, prev_strength_level, prev_prev_attack_level, prev_prev_strength_level);
                if (current_attack_level != prev_attack_level && prev_strength_level != prev_prev_strength_level) {
                    first_attack_level = prev_attack_level;
                    formatted_order.push(`${first_strength_level} - ${current_strength_level} Strength`);
                    hours = calc_strength_hours(first_strength_level, current_strength_level, prev_attack_level);
                    total_hours = total_hours + hours;
                    total_hours = Math.round(total_hours*1000)/1000;
                    console.log(hours, "HOURS");
                    formatted_order.push(`${total_hours} Hours`);
                } else if (current_strength_level != prev_strength_level && prev_attack_level != prev_prev_attack_level) {
                    first_strength_level = prev_strength_level;
                    formatted_order.push(`${first_attack_level} - ${current_attack_level} Attack`);
                    hours = calc_attack_hours(first_attack_level, current_attack_level, prev_strength_level);
                    total_hours = total_hours + hours;
                    total_hours = Math.round(total_hours*1000)/1000;
                    console.log(hours, "HOURS");
                    formatted_order.push(`${total_hours} Hours`);
                } else if (prev_attack_level == end_attack_level && current_strength_level == end_strength_level) {
                    formatted_order.push(`${first_strength_level} - ${current_strength_level} Strength`);
                    hours = calc_strength_hours(first_strength_level, current_strength_level, prev_attack_level);
                    total_hours = total_hours + hours;
                    total_hours = Math.round(total_hours*1000)/1000;
                    console.log(hours, "HOURS");
                    formatted_order.push(`${total_hours} Hours`);
                } else if (prev_strength_level == end_strength_level && current_attack_level == end_attack_level) {
                    formatted_order.push(`${first_attack_level} - ${current_attack_level} Attack`);
                    hours = calc_attack_hours(first_attack_level, current_attack_level, prev_strength_level);
                    total_hours = total_hours + hours;
                    total_hours = Math.round(total_hours*1000)/1000;
                    console.log(hours, "HOURS");
                    formatted_order.push(`${total_hours} Hours`);
                }

                prev_attack_level = current_attack_level;
                prev_strength_level = current_strength_level;
            }
            return formatted_order;
        }
        // calc the hours between 2 attack levels
        function calc_attack_hours(start_attack_level, end_attack_level, strength_level) {
            var total_hours = 0;
            for (;start_attack_level < end_attack_level; start_attack_level++) {
                var hours_to_level = calc_time_to_next_level(start_attack_level, strength_level, 1);
                total_hours = total_hours + hours_to_level;
            }
            return total_hours;
        }
        // calc the hours between 2 strength levels
        function calc_strength_hours(start_strength_level, end_strength_level, attack_level) {
            var total_hours = 0;
            for (;start_strength_level < end_strength_level; start_strength_level++) {
                var hours_to_level = calc_time_to_next_level(attack_level, start_strength_level, 2);
                total_hours = total_hours + hours_to_level;
            }
            return total_hours;
        }

        // Create graph
        console.log("graph");
//        console.log(start_attack_level, end_attack_level, start_strength_level, end_strength_level);
        for (var attack_level = start_attack_level; attack_level <= end_attack_level; attack_level++) {
            console.log("graph1");
            for (var strength_level = start_strength_level; strength_level <= end_strength_level; strength_level++) {
                var node = `${attack_level},${strength_level}`;
//                console.log(attack_level, strength_level, node);

                if (attack_level < end_attack_level) {
                    var next_attack_node = `${attack_level + 1},${strength_level}`;
                    var attack_level_time = calc_time_to_next_level(attack_level, strength_level, 1);
                    addEdge(node, next_attack_node, attack_level_time);
                }

                if (strength_level < end_strength_level) {
                    var next_strength_node = `${attack_level},${strength_level + 1}`;
                    var strength_level_time = calc_time_to_next_level(attack_level, strength_level, 2);
                    addEdge(node, next_strength_node, strength_level_time);
                }
            }
        }
        console.log("shortest order");
        var shortestOrderNodes = shortest_order(`${start_attack_level},${start_strength_level}`, `${end_attack_level},${end_strength_level}`);
        var formatted_order = format_order(shortestOrderNodes);
        console.log(...formatted_order);
        console.log(formatted_order[1], formatted_order[0]);
        console.log (shortestOrderNodes[1], shortestOrderNodes[0]);
        var table = document.getElementById("results-table");
        var tableBody = table.getElementsByTagName("tbody")[0];
        tableBody.innerHTML = ""; // Clear the table body before populating with new data

        // Add new rows with the results to the table
        for (var i = 0; i < formatted_order.length; i += 2) {
            var row = tableBody.insertRow(i / 2);
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);

            cell1.textContent = formatted_order[i];
            cell2.textContent = formatted_order[i + 1];
        }


    }
    document.getElementById("calculate-button").addEventListener("click", function(event) {
        event.preventDefault();
        // Call the `melee_order_results()` function
        melee_order_results();
    });

}
$(document).ready(melee_order);
$(document).on('page:load', melee_order);
