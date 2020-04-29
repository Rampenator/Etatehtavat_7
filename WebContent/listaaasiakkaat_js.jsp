<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main_js.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaat</title>
</head>
<body onkeydown="tutkiKey(event)">
<table class="tg" id="listaus">
	<thead>
		<tr>
			<th class="tg-2lax" colspan="4" id="ilmoitus" ></th>
			<th class="tg-1lax"><a id="uusiAsiakas" href="lisaaasiakas_js.jsp">Lis�� asiakas</a></th>
		</tr>
		<tr>	
			<th class="tg-1lax" colspan="3">Hakusana:</th>
			<th class="tg-0lax"><input type="text" id="hakusana"></th>
			<th class="tg-0lax"><input type="button" value="Hae" id="hakunappi" onclick="haeTiedot()"></th>
		</tr>
		<tr>
	    	<th class="tg-0lax">Etunimi</th>
	    	<th class="tg-0lax">Sukunimi</th>
	    	<th class="tg-0lax">Puhelin</th>
	    	<th class="tg-0lax">S�hk�posti</th>
	    	<th class="tg-0lax">Muuta/Poista</th>
	  	</tr>
	</thead>
	<tbody id ="tbody">	
	</tbody>  	
</table>

<script>
haeTiedot();	
document.getElementById("hakusana").focus();//vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�

function tutkiKey(event){
	if(event.keyCode==13){//Enter
		haeTiedot();
	}		
}
//Funktio tietojen hakemista varten -- GET   /asiakkaat/{hakusana}
function haeTiedot(){	
	document.getElementById("tbody").innerHTML = "";
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//L�hetet��n kutsu backendiin
	      method: 'GET'
	    })
	.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json()	
	})
	.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
		console.log(responseJson);
		var asiakkaat = responseJson.asiakkaat;	
		var htmlStr="";
		for(var i=0;i<asiakkaat.length;i++){			
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";  
       		htmlStr+="<td><a href='muutaasiakas_js.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&ensp;";
        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
        	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;		
	})	
}
//Funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja v�litet��n poistettavan asiakkaan id. 
//DELETE /asiakkaat/id
function poista(asiakas_id){
	if(confirm("Poista asiakas " + asiakas_id +"?")){	
		fetch("asiakkaat/"+ asiakas_id,{//L�hetet��n kutsu backendiin
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmoitus").innerHTML= "Asiakkaan poisto ep�onnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmoitus").innerHTML="Asiakkaan " + asiakas_id +" poisto onnistui.";
				haeTiedot();        	
			}	
			setTimeout(function(){ document.getElementById("ilmoitus").innerHTML=""; }, 5000);
		})		
	}	
}
</script>
</body>
</html>