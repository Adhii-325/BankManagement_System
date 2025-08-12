#Deposit Money
DELIMITER $$
CREATE PROCEDURE sp_DepositMoney(IN p_AccountID INT, IN p_Amount DECIMAL(15,2))
BEGIN
    INSERT INTO Transaction (AccountID, TransactionType, Amount)
    VALUES (p_AccountID, 'Deposit', p_Amount);
END$$
DELIMITER ;

# Withdraw Money
DELIMITER $$
CREATE PROCEDURE sp_WithdrawMoney(IN p_AccountID INT, IN p_Amount DECIMAL(15,2))
BEGIN
    INSERT INTO Transaction (AccountID, TransactionType, Amount)
    VALUES (p_AccountID, 'Withdrawal', p_Amount);
END$$
DELIMITER ;

#Transfer Of Money
DELIMITER $$
CREATE PROCEDURE sp_TransferMoney(
    IN p_FromAccount INT,
    IN p_ToAccount INT,
    IN p_Amount DECIMAL(15,2)
)
BEGIN
    START TRANSACTION;

    INSERT INTO Transaction (AccountID, TransactionType, Amount)
    VALUES (p_FromAccount, 'Withdrawal', p_Amount);

    INSERT INTO Transaction (AccountID, TransactionType, Amount)
    VALUES (p_ToAccount, 'Deposit', p_Amount);

    COMMIT;
END$$
DELIMITER ;

#Auto Update Balance
DELIMITER $$
CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    IF NEW.TransactionType = 'Deposit' THEN
        UPDATE Account
        SET Balance = Balance + NEW.Amount
        WHERE AccountID = NEW.AccountID;
    ELSEIF NEW.TransactionType = 'Withdrawal' THEN
        UPDATE Account
        SET Balance = Balance - NEW.Amount
        WHERE AccountID = NEW.AccountID;
    END IF;
END$$
DELIMITER ;

#Sms Trigger
CREATE TABLE SMS_Notifications (
    SMSID INT PRIMARY KEY AUTO_INCREMENT,
    PhoneNumber VARCHAR(15) NOT NULL,
    Message VARCHAR(255) NOT NULL,
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP
);


