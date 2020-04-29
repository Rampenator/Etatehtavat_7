<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main_js.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Lisää asiakas</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot">
	<table class="tg" id="lisays">
		<thead>	
			<tr>
				<th colspan="3" class="tg-2lax"id="ilmoitus"></th>
				<th colspan="2" class="tg-1lax"><a href="listaaasiakkaat_js.jsp" id="takaisin">Takaisin listaukseen</a></th>
			</tr>		
			<tr>
				<th class="tg-0lax">Etunimi</th>
				<th class="tg-0lax">Sukunimi</th>
				<th class="tg-0lax">Puhelin</th>
				<th class="tg-0lax">Sähköposti</th>
				<th class="tg-0lax"></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="button" name="button" id="tallenna" value="Lisää" onclick="lisaaTiedot()"></td>
			</tr>
		</tbody>
	</table>
</form>
</body>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		lisaaTiedot();
	}
}
document.getElementById("etunimi").focus();//Kursori etunimeen

//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /asiakkaat/
//Ensin validoidaan syötettävät arvot
function lisaaTiedot(){	
	var ilmoitus="";
	if(document.getElementById("etunimi").value.length<3){
		ilmoitus="Nimi on liian lyhyt!";		
	}else if(document.getElementById("sukunimi").value.length<3){
		ilmoitus="Nimi on liian lyhyt!";		
	}else if(document.getElementById("puhelin").value.length<10){
		ilmoitus="Puhelinnumerossa on 10 merkkiä";	
	}else if(document.getElementById("sposti").value.length<10){
		ilmoitus="Syötä validi maili";		
	}
	if(ilmoitus!=""){
		document.getElementById("ilmoitus").innerHTML=ilmoitus;
		setTimeout(function(){ document.getElementById("ilmoitus").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan tiedot json-stringiksi & Lähetään backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmoitus").innerHTML= "Asiakkaan lisääminen epäonnistui";
    	}else if(vastaus==1){	        	
    		document.getElementById("ilmoitus").innerHTML= "Asiakkaan lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmoitus").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}

</script>

</html>