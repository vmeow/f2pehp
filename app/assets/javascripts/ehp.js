var rates = [
	[0,7200,	37224,14400,	100000,28900, 1000000,43000,	1986068,51000,	3000000,57800,	5346332,63000,	13034431,68000], // 0. Attack
	[0,7200,	37224,14400,	100000,28900, 1000000,43000,	1986068,51000,	3000000,57800,	5346332,63000,	13034431,68000], // 1. Defence
	[0,7200,	37224,14400,	100000,28900, 1000000,43000,	1986068,51000,	3000000,57800,	5346332,63000,	13034431,68000], // 2. Strength
	[0,0], // 3. HP
	[0,7000,	37224,14000,	100000,28000,	1000000,42500,	1986068,49000,	3000000,56500,	5346332,61200,	13034431,66000], // 4. Ranged
    [0,43000], // 5. Prayer
	[0,5000,	174,15600,	1358,25200,	3973,34800,	5018,72000, 166636,1000000], // 6. Magic
	[0,40000,	7842,130000,	37224,175000,	737627,480000], // 7. Cooking
	[0,7000,	2411,15000,	13363,28000,	41171,40000,	302288,50000,	1986068,60000,	5346332,70000,	13034431,75000], // 8. Woodcutting
	[0,14000,	4470,28000,	13363,35000,	273742,45000,	737627,55000,	2500000,65000,	6000000,70000,	13034431,75000], // 9. Fishing
	[0,45000,	13363,130500,	61512,195750,	273742,293625], // 10. Firemaking
	[0,57000,	4470,135000,	50339,290000], // 11. Crafting
	[0,40000,	37224,103000,	605032,220000,	4385776,275000], // 12. Smithing
	[0,4000,	14833,12000,	41171,25000,	111945,57000], // 13. Mining
	[0,38000] // 14. RC
];
var rates_im = [
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 0. Attack
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 1. Defence
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 2. Strength
	[0,0], // 3. HP
	[0,4000,	37224,9000,	100000,17000,	1000000,27000,	1986068,30000,	3000000,35000,	5346332,40000,	13034431,42000], // 4. Ranged
	[0,15200], // 5. Prayer
	[0,5000,	3973,34800,	33648,56100], // 6. Magic
	[0,0], // 7. Cooking
	[0,6000,	2411,12000,	13363,24000,	41171,34700,	9800000,72000], // 8. Woodcutting
	[0,12000,	4470,22000,	13363,26000,	273742,28000,	737627,30000,	2500000,32000,	6000000,38000,	9600000,72000], // 9. Fishing
	[0,0], // 10. Firemaking
	[0,13300], // 11. Crafting
	[0,8100], // 12. Smithing
	[0,0], // 13. Mining
	[0,4285] // 14. RC
];
var rates_uim = [
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 0. Attack
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 1. Defence
	[0,5000,	37224,10000,	100000,20000, 1000000, 30000,	1986068,35000,	3000000,40000,	5346332,44000,	13034431,47000], // 2. Strength
	[0,0], // 3. HP
	[0,4000,	37224,9000,	100000,17000,	1000000,27000,	1986068,30000,	3000000,35000,	5346332,40000,	13034431,42000], // 4. Ranged
	[0,15200], // 5. Prayer
	[0,5000,	3973,34800,	33648,45600], // 6. Magic
	[0,0], // 7. Cooking
	[0,6000,	2411,12000,	13363,24000,	41171,34700,	9800000,72000], // 8. Woodcutting
	[0,12000,	4470,22000,	13363,26000,	273742,28000,	737627,30000,	2500000,32000,	6000000,38000,	9600000,72000], // 9. Fishing
	[0,0], // 10. Firemaking
	[0,0], // 11. Crafting
	[0,4800,	9800000,6900], // 12. Smithing
	[0,0], // 13. Mining
	[0,3500] // 14. RC
];

