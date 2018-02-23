function maxhit(level, gear){
	return Math.floor(0.5 + level * (gear+64) / 640);
}

function dps(){

	// Scan variables
	var range = document.querySelector('[name="range"]').value;
	var rangeatt1 = Number(document.querySelector('[name="rangeatt1"]').value);
	var rangeatt2 = Number(document.querySelector('[name="rangeatt2"]').value);
	var strbonus1 = Number(document.querySelector('[name="strengthbonus1"]').value);
	var strbonus2 = Number(document.querySelector('[name="strengthbonus2"]').value);
	var enemyHit = Number(document.querySelector('[name="enemyHit"]').value);
	var enemyDef = Number(document.querySelector('[name="enemyDef"]').value);
	var enemyArm = Number(document.querySelector('[name="enemyArm"]').value);
	var e = document.getElementById("attStyle");
	var attStyle = e.options[e.selectedIndex].value;
	var e = document.getElementById("rngPrayer");
	var rngPrayer = e.options[e.selectedIndex].value;
	var attackspeed1 = Number(document.querySelector('[name="attackspeed1"]').value);
	var attackspeed2 = Number(document.querySelector('[name="attackspeed2"]').value);

	// Effective ranged
	var A = range;
	//multiply by prayer
	switch(rngPrayer){
		case "1":
			A *= 1.05;
			break;
		case "2":
			A *= 1.10;
			break;
		case "3":
			A *= 1.15;
			break;
		default:
			break;
	}
	//round down
	A = Math.floor(A)+8;
	//add stance bonus determined by attack style
	switch(attStyle){
		case "1":
			A += 3;
			break;
		default:
			break;
	}

	// Maximum base hits
	var maxhit1 = maxhit(A, strbonus1);
	var maxhit2 = maxhit(A, strbonus2);

    // Projected max hits
    var projected1 = new Array();
    var projected2 = new Array();

    var projections = "<tbody><tr><td>Ranged</td>";
    var j = 0;
    for(i=1; i<13; i++){
    	j = Number(range)+i;
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


	// Attack roll
	attRoll1 = A * (rangeatt1+64);
	attRoll2 = A * (rangeatt2+64);

	// Enemy effective def & defence roll
	var effD = enemyDef + 8 + 1; //+1 comes from controlled attack style
	var defRoll = effD * (enemyArm+64);

	// Hit chance
	var accuracy1 = 0;
	var accuracy2 = 0;
	if(attRoll1 > defRoll){
		accuracy1 = 1 - (defRoll+2) / (2*(attRoll1+1));
	}
	else{
		accuracy1 = attRoll1 / (2*(defRoll+1));
	}
	if(attRoll2 > defRoll){
		accuracy2 = 1 - (defRoll+2) / (2*(attRoll2+1));
	}
	else{
		accuracy2 = attRoll2 / (2*(defRoll+1));
	}

    // DPS
	//Divide by 2 because that is the average hit
	//0.6 second/tick
	var dps1 = accuracy1 * maxhit1 / 2 / (0.6*attackspeed1);
	var dps2 = accuracy2 * maxhit2 / 2 / (0.6*attackspeed2);

	// Overkill formula
	//This calcalution takes into consideration that enemies have finite hp
	var Y1 = Math.min(maxhit1,enemyHit);
    var Y2 = Math.min(maxhit2,enemyHit);
	var realhit1 = ( (accuracy1*Y1*(Y1+1)) / (enemyHit*(maxhit1+1)) ) * ( 0.5*(maxhit1+enemyHit+1) - ((1/3) * (2*Y1+1)) );
	var realhit2 = ( (accuracy2*Y2*(Y2+1)) / (enemyHit*(maxhit2+1)) ) * ( 0.5*(maxhit2+enemyHit+1) - ((1/3) * (2*Y2+1)) );

    // Overkill DPS
	var okdps1 = realhit1 / (0.6*attackspeed1);
	var okdps2 = realhit2 / (0.6*attackspeed2);

    // XP/h
	var xph1 = okdps1 * 3600 * 4;
	var xph2 = okdps2 * 3600 * 4;

	// Rounding to 4 and 3 decimal places
	accuracy1 = Math.round(accuracy1*10000)/10000;
	accuracy2 = Math.round(accuracy2*10000)/10000;
	dps1 = Math.round(dps1*1000)/1000;
	dps2 = Math.round(dps2*1000)/1000;

	// Output
	document.getElementById("maxhit1").innerHTML = maxhit1;
	document.getElementById("maxhit2").innerHTML = maxhit2;
	document.getElementById("accuracy1").innerHTML = accuracy1;
	document.getElementById("accuracy2").innerHTML = accuracy2;
	document.getElementById("dps1").innerHTML = dps1;
	document.getElementById("dps2").innerHTML = dps2;
	document.getElementById("xph1").innerHTML = Math.round(xph1);
	document.getElementById("xph2").innerHTML = Math.round(xph2);
	document.getElementById("projections").innerHTML = projections;
}
