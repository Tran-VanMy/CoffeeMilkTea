// Path: src/main/java/Config/VietQRConfig.java
package Config;

public class VietQRConfig {
    // Điền thông tin nhận tiền của bạn
    // BANK_ID có thể dùng: "VietinBank" hoặc "ICB" hoặc BIN "970415" (theo VietQR quick link)
    public static final String BANK_ID = "VietinBank";

    // ⚠️ Điền số tài khoản thật
    public static final String ACCOUNT_NO = "0766796358"; // TODO: thay bằng STK thật

    public static final String ACCOUNT_NAME = "TRAN VAN MY";

    // template: compact2 (đẹp, có logo + thông tin) theo VietQR
    public static final String TEMPLATE = "compact2";
}
