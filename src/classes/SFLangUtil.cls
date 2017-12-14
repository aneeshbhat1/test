/**
 * Created by savita.b on 7/26/2017.
 */

public with sharing class SFLangUtil
{
    public static boolean isIntegrationUser()
    {
        String currentUser=UserInfo.getUsername();
        boolean isIntegrationUser=false;
        if(currentUser==Label.Integration_User)
        {
            isIntegrationUser=true;
        }
        return isIntegrationUser;
    }

    public static string[] splitString(string splitstringvalue,string splitchar)
    {
        return splitstringvalue.split('\\'+splitchar);
    }

    public static Date ConvertDateTimeTodate(DateTime inputDatetime)
    {
        return date.newinstance(inputDatetime.year(), inputDatetime.month(), inputDatetime.day());
    }

   public static Boolean getTriggerSettings(String ObjectName)  {
       Boolean isDisable = false;
        BypassTriggersValidation__c setupUser = BypassTriggersValidation__c.getInstance();
        if(setupUser != null &&  String.isBlank(setupUser.TriggerObject__c) 
           && setupUser.DisableTrigger__c!= null && setupUser.DisableTrigger__c== true)
        {
            System.debug('First Loop');
            isDisable= true;
        }
       else if(setupUser != null &&  setupUser.TriggerObject__c!= null && setupUser.TriggerObject__c.containsIgnoreCase(ObjectName)
                && setupUser.DisableTrigger__c!= null && setupUser.DisableTrigger__c== true)
            {
                 System.debug('Second Loop');
                 isDisable= true;
            }
              else {
                      isDisable=false;
                      }
                      system.debug('************* final trigger result'+isDisable);
              return isDisable;        
     }
}