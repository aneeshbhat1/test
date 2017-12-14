/**
 * Created by shravan.boddula on 9/6/2017.
 */


public class DCObjectMerge {
    //lead to lead merge
    public static Lead leadToLeadFieldMerge(Lead sourceLead, Lead duplicateLead) {
        //1. first Name
        sourceLead.FirstName = valueLength(sourceLead.FirstName,duplicateLead.FirstName);
        //2. lastname
        sourceLead.LastName=valueLength(sourceLead.LastName,duplicateLead.LastName);
        //3. DOB
        sourceLead.DOB__c = calculateAge(sourceLead.DOB__c,duplicateLead.DOB__c);
        //4. Mobile Phone, Home phone, Oher phone
        sourceLead = phoneMerge(sourceLead,duplicateLead);
        //5. email merge
        sourceLead = emailMerge(sourceLead,duplicateLead);
        //6. address mergealeim
        sourceLead = addressMerge(sourceLead,duplicateLead);
        //7. program merge
        system.debug('********* source type'+DCBusinessFlow.sourceCustomerRequstType);
        system.debug('********* latest type'+DCBusinessFlow.latestCustomerRequsetType);
        //if(sourceLead.Program__c == 'MULTI' || programMerge(DCBusinessFlow.sourceCustomerRequstType,DCBusinessFlow.latestCustomerRequsetType)) {
        if((sourceLead.Program__c == Label.MULTI) || (duplicateLead.RequestType__c != 'CAM')) {
            sourceLead.Product__c = duplicateLead.Product__c;
            sourceLead.Program__c = duplicateLead.Program__c;
        }
        return sourceLead;
    }

    //Lead to account merge
    public static Account leadtoAccountFieldMerge(Account duplicateAccount, Lead sourceLead) {
        //1. first Name
        duplicateAccount.FirstName = valueLength(duplicateAccount.FirstName,sourceLead.FirstName);
        //2. lastname
        duplicateAccount.LastName = valueLength(duplicateAccount.LastName,sourceLead.LastName);
        //3. DOB
        duplicateAccount.DOB__c = calculateAge(duplicateAccount.DOB__c,sourceLead.DOB__c);
        //4. Mobile Phone, Home phone, other phone
        duplicateAccount = phoneLeadToAccountMerge(duplicateAccount,sourceLead);
        //5. email merge
        duplicateAccount = emailLeadToAccountMerge(duplicateAccount,sourceLead);
        //6. address merge
        duplicateAccount = addressLeadtoAccountMerge(duplicateAccount,sourceLead);
        system.debug('^^^^^^^^^^^^ final acocunt'+duplicateAccount);
        system.debug('duplicateAccount>>>>>'+duplicateAccount);

        return duplicateAccount;
    }

    //Lead to Opportuntiy
    public static void modifyOpportuntiy(Lead sourceLead, Opportunity opportunityRecord) {
        //1. stage update
        if(opportunityRecord.StageName == Label.ClosedLost) {
            // Always for revival
            //opportunityRecord.StageName = Label.Prospecting;
            opportunityRecord.StageName =OpportunitiesSelector.getOpportunityStageName(opportunityRecord);
            system.debug('>>>Previous Opp StageName'+opportunityRecord.StageName);
            opportunityRecord.CloseDate = System.today()+90;
            if(sourceLead.RequestType__c != 'CAM'){
                opportunityRecord.Product__c = sourceLead.Product__c;
                opportunityRecord.Program__c = sourceLead.Program__c;
            }
        }else{
            // this is to update the program for exiting opportunity but no closedlost
            system.debug('**** product'+sourceLead.Product__c);
            system.debug('**** program'+sourceLead.Program__c);
            if(programMerge(DCBusinessFlow.sourceCustomerRequstType,opportunityRecord.Program__c)) {
                opportunityRecord.Product__c = sourceLead.Product__c;
                opportunityRecord.Program__c = sourceLead.Program__c;
            }
        }
        SObjectUnitOfWork.modifyOpportunity(opportunityRecord);
    }

    public static void inActiveOpportunity(Opportunity opportunityRecord) {
        opportunityRecord.isActive__c = false;
        SObjectUnitOfWork.modifyOpportunity(opportunityRecord);
    }

