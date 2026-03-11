package com.motofix.dao;

import com.motofix.controller.DBContext;
import com.motofix.model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBContext {

    public void create(int customerId, Integer vehicleId, Timestamp bookingDate, String note) throws SQLException {
        String sql = "INSERT INTO Bookings (CustomerID, VehicleID, BookingDate, Status, Note) VALUES (?, ?, ?, 'PENDING', ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            if (vehicleId == null) {
                stmt.setNull(2, Types.INTEGER);
            } else {
                stmt.setInt(2, vehicleId);
            }
            stmt.setTimestamp(3, bookingDate);
            stmt.setString(4, note);
            System.out.println("INSERT BOOKING: " + customerId + " - " + vehicleId + " - " + bookingDate);
            stmt.executeUpdate();
        }
    }

    public List<Booking> listAll() throws SQLException {
        String sql = "SELECT b.BookingID, a.firstName AS FullName, a.Username AS Phone, v.PlateNumber, b.BookingDate, b.Status, b.Note "
        + "FROM Bookings b "
        + "JOIN Accounts a ON b.CustomerID = a.AccountID "
        + "LEFT JOIN Vehicles v ON b.VehicleID = v.VehicleID "
        + "ORDER BY b.BookingDate DESC";
        List<Booking> items = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("BookingID"));
                b.setCustomerName(rs.getString("FullName"));
                b.setPhone(rs.getString("Phone"));
                b.setPlateNumber(rs.getString("PlateNumber"));
                b.setBookingDate(rs.getTimestamp("BookingDate"));
                b.setStatus(rs.getString("Status"));
                b.setNote(rs.getString("Note"));
                items.add(b);
            }
        }
        return items;
    }

    public void updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            stmt.executeUpdate();
        }
    }
}
