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
import beans.dao.Dao;
import beans.Asiakas;

@WebServlet("/asiakkaat/*") //voi sis‰lt‰‰ alikansioita 
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Asiakkaat() {
        super();
        System.out.println("Asiakkaat.Asiakkaat()");
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()"); //Testi toimiiko
		String pathInfo = request.getPathInfo(); //Haetaan polkutiedot, esim. /jarkko
		System.out.println("polku: "+pathInfo);
		Dao dao = new Dao(); //Data access object
		ArrayList<Asiakas> asiakkaat = new ArrayList();
		String strJSON = "";
		
		if(pathInfo==null) {//Haetaan kaikki asiakkaat
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
			System.out.println("polku: "+"test1");
		}else if(pathInfo=="/") {
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
			System.out.println("polku: "+"test2");
		}else if(pathInfo.indexOf("haeyksi")!=-1) { //Haetaan yhden asiakkaan tiedot, jos polussa on "haeyksi"
			int asiakas_id = Integer.parseInt(pathInfo.replace("/haeyksi/", "")); //poistetaan polusta "/", j‰ljelle j‰‰ id, joka muutetaan int
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id);
			if(asiakas==null) {
				strJSON = "{}";
			}else {
			JSONObject JSON = new JSONObject();
			JSON.put("asiakas_id", asiakas.getAsiakas_id());
			JSON.put("etunimi", asiakas.getEtunimi());
			JSON.put("sukunimi", asiakas.getSukunimi());
			JSON.put("puhelin", asiakas.getPuhelin());
			JSON.put("sposti", asiakas.getSposti());	
			strJSON = JSON.toString();
			}
		} else { //Haetaan hakusanan mukaiset asiakkaat
			System.out.println("polku: "+"test3");
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString(); //Muutetaan JSONiksi
		}
		response.setContentType("application/json"); //M‰‰ritet‰‰n outputin tyypiksi JSON
		PrintWriter ulos = response.getWriter(); 
		ulos.println(strJSON); //Kirjoittaa ulos strJSONin eli asiakkaat listan
	}
	//Asiakkaan lis‰‰minen
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()"); //Testi toimiiko
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Otetaan vastaan Json string ja muutetaan se Json objectiksi
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		
		response.setContentType("application/json"); //M‰‰ritet‰‰n outputin tyypiksi JSON
		PrintWriter ulos = response.getWriter();
		Dao dao = new Dao(); //Data access object 
		if(dao.lisaaAsiakas(asiakas)){ //metodi palauttaa true/false
			ulos.println("{\"response\":1}");  //Asiakkaan lis‰‰minen onnistui {"response":1}
		}else{
			ulos.println("{\"response\":0}");  //Asiakaab lis‰‰minen ep‰onnistui {"response":0}
		}
	}
	//Asiakkaan muuttaminen
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()"); //Testi toimiiko
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Otetaan vastaan Json string ja muutetaan se Json objectiksi
		Asiakas asiakas = new Asiakas();
		System.out.println(jsonObj);
		int asiakas_id = Integer.parseInt(jsonObj.getString("asiakas_id"));
		asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id"));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json"); //M‰‰ritet‰‰n outputin tyypiksi JSON
		PrintWriter ulos = response.getWriter();
		Dao dao = new Dao(); //Data access object 
		if(dao.muutaAsiakas(asiakas,asiakas_id)){ //metodi palauttaa true/false
			ulos.println("{\"response\":1}");  //Asiakkaan muuttaminen onnistui {"response":1}
		}else{
			ulos.println("{\"response\":0}");  //Asiakaan muuttaminen ep‰onnistui {"response":0}
		}
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()"); //Testi toimiiko
		String pathInfo = request.getPathInfo(); //Haetaan polkutiedot, esim. /jarkko
		System.out.println(pathInfo);
		int asiakas_id = Integer.parseInt(pathInfo.replace("/", "")); //poistetaan polusta "/", j‰ljelle j‰‰ id, joka muutetaan int
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if(dao.poistaAsiakas(asiakas_id)){ //metodi palauttaa true/false
			out.println("{\"response\":1}"); //Asiakkaan poisto onnistui {"response":1}
		}else {
			out.println("{\"response\":0}"); //Asiakkaan poisto ep‰onnistui {"response":0}
		}		
	}

}

