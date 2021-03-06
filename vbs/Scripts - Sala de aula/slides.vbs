option explicit

REM SiteCreate include file

REM ###########################################################################
REM Configure this section to match your installation
REM

REM const g_sSQLPath = "d:\mssql7\binn"

REM
REM End Configuration section
REM ###########################################################################


Dim g_objSiteCfg, g_objGrpCfg, g_sMasterDSN

const sAppDefaultConfigName = "App Default Config"


REM
REM Aside from the parameters below, the caller should set the appcfg_i_*
REM family of constants that determine site options
REM

Sub CreateSite(sSiteName, sSiteDescription, sBizDeskName, nAuthFlags)

    Dim WshShell, wshSysEnv, wshNetwork
	Dim wbSite,webfolder,webFile,strIIS
	strIIS = "IIS://localhost/w3svc/1/ROOT/"
    Set WshShell = Wscript.CreateObject("Wscript.Shell")
    Set WshSysEnv = WshShell.Environment("SYSTEM")
    Set WshNetwork = Wscript.CreateObject("Wscript.Network")

    Dim BinPath, sComputerName
    BinPath = WshSysEnv("COMMERCE_SERVER_ROOT")
    sComputerName = WshNetwork.ComputerName

    Rem Set up DSN's
    Dim sCatalogDSN, sCampaignDSN, sTransactionsDSN, sTransactionConfigDSN
    Dim sBizDataDSN, sDataWarehouseDSN 
    Dim sSQLComputerName
    sSQLComputerName = sComputerName
    g_sMasterDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=master;Data Source=" + sSQLComputerName + ";"
    sCatalogDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_commerce;Data Source=" + sSQLComputerName + ";"
    sCampaignDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_commerce;Data Source=" + sSQLComputerName + ";"
    sTransactionsDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_commerce;Data Source=" + sSQLComputerName + ";"
    sTransactionConfigDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_commerce;Data Source=" + sSQLComputerName + ";"
    sBizDataDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_commerce;Data Source=" + sSQLComputerName + ";"
    sDataWarehouseDSN = "Provider=SQLOLEDB;Persist Security Info=False;User ID=sa;Password=;Initial Catalog=" & sSiteName & "_dw;Data Source=" + sSQLComputerName + ";"

    Rem Flag: whether or not to run SQL scripts
    const bRunScript = True

    ' These names won't change so you shouldn't change them
    const L_sCatalogName_Text = "Product Catalog"
    const L_sCampaignName_Text = "Campaigns"
    const L_sDataWarehouseName_Text = "Site Data Warehouse"
    const L_sDWReferenceResourceName_Text = "Global Data Warehouse"
    const L_sDWProcessingName_Text = "Data Warehouse Processing"
    const L_sTransactionsName_Text = "Transactions"
    const L_sTransactionConfigName_Text = "Transaction Config"
    const L_sAuthManagerSiteName_Text = "Site CS Authentication"
    const L_sBDSReferenceResourceName_Text = "Biz Data Service"
    const L_sDirectMailSiteName_Text = "Direct Mail"
    Dim sDirectMailGroupName, sPredictorGroupName
	const L_sDirectMailOn_Text = "Direct Mail on "
	const L_sPredictor_Text = "Predictor on "
    sDirectMailGroupName = L_sDirectMailOn_Text + sComputerName
    sPredictorGroupName = L_sPredictor_Text + sComputerName
    const sPredictorReferenceResourceName = "Predictor"
    const sBizDataImportFile = ""
    'const sUpmDtsTaskInfo = "UPM Dts Task Information"

    ' Parse connection strings for data to execute scripts
    Dim ParsedDSN, sCatalogDatabaseName, sCatalogDatabaseUser, sCatalogDatabasePwd, sCatalogServer
    ParsedDSN = Split(sCatalogDSN, ";")
    sCatalogDatabaseName = FindItem("Initial Catalog", ParsedDSN)
    sCatalogDatabaseUser = FindItem("User ID", ParsedDSN)
    sCatalogDatabasePwd = FindItem("Password", ParsedDSN)
    sCatalogServer = FindItem("Data Source", ParsedDSN)

    Dim sCampaignDatabaseName, sCampaignDatabaseUser,  sCampaignDatabasePwd, sCampaignServer
    ParsedDSN = Split(sCampaignDSN, ";")
    sCampaignDatabaseName = FindItem("Initial Catalog", ParsedDSN)
    sCampaignDatabaseUser = FindItem("User ID", ParsedDSN)
    sCampaignDatabasePwd = FindItem("Password", ParsedDSN)
    sCampaignServer = FindItem("Data Source", ParsedDSN)

    Dim sTransactionsDatabaseName, sTransactionsDatabaseUser, sTransactionsDatabasePwd, sTransactionsServer 
    ParsedDSN = Split(sTransactionsDSN, ";")
    sTransactionsDatabaseName = FindItem("Initial Catalog", ParsedDSN)
    sTransactionsDatabaseUser = FindItem("User ID", ParsedDSN)
    sTransactionsDatabasePwd = FindItem("Password", ParsedDSN)
    sTransactionsServer = FindItem("Data Source", ParsedDSN)

    Dim sTransactionConfigDatabaseName, sTransactionConfigDatabaseUser, sTransactionConfigDatabasePwd, sTransactionConfigServer 
    ParsedDSN = Split(sTransactionConfigDSN, ";")
    sTransactionConfigDatabaseName = FindItem("Initial Catalog", ParsedDSN)
    sTransactionConfigDatabaseUser = FindItem("User ID", ParsedDSN)
    sTransactionConfigDatabasePwd = FindItem("Password", ParsedDSN)
    sTransactionConfigServer = FindItem("Data Source", ParsedDSN)

    ' Create the databases
    Call CreateDatabases

    ' Create a group admin object
    Set g_objGrpCfg = CreateObject("Commerce.GlobalConfig")
    g_objGrpCfg.Initialize

    ' Create a site in the group & add a service to it
    call CreateSiteConfig

    ' Set up the Site description
    g_objSiteCfg.Fields("s_Description").Value = sSiteDescription
    g_objSiteCfg.SaveConfig

    ' Set up the App Default Config resource
    call SetupAppDefaultConfigResource(g_objSiteCfg, sSiteName)

    ' Set up the catalog resource
    g_objSiteCfg.CreateComponentConfig L_sCatalogName_Text, "MSCS_Catalog"
    'const L_sCatalogDescription_Text =  "Catalog of products offered"
    'g_objSiteCfg.Fields(L_sCatalogName_Text).Value.Fields("s_Description") = L_sCatalogDescription_Text
    g_objSiteCfg.Fields(L_sCatalogName_Text).Value.Fields("s_ProgidPUP") = "Commerce.CatalogPUP"
    g_objSiteCfg.Fields(L_sCatalogName_Text).Value.Fields("connstr_db_Catalog").Value = sCatalogDSN
    Dim sCmdLine
    sCmdLine = "osql /S " + sCatalogServer + " /U " + sCatalogDatabaseUser + " /P " + sCatalogDatabasePwd + " /d " + sCatalogDatabaseName + " /i CatalogCreate.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    g_objSiteCfg.SaveConfig

    ' Set up the campaign resource
    g_objSiteCfg.CreateComponentConfig L_sCampaignName_Text, "MSCS_Campaigns"
    'const L_sCampaignDescription_Text =  "Campaign Management system"
    'g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("s_Description") = L_sCampaignDescription_Text
    g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("s_ProgidPUP") = "Commerce.GenericPup"
    g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("connstr_db_Campaigns").Value = sCampaignDSN
    sCmdLine = "osql /S " + sCampaignServer + " /U " + sCampaignDatabaseUser + " /P " + sCampaignDatabasePwd + " /d " + sCampaignDatabaseName + " /i schema.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sCampaignServer + " /U " + sCampaignDatabaseUser + " /P " + sCampaignDatabasePwd + " /d " + sCampaignDatabaseName + " /i Backend.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sCampaignServer + " /U " + sCampaignDatabaseUser + " /P " + sCampaignDatabasePwd + " /d " + sCampaignDatabaseName + " /i CampaignManager.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sCampaignServer + " /U " + sCampaignDatabaseUser + " /P " + sCampaignDatabasePwd + " /d " + sCampaignDatabaseName + " /i DirectMail.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sCampaignServer + " /U " + sCampaignDatabaseUser + " /P " + sCampaignDatabasePwd + " /d " + sCampaignDatabaseName + " /i Marketing_cfg.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    ' Pup resources
    g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("s_PUPParam1") = "industry_code,customer,event_type,campaign,creative_type,creative_size,creative,creative_property,creative_property_value,campaign_item_types,campaign_item,order_discount,dm_item,ad_item,creative_type_xref,page_group,page_group_xref,target_group,target,target_group_xref,order_discount_expression,order_discount_misc,campaigns_version"
    g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("s_PUPParam2") = "Schema,Backend,CampaignManager,DirectMail"
    g_objSiteCfg.Fields(L_sCampaignName_Text).Value.Fields("s_PUPParam3") = "SchemaDrop"
    LoadResourceDBScript g_objSiteCfg, L_sCampaignName_Text, "schema.sql", "Schema"
    LoadResourceDBScript g_objSiteCfg, L_sCampaignName_Text, "backend.sql", "Backend"
    LoadResourceDBScript g_objSiteCfg, L_sCampaignName_Text, "CampaignManager.sql", "CampaignManager"
    LoadResourceDBScript g_objSiteCfg, L_sCampaignName_Text, "DirectMail.sql", "DirectMail"
    LoadResourceDBScript g_objSiteCfg, L_sCampaignName_Text, "schema_drop.sql", "SchemaDrop"
    g_objSiteCfg.SaveConfig


    ' Set up data warehouse site specific resource
    g_objSiteCfg.CreateComponentConfig L_sDataWarehouseName_Text, "MSCS_DataWarehouse_Site"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("CacheIpResolutionFor") = "30"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("TimeoutResAttempt") = "60"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("ResolutionBatchSize") = "500"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("i_AdjustREquestTimestampsTo") = 0
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("i_StartDayOfTheWeek") = 0
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("IdleTmeBeforeVisitEnds") = "30"
    ' g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("DomainPartsToParsere") = "0"
    ' g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("InsertMissingReferrers") = 1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("MultipleUsersUseTheSameName") = 1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("UseCookiesForInferences") = 1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("UseUPMCookiesForInferences") = 1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("ExcludeCrawlers") = 1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("i_QSSaveWithUri") = 0
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("TruncateTopDir") = 0
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("MinutesRecordsOverlap") = "30"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("IfOverlapDetected") = 3
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("WhenImportIsComplete") = 0
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("s_ProgidPUP") = "Commerce.DataWarehousePuP"
    
    Dim ValArray 
    Redim ValArray(1)
    ValArray(0)= "SITESERVER=ID"
    ValArray(1)= "SITESERVER=GUID"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("s_InfNames").Value = g_objSiteCfg.MakeStringFromArray(ValArray)
    Redim ValArray(4)
    ValArray(0)= "*.gif"
    ValArray(1)= "*.jpg"
    ValArray(2)= "*.jpeg"
    ValArray(3)= "*.cdf"
    ValArray(4)= "*.css"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("s_ExFileTypes").Value = g_objSiteCfg.MakeStringFromArray(ValArray)
    Redim ValArray(4)
    ValArray(0)= -1
    ValArray(1)= -1
    ValArray(2)= -1
    ValArray(3)= -1
    ValArray(4)= -1
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("i_FTypeAllAddressesFlag").Value = g_objSiteCfg.MakeStringFromArray(ValArray)
    Redim ValArray(4)
    ValArray(0)= "All"
    ValArray(1)= "All"
    ValArray(2)= "All"
    ValArray(3)= "All"
    ValArray(4)= "All"
    g_objSiteCfg.Fields(L_sDataWarehouseName_Text).Value.Fields("s_ExFTypesAppList").Value =  g_objSiteCfg.MakeStringFromArray(ValArray)
    g_objSiteCfg.SaveConfig

    ' Set up the transactions resource
    g_objSiteCfg.CreateComponentConfig L_sTransactionsName_Text, "MSCS_Transactions"
    'const L_sTransactionDescription_Text =  "Transaction system"
    'g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("s_Description") = L_sTransactionDescription_Text
    g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("s_ProgidPUP") = "Commerce.GenericPup"
    g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("connstr_db_Transactions").Value = sTransactionsDSN
    sCmdLine = "osql /S " + sTransactionsServer + " /U " + sTransactionsDatabaseUser + " /P " + sTransactionsDatabasePwd + " /d " + sTransactionsDatabaseName + " /i GenID.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sTransactionsServer + " /U " + sTransactionsDatabaseUser + " /P " + sTransactionsDatabasePwd + " /d " + sTransactionsDatabaseName + " /i Requisition.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine ="osql /S " + sTransactionsServer + " /U " + sTransactionsDatabaseUser + " /P " + sTransactionsDatabasePwd + " /d " + sTransactionsDatabaseName + " /i Approvals.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sTransactionsServer + " /U " + sTransactionsDatabaseUser + " /P " + sTransactionsDatabasePwd + " /d " + sTransactionsDatabaseName + " /i TransMetaSchema.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sTransactionsServer + " /U " + sTransactionsDatabaseUser + " /P " + sTransactionsDatabasePwd + " /d " + sTransactionsDatabaseName + " /i TransMetaData.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    ' Pup resources
    g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("s_PUPParam1") = "TransDimension,TransCategory"
    g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("s_PUPParam2") = "GenID,Requisition,Approvals,TransMetaSchema"
    'g_objSiteCfg.Fields(L_sTransactionsName_Text).Value.Fields("s_PUPParam3") = "TransSchemaDrop"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionsName_Text, "GenID.sql", "GenID"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionsName_Text, "Requisition.sql", "Requisition"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionsName_Text, "Approvals.sql", "Approvals"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionsName_Text, "TransMetaSchema.sql", "TransMetaSchema"
    'LoadResourceDBScript g_objSiteCfg, L_sTransactionsName_Text, "Trans_schema_drop.sql", "TransSchemaDrop"
    g_objSiteCfg.SaveConfig

    ' Set up the transaction config resource
    g_objSiteCfg.CreateComponentConfig L_sTransactionConfigName_Text, "MSCS_TransactionConfig"
    'const L_sTransactionConfigDescription_Text =  "Transaction Config system"
    'g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("s_Description") = L_sTransactionConfigDescription_Text
    g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("s_ProgidPUP") = "Commerce.GenericPup"
    g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("connstr_db_TransactionConfig").Value = sTransactionConfigDSN
    sCmdLine = "osql /S " + sTransactionConfigServer + " /U " + sTransactionConfigDatabaseUser + " /P " + sTransactionConfigDatabasePwd + " /d " + sTransactionConfigDatabaseName + " /i AppConfig.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sTransactionConfigServer + " /U " + sTransactionConfigDatabaseUser + " /P " + sTransactionConfigDatabasePwd + " /d " + sTransactionConfigDatabaseName + " /i TaxAndShipping.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    sCmdLine = "osql /S " + sTransactionConfigServer + " /U " + sTransactionConfigDatabaseUser + " /P " + sTransactionConfigDatabasePwd + " /d " + sTransactionConfigDatabaseName + " /i RegionData.sql"
    if bRunScript then WshShell.Run sCmdLine, 1, True
    ' Pup resources
    g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("s_PUPParam1") = "Decode,Region,RegionalTax,ShippingConfig,TableShippingRates"
    g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("s_PUPParam2") = "AppConfig,TaxAndShipping"
    'g_objSiteCfg.Fields(L_sTransactionConfigName_Text).Value.Fields("s_PUPParam3") = "TransSchemaDrop2"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionConfigName_Text, "AppConfig.sql", "AppConfig"
    LoadResourceDBScript g_objSiteCfg, L_sTransactionConfigName_Text, "TaxAndShipping.sql", "TaxAndShipping"
    'LoadResourceDBScript g_objSiteCfg, L_sTransactionConfigName_Text, "TransCfg_schema_drop.sql", "TransSchemaDrop2"
    g_objSiteCfg.SaveConfig

    ' Set up the direct mail resource
    g_objSiteCfg.AddRefToGroupComponent L_sDirectMailSiteName_Text, sDirectMailGroupName
    g_objSiteCfg.SaveConfig

    ' Set up the predictor resource
    g_objSiteCfg.AddRefToGroupComponent sPredictorReferenceResourceName, sPredictorGroupName
    g_objSiteCfg.SaveConfig

    ' Set up the Site Address  resource
    Dim website, sResourceName
    set webSite = GetObject("IIS://localhost/w3svc/1")
    sResourceName = sSiteName
    g_objSiteCfg.CreateComponentConfig sResourceName, "MSCS_Address"
    'const L_sURLInformationDescription_Text =  " URL information"
    'g_objSiteCfg.Fields(sResourceName).Value.Fields("s_Description") = sSiteName & L_sURLInformationDescription_Text
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_VirtualRootName") = LCase(sSiteName)
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_ProgidPUP") = "Commerce.AddressPuP"
    redim varWebServerMachine(0), varWebServerName(0), varWebServerInstance(0)
    varWebServerMachine(0) = sComputerName
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerMachine").Value = g_objSiteCfg.MakeStringFromArray(varWebServerMachine) 'Omar
    varWebServerName(0) = webSite.ServerComment
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerName").Value = g_objSiteCfg.MakeStringFromArray(varWebServerName) 'Omar
    varWebServerInstance(0) = 1
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerInstance").Value = g_objSiteCfg.MakeStringFromArray(varWebServerInstance) 'Omar

    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_NumberOfServers").Value = 1
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_CurrentServer").Value = 0
    g_objSiteCfg.SaveConfig


    ' Set up the BizDesk Address  resource
    set webSite = GetObject("IIS://localhost/w3svc/1")
    sResourceName = sBizDeskName
    g_objSiteCfg.CreateComponentConfig sResourceName, "MSCS_Address"
    'g_objSiteCfg.Fields(sResourceName).Value.Fields("s_Description") = sBizDeskName & L_sURLInformationDescription_Text
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_VirtualRootName") = LCase(sBizDeskName)
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_ProgidPUP") = "Commerce.AddressPuP"
    redim varWebServerMachine(0), varWebServerName(0), varWebServerInstance(0)
    varWebServerMachine(0) = sComputerName
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerMachine").Value = g_objSiteCfg.MakeStringFromArray(varWebServerMachine) 'Omar
    varWebServerName(0) = webSite.ServerComment
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerName").Value = g_objSiteCfg.MakeStringFromArray(varWebServerName) 'Omar
    varWebServerInstance(0) = 1
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_WebServerInstance").Value = g_objSiteCfg.MakeStringFromArray(varWebServerInstance) 'Omar

    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_NumberOfServers").Value = 1
    g_objSiteCfg.Fields(sResourceName).Value.Fields("s_CurrentServer").Value = 0
    g_objSiteCfg.SaveConfig


    ' ------------------------------------------
    ' Set up the biz data store resource

    Dim objPuP, szPath
    Dim sBDSGroupResourceName
    set objPuP = CreateObject("Commerce.UPMPuP")
    sBDSGroupResourceName = objPuP.CreateGroupResource(sSiteName, L_sBDSReferenceResourceName_Text, sBizDataDSN, szPath, True)
    g_objSiteCfg.AddRefToGroupComponent L_sBDSReferenceResourceName_Text, sBDSGroupResourceName
    g_objSiteCfg.SaveConfig
    set g_objGrpCfg = Nothing
    Set g_objGrpCfg = CreateObject("Commerce.GlobalConfig")
    g_objGrpCfg.Initialize
    g_objGrpCfg.Fields(sBDSGroupResourceName).Value.Fields("s_ProgidPUP").Value = "Commerce.UPMPuP"
    g_objGrpCfg.SaveConfig
    objPup.Import sSiteName, L_sBDSReferenceResourceName_Text, sBizDataImportFile, True
    set objPuP = Nothing
    set g_objGrpCfg = Nothing

    ' ------------------------------------------------
    ' Set up the Group Data Warehouse resource

    Dim sDWGroupResourceName
    set objPuP = CreateObject("Commerce.DataWarehousePuP")
    sDWGroupResourceName = objPuP.CreateGroupResource(sSiteName, L_sDWReferenceResourceName_Text, sDataWarehouseDSN, szPath, True)
    g_objSiteCfg.AddRefToGroupComponent L_sDWReferenceResourceName_Text, sDWGroupResourceName
    g_objSiteCfg.SaveConfig
    set g_objGrpCfg = Nothing
    Set g_objGrpCfg = CreateObject("Commerce.GlobalConfig")
    g_objGrpCfg.Initialize
    g_objGrpCfg.Fields(sDWGroupResourceName).Value.Fields("s_ProgidPUP") = "Commerce.DataWarehousePuP"
    g_objGrpCfg.SaveConfig
    set objPuP = Nothing
    set g_objGrpCfg = Nothing

    ' ------------------------------------------------
    ' Set up the Authentication Services resource

    Dim sAuthGroupResourceName
    set objPuP = CreateObject("Commerce.AuthPuP")
    sAuthGroupResourceName = objPuP.CreateGroupResource(sSiteName, L_sAuthManagerSiteName_Text, "", szPath,True)
    g_objSiteCfg.AddRefToGroupComponent L_sAuthManagerSiteName_Text, sAuthGroupResourceName 
    g_objSiteCfg.SaveConfig
    set g_objGrpCfg = Nothing
    Set g_objGrpCfg = CreateObject("Commerce.GlobalConfig")
    g_objGrpCfg.Initialize
    g_objGrpCfg.Fields(sAuthGroupResourceName).Value.Fields("s_ProgidPUP") = "Commerce.AuthPuP"
    g_objGrpCfg.SaveConfig
    objPup.Import sSiteName, L_sAuthManagerSiteName_Text, "", True
    set objPuP = Nothing
    set g_objGrpCfg = Nothing

    '-------------------------------------------------
    'Create a DefaultCatalogSchema
    Call CreateCatalog(sCatalogDSN)


    Dim vRoot, sWWWRootPath
    set vRoot = webSite.GetObject("IIsWebVirtualDir", "Root")
    sWWWRootPath = vRoot.Path + "\"

  On Error Resume Next	' Folder may already exist
    ' create dirs and default files for the site
    ' Create default.asp
    Dim fso, tf
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.CreateFolder(sWWWRootPath + LCase(sSiteName))
    if sSiteName = "BlankSite" then
        Set tf = fso.CreateTextFile(sWWWRootPath + sSiteName + "\default.asp", True)
        tf.WriteLine("Hello World, from " & sSiteName)
        tf.Close
    end if

    Set tf = fso.CreateTextFile(sWWWRootPath + sSiteName + "\csapp.ini", True)
    tf.WriteLine("SiteName=" + sSiteName)
    tf.WriteLine("AddressKeyName=" + sSiteName)
    tf.WriteLine("RelativeURL=" + sSiteName)
    tf.WriteLine("CreatedBy=Marc Whitman")
    tf.WriteLine("CreatedDate=")
    tf.WriteLine("Version=1.0")
    tf.Close

  On Error Goto 0

    ' Add the Metabase entries
    Dim vDir
    set vDir = vRoot.Create("IIsWebVirtualDir", LCase(sSiteName))

    vDir.AccessRead = True
    vDir.AccessExecute = True
    vDir.AppFriendlyName = sSiteName & " application"
    vDir.AppIsolated = 0
    vDir.AuthFlags = nAuthFlags
    vDir.AppCreate True
    vDir.Path = sWWWRootPath + sSiteName
    vDir.KeyType = "IIsWebVirtualDir"
    vDir.SetInfo


  On Error Resume Next	' Folder may already exist

    ' now create dirs and default files for the BizDesk
    ' Create default.asp
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.CreateFolder(sWWWRootPath + LCase(sBizDeskName))
    
    Set tf = fso.CreateTextFile(sWWWRootPath + sBizDeskName + "\csapp.ini", True)
    tf.WriteLine("SiteName=" + sSiteName)
    tf.WriteLine("AddressKeyName=" + sSiteName)
    tf.WriteLine("RelativeURL=" + sBizDeskName)
    tf.WriteLine("CreatedBy=Marc Whitman")
    tf.WriteLine("CreatedDate=")
    tf.WriteLine("Version=1.0")
    tf.Close

  On Error Goto 0

    ' Add the Metabase entries
    set vDir = vRoot.Create("IIsWebVirtualDir", LCase(sBizDeskName))

    vDir.AccessRead = True
    vDir.AccessExecute = True
    vDir.AppFriendlyName = sBizDeskName & ": BizDesk for " & sSiteName
    vDir.AppIsolated = 0
    vDir.AuthFlags = 4
    vDir.AppCreate True
    vDir.Path = sWWWRootPath + sBizDeskName
    vDir.KeyType = "IIsWebVirtualDir"
    vDir.SetInfo

    ' ------------------------------------------------
    ' Sync the Address resources for all the sites

    set objPuP = CreateObject("Commerce.AddressPuP")
    objPup.Import sSiteName, sSiteName, "", True
    objPup.Import sSiteName, sBizDeskName, "", True
    set objPuP = Nothing

	'Modify the IIS metabase properties for folders and files
	Set wbSite = GetObject(strIIS + sSiteName)
	Set webfolder = wbSite.Create("IIsWebDirectory", "pipeline")
	webfolder.AccessRead = False
	webfolder.AccessWrite = False
	webfolder.EnableDirBrowsing = False
	webfolder.ContentIndexed = False
	webfolder.AccessExecute = False
	webfolder.AccessScript = False
	webfolder.DontLog = True
	webfolder.SetInfo
    Set webfolder = Nothing

	Set wbSite = GetObject(strIIS + sSiteName)
    Set webfolder = wbSite.Create("IIsWebDirectory", "include")
    webfolder.AccessRead = False
	webfolder.AccessWrite = False
	webfolder.EnableDirBrowsing = False
	webfolder.ContentIndexed = False
	webfolder.AccessExecute = False
	webfolder.AccessScript = False
	webfolder.DontLog = True
	webfolder.SetInfo
    Set webfolder = Nothing


	Set wbSite = GetObject(strIIS + sSiteName)
    Set webfolder = wbSite.Create("IIsWebDirectory", "template")
    webfolder.AccessRead = False
	webfolder.AccessWrite = False
	webfolder.EnableDirBrowsing = False
	webfolder.ContentIndexed = False
	webfolder.AccessExecute = False
	webfolder.AccessScript = False
	webfolder.DontLog = True
	webfolder.SetInfo
    Set webfolder = Nothing


	set webFile = wbSite.Create("IIsWebFile", "csapp.ini")
    webFile.DontLog = True
    webFile.AccessRead = False
    webFile.AccessWrite = False
    webFile.SetInfo
    Set webFile = Nothing

    set webFile = wbSite.Create("IIsWebFile", "unpack.vbs")
    webFile.DontLog = True
    webFile.AccessRead = False
    webFile.AccessWrite = False
    webFile.AccessExecute = False
    webFile.AccessScript = False

    webFile.SetInfo
    Set webFile = Nothing

   set webFile = wbSite.Create("IIsWebFile", "poschema.xml")
    webFile.DontLog = True
    webFile.AccessRead = False
    webFile.AccessWrite = False
    webFile.SetInfo
    Set webFile = Nothing

    set webFile = wbSite.Create("IIsWebFile", "fileslst.txt")
    webFile.DontLog = True
    webFile.AccessRead = False
    webFile.AccessWrite = False
    webFile.SetInfo
    Set webFile = Nothing

    set webFile = wbSite.Create("IIsWebFile", "rc.xml")
    webFile.DontLog = True
    webFile.AccessRead = False
    webFile.AccessWrite = False
    webFile.SetInfo
    Set webFile = Nothing

    set webFile = wbSite.Create("IIsWebFile", "BDRefresh.asp")
    webFile.AuthBasic = FALSE
    webFile.AuthAnonymous = TRUE	
    webFile.AuthNTLM = FALSE
    webFile.SetInfo
    Set webFile = Nothing

    set webFile = wbSite.Create("IIsWebFile", "RefreshApp.asp")
    webFile.AuthBasic = FALSE
    webFile.AuthAnonymous = TRUE	
    webFile.AuthNTLM = FALSE
    webFile.SetInfo
    Set webFile = Nothing

