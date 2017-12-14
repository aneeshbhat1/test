/**************************************************************************************
Apex Class Name    : ExcelImportControllertest
Version            : 1.0
Created Date       : July 21 2017
Function           : Test class for ExcelImportController
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Aneesh B                  08/02/2017              Original Version
 *************************************************************************************/
@IsTest(seealldata=true)
Public class ExcelImportControllertest {
    static testMethod void testTemplateForGroupMember() {
        test.starttest();
        Boolean leadTemplatePresent, oppTemplatePresent;       
        Group publicGroup=TestDataFactory.getRegularTypeGroupByLabel(Label.ExcelImportPublicGroupName);
        if(publicGroup != null){
            user groupMember = TestDataFactory.getGroupmemberbyGroup(publicGroup);
            system.runAs(groupMember ) {
                string files = ExcelImportController.getTemplates();
                List<ContentDocument> lstOfFiles = (List<ContentDocument>) JSON.deserialize(files, List<ContentDocument>.class);
                if(lstOfFiles != null) {
                    for (ContentDocument document:lstOfFiles) {
                        if (document.Title == 'Lead Template') {
                            leadTemplatePresent = true;
                        }
                        if (document.Title == 'Opportunity Template') {
                            oppTemplatePresent = true;
                        }
                    }
                }
            }
        }
        System.assert(leadTemplatePresent, 'Lead template is not present');
        System.assert(oppTemplatePresent, 'Opportunity template is not present');
        test.stoptest();
    }

    static testMethod void testTemplateForGroupNonmember() {
        test.starttest();       
            user nonExcelImportGroupMember = TestDataFactory.createAdminUser(true);
            if(nonExcelImportGroupMember !=null){            
            system.runAs(nonExcelImportGroupMember ) {
                string files = ExcelImportController.getTemplates();
                List<ContentDocument> lstOfFiles = (List<ContentDocument>) JSON.deserialize(files, List<ContentDocument>.class);
                System.assert(lstOfFiles.size() == 0, 'The files are accessible outside the group as well');
            }
        }
        test.stoptest();
    }
}