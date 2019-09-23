EXEC sp_addlinkedserver
@server='AZUREARODPE01',
@srvproduct='',  
@provider='sqlncli',
@datasrc='tcp:servidorcifpcesarmanrique.database.windows.net,1433',
@location='',
@provstr='',
@catalog='BAE001';

EXEC sp_addlinkedsrvlogin
@rmtsrvname = 'AZUREARODPE01',
@useself = 'false',
@rmtuser = 'alumnado_45',
@rmtpassword = '@A45B35C14';

EXEC sp_serveroption 'AZUREARODPE01', 'rpc out', true;

--Consulta para saber qué protocolo se está usando en la conexión abierta.
SELECT net_transport
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;