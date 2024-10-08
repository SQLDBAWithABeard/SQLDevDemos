# sqlcmd demo -

RUN IN CODESPACES ROB

# how to install go-sqlcmd

# choco install sqlcmd -y
# winget install sqlcmd -y

#Ubuntu
# Set up the prompt in bash
<#
GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"
PS1="${GREEN}Beard${RESET}> "
alias cls="clear"

#>

# In WSL you can do this to get the latest version of sqlcmd for ARM64 or AMD64 into the container
# cp /workspaces/SQLDevDemos/01-sqlcmd/AMD64/sqlcmd /usr/local/share/nvm/current/bin/sqlcmd
# cp /workspaces/SQLDevDemos/01-sqlcmd/ARM64/sqlcmd /usr/local/share/nvm/current/bin/sqlcmd

# chmod 777 /usr/local/share/nvm/current/bin/sqlcmd

# docker pull mcr.microsoft.com/mssql/server:latest

sqlcmd --version

# As with all things, you can get help with sqlcmd by using the --help flag

sqlcmd --help

# What about if we wanted to create a container with a user database from  a user database backup?

sqlcmd create mssql --accept-eula --cached --using https://aka.ms/AdventureWorksLT.bak

sqlcmd query "SELECT DB_NAME() as [Current Database]"
sqlcmd query "SELECT SCHEMA_NAME(t.schema_id) AS schema_name, t.name AS table_name FROM sys.tables t" --database AdventureWorksLT

sqlcmd query "CREATE LOGIN dab WITH PASSWORD='PASSword01'; CREATE USER dab FOR LOGIN dab; ALTER ROLE db_owner ADD MEMBER dab;"  --database AdventureWorksLT










# Change the port protocol to HTTP and the visibility to private to autoforward with a 127.0.0.1

# Want to see the passwords and connect in Azure Data Studio?
sqlcmd config view --raw


























<#

# In the Dev Container
sudo apt update

# so that we can add the add-repo command
sudo apt install software-properties-common -y

curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/debian/11/prod.list)" -y


sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/22.04/prod.list)"

sudo apt install sqlcmd

wget -qO- your_link_here | tar xvz -C
wget -qO-  https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-arm64.tar.bz2 | sudo tar -jxf /usr/local/share/nvm/current/bin/sqlcmd

curl -o /usr/local/share/nvm/current/bin/sqlcmd-linux-arm64.tar.bz2 https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-arm64.tar.bz2

curl -o /usr/local/share/nvm/current/bin/sqlcmd-linux-amd64.tar.bz2 https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-amd64.tar.bz2

tar -xvjf /usr/local/share/nvm/current/bin/sqlcmd-linux-amd64.tar.bz2

tar -jxf /usr/local/share/nvm/current/bin/sqlcmd-linux-amd64.tar.bz2 --directory /path/to/directory


docker cp /mnt/s/sqlcmd-linux-arm64/sqlcmd 6696ef911fe1:/usr/local/share/nvm/current/bin/
cp /workspaces/SQLDevDemos/01-sqlcmd/AMD64/sqlcmd /usr/local/share/nvm/current/bin/sqlcmd
cp /workspaces/SQLDevDemos/01-sqlcmd/ARM64/sqlcmd /usr/local/share/nvm/current/bin/sqlcmd

chmod 777 /usr/local/share/nvm/current/bin/sqlcmd


curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc


# curl -o /etc/yum.repos.d/packages-microsoft-com-prod.repo https://packages.microsoft.com/config/fedora/32/prod.repo
# yum install sqlcmd

#>


<#
# you can still run the old version of sqlcmd

# laptop
Push-Location 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\'
#desktop
Push-Location 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\'

.\sqlcmd.exe -?

Pop-Location

# the new version still has the original flags, including the help ;-)

sqlcmd -?
sqlcmd --help

# if you want to create a new sql container, you can use any of the following versions

sqlcmd create mssql get-tags

# lets create a new sql container
# I am using cached to save redownloading the image
# I am using verbosity 4 to show ALL of the output

sqlcmd create mssql --accept-eula --cached --verbosity 4

# It even tells you what you can do next

# So lets take a look at the contexts (think kubectl contexts)

sqlcmd config view

# Want to see the passwords ?
sqlcmd config view --raw

# Want to get the connection strings?
sqlcmd config connection-strings

# then you can create a cred object
$connectionstrings = sqlcmd config connection-strings

$passwordstring = (($connectionstrings -split 'Password=')[1] -split '"')[0]

#just to check
$passwordstring

# create a credential object
[pscredential]$cred = New-Object System.Management.Automation.PSCredential ('mrrob',( $passwordstring|ConvertTo-SecureString -AsPlainText -Force))

