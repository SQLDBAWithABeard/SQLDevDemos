cd ../dab

dotnet tool install --global Microsoft.DataApiBuilder

dab --version

# need to set a user with a simple password because its easier!!

<#
sqlcmd

CREATE LOGIN dab WITH PASSWORD='PASSword01!'
GO
CREATE USER dab FOR LOGIN dab
GO
ALTER ROLE db_owner ADD MEMBER dab
GO
#>

cd dab

dab init --database-type "mssql" --host-mode "Development" --connection-string "Server=localhost,1433;User Id=mrrob;Database=AdventureWorksLT;Password=1dxz1q!Y$H@71rZ4m%X8D7B7&JE6#McKq!!HQy%6hG*$l&L0%3;TrustServerCertificate=True;Encrypt=True;"

dab start

http://localhost:5000
http://127.0.0.1:8080/

http://localhost:5000/api/Product/ProductID/757
http://127.0.0.1:8080/api/Product/ProductID/757

http://localhost:5000/swagger
http://127.0.0.1:8080/swagger

http://localhost:5000/graphql
http://127.0.0.1:8080/graphql