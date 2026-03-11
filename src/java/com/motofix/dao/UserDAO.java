package com.motofix.dao;

import com.motofix.controller.DBContext;
import com.motofix.model.User;
import java.sql.*;

public class UserDAO extends DBContext {
    
    

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT AccountID, Username, firstName, lastName, PasswordHash, Role, Email, IsActive "
                + "FROM Accounts WHERE Username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return mapAccount(rs);
            }
        }
        return null;
    }

    /** Legacy — kept for compatibility */
    public User findByPhone(String phone) throws SQLException {

    String sql = "SELECT AccountID, Username, firstName, lastName, PasswordHash, Role, Email, IsActive FROM Accounts WHERE Username = ?";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {

        stmt.setString(1, phone);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return mapAccount(rs);
        }
    }

    return null;
}

    public User findById(int userId) throws SQLException {
        String sql = "SELECT AccountID, Username, firstName, lastName, PasswordHash, Role, Email, IsActive "
                + "FROM Accounts WHERE AccountID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return mapAccount(rs);
            }
        }
        return null;
    }

    public int createCustomer(String fullName, String phone) throws SQLException {

    String sql = "INSERT INTO Accounts (Username, firstName, lastName, Email, PasswordHash, Role, IsActive) "
               + "VALUES (?, ?, '', '', ?, 'CUSTOMER', 1)";

    try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        stmt.setString(1, phone); // Username = phone
        stmt.setString(2, fullName);
        stmt.setString(3, com.motofix.util.PasswordUtil.hash(phone));

        stmt.executeUpdate();

        ResultSet rs = stmt.getGeneratedKeys();

        if (rs.next()) {
            return rs.getInt(1);
        }
    }

    throw new SQLException("Create customer failed");
}

    public int createCustomerWithPassword(String fullName, String phone, String password) throws SQLException {
    
    String sql = "INSERT INTO Accounts (Username, firstName, lastName, Email, PasswordHash, Role, IsActive) VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 1)";

    try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        stmt.setString(1, phone);      // Username dùng phone
        stmt.setString(2, fullName);   // firstName
        stmt.setString(3, "");         // lastName
        stmt.setString(4, "");
        stmt.setString(5, password);
        

        stmt.executeUpdate();

        ResultSet rs = stmt.getGeneratedKeys();

        if (rs.next()) {

        int accountId = rs.getInt(1);

        // Tạo record trong bảng Customers
        String sqlCustomer = "INSERT INTO Customers(AccountID) VALUES (?)";

        PreparedStatement stmt2 = connection.prepareStatement(sqlCustomer);

        stmt2.setInt(1, accountId);
        

        stmt2.executeUpdate();

        return accountId;
}
    }

    throw new SQLException("Create customer failed");
}

    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT AccountID, Username, firstName, lastName, PasswordHash, Role, Email, IsActive "
                + "FROM Accounts WHERE Username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("PasswordHash");
                    String inputHash = com.motofix.util.PasswordUtil.hash(password);

                    boolean valid = false;
                    if (storedHash.equals(inputHash)) {
                        valid = true;
                    }
                    // Legacy plain text check (Auto-migrate to SHA-256)
                    else if (storedHash.equals(password)) {
                        String updateSql = "UPDATE Accounts SET PasswordHash = ? WHERE AccountID = ?";
                        try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                            updateStmt.setString(1, inputHash);
                            updateStmt.setInt(2, rs.getInt("AccountID"));
                            updateStmt.executeUpdate();
                        }
                        valid = true;
                        storedHash = inputHash;
                    }

                    if (valid) {
                        User user = mapAccount(rs);
                        user.setPasswordHash(storedHash);
                        return user;
                    }
                }
            }
        }
        return null;
    }

    // Helper to map ResultSet from Accounts table to User
    private User mapAccount(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("AccountID"));
        String firstName = rs.getString("firstName");
        String lastName = rs.getString("lastName");
        String full = ((lastName != null ? lastName : "") + " " + (firstName != null ? firstName : "")).trim();
        user.setFullName(full);
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setRole(rs.getString("Role"));
        user.setActive(rs.getBoolean("IsActive"));
        try {
            user.setPhone(rs.getString("Username"));
        } catch (SQLException ignored) {
        }
        return user;
    }

    public java.util.List<User> listByRole(String role) throws SQLException {
        String sql = "SELECT UserID, FullName, Phone, Role, Address, Email FROM Users "
                + "WHERE Role = ? ORDER BY UserID DESC";
        java.util.List<User> list = new java.util.ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setPhone(rs.getString("Phone"));
                    user.setRole(rs.getString("Role"));
                    user.setAddress(rs.getString("Address"));
                    try {
                        user.setEmail(rs.getString("Email"));
                    } catch (SQLException ignored) {
                    }
                    list.add(user);
                }
            }
        }
        return list;
    }

    /**
     * Create customer with all fields: fullName, phone, hashed password, email,
     * address.
     */
    public void createCustomerFull(String fullName, String phone, String hashedPassword,
            String email, String address) throws SQLException {
        String sql = "INSERT INTO Accounts (FullName, Phone, PasswordHash, Role, Email, Address) "
                + "VALUES (?, ?, ?, 'CUSTOMER', ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, hashedPassword);
            stmt.setString(4, email != null ? email : "");
            stmt.setString(5, address != null ? address : "");
            stmt.executeUpdate();
        }
    }

    public void createStaff(String fullName, String phone, String password, String role) throws SQLException {
        String sql = "INSERT INTO Users (FullName, Phone, PasswordHash, Role) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, password);
            stmt.setString(4, role);
            stmt.executeUpdate();
        }
    }

    public void update(int userId, String fullName, String phone, String role, String address) throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, Phone = ?, Role = ?, Address = ? WHERE UserID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, role);
            stmt.setString(4, address);
            stmt.setInt(5, userId);
            stmt.executeUpdate();
        }
    }

    public void update(int userId, String fullName, String phone, String role, String address, String email)
            throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, Phone = ?, Role = ?, Address = ?, Email = ? WHERE UserID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, role);
            stmt.setString(4, address);
            stmt.setString(5, email);
            stmt.setInt(6, userId);
            stmt.executeUpdate();
        }
    }

    public void updateProfile(int userId, String fullName, String phone, String address) throws SQLException {

    String sql = "UPDATE Accounts SET firstName = ?, Username = ? WHERE AccountID = ?";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {

        stmt.setString(1, fullName);
        stmt.setString(2, phone);
        stmt.setInt(3, userId);

        stmt.executeUpdate();
    }
}

    public void changePassword(int userId, String newPasswordHash) throws SQLException {

    String sql = "UPDATE Accounts SET PasswordHash = ? WHERE AccountID = ?";

    try (PreparedStatement stmt = connection.prepareStatement(sql)) {

        stmt.setString(1, newPasswordHash);
        stmt.setInt(2, userId);

        stmt.executeUpdate();
    }
}
    
    

    /**
     * Hard-delete a customer and ALL related data in the correct FK order:
     * TicketItems → RepairTickets → Bookings → Vehicles → User
     */
    public void delete(int userId) throws SQLException {
        connection.setAutoCommit(false);
        try {
            exec("DELETE ti FROM TicketItems ti "
                    + "JOIN RepairTickets rt ON ti.TicketID = rt.TicketID "
                    + "WHERE rt.CustomerID = ?", userId);
            exec("DELETE FROM RepairTickets WHERE CustomerID = ?", userId);
            exec("DELETE FROM Bookings WHERE CustomerID = ?", userId);
            exec("DELETE FROM Vehicles WHERE OwnerID = ?", userId);
            exec("DELETE FROM Accounts WHERE UserID = ?", userId);
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }
    
    public UserDAO() {
    super();
}
    
    public UserDAO(Connection conn) {
    this.connection = conn;
}
    

    /** Helper: run a single-param int DELETE */
    private void exec(String sql, int param) throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, param);
            stmt.executeUpdate();
        }
    }
}
