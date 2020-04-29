package beans.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import beans.Asiakas;

public class Dao {

	private Connection con=null;
	private ResultSet rs = null;
	private PreparedStatement stmtPrep=null; 
	private String sql;
	private String db = "Myynti.sqlite";
	
	private Connection connect(){ //Luodaan yhteys
    	Connection con = null;    	
    	String path = System.getProperty("catalina.base");    	
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/"); //Eclipsessa
    	//path += "/webapps/"; //Tuotannossa. Laita tietokanta webapps-kansioon
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys avattu.");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyden avaus epäonnistui.");
	        e.printStackTrace();	         
	     }
	     return con;
	}
	
	public ArrayList<Asiakas> listaaKaikki() {
		ArrayList<Asiakas> asiakkaat= new ArrayList();
		sql = "SELECT * FROM asiakkaat";
		
		try {
			con = connect();
			
			if (con!= null) { //Jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);
				rs = stmtPrep.executeQuery();
				
				if (rs!= null) { //Jos kysely onnistui
					while (rs.next()) {
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			}
			con.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return asiakkaat;
	}
	public ArrayList<Asiakas> listaaKaikki(String hakusana) {
		ArrayList<Asiakas> asiakkaat= new ArrayList();
		sql = "SELECT * FROM asiakkaat Where etunimi LIKE ? or sukunimi LIKE ? or puhelin LIKE ? or sposti LIKE ?";
		
		try {
			con = connect();
			
			if (con!= null) { //Jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);
				stmtPrep.setString(1, "%" + hakusana + "%");
				stmtPrep.setString(2, "%" + hakusana + "%");   
				stmtPrep.setString(3, "%" + hakusana + "%");  
				stmtPrep.setString(4, "%" + hakusana + "%");
				rs = stmtPrep.executeQuery();
				
				if (rs!= null) { //Jos kysely onnistui
					while (rs.next()) {
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			}
			con.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return asiakkaat;
	}   
	
	public boolean lisaaAsiakas(Asiakas asiakas) {
		boolean paluuArvo=true;
		sql = "INSERT INTO asiakkaat (etunimi, sukunimi, puhelin, sposti) VALUES (?,?,?,?)";
		try {
			con = connect();
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, asiakas.getEtunimi());
			stmtPrep.setString(2, asiakas.getSukunimi());
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.executeUpdate();
			System.out.println("Uusin id on " + stmtPrep.getGeneratedKeys().getInt(1));
			con.close();
		}catch(  Exception e) {
			e.printStackTrace();
			paluuArvo=false;
		}
		return paluuArvo;
	}
	
	public boolean poistaAsiakas(int asiakas_id) {
		boolean paluuArvo=true;
		sql="DELETE FROM asiakkaat WHERE asiakas_id=?";						  
		try {
			con = connect();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setInt(1, asiakas_id);			
			stmtPrep.executeUpdate();
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
	
	public Asiakas etsiAsiakas(int asiakas_id) {
		Asiakas asiakas = null;
		sql = "SELECT * FROM asiakkaat WHERE asiakas_id=?";
		try {
			con = connect();
			if (con!=null) {
				stmtPrep=con.prepareStatement(sql); 
				stmtPrep.setInt(1, asiakas_id);	
				rs = stmtPrep.executeQuery();
				if(rs.isBeforeFirst()) {//jos kysely tuotti dataa
					rs.next();
					asiakas = new Asiakas();
					asiakas.setAsiakas_id(rs.getInt(1));
					asiakas.setEtunimi(rs.getString(2));
					asiakas.setSukunimi(rs.getString(3));
					asiakas.setPuhelin(rs.getString(4));
					asiakas.setSposti(rs.getString(5));
				}
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return asiakas;
	}
	public boolean muutaAsiakas(Asiakas asiakas, int asikas_id) {
		boolean paluuArvo=true;
		sql="UPDATE asiakkaat SET etunimi=?, sukunimi=?, puhelin=?, sposti=? WHERE asiakas_id=?";						  
		try {
			con = connect();
			stmtPrep=con.prepareStatement(sql); 
			stmtPrep.setString(1, asiakas.getEtunimi());
			stmtPrep.setString(2, asiakas.getSukunimi());
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.setInt(5, asiakas.getAsiakas_id());
			stmtPrep.executeUpdate();
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}
		return paluuArvo;
	}
	 
}
