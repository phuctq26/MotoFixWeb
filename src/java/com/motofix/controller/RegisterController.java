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

public class RegisterController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        if (fullName == null || phone == null || password == null || confirm == null
                || fullName.trim().isEmpty() || phone.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            request.setAttribute("errorField", "phone");
            request.setAttribute("errorMessage", "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0.");
            request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
            return;
        }

        // tối thiểu 6 ký tự
        if (password.length() < 6) {
            request.setAttribute("errorField", "password");
            request.setAttribute("errorMessage", "Mật khẩu phải tối thiểu 6 ký tự.");
            request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("errorField", "confirm");
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
            return;
        }

        try {
            User existing = userDAO.findByPhone(phone);
            if (existing != null) {
                request.setAttribute("errorField", "phone");
                request.setAttribute("errorMessage", "Số điện thoại đã tồn tại. Vui lòng đăng nhập.");
                request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
                return;
            }
            int id = userDAO.createCustomerWithPassword(fullName, phone, password);
            User user = userDAO.findById(id);
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/customer/register.jsp").forward(request, response);
        }
    }
}
