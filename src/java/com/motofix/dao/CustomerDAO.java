package com.motofix.dao;

import com.motofix.controller.DBContext;
import com.motofix.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Customers = JOIN Accounts + Customers (MotoFixDBNew schema).
 * Extends DBContext to use the shared Connection initialized from
 * ConnectDB.properties.
 */
public class CustomerDAO extends DBContext {

    private Customer map(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("CustomerID"));
        c.setAccountId(rs.getInt("AccountID"));
        c.setUsername(rs.getString("Username"));
        c.setFirstName(rs.getString("firstName"));
        c.setLastName(rs.getString("lastName"));
        c.setEmail(rs.getString("Email"));
        c.setAddress(rs.getString("Address"));
        c.setActive(rs.getBoolean("IsActive"));
        try {
            c.setAvatarUrl(rs.getString("AvatarUrl"));
        } catch (SQLException ignored) {
        }
        return c;
    }

    public List<Customer> listAll() throws SQLException {
        String sql = "SELECT c.CustomerID, a.AccountID, a.Username, a.firstName, a.lastName, "
                + "a.Email, a.AvatarUrl, a.IsActive, c.Address "
                + "FROM Customers c JOIN Accounts a ON c.AccountID = a.AccountID "
                + "ORDER BY c.CustomerID DESC";
        List<Customer> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql);
                ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public Customer findById(int customerId) throws SQLException {
        String sql = "SELECT c.CustomerID, a.AccountID, a.Username, a.firstName, a.lastName, "
                + "a.Email, a.AvatarUrl, a.IsActive, c.Address "
                + "FROM Customers c JOIN Accounts a ON c.AccountID = a.AccountID "
                + "WHERE c.CustomerID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /** Returns non-null if username already exists in Accounts */
    public Customer findByUsername(String username) throws SQLException {
        String sql = "SELECT c.CustomerID, a.AccountID, a.Username, a.firstName, a.lastName, "
                + "a.Email, a.AvatarUrl, a.IsActive, c.Address "
                + "FROM Customers c JOIN Accounts a ON c.AccountID = a.AccountID "
                + "WHERE a.Username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /**
     * Create: INSERT into Accounts (Role='CUSTOMER'), then INSERT into Customers.
     * Password defaults to hashed username if not provided.
     */
    public void create(String username, String firstName, String lastName,
            String email, String password, String address) throws SQLException {
        String hash = (password != null && !password.isEmpty())
                ? password
                : "123";

        connection.setAutoCommit(false);
        try {
            int accountId;
            String sqlAcc = "INSERT INTO Accounts (Username, PasswordHash, firstName, lastName, Email, Role) "
                    + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER')";
            try (PreparedStatement st = connection.prepareStatement(sqlAcc, Statement.RETURN_GENERATED_KEYS)) {
                st.setString(1, username);
                st.setString(2, hash);
                st.setString(3, firstName);
                st.setString(4, lastName);
                st.setString(5, email);
                st.executeUpdate();
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Failed to get AccountID");
                    }
                    accountId = rs.getInt(1);
                }
            }
            String sqlCust = "INSERT INTO Customers (AccountID, Address) VALUES (?, ?)";
            try (PreparedStatement st = connection.prepareStatement(sqlCust)) {
                st.setInt(1, accountId);
                st.setString(2, address != null ? address : "");
                st.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    /** Update: modify Accounts and Customers in one transaction */
    public void update(int customerId, String firstName, String lastName,
            String email, String address, boolean isActive) throws SQLException {
        connection.setAutoCommit(false);
        try {
            String sqlAcc = "UPDATE Accounts SET firstName=?, lastName=?, Email=?, IsActive=? "
                    + "WHERE AccountID = (SELECT AccountID FROM Customers WHERE CustomerID=?)";
            try (PreparedStatement st = connection.prepareStatement(sqlAcc)) {
                st.setString(1, firstName);
                st.setString(2, lastName);
                st.setString(3, email);
                st.setBoolean(4, isActive);
                st.setInt(5, customerId);
                st.executeUpdate();
            }
            String sqlCust = "UPDATE Customers SET Address=? WHERE CustomerID=?";
            try (PreparedStatement st = connection.prepareStatement(sqlCust)) {
                st.setString(1, address != null ? address : "");
                st.setInt(2, customerId);
                st.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    /** Soft delete: mark account inactive */
    public void deactivate(int customerId) throws SQLException {
        String sql = "UPDATE Accounts SET IsActive=0 "
                + "WHERE AccountID = (SELECT AccountID FROM Customers WHERE CustomerID=?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.executeUpdate();
        }
    }

    /** Restore: mark account active again */
    public void activate(int customerId) throws SQLException {
        String sql = "UPDATE Accounts SET IsActive=1 "
                + "WHERE AccountID = (SELECT AccountID FROM Customers WHERE CustomerID=?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.executeUpdate();
        }
    }
}
