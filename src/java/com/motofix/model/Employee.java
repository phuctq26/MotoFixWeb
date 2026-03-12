package com.motofix.model;

public class Employee {
    private int employeeId;
    private String fullName; 
    private String phone; 
    private String position;
    private long salary;
    private String hireDate; 
    private boolean status = true; 

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int v) {
        this.employeeId = v;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String v) {
        this.fullName = v;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String v) {
        this.phone = v;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String v) {
        this.position = v;
    }

    public long getSalary() {
        return salary;
    }

    public void setSalary(long v) {
        this.salary = v;
    }

    public String getHireDate() {
        return hireDate;
    }

    public void setHireDate(String v) {
        this.hireDate = v;
    }

    public boolean isActive() {
        return status;
    }

    public void setActive(boolean v) {
        this.status = v;
    }
}
