
ALTER PROCEDURE InsertBankTransaction
    @AccountID INT,
    @TransactionType INT,
    @Amount DECIMAL (10,2),
    @ExternalAccount INT=NULL

AS
DECLARE @CurrentBalance DECIMAL(10,2),@NewBalance DECIMAL(10,2);
BEGIN TRANSACTION;
SET @CurrentBalance=(SELECT Balance
FROM Account
WHERE ID=@AccountID);

--obtener nuevo saldo
IF @TransactionType=2 OR @TransactionType=4
	--retiros
	SET @NewBalance=@CurrentBalance-@Amount;
ELSE
	--depositos
	SET @NewBalance=@CurrentBalance+@Amount;

UPDATE Account SET Balance=@NewBalance WHERE ID=@AccountID;

INSERT INTO Bank_Transaction
    (AccountID,TransactionType,Amount,ExternalAccount)
VALUES
    (@AccountID, @TransactionType, @Amount, @ExternalAccount);
IF @NewBalance>=0
    COMMIT TRANSACTION;
ELSE
    
    ROLLBACK TRANSACTION;
IF @NewBalance<0
    RAISERROR('No es posible realizar la operacion.El balance es negativo.', 16, 1);
    RETURN;

GO


EXEC SelectAccount;
select *from Bank_Transaction;

EXEC InsertBankTransaction @AccountID=1,@TransactionType=2,@Amount=12000;



ALTER PROCEDURE SelectClient
    @ClientID INT=NULL
AS
if(@ClientID IS NULL)

BEGIN

    SELECT *
    FROM CLIENT;
END

ELSE

BEGIN
    select *
    from CLIENT c
    where c.ID=@ClientID;
END
GO

exec SelectClient @ClientID=1;
exec SelectClient;

ALTER PROCEDURE InsertClient
    @Name VARCHAR(200),
    @PhoneNumber VARCHAR(40),
    @Email VARCHAR(50)=NULL
AS
IF EXISTS (SELECT 1
FROM CLIENT
WHERE EMAIL = @Email)
BEGIN
    RAISERROR('El correo electrónico ya esta registrado.', 16, 1);
    RETURN;
END
ELSE
BEGIN
    INSERT INTO CLIENT
        (Name,PhoneNumber,Email)
    VALUES
        (@Name, @PhoneNumber, @Email);

END
GO

select *
from CLIENT;
EXEC InsertClient @Name='Mike3',@PhoneNumber='8116178989',
@EMAIL='miguel67927@outlook.es';


