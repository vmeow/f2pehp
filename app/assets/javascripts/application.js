// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require meleedps.js
/*global $*/

function ready() {
    function maxhit(level, gear){
      level += 8;
      return Math.floor(0.5 + level * (gear+64) / 640);
    }
    
    function dps(){
    	// Scan variables
    	var att = document.querySelector('[name="att"]').value;
    	var str = document.querySelector('[name="str"]').value;
    	var attStyle = document.querySelector('[name="melee_style"]').value;
    	var attPrayer = document.querySelector('[name="att_pray"]').value;
    	var strPrayer = document.querySelector('[name="str_pray"]').value;
    	
    	var strPot = document.querySelector('[name="str_pot"]').checked;

    	var meleeWeapon = document.querySelector('[name="melee_weapon"]').value;
    	var meleeNeck = document.querySelector('[name="melee_neck"]').value;

        var mob = document.querySelector('[name="mob_name"]').value;
        
        // Equipment bonuses
        var attBonus = 0;
        var strBonus = 0;
        var meleeTicks = 4;
        var meleeAttStyle = "";
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
    	var maxHit = maxhit(A, strBonus);

        // Projected max hits
        /*
        var projected1 = new Array();
        var projected2 = new Array();
    
        var projections = "<tbody><tr><td>Str</td>";
        var j = 0;
        for(i=1; i<13; i++){
        	j = Number(str)+i;
        	projections += "<td>" + j + "</td>";
    	}
        projections += "</tr><tr><td>Wpn1</td>";
        for(i=1; i<13; i++){
        	projections += "<td>" + maxhit(A+i, strbonus1) + "</td>";
        }
        projections += "</tr><tr><td>Wpn2</td>";
        for(i=1; i<13; i++){
        	projections += "<td>" + maxhit(A+i, strbonus2) + "</td>";
        }
        projections += "</tr><tbody>";
        */
        
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
    	var attRoll = effA * (attBonus + 64);

    	// Enemy effective def & defence roll
    	var enemyDef = 0;
    	var enemyHP = 0;
    	var enemyArm = 0;
    	
    	switch(mob){
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
    		default:
    			break;
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
    	var ranged = document.querySelector('[name="ranged"]').value;
    	var rangedStyle = document.querySelector('[name="ranged_style"]').value;
    	var rangedPrayer = document.querySelector('[name="ranged_pray"]').value;

    	var rangedWeapon = document.querySelector('[name="ranged_weapon"]').value;
    	var rangedAmmo = document.querySelector('[name="ranged_ammo"]').value;
    	var rangedNeck = document.querySelector('[name="ranged_neck"]').value;
    	var rangedHead = document.querySelector('[name="ranged_head"]').value;
    	var rangedBody = document.querySelector('[name="ranged_body"]').value;
    	var rangedLegs = document.querySelector('[name="ranged_legs"]').value;
    	var rangedHand = document.querySelector('[name="ranged_hand"]').value;

        var mob = document.querySelector('[name="mob_name"]').value;
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
    	var rangedA = ranged;
    	var rangedEffA = ranged;

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
    
    	// Maximum base hits
    	var rangedMaxHit = maxhit(rangedA, rangedStr);

        // Projected max hits
        /*
        var projected1 = new Array();
        var projected2 = new Array();
    
        var projections = "<tbody><tr><td>Str</td>";
        var j = 0;
        for(i=1; i<13; i++){
        	j = Number(str)+i;
        	projections += "<td>" + j + "</td>";
    	}
        projections += "</tr><tr><td>Wpn1</td>";
        for(i=1; i<13; i++){
        	projections += "<td>" + maxhit(A+i, strbonus1) + "</td>";
        }
        projections += "</tr><tr><td>Wpn2</td>";
        for(i=1; i<13; i++){
        	projections += "<td>" + maxhit(A+i, strbonus2) + "</td>";
        }
        projections += "</tr><tbody>";
        */
        

    	rangedEffA = Math.floor(rangedEffA) + 8;
    
    	// Attack roll
    	var attRoll = rangedEffA * (rangedBonus + 64);

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
    		default:
    			break;
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
        $("#ranged_maxhit").val(rangedMaxHit);
        $("#ranged_accuracy").val(rangedAccuracy);
        $("#ranged_dps").val(rangedDps);
        $("#ranged_xph").val(Math.round(rangedXph));
    }
    
    // run the update on every input change and on startup
    $('#att').change(dps);
    $('#str').change(dps);
    $('#att_pray').change(dps);
    $('#str_pray').change(dps);
    $('#str_pot').change(dps);
    $('#melee_style').change(dps);
    $('#melee_weapon').change(dps);
    $('#melee_neck').change(dps);
    $('#mob_name').change(dps);
    dps();
    
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
    rangeddps();
}

$(document).on('turbolinks:load', ready);
