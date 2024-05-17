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
    //java script breaks when it tries to >factorial(26) :^(
    var floorValue = Math.floor(target_health / (max_hit + 1));
    if (floorValue > 24) {
        var y = Math.min(target_health, max_hit);
        var average_hit = (y * (y+1))/(target_health * (max_hit + 1)) * (0.5 * (max_hit + target_health + 1) - 1/3 * (2*y+1));
        return target_health/average_hit;
    }

    for (var n = 0; n <= floorValue; n++) {
        var product = 1;

        for (var i = 0; i <= n-1 ; i++) {
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

function calc_effective_level(level, prayer, skill_boost_factor, skill_boost_addend, style_bonus) {
    var effective_level = Math.floor(Math.floor(level * (1 + skill_boost_factor) + skill_boost_addend) * prayer) + style_bonus;
    return effective_level;
}
