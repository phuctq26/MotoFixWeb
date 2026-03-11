package com.motofix.dao;

import com.motofix.controller.DBContext;
import com.motofix.model.Vehicle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO extends DBContext {

    public VehicleDAO() {
        super();
    }

    public VehicleDAO(Connection conn) {
        this.connection = conn;
    }

    // Tìm xe theo CustomerID + biển số
    public Integer findByOwnerAndPlate(int ownerId, String plateNumber) throws SQLException {

        String sql = "SELECT VehicleID FROM Vehicles WHERE CustomerID = ? AND PlateNumber = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, plateNumber);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("VehicleID");
                }
            }
        }

        return null;
    }

    // Tạo xe mới
    public int create(int ownerId, String plateNumber, String brand, String model) throws SQLException {

        String sql = "INSERT INTO Vehicles (CustomerID, PlateNumber, Brand, Model) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, plateNumber);
            stmt.setString(3, brand);
            stmt.setString(4, model);

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("Create vehicle failed");
    }

    // Lấy danh sách xe của 1 customer
    public List<Vehicle> listByOwner(int ownerId) throws SQLException {

        String sql = "SELECT VehicleID, CustomerID, PlateNumber, Brand, Model " +
                     "FROM Vehicles WHERE CustomerID = ? ORDER BY VehicleID DESC";

        List<Vehicle> vehicles = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    Vehicle v = new Vehicle();

                    v.setVehicleId(rs.getInt("VehicleID"));
                    v.setOwnerId(rs.getInt("CustomerID"));
                    v.setPlateNumber(rs.getString("PlateNumber"));
                    v.setBrand(rs.getString("Brand"));
                    v.setModel(rs.getString("Model"));

                    vehicles.add(v);
                }
            }
        }

        return vehicles;
    }
}