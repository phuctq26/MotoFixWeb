package com.motofix.controller;

import com.motofix.dao.BookingDAO;
import com.motofix.dao.UserDAO;
import com.motofix.dao.VehicleDAO;
import com.motofix.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() {

        bookingDAO = new BookingDAO();

        userDAO = new UserDAO(bookingDAO.connection);

        vehicleDAO = new VehicleDAO(bookingDAO.connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) request.getSession().getAttribute("user");

        if (sessionUser != null) {

            try {

                request.setAttribute("vehicles",
                        vehicleDAO.listByOwner(sessionUser.getUserId()));

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/views/customer/booking.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("BOOKING POST RUNNING");

        User sessionUser = null;

        if (request.getSession(false) != null) {
            sessionUser = (User) request.getSession(false).getAttribute("user");
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        String plateNumber = request.getParameter("plateNumber");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");

        String date = request.getParameter("bookingDate");
        String time = request.getParameter("bookingTime");
        String note = request.getParameter("note");

        Connection conn = bookingDAO.connection;

        if (conn == null) {

            request.setAttribute("error", "Không kết nối được database.");

            request.getRequestDispatcher("/views/customer/booking.jsp")
                    .forward(request, response);

            return;
        }

        try {

            conn.setAutoCommit(false);

            try {

                int customerId;

                // ===== LẤY CUSTOMER =====
                if (sessionUser != null) {

                    customerId = sessionUser.getUserId();

                } else {

                    User user = userDAO.findByPhone(phone);

                    if (user == null) {
                        customerId = userDAO.createCustomer(fullName, phone);
                    } else {
                        customerId = user.getUserId();
                    }
                }

                Integer vehicleId = null;

                String vIdParam = request.getParameter("vehicleId");

                // ===== XE ĐÃ CÓ =====
                if (vIdParam != null && !vIdParam.isEmpty()) {

                    vehicleId = Integer.parseInt(vIdParam);

                }

                // ===== XE MỚI =====
                if (vehicleId == null && plateNumber != null && !plateNumber.trim().isEmpty()) {

                    vehicleId = vehicleDAO.findByOwnerAndPlate(customerId, plateNumber);

                    if (vehicleId == null) {

                        vehicleId = vehicleDAO.create(
                                customerId,
                                plateNumber,
                                brand == null ? "" : brand,
                                model == null ? "" : model
                        );
                    }
                }

                if (vehicleId == null) {
                    throw new Exception("Vehicle information missing");
                }

                // ===== DATE TIME =====
                LocalDate bookingDay = LocalDate.parse(date);

                LocalTime bookingTime = LocalTime.parse(
                        (time == null || time.isEmpty()) ? "09:00" : time
                );

                LocalDateTime bookingDateTime = LocalDateTime.of(bookingDay, bookingTime);

                Timestamp bookingDate = Timestamp.valueOf(bookingDateTime);

                // ===== DEBUG =====
                System.out.println("===== DEBUG BOOKING =====");
                System.out.println("customerId = " + customerId);
                System.out.println("vehicleId = " + vehicleId);
                System.out.println("bookingDate = " + bookingDate);
                System.out.println("note = " + note);

                // ===== CREATE BOOKING =====
                bookingDAO.create(customerId, vehicleId, bookingDate, note);

                conn.commit();

                request.setAttribute("success",
                        "Đặt lịch thành công! Chúng tôi sẽ liên hệ xác nhận.");

            } catch (Exception e) {

                conn.rollback();

                e.printStackTrace();

                request.setAttribute("error",
                        "Không thể đặt lịch. Vui lòng thử lại.");

            } finally {

                conn.setAutoCommit(true);

            }

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute("error", "Lỗi kết nối hệ thống.");
        }

        if (sessionUser != null) {

            try {

                request.setAttribute("vehicles",
                        vehicleDAO.listByOwner(sessionUser.getUserId()));

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/views/customer/booking.jsp")
                .forward(request, response);
    }
}