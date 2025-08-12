# Large transaction
CREATE TABLE Transaction_OTP (
    OTPID INT PRIMARY KEY AUTO_INCREMENT,
    TransactionID INT NOT NULL,
    CustomerID INT NOT NULL,
    OTPCode VARCHAR(6) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    ExpiryAt DATETIME NOT NULL,
    IsUsed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

#OTP Generation
DELIMITER $$
CREATE TRIGGER generate_otp_for_large_txn
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    DECLARE v_otp VARCHAR(6);
    DECLARE cust_id INT
    SELECT CustomerID INTO cust_id
    FROM Account
    WHERE AccountID = NEW.AccountID;
    IF NEW.Amount >= 50000 THEN
        SET v_otp = LPAD(FLOOR(RAND() * 900000) + 100000, 6, '0');
        INSERT INTO Transaction_OTP (TransactionID, CustomerID, OTPCode, ExpiryAt)
        VALUES (NEW.TransactionID, cust_id, v_otp, DATE_ADD(NOW(), INTERVAL 5 MINUTE));
    END IF;
END$$
DELIMITER ;

#Verification Of OTP
DELIMITER $$
CREATE PROCEDURE sp_VerifyTransactionOTP(IN p_TransactionID INT, IN p_OTP VARCHAR(6))
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM Transaction_OTP
    WHERE TransactionID = p_TransactionID
      AND OTPCode = p_OTP
      AND IsUsed = FALSE
      AND NOW() <= ExpiryAt;

    IF v_count > 0 THEN
	    UPDATE Transaction_OTP
        SET IsUsed = TRUE
        WHERE TransactionID = p_TransactionID AND OTPCode = p_OTP;

        SELECT 'OTP Verified. Transaction Approved.' AS Result;
    ELSE
        SELECT 'Invalid or Expired OTP. Transaction Rejected.' AS Result;
    END IF;
END$$
DELIMITER ;
