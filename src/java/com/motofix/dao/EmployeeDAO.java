package com.motofix.dao;

import com.motofix.controller.DBContext;
import com.motofix.model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the Employees table.
 * Schema: EmployeeID, FullName, Phone, Position, Salary, HireDate, Status
 */
public class EmployeeDAO extends DBContext {

    private Employee map(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setEmployeeId(rs.getInt("EmployeeID"));
        e.setFullName(rs.getString("FullName"));
        e.setPhone(rs.getString("Phone"));
        e.setPosition(rs.getString("Position"));
        e.setSalary(rs.getLong("Salary"));
        Date hireDate = rs.getDate("HireDate");
        e.setHireDate(hireDate != null ? hireDate.toString() : "");
        e.setActive(rs.getBoolean("Status"));
        return e;
    }

    public List<Employee> listAll() throws SQLException {
        String sql = "SELECT EmployeeID, FullName, Phone, Position, Salary, HireDate, Status "
                   + "FROM Employees ORDER BY EmployeeID DESC";
        List<Employee> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public Employee findByPhone(String phone) throws SQLException {
        if (phone == null || phone.isEmpty()) return null;
        String sql = "SELECT EmployeeID, FullName, Phone, Position, Salary, HireDate, Status "
                   + "FROM Employees WHERE Phone = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, phone);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public void create(String fullName, String phone, String position,
                       long salary, String hireDate, boolean status) throws SQLException {
        String sql = "INSERT INTO Employees (FullName, Phone, Position, Salary, HireDate, Status) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullName != null ? fullName : "");
            st.setString(2, phone != null ? phone : "");
            st.setString(3, position);
            st.setLong(4, salary);
            setDateOrNow(st, 5, hireDate);
            st.setBoolean(6, status);
            st.executeUpdate();
        }
    }

    public void update(int id, String fullName, String phone, String position,
                       long salary, String hireDate, boolean status) throws SQLException {
        String sql = "UPDATE Employees SET FullName=?, Phone=?, Position=?, Salary=?, HireDate=?, Status=? "
                   + "WHERE EmployeeID=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullName != null ? fullName : "");
            st.setString(2, phone != null ? phone : "");
            st.setString(3, position);
            st.setLong(4, salary);
            setDateOrNull(st, 5, hireDate);
            st.setBoolean(6, status);
            st.setInt(7, id);
            st.executeUpdate();
        }
    }

    /** Soft delete: set Status = INACTIVE */
    public void deactivate(int id) throws SQLException {
        String sql = "UPDATE Employees SET Status=0 WHERE EmployeeID=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        }
    }

    // ── helpers ────────────────────────────────────────────────────────────────
    private void setDateOrNow(PreparedStatement st, int idx, String dateStr) throws SQLException {
        if (dateStr != null && !dateStr.isEmpty()) {
            st.setDate(idx, Date.valueOf(dateStr));
        } else {
            st.setDate(idx, new Date(System.currentTimeMillis()));
        }
    }

    private void setDateOrNull(PreparedStatement st, int idx, String dateStr) throws SQLException {
        if (dateStr != null && !dateStr.isEmpty()) {
            st.setDate(idx, Date.valueOf(dateStr));
        } else {
            st.setNull(idx, Types.DATE);
        }
    }
}
