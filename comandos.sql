use BANK;


INSERT INTO CLIENT
    (Name,PhoneNumber)
VALUES
    ('Brayan', '8115191101');

SELECT *
from CLIENT;

UPDATE CLIENT SET EMAIL='brayan@gmail.com'
WHERE ID=2;

SELECT *
from Account;

SELECT *
from Bank_Transaction;
EXEC sp_rename 'Bank_Transaction.Balance', 'Amount', 'COLUMN';

INSERT INTO AccountType
    (Name)
VALUES
    ('Personal'),
    ('Nomina'),
    ('Ahorro');

INSERT INTO TransactionType
    (Name)
VALUES
    ('Deposito en efectivo'),
    ('Retiro en efectivo'),
    ('Deposito via transferencia'),
    ('Retiro via transferencia');

INSERT INTO Account
    (AccountType,ClientID,Balance)
VALUES
    (1, 1, 5000),
    (2, 1, 10000),
    (1, 2, 3000),
    (2, 2, 14000);

UPDATE Account SET ClientID=2
WHERE ID=4;


INSERT INTO Bank_Transaction
    (AccountID,TransactionType,Amount,ExternalAccount)
VALUES
    (1, 1, 100, NULL),
    (1, 3, 200, 123456),
    (3, 1, 100, NULL),
    (3, 3, 250, 454545);

SELECT a.ID, c.Name as ClientName, a.Balance, a.RegDate, acc.Name as AccountName
from Account a
    JOIN CLIENT c On a.ClientID=c.ID
    JOIN AccountType acc ON a.AccountType=acc.ID;

SELECT b.ID, c.Name AS ClientName, t.Name AS TypeOfTransaction, b.Amount, b.ExternalAccount
FROM Bank_Transaction b
    JOIN Account a ON b.AccountID=a.ID
    JOIN Client c ON a.ClientID=c.ID
    JOIN TransactionType t ON b.TransactionType=t.ID;

ALTER PROCEDURE SelectAccount
    @ClientID INT=NULL
AS
if(@ClientID IS NULL)
BEGIN
    SELECT a.ID, c.Name as ClientName, a.Balance, a.RegDate, acc.Name as AccountName
    from Account a
       LEFT  JOIN CLIENT c On a.ClientID=c.ID
        JOIN AccountType acc ON a.AccountType=acc.ID;
END
ELSE

BEGIN
 SELECT a.ID, c.Name as ClientName, a.Balance, a.RegDate, acc.Name as AccountName
    from Account a
    LEFT JOIN CLIENT c On a.ClientID=c.ID
    JOIN AccountType acc ON a.AccountType=acc.ID
    WHERE a.ClientID=@ClientID;
END


GO

EXEC SelectAccount @ClientID=1;









