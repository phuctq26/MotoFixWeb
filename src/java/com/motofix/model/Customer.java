package com.motofix.model;


public class Customer {
    private int customerId;
    private int accountId;
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String address;
    private String avatarUrl;
    private boolean isActive = true;

    public String getFullName() {
        String l = lastName != null ? lastName.trim() : "";
        String f = firstName != null ? firstName.trim() : "";
        return (l + " " + f).trim();
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int v) {
        this.customerId = v;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int v) {
        this.accountId = v;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String v) {
        this.username = v;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String v) {
        this.firstName = v;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String v) {
        this.lastName = v;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String v) {
        this.email = v;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String v) {
        this.address = v;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String v) {
        this.avatarUrl = v;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean v) {
        this.isActive = v;
    }
}