End Sub

Function FindItem(sParmTag, sParms)
    Dim sParm
	for each sParm in sParms
		if LCase(sParmTag) = LCase(Left(sParm, len(sParmTag))) then
			FindItem = Right(sParm, len(sParm) - len(sParmTag) - 1)		
			exit for
		end if
	next
end function

Sub CreateSiteConfig()
	On Error Resume Next
	Set g_objSiteCfg = g_objGrpCfg.CreateSiteConfig(sSiteName)
	if Err.Number <> 0 then
		Set g_objSiteCfg = CreateObject("Commerce.SiteConfig")
		g_objSiteCfg.Initialize sSiteName
	end if
	Err.Clear
end Sub


Rem
Rem Loads a SQL script into the AdminDB pupdbscripts table using the SiteConfigAdmin object
Rem

Sub LoadResourceDBScript(oSiteCfgAdmin, sResource, sFilePath, sScriptName)
    Dim oFS, oFile, sScriptContents

    const ForReading = 1
    const TristateUseDefault = -2

    Set oFS = CreateObject("Scripting.FileSystemObject")
    Set oFile = oFS.OpenTextFile(sFilePath, ForReading, False, TristateUseDefault)
    sScriptContents = oFile.ReadAll()
    oFile.Close
    set oFile = nothing

    oSiteCfgAdmin.PutSQLScript sResource, sScriptName, sScriptContents

