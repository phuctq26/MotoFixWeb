package com.motofix.controller;

import com.motofix.dao.UserDAO;
import com.motofix.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import com.motofix.controller.DBContext;

public class UpdateProfileController extends HttpServlet {

    private UserDAO userDAO = new UserDAO(new DBContext().connection);

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {

            userDAO.updateProfile(user.getUserId(), fullName, phone, address);

            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);

            session.setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/customer/profile");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}