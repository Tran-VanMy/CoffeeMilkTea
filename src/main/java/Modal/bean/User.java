package Modal.bean;
import java.util.Date;

public class User {
    private long userId;
    private String fullName;
    private String phone;
    private String email;
    private String username;
    private String passwordHash;
    private String role; // CUSTOMER | ADMIN
    private Date createdAt;
	public User() {
		super();
	}
	public User(long userId, String fullName, String phone, String email, String username, String passwordHash,
			String role, Date createdAt) {
		super();
		this.userId = userId;
		this.fullName = fullName;
		this.phone = phone;
		this.email = email;
		this.username = username;
		this.passwordHash = passwordHash;
		this.role = role;
		this.createdAt = createdAt;
	}
	
	public User(long userId, String fullName, String phone, String email, String username, String passwordHash,
			String role) {
		super();
		this.userId = userId;
		this.fullName = fullName;
		this.phone = phone;
		this.email = email;
		this.username = username;
		this.passwordHash = passwordHash;
		this.role = role;
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPasswordHash() {
		return passwordHash;
	}
	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public boolean isAdmin() {
		return "ADMIN".equalsIgnoreCase(role); 
	}
    
}