# and then use it to connect to the database old skool :-)

sqlcmd -U mrrob -P $passwordstring -Q "SELECT Name From sys.databases"
sqlcmd -U mrrob -P $passwordstring -Q "SELECT schema,Name From sys.tables"

# but you dont need it - You can do it straight from the
sqlcmd --query "SELECT Name From sys.databases"

# Of course, I am going to show it in dbatools!!

$sqlcmd1 = Connect-DbaInstance -SqlInstance '127.0.0.1,1433'  -SqlCredential $cred

# Just so I can quickly talk about dbatools v2 and the trust cert
Set-DbatoolsConfig -Name sql.connection.trustcert -Value $true

Invoke-DbaQuery -SqlInstance $sqlcmd1 -Query "SELECT Name From sys.databases"


# but we cna just use sqlcmd and create a database
sqlcmd query "CREATE DATABASE IDontCare"

# We can also use sqlcmd to open a database in Azure Data Studio

sqlcmd open ads

# just in case we get the weird password caching
$passwordstring | Set-Clipboard

# lets create another container, this time with a user database

sqlcmd create mssql --accept-eula --cached --user-database DasIstMirWurst

# notice we have a new context

# which databases do we have?

sqlcmd query "SELECT Name From sys.databases"

sqlcmd query --help

# run a query against the DasIstMirWurst database

sqlcmd query "SELECT DB_NAME() AS [Current Database]" --database tempdb

# run a query file against the DasIstMirWurst database

sqlcmd --input-file 'killswitchengage.sql' --database-name DasIstMirWurst

# what do we have?

sqlcmd query "SELECT Name FROM sys.tables" --database DasIstMirWurst

# the sort of things to make you go hmmmm

sqlcmd query "SELECT  COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'table holding data with a bad name'" --database DasIstMirWurst
sqlcmd --query "SELECT  COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'table holding data with a bad name'" --database-name DasIstMirWurst --format="vert"

# I can open an interactive session

sqlcmd

# and then list colour schemes
  <#
  :list color

  :setvar SQLCMDCOLORSCHEME emacs

  SELECT  COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'table holding data with a bad name'
  GO #>
<#
# so that was the container with the DasIstMirWurst database. What about the other one?

# we can switch contexts (like kubectl)

sqlcmd config use-context mssql

sqlcmd query "SELECT Name From sys.databases"

# we can delete the container (and the context)

sqlcmd delete

# ok we need to force !! Remove both contexts and containers

sqlcmd delete --force --yes
sqlcmd delete --force --yes

# What about if we wanted to create a container with a user database from  a user database backup?

sqlcmd create mssql --accept-eula --cached --using https://aka.ms/AdventureWorksLT.bak


# thats neat

sqlcmd query "SELECT Name From sys.databases"

# remove it
sqlcmd delete --force --yes

# We live in a modern world, my backup is in Azure Storage

sqlcmd create mssql --accept-eula  --cached --using 'https://beardsqlbaks1.blob.core.windows.net/backups/someonlinedeebeebackup.bak?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-05-20T20:17:02Z&st=2024-05-15T12:17:02Z&spr=https&sig=2qcGeIKGLCiD3zE1Z7nH8A%2BCAgPbhBY0xFqR7EX8Y2g%3D' --verbosity 5


# query it
sqlcmd query "SELECT DB_NAME()"

# We can also use sqlcmd to open a database in Azure Data Studio

sqlcmd open ads

# remove it
sqlcmd delete --force --yes


# what about Azure

<#
--authentication-method
Specifies the SQL authentication method to use to connect
to Azure SQL Database. One of: ActiveDirectoryDefault,
ActiveDirectoryIntegrated, ActiveDirectoryPassword,
ActiveDirectoryInteractive,
ActiveDirectoryManagedIdentity,
ActiveDirectoryServicePrincipal, SqlPassword

#>

<#
# Make sure that we are logged in to Azure
# This requires Azure CLI to be installed and logged in

az login
az account set --subscription '6d8f994c-9051-4cef-ba61-528bab27d213'

sqlcmd -S beardenergysrv.database.windows.net -d Strava --authentication-method ActiveDirectoryIntegrated --format="vert"

SELECT [name]
      ,[type]
      ,[distance]
      ,[moving_time]
      ,[total_elevation_gain]
      ,[start_date_local]
      ,[average_cadence]
      ,[average_watts]
      ,[average_heartrate]
  FROM [dbo].[activities]
WHERE id = 8287070797
GO

:setvar SQLCMDCOLORSCHEME doom-one2


# But this had been here all along :-)

sqlcmd -S beardenergysrv.database.windows.net -d Strava -G --format="vert"

