/**************************************************************************************
Apex Class Name    : ExcelImportController
Version            : 1.0
Created Date       : July 21 2017
Function           : Apex Controller for Excel Import
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Aneesh B                  07/21/2017              Original Version
 *************************************************************************************/
public without sharing class ExcelImportController {
    /**
    Gets all templates defined in the library folder pointed by 'Label.Excel_Import_Standard_Templates_Library_Folder'
     */
    @AuraEnabled
    public static String getTemplates() {
        List<ContentWorkSpace> ContentWorkSpaces = SObjectSelector.getTemplateDocuments(Label.ExcelImportStandardTemplatesLibraryFolder);
        List<ContentDocument> files = new List<ContentDocument>();
        if (ContentWorkSpaces != null && ContentWorkSpaces.size() > 0) {
            for (ContentWorkSpace doc:ContentWorkSpaces) {
                if (doc.AttachedContentDocuments != null && doc.AttachedContentDocuments.size() > 0) {
                    for (AttachedContentDocument attDoc:doc.AttachedContentDocuments) {
                        files.add(attdoc.ContentDocument);
                    }
                }
            }
        }

        return JSON.serialize(files);
    }
}