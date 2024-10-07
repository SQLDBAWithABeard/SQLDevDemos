sqlcmd create mssql --accept-eula --cached --using https://aka.ms/AdventureWorksLT.bak
sqlcmd query "CREATE LOGIN dab WITH PASSWORD='PASSword01'; CREATE USER dab FOR LOGIN dab; ALTER ROLE db_owner ADD MEMBER dab;"  --database AdventureWorksLT


$User = "dab"
$PWord = ConvertTo-SecureString -String "PASSword01" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

$env:OPENAI_API_KEY = 'NOT A FAKE KEY HERE PLEASE'


Get-DbaDatabase -SqlInstance localhost -SqlCredential $cred -Database AdventureWorksLT | New-DbaiAssistant -Name gpt4o-mini_1  -Description on -Model gpt-4o-mini

$PSDefaultParameterValues =@{
    "Invoke-DbaiQuery:SqlInstance" = "localhost"
    "Invoke-DbaiQuery:SqlCredential" = $cred
    "Invoke-DbaiQuery:Database" = "AdventureWorksLT"
    "Invoke-DbaiQuery:AssistantName" = "gpt4o-mini_1"
    "Invoke-DbatoolsAI:AssistantName" = "gpt4o-mini_1"
}


Invoke-DbaiQuery  -Message "What questions can I ask about the database" -Verbose

dbai what questions can i ask about the database






# hmmm - it no worky - so

Invoke-DbatoolsAI -Message "Copy the AdventureWorks2022 database from sql1 to sql2 using the network share \\sql1\c$\temp"

#or

dtai Copy the SalesDB database from ServerA to ServerB using the network share \\NetworkPath



