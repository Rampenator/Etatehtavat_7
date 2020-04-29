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
	<table class="tg" id="muutos">
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
				<td><input type="button" name="button" id="tallenna" value="Muuta" onclick="vieTiedot()"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>

</body>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		vieTiedot();
	}		
}
document.getElementById("etunimi").focus();//Kursori etunimeen

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
//GET /asiakkaat/haeyksi/id
var asiakas_id = requestURLParam("asiakas_id"); //Funktio löytyy scripts/main.js 
fetch("asiakkaat/haeyksi/" + asiakas_id,{//Lähetetään kutsu backendiin
      method: 'GET'	      
    })
.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
	console.log(responseJson);
	document.getElementById("etunimi").value = responseJson.etunimi;		
	document.getElementById("sukunimi").value = responseJson.sukunimi;	
	document.getElementById("puhelin").value = responseJson.puhelin;	
	document.getElementById("sposti").value = responseJson.sposti;	
	document.getElementById("asiakas_id").value = responseJson.asiakas_id;	
});	

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä.
//PUT /asiakkaat/
function vieTiedot(){	
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
	
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	//Lähetään muutetut tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'PUT',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmoitus").innerHTML= "Tietojen päivitys epäonnistui";
        }else if(vastaus==1){	        	
        	document.getElementById("ilmoitus").innerHTML= "Tietojen päivitys onnistui";			      	
		}	
		setTimeout(function(){ document.getElementById("ilmoitus").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}
</script>
</html>