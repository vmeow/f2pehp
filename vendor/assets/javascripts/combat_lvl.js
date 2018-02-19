function commas(x){
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function setCookie(name){
	var date = new Date();
	date.setTime(+ date + (90*86400000));
	document.cookie = "username=" + name + "; expires=" + date.toGMTString() + "; path=/";
}

function skill(number, rank, level, exp){
	if(rank == '-1'){
		this.rank = '-';
	}
	else{
		this.rank = rank;
	}
	this.lvl = level;
	this.xp = exp;
}

function user(data){
	var arr = data.split(/\r?\n/);
	for(var i=0; i<24; i++){
		arr[i] = arr[i].split(",");
	}
  var p2p_xp = 0;
  this.overall = new skill(15, arr[0][0], arr[0][1], arr[0][2]);
  this.attack = new skill(0, arr[1][0], arr[1][1], arr[1][2]);
  this.defence = new skill(1, arr[2][0], arr[2][1], arr[2][2]);
  this.strength = new skill(2, arr[3][0], arr[3][1], arr[3][2]);
  this.hitpoints = new skill(3, arr[4][0], arr[4][1], arr[4][2]);
  this.ranged = new skill(4, arr[5][0], arr[5][1], arr[5][2]);
  this.prayer = new skill(5, arr[6][0], arr[6][1], arr[6][2]);
  this.magic = new skill(6, arr[7][0], arr[7][1], arr[7][2]);
  this.cooking = new skill(7, arr[8][0], arr[8][1], arr[8][2]);
  this.woodcutting = new skill(8, arr[9][0], arr[9][1], arr[9][2]);
  p2p_xp += arr[10][2]; // Fletching
  this.fishing = new skill(9, arr[11][0], arr[11][1], arr[11][2]);
  this.firemaking = new skill(10, arr[12][0], arr[12][1], arr[12][2]);
  this.crafting = new skill(11, arr[13][0], arr[13][1], arr[13][2]);
  this.smithing = new skill(12, arr[14][0], arr[14][1], arr[14][2]);
  this.mining = new skill(13, arr[15][0], arr[15][1], arr[15][2]);
  p2p_xp += arr[16][2]; // Herblore
  p2p_xp += arr[17][2]; // Agility
  p2p_xp += arr[18][2]; // Thieving
  p2p_xp += arr[19][2]; // Slayer
  p2p_xp += arr[20][2]; // Farming
  this.runecraft = new skill(14, arr[21][0], arr[21][1], arr[21][2]);
  p2p_xp += arr[22][2]; // Hunter
  p2p_xp += arr[23][2]; // Construction

  this.f2p = !(p2p_xp > 0);
}

function insertStats(player){
	document.getElementById("att").value = player.attack.lvl;
	document.getElementById("str").value = player.strength.lvl;
	document.getElementById("def").value = player.defence.lvl;
	document.getElementById("hit").value = player.hitpoints.lvl;
	document.getElementById("ran").value = player.ranged.lvl;
	document.getElementById("mag").value = player.magic.lvl;
	document.getElementById("pra").value = player.prayer.lvl;
}

function tillNextLvl(combat_lvl){
	return ( Math.floor(combat_lvl)+1-combat_lvl );
}

function calc(){
	// Get combat stats
    var pra = Number(document.getElementById("pra").value);
    var def = Number(document.getElementById("def").value);
    var att = Number(document.getElementById("att").value);
    var str = Number(document.getElementById("str").value);
    var hit = Number(document.getElementById("hit").value);
    var mag = Number(document.getElementById("mag").value);
    var ran = Number(document.getElementById("ran").value);
    
    // Calculate combat level
    var base = 0.25 * (def + hit + Math.floor(pra/2));
	var melee = 0.325 * (att + str);
	var range = 0.325 * (Math.floor(ran/2) + ran);
	var mage = 0.325 * (Math.floor(mag/2) + mag);
    var combat_lvl = 3;
    
    var combat_style = "hybrid";
    if(melee>range && melee>mage){
    	combat_style = "warrior";
        combat_lvl = base + melee;
    }
    else if(range>melee && range>mage){
    	combat_style = "ranger";
        combat_lvl = base + range;
    }
    else if(mage>melee && mage>range){
    	combat_style = "wizard";
        combat_lvl = base + mage;
    }
    // Mage-range hybrid
    else if(mage>melee){
    	combat_lvl = base + mage;
    }
    // Melee-range hybrid
    else if(melee>mage){
    	combat_lvl = base + melee;
    }
    // Melee-mage hybrid
    else if(melee>range){
    	combat_lvl = base + mage;
    }
    // Triple hybrid
    else{
    	combat_lvl = base + mage;
    }
    
    // Display values
    document.getElementById("cb_lvl").innerHTML = Math.floor(combat_lvl*100)/100;
    document.getElementById("combat_img").src = "img/" + combat_style + ".jpg";
    switch(combat_style){
    		case "warrior":
            	document.getElementById("combat_img").width = 272;
                document.getElementById("combat_img").height = 196;
            	break;
            case "ranger":
            	document.getElementById("combat_img").width = 169;
                document.getElementById("combat_img").height = 229;
            	break;
            case "wizard":
            	document.getElementById("combat_img").width = 169;
                document.getElementById("combat_img").height = 228;
            	break;
            case "hybrid":
            	document.getElementById("combat_img").width = 357;
                document.getElementById("combat_img").height = 228;
            	break;   
    }
    document.getElementById("figcaption").innerHTML = "<i>You are a " + combat_style + ".</i>";
    document.getElementById("aggressive_monsters").innerHTML = "Monsters level " + Math.floor((combat_lvl-1)/2) + " and below won't be aggressive to you.";

	// To next level
    var nextlvl_txt = "";
    if(Math.floor(combat_lvl)==126){
    	nextlvl_txt = "You are max combat level.";
    }
    else{
    	nextlvl_txt = "For next combat level you need:<br>";
        if( (99-pra)/8 >= tillNextLvl(combat_lvl) ){
        	var lvls = 1;
        	while( lvls*(1/8) < tillNextLvl(combat_lvl) ){
            	lvls += 1;
            }
            nextlvl_txt += " " + lvls + ' <img src="img/skill_pra.gif" alt="prayer lvls" height="16" width="16">';
        }
        if( (198-def-hit)/4 >= tillNextLvl(combat_lvl) ){
        	var lvls = 1;
            while( lvls*0.25 < tillNextLvl(combat_lvl) ){
            	lvls += 1;
            }
            nextlvl_txt += " " + lvls + " ";
            if(def<99){
            	nextlvl_txt += '<img src="img/skill_def.gif" alt="def lvls" height="16" width="16">';
            }
            if(hit<99){
            	nextlvl_txt += '<img src="img/skill_hit.gif" alt="hp lvls" height="16" width="16">';
            }
            nextlvl_txt += " ";
        }
        var nextLvl = tillNextLvl(combat_lvl) + (combat_lvl-base-melee);
        if( (198-att-str)*0.325 >= nextLvl ){
        	var lvls = 1;
            while( lvls*0.325 < nextLvl ){
            	lvls += 1;
            }
            nextlvl_txt += " " + lvls + " ";
            if(att<99){
            	nextlvl_txt += '<img src="img/skill_att.gif" alt="att lvls" height="16" width="16">';
            }
            if(str<99){
            	nextlvl_txt += '<img src="img/skill_str.gif" alt="str lvls" height="16" width="16">';
            }
            nextlvl_txt += " ";
        }
        var nextLvl = tillNextLvl(combat_lvl) + (combat_lvl-base-range);
        if( 0.325*(Math.floor((99-ran)/2)+(99-ran)) >= nextLvl ){
        	var lvls = 1;
            while( ( (Math.floor((ran+lvls)/2)+ran+lvls)*0.325+base ) < Math.floor(combat_lvl+1) ){
            	lvls += 1;
            }
            nextlvl_txt += " " + lvls + ' <img src="img/skill_ran.gif" alt="range lvls" height="16" width="16"> ';
        }
        var nextLvl = tillNextLvl(combat_lvl) + (combat_lvl-base-mage);
        if( 0.325*(Math.floor((99-mag)/2)+(99-mag)) >= nextLvl ){
        	var lvls = 1;
            while( ( (Math.floor((mag+lvls)/2)+mag+lvls)*0.325+base ) < Math.floor(combat_lvl+1) ){
            	lvls += 1;
            }
            nextlvl_txt += " " + lvls + ' <img src="img/skill_mag.gif" alt="mage lvls" height="16" width="16"> ';
        }
    }
    document.getElementById("next_lvl").innerHTML = nextlvl_txt;
}

function search(){
  var username = document.getElementById("nameInput").value.replace(/ /g,'_');
  document.getElementById("result").innerHTML = "Loading...";

  var query = new XMLHttpRequest();
  query.onreadystatechange = function() {
    if (query.readyState == 4 && query.status == 200) {
      var result = query.responseText;
      if (result.length < 30){
        // Display error
        document.getElementById("result").innerHTML = '<span style="color:red;">' + result + '</span>';
      }
      else{
      	document.getElementById("result").innerHTML = '<span style="color:green;">Search successful</span>';
      	setCookie(document.getElementById("nameInput").value);
        // Display stats
        var player = new user(result);
        insertStats(player);
        calc();
      }
    }
  }
  query.open("GET", "gethiscore.php?name=" + username + "&mode=0", true);
  query.send();
  return false;
}