    //return the longest string
    public static String valueLength(String oldValue,String newValue) {
        String temp = '';
        if((oldValue != null && oldValue.length() > 0) &&
                (newValue != null && newValue.length() > 0 )) {
            temp = oldValue.length() > newValue.length()?oldValue:newValue;
        }
        else if(oldValue == null) {
            temp = newValue;
        }
        else if(newValue == null) {
            temp = oldValue;
        }
        return temp;
    }
    //age calculation
    public static Date calculateAge(Date oldDate, Date newDate) {
        if(newDate != null) {
            return system.today().year() - newDate.year() > 50 ? oldDate : newDate;
        }
        return oldDate;
    }

    public static Boolean programMerge(String sourceLeadRequestType,String dulicateProgram) {
        Boolean isupdate= false;
        if(sourceLeadRequestType != null &&
                (sourceLeadRequestType == Label.Reservation || dulicateProgram == Label.MULTI)
               ) {
            isupdate = true;
        }
        return isupdate;
    }

    //mobile phone

    public static Lead phoneMerge(Lead extLead, Lead duplicateLead) {
        
        //Mobile Phone
        system.debug('My home phone>>>>>'+duplicateLead.Phone +extLead.phone);
        if(duplicateLead.MobilePhone != extLead.MobilePhone &&
                duplicateLead.MobilePhone != extLead.Phone &&
                duplicateLead.MobilePhone != extLead.OtherPhone__c &&
                duplicateLead.MobilePhone != NULL && duplicateLead.MobilePhone !='') {
            if(extLead.OtherPhone__c == NULL || extLead.OtherPhone__c =='') {
                extLead.OtherPhone__c = extLead.MobilePhone;
            }else if(extLead.Phone == NULL || extLead.Phone ==''){
                extLead.Phone = extLead.MobilePhone;
            }
            extLead.MobilePhone = duplicateLead.MobilePhone;
        }
        //HOme phone
        system.debug('The duplead phone'+duplicateLead.Phone +extLead.phone);
        if(duplicateLead.Phone != extLead.MobilePhone &&
                duplicateLead.Phone != extLead.Phone &&
                duplicateLead.Phone != extLead.OtherPhone__c &&
                duplicateLead.Phone != NULL && duplicateLead.Phone != '') {
                system.debug('hey hi i am here'+duplicateLead.Phone +extLead.phone);
            if(extLead.OtherPhone__c == NULL || extLead.OtherPhone__c=='') {
                extLead.OtherPhone__c = extLead.Phone;
            }else if(extLead.MobilePhone == NULL ||extLead.MobilePhone == ''){
                extLead.MobilePhone = extLead.Phone;
            }
            extLead.Phone = duplicateLead.Phone;
        }
        system.debug('The duplead phone1'+duplicateLead.Phone +extLead.phone);
        //other phone
        if(duplicateLead.OtherPhone__c != extLead.MobilePhone &&
                duplicateLead.OtherPhone__c != extLead.Phone &&
                duplicateLead.OtherPhone__c != extLead.OtherPhone__c &&
                duplicateLead.OtherPhone__c != NULL &&  duplicateLead.OtherPhone__c !='') {
            if(extLead.MobilePhone == NULL || extLead.MobilePhone == '') {
                extLead.MobilePhone = extLead.OtherPhone__c;
            }else if(extLead.Phone == NULL || extLead.Phone == ''){
                extLead.Phone = extLead.OtherPhone__c;
            }
            extLead.OtherPhone__c = duplicateLead.OtherPhone__c;
        }
         system.debug('The duplead phone2'+duplicateLead.Phone +extLead.phone);
        return extLead;
    }



    //Email merge logic
    public static Lead emailMerge(Lead extLead, Lead duplicateLead) {
        //Email 1
        if(duplicateLead.Email != extLead.Email &&
                duplicateLead.Email != extLead.Email2__c &&
                duplicateLead.Email != NULL) {
            if(extLead.Email2__c == NULL) {
                extLead.Email2__c = extLead.Email;
            }
            extLead.Email = duplicateLead.Email;
        }
        //Email 2
        if(duplicateLead.Email2__c != extLead.Email2__c &&
                duplicateLead.Email2__c != extLead.Email &&
                duplicateLead.Email2__c != NULL) {
            if(extLead.Email == NULL){
                extLead.Email = duplicateLead.Email2__c;
            }
            else {
                extLead.Email2__c = duplicateLead.Email2__c;
            }
        }
        return extLead;
    }


