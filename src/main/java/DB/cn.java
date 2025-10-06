/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author monza
 */
public class cn {
	private static final String URL = "jdbc:mysql://localhost:3306/psicologia2?useSSL=false&serverTimezone=UTC";
	private static final String USER = "root"; // TODO: cambia según tu entorno
	private static final String PASS = "";     // TODO: cambia según tu entorno

	static {
		try {
			// For MySQL Connector/J 8+, the driver is auto-registered, but keep for safety
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			// ignore, it will still work with Service Provider mechanism
		}
	}

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(URL, USER, PASS);
	}
}
