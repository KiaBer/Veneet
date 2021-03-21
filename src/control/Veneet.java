package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import model.Vene;
import model.dao.Dao;

@WebServlet("/veneet/*")
public class Veneet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Veneet() {
        super();
        System.out.println("Veneet.Veneet()");
    }

	//Tietojen hakeminen: kaikki, hakusanan perusteella ja yhden, jonka tietoja halutaan muokata.
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doGet()");
		String pathInfo = request.getPathInfo(); //haetaan kutsun polkutiedot.			
		System.out.println("polku: "+pathInfo);	
		String strJSON="";
		ArrayList<Vene> veneet;
		Dao dao = new Dao();
		if(pathInfo==null) { //Haetaan kaikki.
			veneet = dao.listaaKaikki();
			strJSON = new JSONObject().put("veneet", veneet).toString();
		}else if(pathInfo.indexOf("haeyksi")!=-1) { //polussa on sana "haeyksi", eli haetaan yhden veneen tiedot.
			int tunnus = Integer.parseInt(pathInfo.replace("/haeyksi/", "")); //poistetaan polusta "/haeyksi/", j‰ljelle j‰‰ tunnus.
			Vene vene = dao.etsiVene(tunnus);
			if(vene==null){ //Jos asiakasta ei lˆytynyt, niin palautetaan tyhj‰ objekti.
				strJSON = "{}";
			}else{
				JSONObject JSON = new JSONObject();
				JSON.put("tunnus", vene.getTunnus());
				JSON.put("nimi", vene.getNimi());
				JSON.put("merkkimalli", vene.getMerkkimalli());
				JSON.put("pituus", vene.getPituus());
				JSON.put("leveys", vene.getLeveys());
				JSON.put("hinta", vene.getHinta());
				strJSON = JSON.toString();
			}
		}else{ //Haetaan hakusanan mukaiset veneet.
			String hakusana = pathInfo.replace("/", "");	
			veneet = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("veneet", veneet).toString();				
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);
		}

	//Veneen lis‰‰minen
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi.			
		Vene vene = new Vene();
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaVene(vene)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //lis‰‰minen ep‰onnistui {"response":0}
		}
	}

	//Veneen tietojen muokkaaminen
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi.			
		Vene vene = new Vene();
		vene.setTunnus(Integer.parseInt(jsonObj.getString("tunnus"))); //tunnus on String, joka pit‰‰ muuttaa int muotoon.
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaVene(vene)){ //metodi palauttaa true/false.
			out.println("{\"response\":1}");  //muokkaaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //muokkaaminen ep‰onnistui {"response":0}
		}
	}

	//Veneen poistaminen
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot.	
		int tunnus = Integer.parseInt(pathInfo.replace("/", "")); //poistetaan polusta "/", j‰ljelle j‰‰ tunnus, joka muutetaan int muotoon.	
		Dao dao = new Dao();
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();		    
		if(dao.poistaVene(tunnus)){ //metodi palauttaa true/false
			out.println("{\"response\":1}"); //poisto onnistui {"response":1}
		}else {
			out.println("{\"response\":0}"); //poisto ep‰onnistui {"response":0}
		}		
	}
}
