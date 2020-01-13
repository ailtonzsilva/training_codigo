'*************************************************************
'MSMQ constants

'Access modes
const MQ_RECEIVE_ACCESS		= 1
const MQ_SEND_ACCESS		= 2
const MQ_PEEK_ACCESS		= 32

'Sharing modes
const MQ_DENY_NONE			= 0
const MQ_DENY_RECEIVE_SHARE = 1

'Transaction Options
const MQ_NO_TRANSACTION		= 0
const MQ_MTS_TRANSACTION	= 1
const MQ_XA_TRANSACTION		= 2
const MQ_SINGLE_MESSAGE		= 3

'*************************************************************
'Queue Path
const QUEUE_PATH = ".\private$\Received_Doc_In"

'Input file name
const IN_FILE_NAME = "ItemList.xml"

'*************************************************************

dim qinfo, qSend, mSend, xmlDoc
dim sPath, sFile, sMesg

'*************************************************************
' Create the queue
'*************************************************************
set qinfo = CreateObject("MSMQ.MSMQQueueInfo")
qinfo.PathName = QUEUE_PATH 

'*************************************************************
' Open queue with SEND access. 
'*************************************************************
Set qSend = qinfo.Open(MQ_SEND_ACCESS, MQ_DENY_NONE)

'*************************************************************
' Put file into message.
'*************************************************************
sPath = WScript.ScriptFullName
sPath = Mid(sPath, 1, InStrRev(sPath, "\"))
sFile = sPath & IN_FILE_NAME

set xmlDoc = CreateObject("MSXML.DOMDocument")
xmlDoc.load sFile

set mSend = CreateObject("MSMQ.MSMQMessage")
mSend.Body = xmlDoc.xml
mSend.Label = "ItemList"
  
'*************************************************************
' Send message to queue.
'*************************************************************
mSend.Send qSend, MQ_SINGLE_MESSAGE
msgbox "File """ & IN_FILE_NAME & """ sent to queue """ & QUEUE_PATH & """", vbOKOnly, "Line Items Sample"

'*************************************************************
' Close queue.
'*************************************************************
qSend.Close
  