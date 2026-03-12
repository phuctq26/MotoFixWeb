package com.motofix.controller;

import com.motofix.dao.UserDAO;
import com.motofix.model.User;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomerController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/customer/update-profile".equals(path)) {
            handleUpdateProfile(request, response);
        } else if ("/customer/change-password".equals(path)) {
            handleChangePassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            userDAO.updateProfile(user.getUserId(), fullName, phone, address);

            // Refresh session user data
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);
            session.setAttribute("user", user);

            request.getSession().setAttribute("message", "Cập nhật thông tin thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");

        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass == null || !newPass.equals(confirmPass)) {
            request.getSession().setAttribute("error", "Mật khẩu mới không khớp!");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }

        try {
            // Verify old password
            // We need to fetch the fresh user data or check hash manually.
            // Better to re-authenticate or check hash if we have it.
            // In session we have 'user' which has 'passwordHash' (populated if we updated
            // the login logic to store it).
            // Let's rely on database check for security + concurrency.
            User freshUser = userDAO.findById(user.getUserId());

            if (!freshUser.getPasswordHash().equals(currentPass)) {
                request.getSession().setAttribute("error", "Mật khẩu hiện tại không đúng!");
                response.sendRedirect(request.getContextPath() + "/change-password");
                return;
            }

            // Update
            userDAO.changePassword(user.getUserId(), newPass);
            request.getSession().setAttribute("message", "Đổi mật khẩu thành công!");
            response.sendRedirect(request.getContextPath() + "/change-password");

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi đổi mật khẩu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/change-password");
        }
    }
}
