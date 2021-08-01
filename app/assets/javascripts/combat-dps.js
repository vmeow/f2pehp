function combatDPS() {
    function maxhit(level, gear){
    level += 8;
    return Math.floor(0.5 + level * (gear+64) / 640);
    }

    function getAttributeValue(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.value : 0;
    }	

    function getAttributeChecked(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.checked : false;
    }

    function dps(){
        // Scan variables
        var att = getAttributeValue("att");
        var str = getAttributeValue("str");
        var attStyle = getAttributeValue("melee_style");
        var attPrayer = getAttributeValue("att_pray");
        var strPrayer = getAttributeValue("str_pray");
        
        var strPot = getAttributeChecked('str_pot');

        var meleeWeapon = getAttributeValue("melee_weapon");
        var meleeNeck = getAttributeValue("melee_neck");
        var meleeBoots = getAttributeChecked("melee_boots");

        var mob = getAttributeValue("mob_name");
        var customStats = getAttributeChecked('custom_stats');
        var mobHP = getAttributeValue("mob_hp");
        var mobDef = getAttributeValue("mob_def");
        var mobArm = getAttributeValue("mob_arm");
        
        var customPlayerStats = getAttributeChecked('custom_stats_melee');
        var customAtt = getAttributeValue("att_bonus");
        var customStr = getAttributeValue("str_bonus");
        var customSpeed = getAttributeValue("att_speed");
        var customDmgMult = getAttributeValue("dmg_mult");

        // Equipment bonuses
        var attBonus = 0;
        var strBonus = 0;
        var meleeTicks = 4;
        var meleeAttStyle = "";
        var dmgMult = 1;
        switch(meleeWeapon){
            case "Rune scimitar":
                attBonus += 45;
                strBonus += 44;
                meleeTicks = 4;
                meleeAttStyle = "Slash";
                break;
            case "Rune sword":
                attBonus += 38;
                strBonus += 39;
                meleeTicks = 4;
                meleeAttStyle = "Stab";
                break;
            case "Barronite mace":
                attBonus += 40;
                strBonus += 40;
                meleeTicks = 4;
                meleeAttStyle = "Crush";
                dmgMult = 1.15;
                break;
            case "Rune longsword":
                attBonus += 47;
                strBonus += 49;
                meleeTicks = 5;
                meleeAttStyle = "Slash";
                break;
            case "Rune battleaxe":
                attBonus += 48;
                strBonus += 64;
                meleeTicks = 6;
                meleeAttStyle = "Slash";
                break;
            case "Rune 2h sword":
                attBonus += 69;
                strBonus += 70;
                meleeTicks = 7;
                meleeAttStyle = "Slash";
                break;
            case "Hill giant club":
                attBonus += 65;
                strBonus += 70;
                meleeTicks = 7;
                meleeAttStyle = "Crush";
                break;
            case "Adamant scimitar":
                attBonus += 29;
                strBonus += 28;
                meleeTicks = 4;
                meleeAttStyle = "Slash";
                break;
            case "Adamant sword":
                attBonus += 23;
                strBonus += 24;
                meleeTicks = 4;
                meleeAttStyle = "Stab";
                break;
            case "Adamant 2h sword":
                attBonus += 43;
                strBonus += 44;
                meleeTicks = 7;
                meleeAttStyle = "Slash";
                break;
            case "None":
                meleeTicks = 4;
                meleeAttStyle = "Crush";
                break;
            case "Event rpg":
                meleeTicks = 3;
                meleeAttStyle = "Crush";
                break;
            default:
                meleeTicks = 4;
                meleeAttStyle = "Crush";
                break;
        }
        
        switch(meleeNeck){
            case "Amulet of power":
                attBonus += 6;
                strBonus += 6;
                break;
            case "Amulet of strength":
                strBonus += 10;
                break;
            case "Amulet of accuracy":
                attBonus += 4;
                break;
            default:
                break;
        }

        if (meleeBoots) {
            strBonus += 1;
        }
        
        // Effective str
        var A = str;
        if(strPot){
            A = Math.floor(A * 1.1 + 3);
        }

        switch(strPrayer){
            case "Burst of Strength (+5%)":
                A *= 1.05;
                break;
            case "Superhuman Strength (+10%)":
                A *= 1.10;
                break;
            case "Ultimate Strength (+15%)":
                A *= 1.15;
                break;
            default:
                break;
        }

        A = Math.floor(A);
        switch(attStyle){
            case "Aggressive":
                A += 3;
                break;
            case "Controlled":
                if(meleeWeapon == "Rune scimitar"){
                    meleeAttStyle = "Stab"; 
                    att -= 38;
                } else if(meleeWeapon == "Adamant scimitar") {
                    meleeAttStyle = "Stab"; 
                    att -= 23;
                }
                A += 1;
                break;
            case "Accurate":
                break;
            case "Defensive":
                break;
            default:
                break;
        }

        // Maximum base hits
        if(customPlayerStats){
            var maxHit = maxhit(A, Number(customStr));
        } else {
            var maxHit = maxhit(A, strBonus);
        }

        // Effective att
        var effA = att;
        switch(attPrayer){
            case "Clarity of Thought (+5%)":
                effA *= 1.05;
                break;
            case "Improved Reflexes (+10%)":
                effA *= 1.10;
                break;
            case "Incredible Reflexes (+15%)":
                effA *= 1.15;
                break;
            default:
                break;
        }
        effA = Math.floor(effA) + 8;
        switch(attStyle){
            case "Accurate":
                effA += 3;
                break;
            case "Controlled":
                effA += 1;
                break;
            case "Aggressive":
                break;
            case "Defensive":
                break;
            default:
                break;
        }

        // Attack roll
        if(customPlayerStats){
            var attRoll = effA * (Number(customAtt) + 64);
            meleeTicks = Number(customSpeed);
        } else {
            var attRoll = effA * (attBonus + 64);
        }

        // Enemy effective def & defence roll
        var enemyDef = 0;
        var enemyHP = 0;
        var enemyArm = 0;
        var isGolem = false;
        
        switch(mob){
            case "Flawed Golem":
                enemyDef = 6;
                enemyHP = 25;
                if(meleeAttStyle == "Crush"){
                    enemyArm = 0;
                } else {
                    enemyArm = 5;
                }
                isGolem = true;
                break;
            case "Mind Golem":
                enemyDef = 25;
                enemyHP = 40;
                if(meleeAttStyle == "Crush"){
                    enemyArm = 0;
                } else {
                    enemyArm = 5;
                }
                isGolem = true;
                break;
            case "Body Golem":
                enemyDef = 45;
                enemyHP = 60;
                if(meleeAttStyle == "Crush"){
                    enemyArm = 0;
                } else {
                    enemyArm = 5;
                }
                isGolem = true;
                break;
            case "Ogress Warrior":
                enemyDef = 82;
                enemyHP = 82;
                if(meleeAttStyle == "Stab"){
                    enemyArm = 10;
                } else {
                    enemyArm = 12;
                }
                break;
            case "Ogress Shaman":
                enemyDef = 82;
                enemyHP = 82;
                if(meleeAttStyle == "Stab"){
                    enemyArm = 12;
                } else {
                    enemyArm = 14;
                }
                break;
            case "Obor":
                enemyDef = 60;
                enemyHP = 120;
                if(meleeAttStyle == "Stab"){
                    enemyArm = 35;
                } else if(meleeAttStyle == "Slash"){
                    enemyArm = 40;
                } else{
                    enemyArm = 45;
                }
            case "Bryophyta":
                enemyDef = 100;
                enemyHP = 115;
                enemyArm = 0;
            case "Lesser demon":
                enemyDef = 71;
                enemyHP = 81;
                break;
            case "Moss giant":
                enemyDef = 30;
                enemyHP = 60;
                break;
            case "Hill giant":
                enemyDef = 26;
                enemyHP = 35;
                break;
            case "Giant spider":
                enemyDef = 31;
                enemyHP = 50;
                enemyArm = 10;
                break;
            case "Flesh crawler":
                enemyDef = 10;
                enemyHP = 25;
                enemyArm = 15;
                break;
            case "Ice Giant":
                enemyDef = 40;
                enemyHP = 70;
                if(meleeAttStyle == "Stab"){
                    enemyArm = 0;
                } else if(meleeAttStyle == "Slash"){
                    enemyArm = 3;
                } else{
                    enemyArm = 2;
                }
                break;
            case "Dark Wizard (Level 20)":
                enemyDef = 14;
                enemyHP = 24;
                break;
            default:
                break;
        }
        if(customStats){
            enemyDef = Number(mobDef);
            enemyHP = Number(mobHP);
            enemyArm = Number(mobArm);
        }

        if (customPlayerStats){
            maxHit = Math.floor(maxHit * customDmgMult);
        } else if (isGolem && meleeWeapon == "Barronite mace") {
            maxHit = Math.floor(maxHit * dmgMult);
        }

        var effD = enemyDef + 9;
        var defRoll = effD * (enemyArm+64);

        // Hit chance
        var accuracy = 0;
        if(attRoll > defRoll){
            accuracy = 1 - (defRoll+2) / (2*(attRoll+1));
        }
        else{
            accuracy = attRoll / (2*(defRoll+1));
        }

        // DPS
        var dps = accuracy * maxHit / 2 / (0.6*meleeTicks);

        // Overkill formula
        var Y = Math.min(maxHit,enemyHP);
        var realhit = ( (accuracy*Y*(Y+1)) / (enemyHP*(maxHit+1) )) * ( 0.5 * (maxHit+enemyHP+1) - ((1/3) * (2*Y+1)) );

        // Overkill DPS
        var okdps = realhit / (0.6*meleeTicks);
        
        // XP/h
        var xph = okdps * 3600 * 4;

        // Rounding
        accuracy = Math.round(accuracy*10000)/10000;
        dps = Math.round(dps*1000)/1000;

        // Output
        if (customAtt <= -65) {
            accuracy = 0;
            dps = 0;
            xph = 0;
        }
        $("#melee_maxhit").val(maxHit);
        $("#melee_accuracy").val(accuracy);
        $("#melee_dps").val(dps);
        $("#melee_xph").val(Math.round(xph));
        //document.getElementById("#melee_maxhit").value = maxHit;
        //document.getElementById("#melee_accuracy").innerHTML = accuracy;
        //document.getElementById("#melee_dps").innerHTML = dps;
        //document.getElementById("#melee_xph").innerHTML = Math.round(xph);
        //document.getElementById("projections").innerHTML = projections;
    }

    function rangeddps(){
        // Scan variables
        var ranged = getAttributeValue("ranged");
        var rangedStyle = getAttributeValue("ranged_style");
        var rangedPrayer = getAttributeValue("ranged_pray");

        var rangedWeapon = getAttributeValue("ranged_weapon");
        var rangedAmmo = getAttributeValue("ranged_ammo");
        var rangedNeck = getAttributeValue("ranged_neck");
        var rangedHead = getAttributeValue("ranged_head");
        var rangedBody = getAttributeValue("ranged_body");
        var rangedLegs = getAttributeValue("ranged_legs");
        var rangedHand = getAttributeValue("ranged_hand");

        var mob = getAttributeValue("mob_name");
        var customStats = getAttributeChecked("custom_stats");
        var mobHP = getAttributeValue("mob_hp");
        var mobDef = getAttributeValue("mob_def");
        var mobArm = getAttributeValue("mob_arm");
        
        var customPlayerStats = getAttributeChecked('custom_stats_ranged');
        var customRangedAtt = getAttributeValue("ranged_att_bonus");
        var customRangedStr = getAttributeValue("ranged_str_bonus");
        var customRangedSpeed = getAttributeValue("ranged_att_speed");
        var customDmgMult = getAttributeValue("ranged_dmg_mult");

        // Equipment bonuses
        var rangedBonus = 0;
        var rangedStr = 0;
        var rangedTicks = 4;
        
        switch(rangedWeapon){
            case "Maple shortbow":
                rangedBonus += 29;
                break;
            case "Willow shortbow":
                rangedBonus += 20;
                break;
            case "Oak shortbow":
                rangedBonus += 14;
                break;
            case "Shortbow":
                rangedBonus += 8;
                break;
        }
        
        switch(rangedAmmo){
            case "Adamant arrow":
                rangedStr += 31;
                break;
            case "Mithril arrow":
                rangedStr += 22;
                break;
            case "Steel arrow":
                rangedStr += 16;
                break;
            case "Iron arrow":
                rangedStr += 10;
                break;
            case "Bronze arrow":
                rangedStr += 7;
                break;
        }
        
        switch(rangedNeck){
            case "Amulet of power":
                rangedBonus += 6;
                break;
            case "Amulet of accuracy":
                rangedBonus += 4;
                break;
            default:
                break;
        }
        
        switch(rangedHead){
            case "Coif":
                rangedBonus += 2;
                break;
            case "Leather cowl":
                rangedBonus += 1;
                break;
            default:
                break;
        }
        
        switch(rangedBody){
            case "Green d'hide body":
                rangedBonus += 15;
                break;
            case "Studded/Hardleather body":
                rangedBonus += 8;
                break;
            case "Leather body":
                rangedBonus += 2;
                break;
            default:
                break;
        }
        
        switch(rangedLegs){
            case "Green d'hide chaps":
                rangedBonus += 8;
                break;
            case "Studded chaps":
                rangedBonus += 6;
                break;
            case "Leather chaps":
                rangedBonus += 4;
                break;
            default:
                break;
        }
        
        switch(rangedHand){
            case "Green d'hide vambs":
                rangedBonus += 8;
                break;
            case "Leather vambs":
                rangedBonus += 4;
                break;
            default:
                break;
        }
        // Effective str
        var rangedA = Number(ranged);
        var rangedEffA = Number(ranged);

        switch(rangedPrayer){
            case "Sharp Eye (+5%)":
                rangedA *= 1.05;
                rangedEffA *= 1.05;
                break;
            case "Hawk Eye (+10%)":
                rangedA *= 1.10;
                rangedEffA *= 1.10;
                break;
            case "Eagle Eye (+15%)":
                rangedA *= 1.15;
                rangedEffA *= 1.15;
                break;
            default:
                break;
        }

        rangedA = Math.floor(rangedA);
        switch(rangedStyle){
            case "Accurate":
                rangedA += 3;
                rangedEffA += 3;
                break;
            case "Rapid":
                rangedTicks = 3;
                break;
            case "Defensive":
                break;
            default:
                break;
        }

        // Maximum base hits, attack roll
        if(customPlayerStats){
            var attRoll = rangedEffA * (Number(customRangedAtt) + 64);
            var rangedMaxHit = maxhit(rangedA, Number(customRangedStr));
            rangedTicks = Number(customRangedSpeed);
        } else {
            var attRoll = rangedEffA * (rangedBonus + 64);
            var rangedMaxHit = maxhit(rangedA, rangedStr);
        }
        
        rangedEffA = Math.floor(rangedEffA) + 8;
        
        // Enemy effective def & defence roll
        var enemyDef = 0;
        var enemyHP = 0;
        var enemyArm = 0;
        
        switch(mob){
            case "Ogress Warrior":
                enemyDef = 82;
                enemyHP = 82;
                enemyArm = 16;
                break;
            case "Ogress Shaman":
                enemyDef = 82;
                enemyHP = 82;
                enemyArm = 8;
                break;
            case "Flawed Golem":
                enemyDef = 6;
                enemyHP = 25;
                enemyArm = 10;
                break;
            case "Mind Golem":
                enemyDef = 25;
                enemyHP = 40;
                enemyArm = 10;
                break;
            case "Body Golem":
                enemyDef = 45;
                enemyHP = 60;
                enemyArm = 10;
                break;
            case "Obor":
                enemyDef = 60;
                enemyHP = 120;
                enemyArm = 20;
                break;
            case "Bryophyta":
                enemyDef = 100;
                enemyHP = 115;
                enemyArm = 0;
                break;
            case "Lesser demon":
                enemyDef = 71;
                enemyHP = 81;
                break;
            case "Moss giant":
                enemyDef = 30;
                enemyHP = 60;
                break;
            case "Hill giant":
                enemyDef = 26;
                enemyHP = 35;
                break;
            case "Giant spider":
                enemyDef = 31;
                enemyHP = 50;
                enemyArm = 10;
                break;
            case "Flesh crawler":
                enemyDef = 10;
                enemyHP = 25;
                enemyArm = 15;
                break;
            case "Ice Giant":
                enemyDef = 40;
                enemyHP = 70;
                break;
            case "Dark Wizard (Level 20)":
                enemyDef = 14;
                enemyHP = 24;
                break;
            default:
                break;
        }
        if(customStats){
            enemyDef = Number(mobDef);
            enemyHP = Number(mobHP);
            enemyArm = Number(mobArm);
        }

        if(customPlayerStats){
            rangedMaxHit = Math.floor(rangedMaxHit * customDmgMult);
        }
        
        var effD = enemyDef + 9;
        var defRoll = effD * (enemyArm+64);

        // Hit chance
        var rangedAccuracy = 0;
        if(attRoll > defRoll) {
            rangedAccuracy = 1 - (defRoll+2) / (2*(attRoll+1));
        } else {
            rangedAccuracy = attRoll / (2*(defRoll+1));
        }

        // DPS
        var rangedDps = rangedAccuracy * rangedMaxHit / 2 / (0.6*rangedTicks);

        // Overkill formula
        var Y = Math.min(rangedMaxHit, enemyHP);
        var realhit = ( (rangedAccuracy*Y*(Y+1)) / (enemyHP*(rangedMaxHit+1) )) * ( 0.5 * (rangedMaxHit+enemyHP+1) - ((1/3) * (2*Y+1)) );

        // Overkill DPS
        var okdps = realhit / (0.6*rangedTicks);

        // XP/h
        var rangedXph = okdps * 3600 * 4;

        // Rounding
        rangedAccuracy = Math.round(rangedAccuracy*10000)/10000;
        rangedDps = Math.round(rangedDps*1000)/1000;

        // Output
        if (customRangedAtt <= -65) {
            rangedAccuracy = 0;
            rangedDps = 0;
            rangedXph = 0;
        }
        $("#ranged_maxhit").val(rangedMaxHit);
        $("#ranged_accuracy").val(rangedAccuracy);
        $("#ranged_dps").val(rangedDps);
        $("#ranged_xph").val(Math.round(rangedXph));
    }

    function magicdps(){
        // Scan variables
        var magic = getAttributeValue("magic");
        var magicPrayer = getAttributeValue("magic_pray");
        var magicSpell = getAttributeValue("magic_spell");

        var magicWeapon = getAttributeValue("magic_weapon");
        var magicNeck = getAttributeValue("magic_neck");
        var magicHead = getAttributeValue("magic_head");
        var magicBody = getAttributeValue("magic_body");
        var magicLegs = getAttributeValue("magic_legs");

        var mob = getAttributeValue("mob_name");
        var customStats = getAttributeChecked('custom_stats');
        var pvp = getAttributeChecked("pvp");
        var mobHP = getAttributeValue("mob_hp");
        var mobDef = getAttributeValue("mob_def");
        var mobMagic = getAttributeValue("mob_magic");
        var mobArm = getAttributeValue("mob_arm");
        
        var customPlayerStats = getAttributeChecked('custom_stats_magic');
        var customMagicAtt = getAttributeValue("magic_att_bonus");
        var customMagicSpeed = getAttributeValue("magic_att_speed");
        var customDmgMult = getAttributeValue("magic_dmg_mult");

        
        // Equipment bonuses
        var magicBonus = 0;
        var magicTicks = 5;
        
        switch(magicWeapon){
            case "Staff of (element)":
                magicBonus += 10;
                break;
        }
        
        switch(magicNeck){
            case "Amulet of magic":
                magicBonus += 10;
                break;
            case "Amulet of power":
                magicBonus += 6;
                break;
            case "Amulet of accuracy":
                magicBonus += 4;
                break;
            default:
                break;
        }
        
        switch(magicHead){
            case "Wizard hat":
                magicBonus += 2;
                break;
        }
        
        switch(magicBody){
            case "Wizard robe":
                magicBonus += 3;
                break;
            case "Zamorak robe top":
                magicBonus += 2;
                break;
            default:
                break;
        }
        
        switch(magicLegs){
            case "Zamorak robe":
                magicBonus += 2;
                break;
            default:
                break;
        }
        
        // Maximum base hits
        var magicMaxHit = 0;
        var magicXpPerCast = 0;
        switch(magicSpell){
            case "Fire blast":
                magicMaxHit = 16;
                magicXpPerCast = 34.5;
                break;
            case "Fire bolt":
                magicMaxHit = 12;
                magicXpPerCast = 22.5;
                break;
            case "Fire strike":
                magicMaxHit = 8;
                magicXpPerCast = 11.5;
                break;
        }

        var magicEffA = Number(magic);
        switch(magicPrayer){
            case "Mystic Will (+5%)":
                magicEffA *= 1.05;
                break;
            case "Mystic Lore (+10%)":
                magicEffA *= 1.10;
                break;
            case "Mystic Might (+15%)":
                magicEffA *= 1.15;
                break;
            default:
                break;
        }
        magicEffA = Math.floor(magicEffA) + 8;
        
        // Attack roll
        if(customPlayerStats){
            var attRoll = magicEffA * (Number(customMagicAtt) + 64);
            magicTicks = Number(customMagicSpeed);
        } else {
            var attRoll = magicEffA * (magicBonus + 64);
        }

        // Enemy effective def & defence roll
        var enemyDef = 0;
        var enemyHP = 0;
        var enemyArm = 0;
        
        switch(mob){
            case "Ogress Warrior":
                enemyDef = 60;
                enemyHP = 82;
                enemyArm = 14;
                break;
            case "Ogress Shaman":
                enemyDef = 68;
                enemyHP = 82;
                enemyArm = 16;
                break;
            case "Flawed Golem":
                enemyDef = 6;
                enemyHP = 25;
                enemyArm = 2;
                break;
            case "Mind Golem":
                enemyDef = 25;
                enemyHP = 40;
                enemyArm = 2;
                break;
            case "Body Golem":
                enemyDef = 45;
                enemyHP = 60;
                enemyArm = 2;
                break;
            case "Obor":
                enemyDef = 60;
                enemyHP = 120;
                enemyArm = 20;
            case "Bryophyta":
                enemyDef = 100;
                enemyHP = 115;
                enemyArm = 0;
            case "Lesser demon":
                enemyDef = 1;
                enemyHP = 81;
                enemyArm = -10;
                break;
            case "Moss giant":
                enemyDef = 1;
                enemyHP = 60;
                break;
            case "Hill giant":
                enemyDef = 1;
                enemyHP = 35;
                break;
            case "Giant spider":
                enemyDef = 1;
                enemyHP = 50;
                enemyArm = 10;
                break;
            case "Flesh crawler":
                enemyDef = 1;
                enemyHP = 25;
                enemyArm = 15;
                break;
            case "Ice Giant":
                enemyDef = 1;
                enemyHP = 70;
                break;
            case "Dark Wizard (Level 20)":
                enemyDef = 22;
                enemyHP = 24;
                enemyArm = 3;
                break;
            default:
                break;
        }
        if(customStats){
            if(pvp){
                enemyDef = Math.floor(Number(mobDef) * 0.3) + Math.floor(Number(mobMagic) * 0.7);
            } else {
                enemyDef = Number(mobMagic);
            }
            enemyHP = Number(mobHP);
            enemyArm = Number(mobArm);
        }

        if(customPlayerStats){
            magicMaxHit = Math.floor(magicMaxHit * customDmgMult);
        }
        
        var effD = enemyDef + 9;
        var defRoll = effD * (enemyArm+64);

        // Hit chance
        var magicAccuracy = 0;
        if(attRoll > defRoll) {
            magicAccuracy = 1 - (defRoll+2) / (2*(attRoll+1));
        } else {
            magicAccuracy = attRoll / (2*(defRoll+1));
        }

        // DPS
        var magicDps = magicAccuracy * magicMaxHit / 2 / (0.6*magicTicks);

        // Overkill formula
        var Y = Math.min(magicMaxHit, enemyHP);
        var realhit = ( (magicAccuracy*Y*(Y+1)) / (enemyHP*(magicMaxHit+1) )) * ( 0.5 * (magicMaxHit+enemyHP+1) - ((1/3) * (2*Y+1)) );

        // Overkill DPS
        var okdps = realhit / (0.6*magicTicks);

        // XP/h
        var magicXph = okdps * 3600 * 2 + 6000/magicTicks*magicXpPerCast;

        // Rounding
        magicAccuracy = Math.round(magicAccuracy*10000)/10000;
        magicDps = Math.round(magicDps*1000)/1000;
        
        // Output
        if (customMagicAtt <= -65) {
            magicAccuracy = 0;
            magicDps = 0;
            magicXph = 6000/magicTicks*magicXpPerCast;
        }
        $("#magic_maxhit").val(magicMaxHit);
        $("#magic_accuracy").val(magicAccuracy);
        $("#magic_dps").val(magicDps);
        $("#magic_xph").val(Math.round(magicXph));
    }

    function combat(){
        // Scan variables
        var att = getAttributeValue("combat_att");
        var str = getAttributeValue("combat_str");
        var def = getAttributeValue("combat_def");
        var hp = getAttributeValue("combat_hp");
        var pray = getAttributeValue("combat_pray");
        var ranged = getAttributeValue("combat_ranged");
        var magic = getAttributeValue("combat_magic");

        // Calc Combat
        var base = 0.25 * (Number(def) + Number(hp) + Number(Math.floor(pray/2)));
        var melee = 0.325 * (Number(att) + Number(str));
        var range = 0.325 * (Math.floor(ranged/2) + Number(ranged));
        var mage = 0.325 * (Math.floor(magic/2) + Number(magic));
        var combat = Math.floor(base + Math.max(melee, range, mage)) 

        // Output
        $("#combat_level").val(combat);
    }

    function startup() {
        // run the update on every input change and on startup
        $('#att').change(dps);
        $('#str').change(dps);
        $('#att_pray').change(dps);
        $('#str_pray').change(dps);
        $('#str_pot').change(dps);
        $('#melee_style').change(dps);
        $('#melee_weapon').change(dps);
        $('#melee_neck').change(dps);
        $('#melee_boots').change(dps);
        $('#mob_name').change(dps);
        $('#custom_stats').change(dps);
        $('#pvp').change(dps);
        $('#mob_arm').change(dps);
        $('#mob_hp').change(dps);
        $('#mob_def').change(dps);
        $('#custom_stats_melee').change(dps);
        $('#att_bonus').change(dps);
        $('#str_bonus').change(dps);
        $('#att_speed').change(dps);
        $('#dmg_mult').change(dps);
        
        $('#ranged').change(rangeddps);
        $('#ranged_pray').change(rangeddps);
        $('#ranged_style').change(rangeddps);
        $('#ranged_weapon').change(rangeddps);
        $('#ranged_ammo').change(rangeddps);
        $('#ranged_neck').change(rangeddps);
        $('#ranged_head').change(rangeddps);
        $('#ranged_body').change(rangeddps);
        $('#ranged_legs').change(rangeddps);
        $('#ranged_hand').change(rangeddps);
        $('#mob_name').change(rangeddps);
        $('#custom_stats').change(rangeddps);
        $('#pvp').change(rangeddps);
        $('#mob_arm').change(rangeddps);
        $('#mob_hp').change(rangeddps);
        $('#mob_def').change(rangeddps);
        $('#custom_stats_ranged').change(rangeddps);
        $('#ranged_att_bonus').change(rangeddps);
        $('#ranged_str_bonus').change(rangeddps);
        $('#ranged_att_speed').change(rangeddps);
        $('#ranged_dmg_mult').change(rangeddps);
        
        $('#magic').change(magicdps);
        $('#magic_pray').change(magicdps);
        $('#magic_weapon').change(magicdps);
        $('#magic_neck').change(magicdps);
        $('#magic_head').change(magicdps);
        $('#magic_body').change(magicdps);
        $('#magic_legs').change(magicdps);
        $('#magic_spell').change(magicdps);
        $('#mob_name').change(magicdps);
        $('#custom_stats').change(magicdps);
        $('#pvp').change(magicdps);
        $('#mob_arm').change(magicdps);
        $('#mob_magic').change(magicdps);
        $('#mob_hp').change(magicdps);
        $('#mob_def').change(magicdps);
        $('#custom_stats_magic').change(magicdps);
        $('#magic_att_bonus').change(magicdps);
        $('#magic_att_speed').change(magicdps);
        $('#magic_dmg_mult').change(magicdps);
        
        $('#combat_att').change(combat);
        $('#combat_str').change(combat);
        $('#combat_def').change(combat);
        $('#combat_hp').change(combat);
        $('#combat_pray').change(combat);
        $('#combat_magic').change(combat);
        $('#combat_ranged').change(combat);

        dps()
        rangeddps()
        magicdps()
        combat()

    }

    // Only run on the combat and dps pages
    if ($('#body-dps').length || $('#body-combat').length) {
        startup();
    }
}

$(document).ready(combatDPS);
$(document).on('page:load', combatDPS);