function commas(x){
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function timeAgo(seconds){
	var result = "";
	var days = Math.floor(seconds / 86400);
	var hours = Math.floor(seconds % 86400 / 3600);
	var minutes = Math.floor(seconds % 3600 / 60);
	var seconds = seconds % 60;
	if(days > 0){
		return days + " day" + ( days == 1 ? "": "s")+ " and " + hours + " hour" + ( hours == 1 ? "": "s");
	}
	else if (hours > 0){
		return hours + " hour" + ( hours == 1 ? "": "s")+ " and " + minutes + " minute" + ( minutes == 1 ? "": "s");
	}
	else if(minutes > 0){
		return minutes + " minute" + ( minutes == 1 ? "": "s")+ " and " + seconds + " second" + ( seconds == 1 ? "": "s");
	}
	else{
		return seconds + " second" + ( seconds == 1 ? "": "s");
	}
}

function setCookie(name, mode){
	var date = new Date();
	date.setTime(+ date + (90*86400000));
	document.cookie = "username=" + name + "; expires=" + date.toGMTString() + "; path=/";
	document.cookie = "gamemode=" + mode + "; expires=" + date.toGMTString() + "; path=/";
	
}

function skill_mining(number, rank, level, exp, mode, skill2, skill3, skill4){
	if(rank == '-1'){
		this.rank = '-';
	}
	else{
		this.rank = rank;
	}
	this.lvl = level;
	this.xp = exp;
	switch(mode){
		case 0:
			var rate = rates[number];
			break;
		case 1:
			var rate = rates_im[number];
			break;
		default:
			var rate = rates_uim[number];
			break;
	}
	var ehp = 0;
	if(number == 15 || rate[1] == 0 ){
		this.ehp = 0;
	//reg ironman mining
	} else if (number == 13 && mode == 1) {
		
		this.smithxp = skill2.xp;
		this.craftxp = skill3.xp;
		this.rcxp = skill4.xp;
		
		this.xplimit1 = 35*(this.smithxp - (13.7 * this.craftxp/52.5))/18.75;
		this.xplimit2 = 40 * this.craftxp/52.5;
		this.xplimit3 = 5 * this.rcxp/5; //air runes
		
		this.xplimit = this.xplimit1 + this.xplimit2 + this.xplimit3;
	
		//console.log(this.xplimit);
	
		if(exp > this.xplimit) {
			x = 0;
			for(var i = rate.length - 1; i >= 0; i = i-2){
				if(exp > rate[i-1]){
					if(rate[i-1] < this.xplimit) x = this.xplimit;
					else x = rate[i-1];
				
					ehp += ( exp - x ) / rate[i];
					exp = x;
				}
				if(exp == this.xplimit) break;
			}
			this.ehp = Math.round( ehp * 10) / 10;
		}
	}
	else{
		for(var i = rate.length - 1; i >= 0; i = i-2){
		if(exp > rate[i-1]){
			ehp += ( exp - rate[i-1] ) / rate[i];
			exp = rate[i-1];
			}
		}
		this.ehp = Math.round( ehp * 10) / 10;
	}
}

function skill_(number, rank, level, exp, mode, skill2){
	if(rank == '-1'){
		this.rank = '-';
	}
	else{
		this.rank = rank;
	}
	this.lvl = level;
	this.xp = exp;
	this.xplimit = 0;
	switch(mode){
		case 0:
			var rate = rates[number];
			break;
		case 1:
			var rate = rates_im[number];
			break;
		default:
			var rate = rates_uim[number];
			break;
	}
	this.ehp = 0;
	if(number == 15 || rate[1] == 0 ){
		this.ehp = 0;
	} else if (number == 12 && mode == 1) {
		
		this.craftxp = skill2.xp;
		
		this.xplimit = 13.7 * this.craftxp/52.5;
	} else if (number == 7 && mode == 1) {
		this.fishxp = skill2.xp;
		
		this.xplimit = 78.4* this.fishxp/58.4;
	} else if (number == 9 && mode == 1) {
		this.cookxp = skill2.xp;
		
		this.xplimit = 58.4 * this.cookxp/78.4;
	}
	
	//console.log(this.xplimit);
	
	if(exp >= this.xplimit) {
		x = 0;
		for(var i = rate.length - 1; i >= 0; i = i-2){
			if(exp > rate[i-1]){
				if(rate[i-1] < this.xplimit) x = this.xplimit;
				else x = rate[i-1];
			
				this.ehp += ( exp - x ) / rate[i];
				exp = x;
			}
			if(exp == this.xplimit) break;
		}
		this.ehp = Math.round( this.ehp * 10) / 10;
	}

}

function skill(number, rank, level, exp, mode){
	if(rank == '-1'){
		this.rank = '-';
	}
	else{
		this.rank = rank;
	}
	this.lvl = level;
	this.xp = exp;
	switch(mode){
		case 0:
			var rate = rates[number];
			break;
		case 1:
			var rate = rates_im[number];
			break;
		default:
			var rate = rates_uim[number];
			break;
	}
	var ehp = 0;
	if(number == 15 || rate[1] == 0 ){
		this.ehp = 0;
	} else if (number == 12 && mode == 1) {
		
	
	
		for(var i = rate.length - 1; i >= 0; i = i-2){
		if(exp > rate[i-1]){
			ehp += ( exp - rate[i-1] ) / rate[i];
			exp = rate[i-1];
			}
		}
		this.ehp = Math.round( ehp * 10) / 10;
	}
	else{
		for(var i = rate.length - 1; i >= 0; i = i-2){
		if(exp > rate[i-1]){
			ehp += ( exp - rate[i-1] ) / rate[i];
			exp = rate[i-1];
			}
		}
		this.ehp = Math.round( ehp * 10) / 10;
	}
}

function timeTo(player, gamemode, goal){
	// Calculate how long it takes to goal in each skill
	var required = [];
	for(var numb = 0; numb < 15; numb++){
		required[numb] = new skill(numb,0,0, goal, gamemode);
	}
	var result = 0;
	// Needed_EHP - Current_EHP
	if(required[0].ehp > player.attack.ehp)
		result += required[0].ehp - player.attack.ehp;
	if(required[1].ehp > player.defence.ehp)
		result += required[1].ehp - player.defence.ehp;
	if(required[2].ehp > player.strength.ehp)
		result += required[2].ehp - player.strength.ehp;
	if(required[3].ehp > player.hitpoints.ehp)
		result += required[3].ehp - player.hitpoints.ehp;
	if(required[4].ehp > player.ranged.ehp)
		result += required[4].ehp - player.ranged.ehp;
	if(required[5].ehp > player.prayer.ehp)
		result += required[5].ehp - player.prayer.ehp;
	if(required[6].ehp > player.magic.ehp)
		result += required[6].ehp - player.magic.ehp;
	if(required[7].ehp > player.cooking.ehp)
		result += required[7].ehp - player.cooking.ehp;
	if(required[8].ehp > player.woodcutting.ehp)
		result += required[8].ehp - player.woodcutting.ehp;
	if(required[9].ehp > player.fishing.ehp)
		result += required[9].ehp - player.fishing.ehp;
	if(required[10].ehp > player.firemaking.ehp)
		result += required[10].ehp - player.firemaking.ehp;
	if(required[11].ehp > player.crafting.ehp)
		result += required[11].ehp - player.crafting.ehp;
	if(required[12].ehp > player.smithing.ehp)
		result += required[12].ehp - player.smithing.ehp;
	if(required[13].ehp > player.mining.ehp)
		result += required[13].ehp - player.mining.ehp;
	if(required[14].ehp > player.runecraft.ehp)
		result += required[14].ehp - player.runecraft.ehp;

	return commas(Math.round(result));
}

function user(data, mode){
	var arr = data.split(/\r?\n/);
	for(var i=0; i<24; i++){
		arr[i] = arr[i].split(",");
	}
  var p2p_xp = 0;
  this.overall = new skill(15, arr[0][0], arr[0][1], arr[0][2], mode);
  this.attack = new skill(0, arr[1][0], arr[1][1], arr[1][2], mode);
  this.defence = new skill(1, arr[2][0], arr[2][1], arr[2][2], mode);
  this.strength = new skill(2, arr[3][0], arr[3][1], arr[3][2], mode);
  this.hitpoints = new skill(3, arr[4][0], arr[4][1], arr[4][2], mode);
  this.ranged = new skill(4, arr[5][0], arr[5][1], arr[5][2], mode);
  this.prayer = new skill(5, arr[6][0], arr[6][1], arr[6][2], mode);
  this.magic = new skill(6, arr[7][0], arr[7][1], arr[7][2], mode);
  this.cooking = new skill(7, arr[8][0], arr[8][1], arr[8][2], mode);
  this.woodcutting = new skill(8, arr[9][0], arr[9][1], arr[9][2], mode);
  p2p_xp += arr[10][2]; // Fletching
  this.fishing = new skill(9, arr[11][0], arr[11][1], arr[11][2], mode);
  
  this.firemaking = new skill(10, arr[12][0], arr[12][1], arr[12][2], mode);
  this.crafting = new skill(11, arr[13][0], arr[13][1], arr[13][2], mode);
  this.smithing = new skill_(12, arr[14][0], arr[14][1], arr[14][2], mode, this.crafting);
  
  this.runecraft = new skill(14, arr[21][0], arr[21][1], arr[21][2], mode);
  
  this.mining = new skill(13, arr[15][0], arr[15][1], arr[15][2], mode);
  p2p_xp += arr[16][2]; // Herblore
  p2p_xp += arr[17][2]; // Agility
  p2p_xp += arr[18][2]; // Thieving
  p2p_xp += arr[19][2]; // Slayer
  p2p_xp += arr[20][2]; // Farming
  
  p2p_xp += arr[22][2]; // Hunter
  p2p_xp += arr[23][2]; // Construction

  // Calculate overall EHP
  this.overall.ehp = Math.round((this.attack.ehp + this.defence.ehp + this.strength.ehp + this.hitpoints.ehp
  + this.ranged.ehp + this.prayer.ehp + this.magic.ehp + this.cooking.ehp + this.woodcutting.ehp
  + this.fishing.ehp + this.firemaking.ehp + this.crafting.ehp + this.smithing.ehp
  + this.mining.ehp + this.runecraft.ehp) * 10) / 10;
  this.f2p = !(p2p_xp > 0);
}

function printRates(mode){
	var skill_names = ["Attack", "Defence", "Strength", "Hitpoints", "Ranged", "Prayer", "Magic", "Cooking", "Woodcutting", "Fishing", "Firemaking", "Crafting", "Smithing", "Mining", "Runecraft"];
	var result = '<table class="ranks">';
	switch(mode){
		case 0:
			for(var i=0; i<rates.length; i++){
				if(i%2==0){
					result += '<tr>';
				}
				result += '<td style="text-align:center;padding-top:12px;"><u>' + skill_names[i] + '</u><br>';
				for(var j=0; j<rates[i].length; j=j+2){
					result += rates[i][j] + ' XP: ' + rates[i][j+1] + ' XP/h<br>';
				}
				result += '</td>';
				if(i%2!=0 || i==rates.length-1){
					result += '</tr>';
				}
			}
			break;
		case 1:
			for(var i=0; i<rates_im.length; i++){
				if(i%2==0){
					result += '<tr>';
				}
				result += '<td style="text-align:center;padding-top:12px;"><u>' + skill_names[i] + '</u><br>';
				for(var j=0; j<rates_im[i].length; j=j+2){
					result += rates_im[i][j] + ' XP: ' + rates_im[i][j+1] + ' XP/h<br>';
				}
				result += '</td>';
				if(i%2!=0 || i==rates_im.length-1){
					result += '</tr>';
				}
			}
			break;
		default:
			for(var i=0; i<rates_uim.length; i++){
				if(i%2==0){
					result += '<tr>';
				}
				result += '<td style="text-align:center;padding-top:12px;"><u>' + skill_names[i] + '</u><br>';
				for(var j=0; j<rates_uim[i].length; j=j+2){
					result += rates_uim[i][j] + ' XP: ' + rates_uim[i][j+1] + ' XP/h<br>';
				}
				result += '</td>';
				if(i%2!=0 || i==rates_uim.length-1){
					result += '</tr>';
				}
			}
			break;
	}
	result += '</table>';
	document.write(result);
}

function printStats(player){
	var stats = '<table class="table table-condensed"><thead><tr>';
	stats += '<th>Skill</th><th>Rank</th><th>Level</th><th>XP</th><th>EHP</th><th class="gainsDisplay" id="gainsHeader"></th></tr></thead><tbody>';
	stats += '<tr><td><img src="img/skill_ove.gif"> Overall</td>';
	stats += '<td>' + commas(player.overall.rank) + '</td>';
	stats += '<td>' + commas(player.overall.lvl) + '</td>';
	stats += '<td>' + commas(player.overall.xp) + '</td>';
	stats += '<td>' + commas(player.overall.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="oveGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_att.gif"> Attack</td>';
	stats += '<td>' + commas(player.attack.rank) + '</td>';
	stats += '<td>' + player.attack.lvl + '</td>';
	stats += '<td>' + commas(player.attack.xp) + '</td>';
	stats += '<td>' + commas(player.attack.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="attGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_def.gif"> Defence</td>';
	stats += '<td>' + commas(player.defence.rank) + '</td>';
	stats += '<td>' + player.defence.lvl + '</td>';
	stats += '<td>' + commas(player.defence.xp) + '</td>';
	stats += '<td>' + commas(player.defence.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="defGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_str.gif"> Strength</td>';
	stats += '<td>' + commas(player.strength.rank) + '</td>';
	stats += '<td>' + player.strength.lvl + '</td>';
	stats += '<td>' + commas(player.strength.xp) + '</td>';
	stats += '<td>' + commas(player.strength.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="strGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_hit.gif"> Hitpoints</td>';
	stats += '<td>' + commas(player.hitpoints.rank) + '</td>';
	stats += '<td>' + player.hitpoints.lvl + '</td>';
	stats += '<td>' + commas(player.hitpoints.xp) + '</td>';
	stats += '<td>' + commas(player.hitpoints.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="hitGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_ran.gif"> Ranged</td>';
	stats += '<td>' + commas(player.ranged.rank) + '</td>';
	stats += '<td>' + player.ranged.lvl + '</td>';
	stats += '<td>' + commas(player.ranged.xp) + '</td>';
	stats += '<td>' + commas(player.ranged.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="ranGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_pra.gif"> Prayer</td>';
	stats += '<td>' + commas(player.prayer.rank) + '</td>';
	stats += '<td>' + player.prayer.lvl + '</td>';
	stats += '<td>' + commas(player.prayer.xp) + '</td>';
	stats += '<td>' + commas(player.prayer.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="praGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_mag.gif"> Magic</td>';
	stats += '<td>' + commas(player.magic.rank) + '</td>';
	stats += '<td>' + player.magic.lvl + '</td>';
	stats += '<td>' + commas(player.magic.xp) + '</td>';
	stats += '<td>' + commas(player.magic.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="magGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_coo.gif"> Cooking</td>';
	stats += '<td>' + commas(player.cooking.rank) + '</td>';
	stats += '<td>' + player.cooking.lvl + '</td>';
	stats += '<td>' + commas(player.cooking.xp) + '</td>';
	stats += '<td>' + commas(player.cooking.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="cooGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_woo.gif"> Woodcutting</td>';
	stats += '<td>' + commas(player.woodcutting.rank) + '</td>';
	stats += '<td>' + player.woodcutting.lvl + '</td>';
	stats += '<td>' + commas(player.woodcutting.xp) + '</td>';
	stats += '<td>' + commas(player.woodcutting.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="wooGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_fis.gif"> Fishing</td>';
	stats += '<td>' + commas(player.fishing.rank) + '</td>';
	stats += '<td>' + player.fishing.lvl + '</td>';
	stats += '<td>' + commas(player.fishing.xp) + '</td>';
	stats += '<td>' + commas(player.fishing.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="fisGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_fir.gif"> Firemaking</td>';
	stats += '<td>' + commas(player.firemaking.rank) + '</td>';
	stats += '<td>' + player.firemaking.lvl + '</td>';
	stats += '<td>' + commas(player.firemaking.xp) + '</td>';
	stats += '<td>' + commas(player.firemaking.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="firGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_cra.gif"> Crafting</td>';
	stats += '<td>' + commas(player.crafting.rank) + '</td>';
	stats += '<td>' + player.crafting.lvl + '</td>';
	stats += '<td>' + commas(player.crafting.xp) + '</td>';
	stats += '<td>' + commas(player.crafting.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="craGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_smi.gif"> Smithing</td>';
	stats += '<td>' + commas(player.smithing.rank) + '</td>';
	stats += '<td>' + player.smithing.lvl + '</td>';
	stats += '<td>' + commas(player.smithing.xp) + '</td>';
	stats += '<td>' + commas(player.smithing.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="smiGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_min.gif"> Mining</td>';
	stats += '<td>' + commas(player.mining.rank) + '</td>';
	stats += '<td>' + player.mining.lvl + '</td>';
	stats += '<td>' + commas(player.mining.xp) + '</td>';
	stats += '<td>' + commas(player.mining.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="minGains"></td></tr>';
	stats += '<tr><td><img src="img/skill_run.gif"> Runecraft</td>';
	stats += '<td>' + commas(player.runecraft.rank) + '</td>';
	stats += '<td>' + player.runecraft.lvl + '</td>';
	stats += '<td>' + commas(player.runecraft.xp) + '</td>';
	stats += '<td>' + commas(player.runecraft.ehp) + '</td>';
	stats += '<td class="gainsDisplay" id="runGains"></td></tr>';
	stats += '<tr><td style="text-align:right;">Time to 1493 total:</td><td id="timeTo99"></td><td colspan="2" style="text-align:right;">Time to 200m all skills:</td><td id="timeTo200m"></td><td class="gainsDisplay"></td></tr>';

	stats += '</tbody></table><p id="cmlResult" class="small" style="color:red;text-align:center;"></p>';
	return stats;
}

function updateCml(player){
	document.getElementById("cmlResult").innerHTML = "Updating...";
	var updquery = new XMLHttpRequest();
	updquery.onreadystatechange = function() {
		if (updquery.readyState == 4 && updquery.status == 200) {
			var result = updquery.responseText;
			if (result != 1){
				// Display error
				document.getElementById("cmlResult").innerHTML = '<span style="color:red;">Error updating CML</span>';
			}
			else{
				// Display update message
				document.getElementById("cmlResult").innerHTML = 'CML updated - click "Calculate" to use the latest stats';
			}
		}
	}
	updquery.open("GET", "update_cml.php?name=" + player, true);
	updquery.send();
}

function showGains(username, player, period, mode){
	var cmlquery = new XMLHttpRequest();
	cmlquery.onreadystatechange = function() {
		if (cmlquery.readyState == 4 && cmlquery.status == 200) {
			var result = cmlquery.responseText;
			if (result.length < 30){
				// Display error
				document.getElementById("cmlResult").innerHTML = "Error connecting to CML";
			}
			else{
				// Display gains
				switch(period){
					case "86400":
						document.getElementById("gainsHeader").innerHTML = "Gains today";
						break;
					case "172800":
						document.getElementById("gainsHeader").innerHTML = "Gains 2 days";
						break;
					case "259200":
						document.getElementById("gainsHeader").innerHTML = "Gains 3 days";
						break;
					case "432000":
						document.getElementById("gainsHeader").innerHTML = "Gains 5 days";
						break;
					case "604800":
						document.getElementById("gainsHeader").innerHTML = "Gains last week";
						break;
					case "1209600":
						document.getElementById("gainsHeader").innerHTML = "Gains last 2 weeks";
						break;
					case "1814400":
						document.getElementById("gainsHeader").innerHTML = "Gains last 3 weeks";
						break;
					case "2678400":
						document.getElementById("gainsHeader").innerHTML = "Gains last month";
						break;
					case "5256000":
						document.getElementById("gainsHeader").innerHTML = "Gains last 2 months";
						break;
					case "7884000":
						document.getElementById("gainsHeader").innerHTML = "Gains last 3 months";
						break;
					case "15768000":
						document.getElementById("gainsHeader").innerHTML = "Gains last 6 months";
						break;
					case "23652000":
						document.getElementById("gainsHeader").innerHTML = "Gains last 9 months";
						break;
					case "31536000":
						document.getElementById("gainsHeader").innerHTML = "Gains last year";
						break;
					case "63072000":
						document.getElementById("gainsHeader").innerHTML = "Gains 2 years";
						break;
					case "94608000":
						document.getElementById("gainsHeader").innerHTML = "Gains 3 years";
						break;
					default:
						document.getElementById("gainsHeader").innerHTML = "Gains this summer";
						break;
				}
				var arr = result.split(/\r?\n/);
				for(var i=0; i<23; i++){
					arr[i] = arr[i].split(",");
				}
				document.getElementById("cmlResult").style.color = "#333";
				document.getElementById("cmlResult").innerHTML = '<a target="_blank" href="http://crystalmathlabs.com/tracker/track.php?player='+username+'" style="color:#7B4F17;">CML</a> updated ' + timeAgo(arr[0][0]) + ' ago <span id="updateLink"></span>';
				document.getElementById("updateLink").innerHTML = '(<a href="javascript:;" onclick=\'updateCml("'+username+'")\' style="color:#7B4F17;">click here to update</a>)';

				// Calculate EHPs before
				var ehps = [];
				var j = -1;
				for(var i=2; i<23; i++){
					if(i == 11)
						i++;
					if(i == 17)
						i=22;
					j++;
					if(arr[i][0] == 0)
						// No change
						ehps[j] = 0;
					else{
						// Gained ehp
						var old_xp = 0;
						var new_xp = 0;
						if(j == 12) {
							old_xp = new skill_(j, 0, 0, arr[i][2] - arr[i][0], mode, new skill(11, 0, 0, arr[14][2] - arr[14][0], mode));
							new_xp = new skill_(j, 0, 0, arr[i][2], mode, new skill(11, 0, 0, arr[14][2], mode));
							
							console.log(old_xp);
							console.log(new_xp);
						} else {
							old_xp = new skill(j, 0, 0, arr[i][2] - arr[i][0], mode);
							new_xp = new skill(j, 0, 0, arr[i][2], mode);
						}
						ehps[j] = Math.round( (new_xp.ehp - old_xp.ehp) * 10) / 10;
						if(j == 12 && arr[i][2] < new_xp.xplimit) ehps[j] = Math.round(old_xp.ehp);
						
						console.log(ehps[j]);
					}
				}
				var total_ehp = 0;
				for(var i=0; i<ehps.length; i++){
					total_ehp += ehps[i];
				}
				total_ehp = Math.round(total_ehp * 10) / 10;

				document.getElementById("oveGains").innerHTML = ("+" + commas(arr[1][0]) + " (" + commas(total_ehp) + "h)");
				document.getElementById("attGains").innerHTML = ("+" + commas(arr[2][0]) + " (" + commas(ehps[0]) + "h)");
				document.getElementById("defGains").innerHTML = ("+" + commas(arr[3][0]) + " (" + commas(ehps[1]) + "h)");
				document.getElementById("strGains").innerHTML = ("+" + commas(arr[4][0]) + " (" + commas(ehps[2]) + "h)");
				document.getElementById("hitGains").innerHTML = ("+" + commas(arr[5][0]) + " (" + commas(ehps[3]) + "h)");
				document.getElementById("ranGains").innerHTML = ("+" + commas(arr[6][0]) + " (" + commas(ehps[4]) + "h)");
				document.getElementById("praGains").innerHTML = ("+" + commas(arr[7][0]) + " (" + commas(ehps[5]) + "h)");
				document.getElementById("magGains").innerHTML = ("+" + commas(arr[8][0]) + " (" + commas(ehps[6]) + "h)");
				document.getElementById("cooGains").innerHTML = ("+" + commas(arr[9][0]) + " (" + commas(ehps[7]) + "h)");
				document.getElementById("wooGains").innerHTML = ("+" + commas(arr[10][0]) + " (" + commas(ehps[8]) + "h)");
				document.getElementById("fisGains").innerHTML = ("+" + commas(arr[12][0]) + " (" + commas(ehps[9]) + "h)");
				document.getElementById("firGains").innerHTML = ("+" + commas(arr[13][0]) + " (" + commas(ehps[10]) + "h)");
				document.getElementById("craGains").innerHTML = ("+" + commas(arr[14][0]) + " (" + commas(ehps[11]) + "h)");
				document.getElementById("smiGains").innerHTML = ("+" + commas(arr[15][0]) + " (" + commas(ehps[12]) + "h)");
				document.getElementById("minGains").innerHTML = ("+" + commas(arr[16][0]) + " (" + commas(ehps[13]) + "h)");
				document.getElementById("runGains").innerHTML = ("+" + commas(arr[22][0]) + " (" + commas(ehps[14]) + "h)");

				var list = document.getElementsByClassName("gainsDisplay");
				for(var i=0; i<list.length; i++){
					list[i].style.display = "table-cell";
				}
			}
		}
	}
	cmlquery.open("GET", "getgains.php?name=" + username + "&period=" + period, true);
	cmlquery.send();
}

function search(){
  var username = document.getElementById("nameInput").value.replace(/ /g,'_');
  var e = document.getElementById("period");
  var period = e.options[e.selectedIndex].value;
  var gamemode = 2;
  if(document.getElementById("radio0").checked){
    gamemode = 0;
  }
  else if(document.getElementById("radio1").checked){
    gamemode = 1;
  }
  document.getElementById("result").innerHTML = "<br><h4>Loading...</h4>";

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
        document.getElementById("timeTo99").innerHTML = timeTo(player, gamemode, 13034431) + ' hours';
        document.getElementById("timeTo200m").innerHTML = timeTo(player, gamemode, 200000000) + ' hours';
        showGains(username, player, period, gamemode);
      }
    }
  }
  query.open("GET", "gethiscore.php?name=" + username + "&mode=" + gamemode, true);
  query.send();
  return false;
}