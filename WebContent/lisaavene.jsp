<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Courgette&display=swap" rel="stylesheet">
<title>Veneen lisääminen</title>
</head>
<div class="header">
<h1>Venemaailma</h1>
</div>
<body>
<form  id="tiedot">
	<table>
	<thead>
		<tr>
			<th colspan="5">Lisää uuden veneen tiedot:</th>
			<th colspan="1" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
		</tr>
		<tr>
			<th>Nimi</th>
			<th>Merkki/malli</th>
			<th>Pituus</th>
			<th>Leveys</th>
			<th>Hinta</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" name="nimi" id="nimi"></td>
			<td><input type="text" name="merkkimalli" id="merkkimalli"></td>
			<td><input type="text" name="pituus" id="pituus"></td>
			<td><input type="text" name="leveys" id="leveys"></td> 
			<td><input type="text" name="hinta" id="hinta"></td> 
			<td><input class= "nappi" type="submit" id="tallenna" value="Lisää"></td>
		</tr>
	</tbody>
</table>
</form>
<span id="ilmo"></span>
<script>
$(document).ready(function(){
	$("#takaisin").click(function(){
		document.location="listaaveneet.jsp";
	});
	
	$("#nimi").focus();

	//Lomakkeella annettujen tietojen tarkistus.
	$("#tiedot").validate({						
		rules: {
			nimi:  {
				required: true,				
				minlength: 2				
			},	
			merkkimalli:  {
				required: true,				
				minlength: 4				
			},
			pituus:  {
				required: true				
			},
			leveys:  {
				required: true				
			},
			hinta:  {
				required: true			
			}
		},
		messages: {
			nimi: {     
				required: "Anna veneen nimi",				
				minlength: "Liian lyhyt"			
			},
			merkkimalli: {
				required: "Anna merkki/malli",				
				minlength: "Liian lyhyt"
			},
			pituus: {
				required: "Anna pituus muodossa 0.0"
			},
			leveys: {
				required: "Anna leveys muodossa 0.0"
			},
			hinta: {
				required: "Anna veneen hinta"
			}
		},	
		submitHandler: function(form) {	
			lisaaTiedot();
		}		
	});   
});

//Funktion uuden veneen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä.
function lisaaTiedot(){
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	$.ajax({url:"veneet", data:formJsonStr, type:"POST", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
        	$("#ilmo").html("Veneen lisääminen epäonnistui.");
        }else if(result.response==1){			
        	$("#ilmo").html("Veneen lisääminen onnistui.");
        	$("#nimi, #merkkimalli, #pituus, #leveys, #hinta").val("");
        	setTimeout(function () {
        	    window.location.href = 'listaaveneet.jsp';
        	}, 3000);
		}
    }});	
}
</script>
</body>
</html>