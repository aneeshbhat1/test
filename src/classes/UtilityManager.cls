public class UtilityManager 
{
    private static List<String> debugStackTrace = new List<String>();

public static void Log(string LogMessage)   
 {
     try
     {
     	//LogFile(LogMessage);
        LogSystem(LogMessage);
     }
     catch(Exception ex)
     {
         system.debug('UtilityManager-Excetion while printing debugs.');
     }
 }
    private static void LogSystem(string LogMessage)
    {
        System.debug(LogMessage);
    }
    private static void LogFile2(string LogMessage) {
        debugStackTrace.add(userinfo.getuserid()+' :--'+String.valueOf(datetime.now()) +': ' +LogMessage+'\n');
        if(debugStackTrace.size() >1000) {
            writeLog(string.join(debugStackTrace,','));
            debugStackTrace.clear();
        }
    }
    private static void writeLog(string LogMessage)
    {
        List<Document> docs=[select Body from Document where Name='DupeCheckCustomLog'];
        if (docs.size()>0 && docs[0]!=null)
        {   Document d=docs[0];

            d.Body= Blob.valueOf(d.Body.toString() + '\r'+ LogMessage);
            update d;
        }
        else
        {

            Document d = new Document();
            d.Name = 'DupeCheckCustomLog';
            String myContent = LogMessage;
            d.Body = Blob.valueOf(myContent);
            d.ContentType = 'text/plain';
            d.Type = 'text';
            d.FolderId= '00l9E000000M6nUQAS';
            insert d;
        }
    }

    private static void LogFile(string LogMessage)
    {
        LogMessage=String.valueOf(datetime.now()) +': ' +  LogMessage;
     	List<Document> docs=[select Body from Document where Name='DupeCheckCustomLog'];
     	if (docs.size()>0 && docs[0]!=null)
     	{   Document d=docs[0];
         
         	d.Body= Blob.valueOf(d.Body.toString() + '\r'+ LogMessage); 
         	update d;
     	}
     	else
     	{
         
     		Document d = new Document(); 
     		d.Name = 'DupeCheckCustomLog';
     		String myContent = LogMessage; 
     		d.Body = Blob.valueOf(myContent); 
     		d.ContentType = 'text/plain';
	 		d.Type = 'text';
        	d.FolderId= '00l9E000000M6nUQAS';
     		insert d;
     	}
    }
    
    public static Boolean IsNumeric(string str)
    {
        Pattern isnumber = Pattern.Compile('^[0-9]+$');
		Matcher postalMatch = isnumber.matcher(str);
        if (postalMatch.matches())
        {
            return true;
        }
        else
        {
           	return false;
        }        
    }

}