function commas(x){
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function setCookie(name, mode){
	var date = new Date();
	date.setTime(+ date + (90*86400000));
	document.cookie = "username=" + name + "; expires=" + date.toGMTString() + "; path=/";
	document.cookie = "gamemode=" + mode + "; expires=" + date.toGMTString() + "; path=/";
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

function printStats(player){
	var stats = '<table><tbody>';
	stats += '<tr><td><img src="img/skill_ove.gif"></td>';
	stats += '<td>' + commas(player.overall.lvl) + '</td>';
	stats += '<td>' + commas(player.overall.rank) + '</td>';
	stats += '<td>' + commas(player.overall.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_att.gif"></td>';
	stats += '<td>' + commas(player.attack.lvl) + '</td>';
	stats += '<td>' + commas(player.attack.rank) + '</td>';
	stats += '<td>' + commas(player.attack.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_def.gif"></td>';
	stats += '<td>' + commas(player.defence.lvl) + '</td>';
	stats += '<td>' + commas(player.defence.rank) + '</td>';
	stats += '<td>' + commas(player.defence.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_str.gif"></td>';
	stats += '<td>' + commas(player.strength.lvl) + '</td>';
	stats += '<td>' + commas(player.strength.rank) + '</td>';
	stats += '<td>' + commas(player.strength.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_hit.gif"></td>';
	stats += '<td>' + commas(player.hitpoints.lvl) + '</td>';
	stats += '<td>' + commas(player.hitpoints.rank) + '</td>';
	stats += '<td>' + commas(player.hitpoints.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_ran.gif"></td>';
	stats += '<td>' + commas(player.ranged.lvl) + '</td>';
	stats += '<td>' + commas(player.ranged.rank) + '</td>';
	stats += '<td>' + commas(player.ranged.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_pra.gif"></td>';
	stats += '<td>' + commas(player.prayer.lvl) + '</td>';
	stats += '<td>' + commas(player.prayer.rank) + '</td>';
	stats += '<td>' + commas(player.prayer.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_mag.gif"></td>';
	stats += '<td>' + commas(player.magic.lvl) + '</td>';
	stats += '<td>' + commas(player.magic.rank) + '</td>';
	stats += '<td>' + commas(player.magic.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_coo.gif"></td>';
	stats += '<td>' + commas(player.cooking.lvl) + '</td>';
	stats += '<td>' + commas(player.cooking.rank) + '</td>';
	stats += '<td>' + commas(player.cooking.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_woo.gif"></td>';
	stats += '<td>' + commas(player.woodcutting.lvl) + '</td>';
	stats += '<td>' + commas(player.woodcutting.rank) + '</td>';
	stats += '<td>' + commas(player.woodcutting.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_fis.gif"></td>';
	stats += '<td>' + commas(player.fishing.lvl) + '</td>';
	stats += '<td>' + commas(player.fishing.rank) + '</td>';
	stats += '<td>' + commas(player.fishing.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_fir.gif"></td>';
	stats += '<td>' + commas(player.firemaking.lvl) + '</td>';
	stats += '<td>' + commas(player.firemaking.rank) + '</td>';
	stats += '<td>' + commas(player.firemaking.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_cra.gif"></td>';
	stats += '<td>' + commas(player.crafting.lvl) + '</td>';
	stats += '<td>' + commas(player.crafting.rank) + '</td>';
	stats += '<td>' + commas(player.crafting.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_smi.gif"></td>';
	stats += '<td>' + commas(player.smithing.lvl) + '</td>';
	stats += '<td>' + commas(player.smithing.rank) + '</td>';
	stats += '<td>' + commas(player.smithing.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_min.gif"></td>';
	stats += '<td>' + commas(player.mining.lvl) + '</td>';
	stats += '<td>' + commas(player.mining.rank) + '</td>';
	stats += '<td>' + commas(player.mining.xp) + '</td></tr>';
	stats += '<tr><td><img src="img/skill_run.gif"></td>';
	stats += '<td>' + commas(player.runecraft.lvl) + '</td>';
	stats += '<td>' + commas(player.runecraft.rank) + '</td>';
	stats += '<td>' + commas(player.runecraft.xp) + '</td></tr>';
	stats += '</tbody></table>';
	return stats;
}

function search(){
  var username = document.getElementById("nameInput").value.replace(/ /g,'_');
  var gamemode = 2;
  if(document.getElementById("radio0").checked){
    gamemode = 0;
  }
  else if(document.getElementById("radio1").checked){
    gamemode = 1;
  }
  document.getElementById("result").innerHTML = "<h4>Loading...</h4>";

  var query = new XMLHttpRequest();
  query.onreadystatechange = function() {
    if (query.readyState == 4 && query.status == 200) {
      var result = query.responseText;
      if (result.length < 30){
        // Display error
        document.getElementById("result").innerHTML = '<h4 style="color:red;">' + result + '</h4>';
      }
      else{
      	setCookie(document.getElementById("nameInput").value, gamemode);
        // Display stats
        var player = new user(result, gamemode);
        document.getElementById("result").innerHTML = printStats(player);
      }
    }
  }
  query.open("GET", "gethiscore.php?name=" + username + "&mode=" + gamemode, true);
  query.send();
  return false;
}