# what about if we wanted to create a container from our own image ?
# and define the context name

sqlcmd create mssql --name dbachecks --hostname WilliamDurkin  --accept-eula --cached --context-name dbachecks1 --registry dbachecks --repo sqlinstance1 --tag v2.38.0  --verbosity 4

# CTRL + C now we have a custom user in this container so the context wont work

sqlcmd config view

# so we can create a new user in the config file. We have to set the password as an environment variable

$env:SQLCMD_PASSWORD='dbatools.IO'
sqlcmd config add-user --name sqladmin --username sqladmin --password-encryption dpapi

sqlcmd config view

# and then a new context with the new user

sqlcmd config add-context --help

sqlcmd config add-context --name dbachecks-sqladmin --endpoint dbachecks1 --user sqladmin

# and now we will be able to log into the container and run a query

sqlcmd config use-context dbachecks-sqladmin
sqlcmd query "SELECT Name From sys.databases"

# and even open it in Azure Data Studio

sqlcmd open ads

# clean up

sqlcmd deletey


# so this is a bit interesting but there is an issue opened. See sqlcmd is open-source and you can help to guide the direction of the project.
https://github.com/microsoft/go-sqlcmd/issues/372

sqlcmd config view

sqlcmd delete

sqlcmd delete-context dbachecks

sqlcmd config add-endpoint --name dbachecks1 --address localhost

sqlcmd config delete-user --name sqladmin








## new things

# cd C:\temp\sqlcmd319

$env:SQLCMD_ACCEPT_EULA='YES'

sqlcmd --help


# I want to restore a backup

./sqlcmd create mssql --cached --using https://aka.ms/AdventureWorksLT.bak

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes

# Lets see the new things

# restore from a file into an existing container
./sqlcmd create mssql --cached

# restore the file into it
./sqlcmd use https://aka.ms/AdventureWorksLT.bak

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes

# I dont have a file in an URL with a .bak extension

# restore from a file into an existing container
./sqlcmd create mssql --cached

# I want to restore some database backup into it
./sqlcmd use D:\SQLBackups\AdventureWorks2017.bak

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes


# I want to restore some database backup as that database name

# restore from a file into an existing container
./sqlcmd create mssql --cached

# restore a local file into it as a different name
./sqlcmd use D:\SQLBackups\AdventureWorks2017.bak,thatdatabasename

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes

# I am organised, can I do it all in one line please. Just restore when I create please

./sqlcmd create mssql --cached --use D:\SQLBackups\AdventureWorks2017.bak

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes

# I am organised, can I do it all in one line please.

./sqlcmd create mssql --cached --use D:\SQLBackups\AdventureWorks2017.bak,yetanotherdatabasenamejusttoshowyouican

# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes

# I am organised, AND LAZY, can I do it all in one line please.

./sqlcmd create mssql --cached --use D:\SQLBackups\AdventureWorks2017.bak,anevenlongerdatabasenametoseeifanyoneisreadingthissaybeard --open ads

# query it
./sqlcmd query "SELECT DB_NAME()"


# remove it
./sqlcmd delete --force --yes

# I dont have a .bak but I want to attach an mdf file please

./sqlcmd create mssql --cached --using C:\temp\backup\anotherdatabaseforwilliam.mdf,anotherdatabaseforwilliam

# query it
./sqlcmd query "SELECT DB_NAME()"
./sqlcmd query "SELECT name from sys.databases"

# remove it
./sqlcmd delete --force --yes

# We live in a modern world, my backup is in Azure Storage

./sqlcmd create mssql --cached --use 'https://beardsqlbaks1.blob.core.windows.net/backups/someonlinedeebeebackup.bak?sp=racwd&st=2023-09-12T15:31:05Z&se=2023-09-17T23:31:05Z&spr=https&sv=2022-11-02&sr=b&sig=FRda2aEhH6aBk2rNLmtQ4zcJbi8ykWHCWM4OaSGDlpQ%3D' --verbosity 5


# query it
./sqlcmd query "SELECT DB_NAME()"

# remove it
./sqlcmd delete --force --yes




GOOS=windows GOARCH=amd64 go build -o ../sqlcmd.exe -ldflags="-X main.version=1.7" ../cmd/modern

2019-latest

wget -O /var/opt/mssql/backup.bak 'https://beardsqlbaks1.blob.core.windows.net/backups/someonlinedeebeebackup.bak?sp=racw&st=2023-09-12T14:16:53Z&se=2023-10-03T22:16:53Z&sv=2022-11-02&sr=b&sig=hu1nLNRxs12YF1vbFL0K9%2FuWXEh5G4SaqCoYwc3PCDc%3D'
#>