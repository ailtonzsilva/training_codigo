 
    Set objLocator = CreateObject("WbemScripting.SWbemLocator")
    Set objServices = objLocator.ConnectServer(, "root/MicrosoftBizTalkServer")
    'On Error Resume Next
    Set objBTSRecvSvc = objServices.Get("MicrosoftBizTalkServer_ReceiveFunction")
    Set objBTSRecvSvcInstance = objBTSRecvSvc.SpawnInstance_
 
    objBTSRecvSvcInstance.name = "DemoFileReceiveFunction"
    objBTSRecvSvcInstance.groupname = "BizTalk Server Group"
    objBTSRecvSvcInstance.FilenameMask = "*.xml"
    objBTSRecvSvcInstance.ProcessingServer = "rcanand"
    objBTSRecvSvcInstance.ProtocolType = 1'ADMIN_PROTOCOL_TYPE_FILE
    objBTSRecvSvcInstance.PollingLocation = "C:\SDKDemo\ReceiveLocation"
    
    
    objBTSRecvSvcInstance.ChannelName = "DemoChannel"
    objBTSRecvSvcInstance.Put_ (2)'wbemChangeFlagCreateOnly
    