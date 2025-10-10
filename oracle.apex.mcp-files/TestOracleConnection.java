import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class TestOracleConnection {
    public static void main(String[] args) {
        String dbUrl = "jdbc:oracle:thin:@qik84h5rgwho9el0_low";
        Properties props = new Properties();
        props.setProperty("user", "sys");
        props.setProperty("password", "NWFlMWQ5");
        props.setProperty("oracle.net.tns_admin", "/Users/helder/lib/oracle/wallets/Wallet_QIK84H5RGWHO9EL0");

        System.out.println("Attempting to connect to: " + dbUrl);
        System.out.println("Using TNS_ADMIN: " + props.getProperty("oracle.net.tns_admin"));

        try (Connection connection = DriverManager.getConnection(dbUrl, props)) {
            if (connection != null) {
                System.out.println("Successfully connected to the database!");
            } else {
                System.out.println("Failed to make connection!");
            }
        } catch (SQLException e) {
            System.err.println("Connection Failed! Check output console");
            e.printStackTrace();
        }
    }
}