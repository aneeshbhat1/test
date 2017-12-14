/**************************************************************************************
Apex Class Name    : TemplateSettingsSelector
Version            : 1.0
Created Date       : Dec 6 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arkadiusz Celej             06-Dec-2017            Original Version
*******************************************************************************/
public class TemplateSettingsSelector {

    public static List<TemplateSetting__c> getTemplateSettings(Set<String> markets, Set<String> programs, Set<String> languages){
        return [
                SELECT Name, AgeFromYears__c,
                        AgeToYears__c,
                        Letter__c, Label__c, Market__c, Program__c, Language__c
                FROM TemplateSetting__c
                WHERE
                Market__c IN :markets AND Program__c IN :programs AND Language__c IN :languages
        ];
    }
}