End Sub


sub CreateDatabases

    Dim objADO

    set objADO = CreateObject("ADODB.Connection")

    objADO.Open g_sMasterDSN

    On Error Resume Next
    objADO.Execute("Drop Database " & sSiteName & "_commerce")
    objADO.Execute("Drop Database " & sSiteName & "_dw")
    objADO.Execute("Create Database " & sSiteName & "_commerce")
    objADO.Execute("Create Database " & sSiteName & "_dw")

end sub


Sub SetupAppDefaultConfigResource(g_objSiteCfg, sSiteName)
	Dim rsAppDefaultConfig
	Dim objDataFunctions
	const L_sPageEncodingCharset_Text =  "Windows-1252"
        Set objDataFunctions = CreateObject("Commerce.DataFunctions")
	g_objSiteCfg.CreateComponentConfig sAppDefaultConfigName, "MSCS_AppConfigDefault"
	Set rsAppDefaultConfig = g_objSiteCfg.Fields(sAppDefaultConfigName).Value

	' Set the AppConfig fields initialized the same on both B2B and B2C
	rsAppDefaultConfig.Fields("s_SMTPServerName").Value = "TestSMTPServer"
	rsAppDefaultConfig.Fields("i_AddItemRedirectOptions").Value = 1 'REDIRECT_TO_PRODUCT
	rsAppDefaultConfig.Fields("s_AnonymousUserDefaultCatalogSet").Value = "{11111111-1111-1111-1111-111111111111}"
	rsAppDefaultConfig.Fields("s_AuthenticatedUserDefaultCatalogSet").Value = "{22222222-2222-2222-2222-222222222222}"
	rsAppDefaultConfig.Fields("i_AltCurrencyOptions").Value = 0 'ALTCURRENCY_DISPLAY_DISABLED
	rsAppDefaultConfig.Fields("f_AltCurrencyConversionRate").Value = 2
	rsAppDefaultConfig.Fields("i_AltCurrencyLocale").Value = objDataFunctions.Locale
	rsAppDefaultConfig.Fields("s_AltCurrencySymbol").Value = "EUR"
	rsAppDefaultConfig.Fields("i_CurrencyDisplayOrderOptions").Value = 0 'EURO_DISPLAY_BASE_CURRENCY_FIRST
	rsAppDefaultConfig.Fields("i_SiteDefaultLocale").Value = objDataFunctions.Locale
	rsAppDefaultConfig.Fields("i_BaseCurrencyLocale").Value = objDataFunctions.Locale
	rsAppDefaultConfig.Fields("s_BaseCurrencySymbol").Value = Mid(objDataFunctions.Money,1,1)
	rsAppDefaultConfig.Fields("s_BaseCurrencyCode").Value = "USD"
	rsAppDefaultConfig.Fields("s_AltCurrencyCode").Value = "EUR"
    rsAppDefaultConfig.Fields("s_PageEncodingCharset").Value = L_sPageEncodingCharset_Text
	rsAppDefaultConfig.Fields("i_SitePrivacyOptions").Value = 1 'PROFILE_ANONYMOUS_USER
	rsAppDefaultConfig.Fields("i_SiteTicketOptions").Value = 2 'PUT_TICKET_IN_COOKIE
	rsAppDefaultConfig.Fields("i_BizTalkOptions").Value = 0 'disabled
	rsAppDefaultConfig.Fields("S_BizTalkSubmittypeQueue").Value = "1"
	rsAppDefaultConfig.Fields("i_HostNameCorrectionOptions").Value = 1 'HOSTNAME_CORRECTION_ENABLED
	rsAppDefaultConfig.Fields("i_CookiePathCorrectionOptions").Value = 1 'APP_BASED_CORRECTION
	rsAppDefaultConfig.Fields("i_FormLoginTimeOut").Value = 60 'minutes
	rsAppDefaultConfig.Fields("S_WeightMeasure").Value = "lbs"


	'Properties currently not set
	'S_BizTalkSourceQualifierID
	'S_BizTalkSourceQualifierValue
	'S_BizTalkOrderDocType
	'S_BizTalkCatalogDocType
	'S_BizTalkSubmittypeQueue
	'S_BizTalkConnString
	'i_ShipToLevelOptions  '(not impl)
	'i_ShoppingListOptions  '(not impl)

	' Initialize the AppConfig options differently based on type of site
	' It is up to the caller to set the appcfg_i_* parameters
	rsAppDefaultConfig.Fields("i_AddressBookOptions").Value         = appcfg_i_AddressBookOptions
	rsAppDefaultConfig.Fields("i_AuctionsOptions").Value            = appcfg_i_AuctionsOptions
	rsAppDefaultConfig.Fields("i_FormLoginOptions").Value           = appcfg_i_FormLoginOptions
	rsAppDefaultConfig.Fields("i_SiteRegistrationOptions").Value    = appcfg_i_SiteRegistrationOptions
	rsAppDefaultConfig.Fields("i_PaymentOptions").Value             = appcfg_i_PaymentOptions
	rsAppDefaultConfig.Fields("i_BillingOptions").Value             = appcfg_i_BillingOptions
	rsAppDefaultConfig.Fields("i_DelegatedAdminOptions").Value      = appcfg_i_DelegatedAdminOptions

	g_objSiteCfg.SaveConfig
        Set objDataFunctions = Nothing

End Sub


'Create Default Catalog
Sub CreateCatalog(sCatalogDSN)
	
	Dim objCatalogMgr
	
	Set objCatalogMgr = CreateObject("Commerce.CatalogManager")

	objCatalogMgr.Initialize sCatalogDSN,1

	objCatalogMgr.ImportXML "defaultcatalogschema.xml",0

	Set objCatalogMgr = nothing

End Sub