    //Address merge logic
    public static Lead addressMerge(Lead sourceLead, Lead duplicateLead) {
        if(sourceLead.Street == NULL && (
                duplicateLead.PostalCode != NULL ||
                        duplicateLead.City  != NULL ||
                        duplicateLead.Region__c != NULL
        )) {
            sourceLead.Street = duplicateLead.Street!=null ?
                    duplicateLead.Street : valueLength(sourceLead.Street, duplicateLead.Street);
            sourceLead.PostalCode = duplicateLead.PostalCode!=null?duplicateLead.PostalCode:sourceLead.PostalCode;
            sourceLead.City = duplicateLead.City!=null?duplicateLead.City:sourceLead.City;
            sourceLead.Region__c = duplicateLead.Region__c!=null?duplicateLead.Region__c:sourceLead.Region__c;
        }else if(duplicateLead.Street == NULL && sourceLead.Street != NULL){
            //
        }
        else if(!(sourceLead.Street == duplicateLead.Street &&
                ((sourceLead.PostalCode == duplicateLead.PostalCode
                        && sourceLead.Region__c == duplicateLead.Region__c
                        && sourceLead.City != duplicateLead.City)
                        ||
                        (sourceLead.PostalCode == duplicateLead.PostalCode
                                && sourceLead.Region__c != duplicateLead.Region__c
                                && sourceLead.City == duplicateLead.City)
                        ||
                        (sourceLead.PostalCode != duplicateLead.PostalCode
                                && sourceLead.Region__c == duplicateLead.Region__c
                                && sourceLead.City == duplicateLead.City))
        )){
            sourceLead.Street = duplicateLead.Street!=null?
                    duplicateLead.Street:valueLength(sourceLead.Street,duplicateLead.Street);
            sourceLead.PostalCode = (duplicateLead.PostalCode!=null && duplicateLead.PostalCode.isNumeric())?duplicateLead.PostalCode:sourceLead.PostalCode;
            sourceLead.City = duplicateLead.City!=null?duplicateLead.City:sourceLead.City;
            sourceLead.Region__c = duplicateLead.Region__c!=null?duplicateLead.Region__c:sourceLead.Region__c;
        }
        else{
            sourceLead.PostalCode = sourceLead.PostalCode!=null?sourceLead.PostalCode:duplicateLead.PostalCode;
            sourceLead.City = sourceLead.City!=null?sourceLead.City:duplicateLead.City;
            sourceLead.Region__c = sourceLead.Region__c!=null?sourceLead.Region__c:duplicateLead.Region__c;
        }

        return sourceLead;
    }


    public static Account phoneLeadToAccountMerge(Account extAccount, Lead duplicateLead) {

        //Mobile Phone 
        if(duplicateLead.MobilePhone != extAccount.PersonMobilePhone &&
                duplicateLead.MobilePhone != extAccount.PersonHomePhone &&
                duplicateLead.MobilePhone != extAccount.PersonOtherPhone &&
                duplicateLead.MobilePhone != NULL && duplicateLead.MobilePhone != '') {
            if(extAccount.PersonOtherPhone == NULL || extAccount.PersonOtherPhone =='') {
                extAccount.PersonOtherPhone = extAccount.PersonMobilePhone;
            }else if(extAccount.PersonHomePhone == NULL || extAccount.PersonHomePhone ==''){
                extAccount.PersonHomePhone = extAccount.PersonMobilePhone;
            }
            extAccount.PersonMobilePhone = duplicateLead.MobilePhone;

        }
        //HOme phone
        if(duplicateLead.Phone != extAccount.PersonMobilePhone &&
                duplicateLead.Phone != extAccount.PersonHomePhone &&
                duplicateLead.Phone != extAccount.PersonOtherPhone &&
                duplicateLead.Phone != NULL &&  duplicateLead.Phone !='') {
            if(extAccount.PersonOtherPhone == NULL || extAccount.PersonOtherPhone == '') {
                extAccount.PersonOtherPhone = extAccount.PersonHomePhone;
            }else if(extAccount.PersonMobilePhone == NULL || extAccount.PersonMobilePhone ==''){
                extAccount.PersonMobilePhone = extAccount.PersonHomePhone;
            }
            extAccount.PersonHomePhone = duplicateLead.Phone;

        }
        //other phone
        if(duplicateLead.OtherPhone__c != extAccount.PersonMobilePhone &&
                duplicateLead.OtherPhone__c != extAccount.PersonHomePhone &&
                duplicateLead.OtherPhone__c != extAccount.PersonOtherPhone &&
                duplicateLead.OtherPhone__c != NULL && duplicateLead.OtherPhone__c !='') {
            if(extAccount.PersonMobilePhone == NULL || extAccount.PersonMobilePhone =='') {
                extAccount.PersonMobilePhone = extAccount.PersonOtherPhone;
            }else if(extAccount.PersonHomePhone == NULL || extAccount.PersonHomePhone ==''){
                extAccount.PersonHomePhone = extAccount.PersonOtherPhone;
            }
            extAccount.PersonOtherPhone = duplicateLead.OtherPhone__c;
        }


        return extAccount;
    }

