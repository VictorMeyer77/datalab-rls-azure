CREATE TABLE dbo.fake_data (
	price DECIMAL,
	quantity INT,
	product_id INT,
	caisse VARCHAR(3),
);

INSERT INTO dbo.fake_data VALUES (12.8, 6, 112876, 'GCM');
INSERT INTO dbo.fake_data VALUES (1298.8, 1, 81929, 'GNE');
INSERT INTO dbo.fake_data VALUES (298.8, 2, 77666543, 'GCA');
INSERT INTO dbo.fake_data VALUES (100.8, 2, 6543, 'GCA');

CREATE USER GCM WITHOUT LOGIN
GO;
CREATE USER GCA WITHOUT LOGIN
GO;
CREATE USER GNE WITHOUT LOGIN
GO;
CREATE USER PVL WITHOUT LOGIN
GO;

GRANT SELECT ON dbo.fake_data TO GCM;
GRANT SELECT ON dbo.fake_data TO GCA;
GRANT SELECT ON dbo.fake_data TO GNE;
GRANT SELECT ON dbo.fake_data TO PVL;
GO;


EXECUTE AS USER = 'GCM';
SELECT * FROM dbo.fake_data;
REVERT;

CREATE SCHEMA Security;
GO;

CREATE FUNCTION Security.fn_securitypredicate(@Caisse AS nvarchar(100))
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result
WHERE @Caisse = USER_NAME() ;
GO;

CREATE SECURITY POLICY FakeFilter
ADD FILTER PREDICATE Security.fn_securitypredicate(caisse)
ON dbo.fake_data
WITH (STATE = ON);
GO;

EXECUTE AS USER = 'GCA';
SELECT * FROM dbo.fake_data;
REVERT;