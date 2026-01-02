package Modal.bean;

import java.util.Date;

public class Voucher {
    private int voucherId;
    private String code;
    private String type; // PERCENT | AMOUNT | FREESHIP
    private long value;

    private long minSubtotal;
    private Long maxDiscount;
    private int quantity;

    private Date startAt;
    private Date endAt;
    private boolean active;
	public Voucher() {
		super();
	}
	public Voucher(int voucherId, String code, String type, long value, long minSubtotal, Long maxDiscount,
			int quantity, Date startAt, Date endAt, boolean active) {
		super();
		this.voucherId = voucherId;
		this.code = code;
		this.type = type;
		this.value = value;
		this.minSubtotal = minSubtotal;
		this.maxDiscount = maxDiscount;
		this.quantity = quantity;
		this.startAt = startAt;
		this.endAt = endAt;
		this.active = active;
	}
	public int getVoucherId() {
		return voucherId;
	}
	public void setVoucherId(int voucherId) {
		this.voucherId = voucherId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public long getValue() {
		return value;
	}
	public void setValue(long value) {
		this.value = value;
	}
	public long getMinSubtotal() {
		return minSubtotal;
	}
	public void setMinSubtotal(long minSubtotal) {
		this.minSubtotal = minSubtotal;
	}
	public Long getMaxDiscount() {
		return maxDiscount;
	}
	public void setMaxDiscount(Long maxDiscount) {
		this.maxDiscount = maxDiscount;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public Date getStartAt() {
		return startAt;
	}
	public void setStartAt(Date startAt) {
		this.startAt = startAt;
	}
	public Date getEndAt() {
		return endAt;
	}
	public void setEndAt(Date endAt) {
		this.endAt = endAt;
	}
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
    
    
}