    public static Account emailLeadToAccountMerge(Account extAccount, Lead duplicateLead) {
        //Email 1
        if(duplicateLead.Email != extAccount.PersonEmail &&
                duplicateLead.Email != extAccount.Email2__c &&
                duplicateLead.Email != NULL) {
            if(extAccount.Email2__c == NULL) {
                extAccount.Email2__c = extAccount.PersonEmail;
            }
            extAccount.PersonEmail = duplicateLead.Email;
        }
        //Email 2
        if(duplicateLead.Email2__c != extAccount.Email2__c &&
                duplicateLead.Email2__c != extAccount.PersonEmail &&
                duplicateLead.Email2__c != NULL) {
            if(extAccount.PersonEmail == NULL){
                extAccount.PersonEmail = duplicateLead.Email2__c;
            }
            else {
                extAccount.Email2__c = duplicateLead.Email2__c;
            }
        }
        return extAccount;
    }


    public static Account addressLeadtoAccountMerge(Account duplicateAccount,Lead sourceLead) {
        if(duplicateAccount.PersonMailingStreet == NULL && (
                sourceLead.PostalCode != NULL ||
                        sourceLead.City  != NULL ||
                        sourceLead.Region__c != NULL
        )) {
            duplicateAccount.PersonMailingStreet = sourceLead.Street!=null?sourceLead.Street:duplicateAccount.PersonMailingStreet;
            duplicateAccount.PersonMailingPostalCode = (sourceLead.PostalCode!=null && sourceLead.PostalCode.isNumeric())?sourceLead.PostalCode:duplicateAccount.PersonMailingPostalCode;
            duplicateAccount.PersonMailingCity = sourceLead.City!=null?sourceLead.City:duplicateAccount.PersonMailingCity;
            duplicateAccount.Region__c = sourceLead.Region__c!=null?sourceLead.Region__c:duplicateAccount.Region__c;
        }else if(sourceLead.Street == NULL && duplicateAccount.PersonMailingStreet != NULL){
            //
        }

        else if(!(duplicateAccount.PersonMailingStreet == sourceLead.Street &&
                ((duplicateAccount.PersonMailingPostalCode == sourceLead.PostalCode
                        && duplicateAccount.Region__c == sourceLead.Region__c
                        && duplicateAccount.PersonMailingCity != sourceLead.City)
                        ||
                        (duplicateAccount.PersonMailingPostalCode == sourceLead.PostalCode
                                && duplicateAccount.Region__c != sourceLead.Region__c
                                && duplicateAccount.PersonMailingCity == sourceLead.City)
                        ||
                        (duplicateAccount.PersonMailingPostalCode != sourceLead.PostalCode
                                && duplicateAccount.Region__c == sourceLead.Region__c
                                && duplicateAccount.PersonMailingCity == sourceLead.City)
                ))){
           duplicateAccount.PersonMailingStreet = sourceLead.Street!=null?sourceLead.Street:duplicateAccount.PersonMailingStreet;
            duplicateAccount.PersonMailingPostalCode = (sourceLead.PostalCode!=null  && sourceLead.PostalCode.isNumeric())?sourceLead.PostalCode:duplicateAccount.PersonMailingPostalCode;
            duplicateAccount.PersonMailingCity = sourceLead.City!=null?sourceLead.City:duplicateAccount.PersonMailingCity;
            duplicateAccount.Region__c = sourceLead.Region__c!=null?sourceLead.Region__c:duplicateAccount.Region__c;
        }
        else{
             duplicateAccount.PersonMailingStreet = duplicateAccount.PersonMailingStreet!=null?duplicateAccount.PersonMailingStreet:sourceLead.Street;
            duplicateAccount.PersonMailingPostalCode = duplicateAccount.PersonMailingPostalCode!=null?duplicateAccount.PersonMailingPostalCode:sourceLead.PostalCode;
            duplicateAccount.PersonMailingCity = duplicateAccount.PersonMailingCity!=null?duplicateAccount.PersonMailingCity:sourceLead.City;
            duplicateAccount.Region__c = duplicateAccount.Region__c!=null?duplicateAccount.Region__c:sourceLead.Region__c;
        }
        return duplicateAccount ;
    }

}