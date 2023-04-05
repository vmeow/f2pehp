function monster_ratio() {
    function getAttributeValue(a) {
        var ele = document.querySelector('[name="' + a + '"]');
        return ele ? ele.value : 0;
    }

    function getAttributeChecked(value) {
        var ele = document.querySelector('[name="' + value + '"]');
        return ele ? ele.checked : false;
    }

    function calcRatio(combatxp, smithxp, craftxp, runecraftxp, smithper1, craftper1, runecraftper1, natsper1, lawsper1, hpper1, smithper2, craftper2, runecraftper2, natsper2, lawsper2, hpper2, smithperlaw, craftperlaw, runecraftperlaw, smithpernat, runecraftpercraft, start_laws, start_nats, runecraft_setting) {
        
        if (runecraft_setting) {
            if (runecraftper1 > runecraftper2)
            runecraftxp/Math.max(runecraftper1, runecraftper2)
        }
         
        var smithxp = smithxp - (start_nats*smithpernat);
        
        const monster1_zero_time_crafting = Math.max(1 - craftper1 / (4 * hpper1) * (combatxp / craftxp), 0);
        const monster1_zero_time_smithing = 1 - (1 - (craftxp / smithxp) * monster1_zero_time_crafting * 13.7 / 52.5);
        const monster1_zero_time_runecraft = Math.max(1 - craftxp/runecraftxp * monster1_zero_time_crafting * runecraftpercraft, 0);
        
        

        const monster1_laws_for_craft = craftxp * monster1_zero_time_crafting / craftperlaw;
        const monster1_laws_for_smith = Math.max(((smithxp - combatxp * (natsper1 / (4 * hpper1) * smithpernat)) - smithxp * monster1_zero_time_smithing) / smithperlaw, 0);
        const monster1_laws_for_runecraft = Math.max((runecraftxp * monster1_zero_time_runecraft - combatxp * (hpper1*4*runecraftper1)),0) / runecraftperlaw;
        const monster1_laws_gained = combatxp * lawsper1 / (4 * hpper1);
        
        const monster2_zero_time_crafting = Math.max(1 - craftper2 / (4 * hpper2) * (combatxp / craftxp), 0);
        const monster2_zero_time_smithing = 1 - (1 - (craftxp / smithxp) * monster2_zero_time_crafting * 13.7 / 52.5);
        const monster2_zero_time_runecraft = Math.max(1 - craftxp/runecraftxp * monster2_zero_time_crafting * runecraftpercraft, 0);

        const monster2_laws_for_craft = craftxp * monster2_zero_time_crafting / craftperlaw;
        const monster2_laws_for_smith = Math.max(((smithxp - combatxp * (natsper2 / (4 * hpper2) * smithpernat)) - smithxp * monster2_zero_time_smithing) / smithperlaw, 0);
        const monster2_laws_for_runecraft = Math.max((runecraftxp * monster2_zero_time_runecraft - combatxp * (hpper2*4*runecraftper2)),0) / runecraftperlaw;
        
        const monster2_laws_gained = combatxp * lawsper2 / (4 * hpper2);

        var top = monster1_laws_for_craft + monster1_laws_for_smith + monster1_laws_for_runecraft - start_laws - monster1_laws_gained;
        var bottom = monster2_laws_gained - (monster2_laws_for_craft + monster2_laws_for_smith + monster2_laws_for_runecraft - start_laws);     

        let x = Math.max(top / bottom, 0);
        let findperc = 0;
        if (x == 0 && Math.max(top, bottom) == top) {
          findperc = 1;
        } else if (x != 0) {
          findperc = 1 - (x / (1 + x));
        }
        
        return Math.max(findperc, 0);
    }
    
    function monster_ratio_results() {
        //xp needed
        var start_combat_xp = getAttributeValue("start_combat_xp");
        var end_combat_xp = getAttributeValue("end_combat_xp");
        var start_smithing_xp = getAttributeValue("start_smithing_xp");
        var end_smithing_xp = getAttributeValue("end_smithing_xp");
        var start_crafting_xp = getAttributeValue("start_crafting_xp");
        var end_crafting_xp = getAttributeValue("end_crafting_xp");
        var start_runecraft_xp = getAttributeValue("start_runecraft_xp");
        var end_runecraft_xp = getAttributeValue("end_runecraft_xp");
        var start_laws = getAttributeValue("start_laws");
        var start_nats = getAttributeValue("start_nats");

        //methods
        var monster1 = getAttributeValue("monster1");
        var monster2 = getAttributeValue("monster2");
        var smithmethod = getAttributeValue("smithmethod");
        var craftmethod = getAttributeValue("craftmethod");
        var runecraftmethod = getAttributeValue("runecraftmethod");
        


        //settings
        var boss_setting = getAttributeChecked("boss_setting");
        var wildy_hill_setting = getAttributeChecked("wildy_hill_setting");
        var wildy_moss_setting = getAttributeChecked("wildy_moss_setting");
        var bryo_staff_setting = getAttributeChecked("bryo_staff_setting");
        var runecraft_setting = getAttributeChecked("runecraft_setting");
        var smith_nat_setting = getAttributeChecked("smith_nat_setting");
        //custom
        var custom_smith_xp_per_law = getAttributeValue("smith_xp_per_law");
        var custom_smith_xp_per_nat = getAttributeValue("smith_xp_per_nat");
        var custom_craft_xp_per_law = getAttributeValue("craft_xp_per_law");
        var custom_runecraft_xp_per_law = getAttributeValue("runecraft_xp_per_law");

        var custom1hp = getAttributeValue("custom1hp");
        var custom1laws = getAttributeValue("custom1laws");
        var custom1nats = getAttributeValue("custom1nats");
        var custom1craft = getAttributeValue("custom1craft");
        var custom1smith = getAttributeValue("custom1smith");
        var custom1runecraft = getAttributeValue("custom1runecraft");
        var custom2hp = getAttributeValue("custom2hp");
        var custom2laws = getAttributeValue("custom2laws");
        var custom2nats = getAttributeValue("custom2nats");
        var custom2craft = getAttributeValue("custom2craft");
        var custom2smith = getAttributeValue("custom2smith");
        var custom2runecraft = getAttributeValue("custom2runecraft");

        //formula variables
        var combatxp = end_combat_xp - start_combat_xp;
        var smithxp = end_smithing_xp - start_smithing_xp;
        var craftxp = end_crafting_xp - start_crafting_xp;
        var runecraftxp = end_runecraft_xp - start_runecraft_xp;
        var start_charges = 0;
        //
        var craftper1 = 0;
        var smithper1 = 0;
        var natsper1 = 0;
        var lawsper1 = 0;
        var hpper1 = 1;
        var runecraftper1 = 0;
        
        var craftper2 = 0;
        var smithper2 = 0;
        var natsper2 = 0;
        var lawsper2 = 0;
        var hpper2 = 1;
        var runecraftper2 = 0;

        var smithperlaw = (3.5*37.5);
        var craftperlaw = 24 * 52.5;
        var smithpernat = 37.5;
        var runecraftperlaw = 0;
        
        var smithpercraft = 13.7/52.5;
        var runecraftpercraft = 0;


        // logic for wildy keys
        var giant_key_rate = (1 / 120);
        if (wildy_hill_setting) {
            giant_key_rate = (1 / 60);
        }
        // Mossy key math, for proof
        // if (wilderness & random(100) == 0 || slayer & random(75) == 0 || random(150) == 0)
        // = (1/100 + 1/150 - (1/100 * 1/150)) / (16/15)
        var mossy_key_rate = (1 / 140);
        if (wildy_moss_setting) {
            mossy_key_rate = 0.0155625;
        }

        // logic for enable boss
        var bryo_combat = 0;
        var bryo_craft = 0;
        var bryo_nats = 0;
        var bryo_laws = 0;
        var obor_combat = 0;
        var obor_craft = 0;
        var obor_nats = 0;
        var obor_laws = 0;

        if (boss_setting) {
            bryo_combat = 831.5 * mossy_key_rate; // 471.5 + 40 * 3 * 3; Assumes 3 growthling spawns per kill
            bryo_craft = 32.518361582 * mossy_key_rate; // 5 * (85+107.5) * 4/118 * 5980/6000, includes the rough time to cut
            bryo_nats = 6.779661017 * mossy_key_rate; // 100 * 8/118
            bryo_laws = 5.084745763 * mossy_key_rate; // 100 * 6/118
            obor_combat = 516 * giant_key_rate;
            obor_craft = 40.647951977 * giant_key_rate; // 5 * (85+107.5) * 5/118 * 5980/6000, includes the rough time to cut
            obor_nats = 3.529661017 * giant_key_rate; // (40 + 79)/2 * 7/118 * 1/120
            obor_laws = 7.576271186 * giant_key_rate; // (50 + 99)/2 * 12/118
        }
        if (smith_nat_setting) {
              var smithpernat = custom_smith_xp_per_nat;
        }
        if (bryo_staff_setting) {
              var smithpernat = smithpernat * 15/14; //geometric series, 1/15 chance of not consuming charge
            }
        
        // Smithing
        switch(smithmethod) {
            case "Telegrab Nats":
                smithperlaw = 3.5*smithpernat;
                break;
            case "Disk of Returning ROF":
                smithperlaw = 23*37.5; //23 inv spaces: laws, water runes, pick axe, air staff, hammer, disk of returning. 1 tele per trip
                break;
            case "Double Tele ROF":
                smithperlaw = 24*37.5/2; //24 inv spaces: laws, water runes, pick axe, air staff, fire runes. Hammer is on table. 2 teles per trip
                break;
            case "Custom Smithing Method":
                smithperlaw = custom_smith_xp_per_law; //24 inv spaces: laws, water runes, pick axe, air staff, fire runes. Hammer is on table. 2 teles per trip
                break;
            case "No Tele ROF":
            case "No Laws Method":    
            default:
                smithperlaw = Infinity;
                break;
        }
        
        // Crafting
        switch(craftmethod) {
            case "Craft guild/vsw (21 inv)":
                craftperlaw = 21 * 52.5;
                break;
            case "Custom Crafting Method":
                craftperlaw = custom_craft_xp_per_law;
                break;
            case "Air Tiaras (UIM)":
                craftperlaw = 52.5*12.5/2; // alternate between 13 12 air tallies per trip. equip silver tiara for the 12.5 average. tele to lumby, tele to fally = 2 laws per trip
                runecraftpercraft = 25/52.5;
                break;
            case "Air Tiaras (Bank)":
                runecraftpercraft = 25/52.5;
            case "Craft guild/vsw":
            case "Craft guild w/ air runes":
            default:
                craftperlaw = 24 * 52.5;
                break;
        }
        
        // runecraft-ing
        switch(runecraftmethod) {
            case "Varrock Tele Earths":
                runecraftperlaw = 21 * 6.5;
                break;
            case "Fally Pub Earths":
                runecraftperlaw = 24 * 6.5/2; //laws, airs, waters, fires
                break;
            case "Custom Runecraft Method":
                runecraftperlaw = custom_runecraft_xp_per_law;
                break;
            case "Suicide Bodies":
            case "Earth Runes":
            default:
                runecraftperlaw = Infinity;
            break;
        }
        
        // Combat
        switch (monster1) {
            case "Ogress Warrior":
                craftper1 = 10.689655172; // 107.5 * 4/116 + 67.5 * 4/116 + 85 * 4/116 + 50 * 4/116
                natsper1 = 0.648965517; // 11.5*7/116 - 1/40 - 1/100 - 1/100
                lawsper1 = 0.693965517; // 11.5*7/116
                hpper1 = 82;
                break;
            case "Ogress Shaman":
                craftper1 = 10.689655172; // 107.5 * 4/116 + 67.5 * 4/116 + 85 * 4/116 + 50 * 4/116
                natsper1 = 0.648965517; // 11.5*7/116 - 1/40 - 1/100 - 1/100
                lawsper1 = 0.693965517; // 11.5*7/116
                hpper1 = 82;
                break;
            case "Flawed Golem":
                craftper1 = 3.221153846; // 50 * 2/52 + 67.5 * 1/52
                runecraftper1 = 3.980769231; // 7.5 * 2 * 12/52 + 3 * 9/52 Always assume body runes with noted ess?
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 25;
                break;
            case "Mind Golem":
                craftper1 = 8.076923077; // 50 * 4/52 + 67.5 * 2/52 + 85 * 1/52
                runecraftper1 = 10.814102564; // 7.5 * 4 * 6/52 + 1 * 1/52  + 2/15 * 55
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 40;
                break;
            case "Body Golem":
                craftper1 = 8.076923077; // 50 * 4/52 + 67.5 * 2/52 + 85 * 1/52
                runecraftper1 = 14.346153846; // 7.5 * 5 * 6/52 + 1 * 1/52  + 2/15 * 75
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 60;
                break;
            case "Lesser demon":
                craftper1 = 0.872802734; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 79;
                break;
            case "Moss giant":
                craftper1 = 0.872802734 + bryo_craft; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper1 = 0.140625 + bryo_nats; // 6 * 3/128
                lawsper1 = 0.09375 + bryo_laws; // 3 * 4/128
                hpper1 = 60 + bryo_combat / 4; // divide by 4 because formula uses hp instead of combat xp per kill
                break;
            case "Hill giant":
                craftper1 = 0.654597604 + obor_craft; // 50 * 1/170.67 + 67.5 * 1/341.33 + 85 * 1/682.67 + 107.5 * 1/2730.67
                natsper1 = 0.09375 + obor_nats; // 6 * 2/128
                lawsper1 = 0.046875 + obor_laws; // 2 * 3/128
                hpper1 = 35 + obor_combat / 4; // divide by 4 because formula uses hp instead of combat xp per kill
                break;
            case "Giant spider":
                craftper1 = 0;
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 50;
                break;
            case "Flesh crawler":
                craftper1 = 0.53671875; // 50 * 1/200 + 67.5 * 1/400 + 67.5 * 1/800 + 107.5 * 1/3200
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 25;
                break;
            case "Minotaur":
                craftper1 = 0.53671875; // 50 * 1/200 + 67.5 * 1/400 + 67.5 * 1/800 + 107.5 * 1/3200
                runecraftper1 = 16.707920792; // 7.5 * 3 * 3/101 * 25. 25 inv spaces, also doesnt include 0 time ess since using up 0 time ess still costs sceptre pieces
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 10;
                break;
            case "Ice Giant":
                craftper1 = 0.872802734; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper1 = 0.1875; // 6 * 4/128
                lawsper1 = 0.046875; // 3 * 2/128
                hpper1 = 70;                
                break;
            case "Dark Wizard (Level 20)":
                craftper1 = 0;
                natsper1 = 0.21875; // 4 * 7/128
                lawsper1 = 0.0234375; // 3 * 1/128
                hpper1 = 24;
                break;
            case "Custom Mob 1":
                craftper1 = custom1craft;
                smithper1 = custom1smith;
                runecraftper1 = custom1runecraft;
                natsper1 = custom1nats;
                lawsper1 = custom1laws;
                hpper1 = custom1hp;
                break;
            case "Custom Mob 2":
                craftper1 = custom2craft;
                smithper1 = custom2smith;
                runecraftper1 = custom2runecraft;
                natsper1 = custom2nats;
                lawsper1 = custom2laws;
                hpper1 = custom2hp;
                break;
            default:
                craftper1 = 0;
                natsper1 = 0;
                lawsper1 = 0;
                hpper1 = 1;
                break;
            }
        switch (monster2) {
            case "Ogress Warrior":
                craftper2 = 10.689655172; // 107.5 * 4/116 + 67.5 * 4/116 + 85 * 4/116 + 50 * 4/116
                natsper2 = 0.648965517; // 11.5*7/116 - 1/40 - 1/100 - 1/100
                lawsper2 = 0.693965517; // 11.5*7/116
                hpper2 = 82;
                break;
            case "Ogress Shaman":
                craftper2 = 10.689655172; // 107.5 * 4/116 + 67.5 * 4/116 + 85 * 4/116 + 50 * 4/116
                natsper2 = 0.648965517; // 11.5*7/116 - 1/40 - 1/100 - 1/100
                lawsper2 = 0.693965517; // 11.5*7/116
                hpper2 = 82;
                break;
            case "Flawed Golem":
                craftper2 = 3.221153846; // 50 * 2/52 + 67.5 * 1/52
                runecraftper2 = 3.980769231; // 7.5 * 2 * 12/52 + 3 * 9/52 Always assume body runes with noted ess?
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 25;
                break;
            case "Mind Golem":
                craftper2 = 8.076923077; // 50 * 4/52 + 67.5 * 2/52 + 85 * 1/52
                runecraftper2 = 10.814102564; // 7.5 * 4 * 6/52 + 1 * 1/52  + 2/15 * 55
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 40;
                break;
            case "Body Golem":
                craftper2 = 8.076923077; // 50 * 4/52 + 67.5 * 2/52 + 85 * 1/52
                runecraftper2 = 14.346153846; // 7.5 * 5 * 6/52 + 1 * 1/52  + 2/15 * 75
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 60;
                break;
            case "Lesser demon":
                craftper2 = 0.872802734; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 79;
                break;
            case "Moss giant":
                craftper2 = 0.872802734 + bryo_craft; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper2 = 0.140625 + bryo_nats; // 6 * 3/128
                lawsper2 = 0.09375 + bryo_laws; // 3 * 4/128
                hpper2 = 60 + bryo_combat / 4; // divide by 4 because formula uses hp instead of combat xp per kill
                break;
            case "Hill giant":
                craftper2 = 0.654597604 + obor_craft; // 50 * 1/170.67 + 67.5 * 1/341.33 + 85 * 1/682.67 + 107.5 * 1/2730.67
                natsper2 = 0.09375 + obor_nats; // 6 * 2/128
                lawsper2 = 0.046875 + obor_laws; // 2 * 3/128
                hpper2 = 35 + obor_combat / 4; // divide by 4 because formula uses hp instead of combat xp per kill
                break;
            case "Giant spider":
                craftper2 = 0;
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 50;
                break;
            case "Flesh crawler":
                craftper2 = 0.53671875; // 50 * 1/200 + 67.5 * 1/400 + 67.5 * 1/800 + 107.5 * 1/3200
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 25;
                break;
            case "Minotaur":
                craftper2 = 0.53671875; // 50 * 1/200 + 67.5 * 1/400 + 67.5 * 1/800 + 107.5 * 1/3200
                runecraftper2 = 16.707920792; // 7.5 * 3 * 3/101 * 25. 25 inv spaces, also doesnt include 0 time ess since using up 0 time ess still costs sceptre pieces
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 10;
                break;
            case "Ice Giant":
                craftper2 = 0.872802734; // 50 * 1/128 + 67.5 * 1/256 + 85 * 1/512 + 107.5 * 1/2048
                natsper2 = 0.1875; // 6 * 4/128
                lawsper2 = 0.046875; // 3 * 2/128
                hpper2 = 70;
                break;
            case "Dark Wizard (Level 20)":
                craftper2 = 0;
                natsper2 = 0.21875; // 4 * 7/128
                lawsper2 = 0.0234375; // 3 * 1/128
                hpper2 = 24;
                break;
            case "Custom Mob 1":
                craftper2 = custom1craft;
                smithper2 = custom1smith;
                runecraftper2 = custom1runecraft;
                natsper2 = custom1nats;
                lawsper2 = custom1laws;
                hpper2 = custom1hp;
                break;
            case "Custom Mob 2":
                craftper2 = custom2craft;
                smithper2 = custom2smith;
                runecraftper2 = custom2runecraft;
                natsper2 = custom2nats;
                lawsper2 = custom2laws;
                hpper2 = custom2hp;       
                break;
            default:
                craftper2 = 0;
                natsper2 = 0;
                lawsper2 = 0;
                hpper2 = 1;
                break;
            }
            
            craftperlaw = (Number(craftperlaw) === 0) ? Infinity : craftperlaw;
            smithperlaw = (Number(smithperlaw) === 0) ? Infinity : smithperlaw;
            runecraftperlaw = (Number(runecraftperlaw) === 0) ? Infinity : runecraftperlaw;
            
            var ratio1 = calcRatio(combatxp, smithxp, craftxp, runecraftxp, smithper1, craftper1, runecraftper1, natsper1, lawsper1, hpper1, smithper2, craftper2, runecraftper2, natsper2, lawsper2, hpper2, smithperlaw, craftperlaw, runecraftperlaw, smithpernat, runecraftpercraft, start_laws, start_nats, runecraft_setting);
            var ratio2 = 1 - ratio1;
            var monster1_kills = ratio1 * combatxp / (4 * hpper1);
            var monster2_kills = ratio2 * combatxp / (4 * hpper2);
            var laws_gained = monster1_kills * lawsper1 + monster2_kills * lawsper2;
            var nats_gained = monster1_kills * natsper1 + monster2_kills * natsper2;
            
            var zero_time_craft = monster1_kills * craftper1 + monster2_kills * craftper2;
            var zero_time_smith = Math.max(craftxp - zero_time_craft, 0) * 13.7/52.5 + monster1_kills * smithper1 + monster2_kills * smithper2;
            var zero_time_runecraft = monster1_kills * runecraftper1 + monster2_kills * runecraftper2 + Math.max(craftxp - zero_time_craft, 0) * runecraftpercraft;
            
            var laws_for_craft = Math.max(craftxp - zero_time_craft, 0)/craftperlaw;
            var laws_for_smith = Math.max(smithxp - zero_time_smith - nats_gained * smithpernat, 0)/smithperlaw;
            var laws_for_runecraft = Math.max(runecraftxp - zero_time_runecraft, 0)/runecraftperlaw;
            var excess_laws_needed = (laws_for_craft + laws_for_runecraft + laws_for_smith) - laws_gained - start_laws - start_nats/smithperlaw*smithpernat;
            if (monster1 == "Hill giant"&& boss_setting){
              var monster1_boss_kc = monster1_kills * giant_key_rate;
            } else if (monster1 == "Moss giant"&& boss_setting){
              var monster1_boss_kc = monster1_kills * mossy_key_rate;
            } else {
              var monster1_boss_kc = NaN;
            }
            
            if (monster2 == "Hill giant" && boss_setting){
              monster2_boss_kc = monster2_kills * giant_key_rate;
            } else if (monster2 == "Moss giant"&& boss_setting){
              monster2_boss_kc = monster2_kills * mossy_key_rate;
            } else {
              var monster2_boss_kc = NaN;
            }
            
            // Rounding
            ratio1 = Math.round(ratio1 * 10000)/10000;
            ratio2 = Math.round(ratio2 * 10000)/10000;
            monster1_kills = Math.round(monster1_kills);
            monster2_kills = Math.round(monster2_kills); 
//            combatxp1 = Math.round(monster1_kills * hpper1 * 4 * 10)/10; // Dont think this is the right approach
//            combatxp2 = Math.round(monster2_kills * hpper2 * 4 * 10)/10;  
            combatxp1 = Math.round(combatxp * ratio1);     
            combatxp2 = Math.round(combatxp * ratio2);
            laws_for_craft = Math.round(laws_for_craft);
            laws_for_smith = Math.round(laws_for_smith);
            laws_for_runecraft = Math.round(laws_for_runecraft);
            zero_time_smith = Math.round(zero_time_smith);
            zero_time_craft = Math.round(zero_time_craft);
            zero_time_runecraft = Math.round(zero_time_runecraft);
            monster1_boss_kc = Math.round(monster1_boss_kc);
            monster2_boss_kc = Math.round(monster2_boss_kc);
            excess_laws_needed = Math.round(excess_laws_needed);
            laws_gained = Math.round(laws_gained);
            nats_gained = Math.round(nats_gained);
            
            
            // output
            $("#monster_ratio1").val(ratio1);
            $("#monster_ratio2").val(ratio2);
            $("#combatgained").val(combatxp);
            $("#smithgained").val(smithxp);
            $("#craftgained").val(craftxp);
            $("#combatxp1").val(combatxp1);
            $("#combatxp2").val(combatxp2);
            $("#monster1_kills").val(monster1_kills);
            $("#monster2_kills").val(monster2_kills);
            $("#laws_for_craft").val(laws_for_craft);
            $("#laws_for_smith").val(laws_for_smith);
            $("#laws_for_runecraft").val(laws_for_runecraft);
            $("#zero_time_smith").val(zero_time_smith);
            $("#zero_time_craft").val(zero_time_craft);
            $("#zero_time_runecraft").val(zero_time_runecraft);
            $("#bosskc1").val(monster1_boss_kc);
            $("#bosskc2").val(monster2_boss_kc);
            $("#excess_laws").val(excess_laws_needed);
            $("#lawsgained").val(laws_gained);
            $("#natsgained").val(nats_gained);
}
function startup() {
    // run the update on every input change and on startup
    $('#start_combat_xp').change(monster_ratio_results);
    $('#end_combat_xp').change(monster_ratio_results);
    $('#start_smithing_xp').change(monster_ratio_results);
    $('#end_smithing_xp').change(monster_ratio_results);
    $('#start_runecraft_xp').change(monster_ratio_results);
    $('#end_runecraft_xp').change(monster_ratio_results);
    $('#start_crafting_xp').change(monster_ratio_results);
    $('#start_laws').change(monster_ratio_results);
    $('#start_nats').change(monster_ratio_results);

    $('#monster1').change(monster_ratio_results);
    $('#monster2').change(monster_ratio_results);
    $('#monster1b').change(monster_ratio_results);
    $('#monster2b').change(monster_ratio_results);

    $('#smithmethod').change(monster_ratio_results);
    $('#craftmethod').change(monster_ratio_results);
    $('#runecraftmethod').change(monster_ratio_results);

    $('#boss_setting').change(monster_ratio_results);
    $('#wildy_hill_setting').change(monster_ratio_results);
    $('#wildy_moss_setting').change(monster_ratio_results);
    $('#bryo_staff_setting').change(monster_ratio_results);
    $('#smith_nat_setting').change(monster_ratio_results);

    $('#smith_xp_per_law').change(monster_ratio_results);
    $('#smith_xp_per_nat').change(monster_ratio_results);
    $('#craft_xp_per_law').change(monster_ratio_results);

    $('#custom1hp').change(monster_ratio_results);
    $('#custom1laws').change(monster_ratio_results);
    $('#custom1nats').change(monster_ratio_results);
    $('#custom1craft').change(monster_ratio_results);
    $('#custom1smith').change(monster_ratio_results);
    $('#custom1runecraft').change(monster_ratio_results);
    $('#custom2hp').change(monster_ratio_results);
    $('#custom2laws').change(monster_ratio_results);
    $('#custom2nats').change(monster_ratio_results);
    $('#custom2craft').change(monster_ratio_results);
    $('#custom2smith').change(monster_ratio_results);
    $('#custom2runecraft').change(monster_ratio_results);

    monster_ratio_results();
}

    if ($('#body-monster_ratio').length) {
        startup();
    }
}
function changeMonsters(selectElement) {
    var selectedValue = selectElement.value;
    var selectTags = document.getElementsByTagName("select");
    for (var i = 0; i < selectTags.length; i++) {
        var selectTag = selectTags[i];
        if (selectTag.id.slice(0, 8) !== selectElement.id.slice(0, 8)) {
            continue;
        }

        if (selectTag.id !== selectElement.id) {
            selectTag.value = selectedValue;
        }
    }
}


$(document).ready(monster_ratio);
$(document).on('page:load', monster_ratio);
