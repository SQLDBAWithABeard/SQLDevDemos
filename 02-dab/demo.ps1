# RUN IN CODESPACES ROB

cd ../02-dab
cd 02-dab/

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

# lets create the data api builder

dab init --database-type "mssql" --host-mode "Development" --connection-string 'Server=127.0.0.1;User Id=dab;Database=AdventureWorksLT;Password="PASSword01!";TrustServerCertificate=True;Encrypt=True;'

# look at the new config file
code /workspaces/SQLDevDemos/02-dab/dab-config.json

# Now we can start the data api builder :-)

dab start

# and take a look at it

http://localhost:5000
http://127.0.0.1:8080/

http://localhost:5000/api/Product/ProductID/757
http://127.0.0.1:8080/api/Product/ProductID/757

# Hmm there are no entitities created.

# We could

# add them all ourselves individually

# but we have an existing database and maybe a lot of entities

# lets use Davide's magic T-SQL script of awesome!

code /workspaces/SQLDevDemos/02-dab/sql-to-dab-config.sql

# add the results to the correct place in the config file and restart dab

# Now look !!

http://localhost:5000/api/Product/ProductID/757
http://127.0.0.1:8080/api/Product/ProductID/757

http://localhost:5000/swagger
http://127.0.0.1:8080/swagger

http://localhost:5000/graphql
http://127.0.0.1:8080/graphql