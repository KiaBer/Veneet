<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Courgette&display=swap" rel="stylesheet">
<title>Venelista</title>
</head>
<div class="header">
<h1>Venemaailma</h1>
</div>
<body>
<table id="listaus">
	<thead>
		<tr>
			<th colspan="6" class="oikealle"><span id="uusiVene">Lisää uusi vene</span></th>
		</tr>
		<tr>
			<th colspan="4" class="oikealle">Hakusana:</th>
			<th><input type="text" id="hakusana"></th>
			<th><input class= "nappi" type="button" id="hae" value="Hae"></th>
		</tr>				
		<tr>
			<th>Nimi</th>
			<th>Merkki/Malli</th>
			<th>Pituus</th>
			<th>Leveys</th>	
			<th>Hinta</th>
			<th></th>						
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
<script>
$(document).ready(function(){	
	$("#uusiVene").click(function(){
		document.location="lisaavene.jsp";
	});
	
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enter aktivoi hae napin
			  haeTiedot();
		  }
	});	
	
	$("#hae").click(function(){	
		haeTiedot();
	});
	
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
	haeTiedot();
});

//Funktio tietojen hakemista varten. Kutsutaan backin GET-metodia
function haeTiedot(){	
	$("#listaus tbody").empty();
	$.ajax({url:"veneet/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){	
		$.each(result.veneet, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.tunnus+"'>";
        	htmlStr+="<td>"+field.nimi+"</td>";
        	htmlStr+="<td>"+field.merkkimalli+"</td>";
        	htmlStr+="<td>"+field.pituus+"</td>";
        	htmlStr+="<td>"+field.leveys+"</td>";
        	htmlStr+="<td>"+field.hinta+"</td>";
        	htmlStr+="<td><a class=muuta href='muutavene.jsp?tunnus="+field.tunnus+"'>Muuta</a>&nbsp;";
        	htmlStr+="<span class='poista' onclick=poista('"+field.tunnus+"','"+field.nimi+"','"+field.merkkimalli.replace(" ", "&nbsp;")+"')>Poista</span></td>"; 
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });	
    }});
}

//Funktio veneen poistamista varten. Kutsutaan backin DELETE-metodia. Huomaa, että kaikki veneen tiedot poistuu, Oikeassa työssä merkitään poistetuksi, jolloin tiedot jää jemmaan.
function poista(tunnus, nimi, merkkimalli) {
	if(confirm("Poista vene " + nimi +" "+ merkkimalli +"?")){	
		$.ajax({url:"veneet/"+tunnus, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("Veneen poisto epäonnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+tunnus);
	        	alert("Veneen " + nimi +" "+ merkkimalli +" poisto onnistui.");
				haeTiedot();        	
			}
	    }});
	}
}
</script>
</body>
<footer>
	<ul>
	  <li>Venemaailma</li>
	  <li>Satamatie 8</li>
	  <li>01800 Satamala</li>
	  <li>050 456 3893</li>
	</ul>
</footer>
</html>