/**
 * Created by savita.b on 6/13/2017.
 */
@isTest
public class DCTestDataUtil {
    public static list<Lead> insertNewLeadRecords() {
        Datetime nowdatetime=datetime.now();
        Lead newLead = new Lead();
        newLead.FirstName = 'FirstName';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '9988776666';
        newLead.OtherPhone__c = '9988776666';
        //newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
        //newLead.Parent_Email__c = 'ParentEmail@email.com';
        //newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region' ;
        newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.InsertTime__c =nowdatetime;

        Lead newLead2 = new Lead();
        newLead2.FirstName = 'FirstName2';
        newLead2.LastName = 'LastName';
        newLead2.TritonId__c = 'triton id123';
        newLead2.PostalCode = '560048';
        newLead2.phone = '9988776666';
        newLead2.MobilePhone = '9988776666';
        newLead2.OtherPhone__c = '9988776666';
        //newLead2.Parent_Phone__c = '9988776666';
        newLead2.DOB__c = system.today();
        newLead2.Email = 'StudentEmail1@email.com';
        newLead2.Email2__c = 'StudentEmail2@email.com';
        //newLead2.Parent_Email__c = 'ParentEmail@email.com';
        //newLead2.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead2.Region__c = 'Region' ;
        newlead2.Program__c='MLY';
        newlead2.product__c='APP';
        newLead2.market__c = 'DEB';
        newLead2.SalesOffice__c = 'DEB';
        //newLead2.isdupe__c = false;
        List<Lead> leadList = new List<Lead>();
        leadList.add(newLead);
        leadList.add(newLead2);
        //insert leadList;
        return leadList;
    }

    public static list<Lead> leadData() {
        // Datetime nowdatetime=datetime.now();
       /* Lead newLead = new Lead();
        newLead.FirstName = 'FirstName';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '9988776666';
        newLead.OtherPhone__c = '9988776666';
        newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
        newLead.Parent_Email__c = 'ParentEmail@email.com';
        newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region' ;
        //newLead.isdupe__c = false;
         newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.Insert_Time__c =nowdatetime;*/

        Lead newLead2 = new Lead();
        Datetime nowdatetimee=datetime.now()-1;
        newLead2.FirstName = '@345';
        newLead2.LastName = '*tyuri';
        newLead2.TritonId__c = '12345@XYZ';
        newLead2.PostalCode = '00@001';
        newLead2.phone = '000000124563';
        newLead2.MobilePhone = '000000120063';
        newLead2.OtherPhone__c = '1200001256';
       // newLead2.Parent_Phone__c = '3698520000';
        newLead2.DOB__c = system.today();
        newLead2.Email = 'rtyuie@fox.com';
        newLead2.Email2__c = 'rpoolsuie@fox.com';
        //newLead2.Parent_Email__c = 'rtvbrtynie@fox.com';
       // newLead2.Invoice_Email__c = 'rtyupooyuicxie@fox.com';
        newLead2.Region__c = 'AUSNEW' ;
        newlead2.Program__c='ILSH';
        newlead2.product__c='ILS';
        newLead2.market__c = 'AEA';
        newLead2.SalesOffice__c = '';

        newLead2.InsertTime__c=nowdatetimee;
        List<Lead> leadList = new List<Lead>();
        //leadList.add(newLead);
        leadList.add(newLead2);
        //insert leadList;
        return leadList;
    }

    public static list<Lead> leadDataa() {
        Datetime nowdatetime=datetime.now();
        Lead newLead = new Lead();
        newLead.FirstName = 'FirstName';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '9988776666';
        newLead.OtherPhone__c = '9988776666';
       // newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
       // newLead.Parent_Email__c = 'ParentEmail@email.com';
        //newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region';
        newLead.RequestType__c='BR';
        //newLead.isdupe__c = false;
        newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.InsertTime__c =nowdatetime;

        Lead newLead2 = new Lead();
        //Datetime nowdatetimee=datetime.now();
        newLead2.FirstName = 'FirstName2';
        newLead2.LastName = 'LastName';
        newLead2.TritonId__c = 'triton id123';
        newLead2.PostalCode = '560048';
        newLead2.phone = '9988776666';
        newLead2.MobilePhone = '9988776666';
        newLead2.OtherPhone__c = '9988776666';
        //newLead2.Parent_Phone__c = '9988776666';
        newLead2.DOB__c = system.today();
        newLead2.Email = 'StudentEmail1@email.com';
        newLead2.Email2__c = 'StudentEmail2@email.com';
       //newLead2.Parent_Email__c = 'ParentEmail@email.com';
        //newLead2.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead2.Region__c = 'Region' ;
        newlead2.Program__c='MLY';
        newlead2.product__c='APP';
        newLead2.market__c = 'DEB';
        newLead2.SalesOffice__c = 'DEB';
        newLead2.isdupe__c = false;
        newLead2.InsertTime__c=nowdatetime;
        List<Lead> leadList = new List<Lead>();
        leadList.add(newLead);
        leadList.add(newLead2);
        //insert leadList;
        return leadList;
    }

    public static list<Lead> leadDataforRanking() {
        Datetime nowdatetime=datetime.now();
        Lead newLead = new Lead();
        newLead.FirstName = 'XYZ';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '2314526389';
        newLead.OtherPhone__c = '1245789635';
       // newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
        //newLead.Parent_Email__c = 'ParentEmail@email.com';
        //newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region';
        //newLead.IsConverted=true;
        newLead.RequestType__c='CAM';
        //newLead.isdupe__c = false;
        newlead.Program__c='AY';
        //newlead.Ranking__c=5;
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.InsertTime__c =nowdatetime;


        List<Lead> leadList = new List<Lead>();
        //leadList.add(newLead);
        leadList.add(newLead);
        //insert leadList;
        return leadList;
    }

    public static list<Lead> testRule2() {
        Datetime nowdatetime=datetime.now();
        Lead newLead = new Lead();
        newLead.FirstName = 'FirstName';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '9988776666';
        newLead.OtherPhone__c = '9988776666';
        //newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
        //newLead.Parent_Email__c = 'ParentEmail@email.com';
       // newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region' ;
        //newLead.isdupe__c = false;
        newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.InsertTime__c =nowdatetime;

        Lead newLead2 = new Lead();
        //Datetime nowdatetimee=datetime.now();
        newLead2.FirstName = 'FirstName';
        newLead2.LastName = 'LastName';
        newLead2.TritonId__c = 'triton id123';
        newLead2.PostalCode = '560048';
        newLead2.phone = '0012345678';
        newLead2.MobilePhone = '2345678012';
        newLead2.OtherPhone__c = '12344578520';
        //newLead2.Parent_Phone__c = '9988776666';
        newLead2.DOB__c = system.today();
        newLead2.Email = 'StudentEmail1@email.com';
        newLead2.Email2__c = 'StudentEmail2@email.com';
        //newLead2.Parent_Email__c = 'ParentEmail@email.com';
        //newLead2.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead2.Region__c = 'Region' ;
        newlead2.Program__c='MLY';
        newlead2.product__c='APP';
        newLead2.market__c = 'DEB';
        newLead2.SalesOffice__c = 'DEB';
        newLead2.isdupe__c = false;
        newLead2.InsertTime__c=nowdatetime;
        List<Lead> leadList = new List<Lead>();
        leadList.add(newLead);
        leadList.add(newLead2);
        //insert leadList;
        return leadList;
    }



    public static list<Lead> insertLeadListRecords() {
        Datetime nowdatetime=datetime.now();
        Lead newLead = new Lead();
        newLead.FirstName = 'FirstName';
        newLead.LastName = 'LastName';
        newLead.street = 'AddressLine2';
        //newLead.City = 'City';
        newLead.TritonId__c = 'triton id123';
        newLead.PostalCode = '560048';
        newLead.phone = '9988776666';
        newLead.MobilePhone = '9988776666';
        newLead.OtherPhone__c = '9988776666';
        //newLead.Parent_Phone__c = '9988776666';
        newLead.DOB__c = system.today();
        newLead.Email= 'PersonEmail@email.com';
        newLead.Email2__c = 'StudentEmail2@email.com';
        //newLead.Parent_Email__c = 'ParentEmail@email.com';
       // newLead.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead.Region__c = 'Region' ;
        newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.market__c = 'DEB';
        newLead.SalesOffice__c = 'DEB';
        newlead.InsertTime__c =nowdatetime;

        Lead newLead2 = new Lead();
        newLead2.FirstName = 'FirstName2';
        newLead2.LastName = 'LastName';
        newLead2.TritonId__c = 'triton id123';
        newLead2.PostalCode = '560048';
        newLead2.phone = '9988776666';
        newLead2.MobilePhone = '9988776666';
        newLead2.OtherPhone__c = '9988776666';
        //newLead2.Parent_Phone__c = '9988776666';
        newLead2.DOB__c = system.today();
        newLead2.Email = 'StudentEmail1@email.com';
        newLead2.Email2__c = 'StudentEmail2@email.com';
        //newLead2.Parent_Email__c = 'ParentEmail@email.com';
        //newLead2.Invoice_Email__c = 'InvoiceEmail@email.com';
        newLead2.Region__c = 'Region' ;
        newlead2.Program__c='MLY';
        newlead2.product__c='APP';
        newLead2.market__c = 'DEB';
        newLead2.SalesOffice__c = 'DEB';
        //newLead2.isdupe__c = false;
        newLead2.InsertTime__c=nowdatetime;
        List<Lead> leadList = new List<Lead>();
        leadList.add(newLead);
        leadList.add(newLead2);
        //insert leadList;
        return leadList;
    }


    public static Lead insertAnotherSetOfLeadRecord() {
        Datetime nowdatetime=datetime.now()-1;
        Lead anotherlead = new Lead();
        anotherlead.FirstName = 'FirstName';
        anotherlead.LastName = 'LastName';
        // anotherlead.Address_Line1__c = 'AddressLine1';
        anotherlead.street = 'AddressLine2';
        anotherlead.city = 'city1';
        //anotherlead.City = 'City';
        anotherlead.TritonId__c = 'triton id123';
        anotherlead.PostalCode = '560048';
        anotherlead.phone = '9988776666';
        anotherlead.MobilePhone = '9988776666';
        anotherlead.OtherPhone__c = '9988776666';
        //anotherlead.Parent_Phone__c = '9988776666';
        anotherlead.DOB__c = system.today();
        anotherlead.Email = 'StudentEmail1@email.com';
        anotherlead.Email2__c = 'StudentEmail2@email.com';
       // anotherlead.Parent_Email__c = 'ParentEmail@email.com';
        //anotherlead.Invoice_Email__c = 'InvoiceEmail@email.com';
        anotherlead.Region__c = 'Region' ;
        //  newLead.Activity__c=.Activity;
        anotherlead.Program__c='MLY';
        anotherlead.product__c='APP';
        anotherlead.market__c = 'DEB';
       
        anotherlead.InsertTime__c =nowdatetime;

        //anotherlead.isdupe__c = false;

        //insert anotherlead;
        return anotherlead;
    }
    public static Lead DynamicinsertNewLeadRecords(string firstname,string lastname,string city,string street,string postalcode,string phone,
            string mobilephone,string otherphone,string tritonid,string studentemail1,string studentemail2,string region,date DOB) {
        Datetime nowdatetime=datetime.now()-(1/6.0);
        Lead newLead = new Lead();
        newLead.FirstName = firstname;
        newLead.LastName = lastname;
        newLead.city = city;
        newLead.street = street;
        newLead.PostalCode = postalcode;
        newLead.phone = phone;
        newLead.MobilePhone = mobilephone;
        newLead.OtherPhone__c = otherphone;
        newLead.TritonId__c = tritonid;
        newLead.Email = studentemail1;
        newLead.Email2__c = studentemail2;
        newLead.Region__c = region ;
        newlead.Program__c='MLY';
        newlead.product__c='APP';
        newLead.DOB__c = DOB;
        newLead.market__c = 'DEB';
        
        newLead.InsertTime__c =nowdatetime;

        //insert newLead;
        return newLead;
    }
    public static Lead DynamicinsertAnotherSetOfLeadRecord(string firstname,string lastname,string city,string street,string postalcode,string phone,string mobilephone,string otherphone,string tritonid,string studentemail1,string studentemail2,string region,date DOB) {
        Datetime nowdatetime=datetime.now();
        Lead anotherlead = new Lead();
        anotherlead.FirstName = firstname;
        anotherlead.LastName = lastname;
        anotherlead.city = city;
        anotherlead.street = street;
        anotherlead.PostalCode = postalcode;
        anotherlead.phone = phone;
        anotherlead.MobilePhone = mobilephone;
        anotherlead.OtherPhone__c = otherphone;
        anotherlead.TritonId__c = tritonid;
        anotherlead.Email = studentemail1;
        anotherlead.Email2__c = studentemail2;
        anotherlead.Region__c = region ;
        anotherlead.Program__c='MLY';
        anotherlead.product__c='APP';
        anotherlead.DOB__c = DOB;
       
        anotherlead.InsertTime__c =nowdatetime;
        //anotherlead.ownerid='0050Y000001ZqLu';

        //insert anotherlead;
        return anotherlead;
    }
    public static account DynamicinsertAnotherSetOfaccountRecord(string firstname,string lastname,string personalmailingcity,string personalmailingstreet,string personalmailingpostalcode,string personalmailingphone,string personalmailingmobilephone,string personalmailingotherphone,string tritonid,string studentemail1,string studentemail2,string region,boolean hasbooking,date DOB,date bookingdate) {
        Datetime nowdatetime=datetime.now()-1;
        account anotheraccount = new account();
        anotheraccount.FirstName = firstname;
        anotheraccount.LastName = lastname;
        anotheraccount.personmailingcity = personalmailingcity;
        anotheraccount.personmailingstreet= personalmailingstreet;
        anotheraccount.personmailingpostalcode = personalmailingpostalcode;
        anotheraccount.personhomephone = personalmailingphone;
        anotheraccount.personmobilephone = 'phone';
        anotheraccount.personotherphone = personalmailingotherphone;
        anotheraccount.TritonId__c = tritonid;
        anotheraccount.PersonEmail= studentemail1;
        anotheraccount.Email2__c = studentemail2;
        anotheraccount.Region__c = Region ;
        anotheraccount.HasBooking__c = hasbooking;
        anotheraccount.DOB__c = DOB;
        anotheraccount.BookingDate__c = bookingdate;

        //insert anotheraccount;
        return anotheraccount;
    }
    public static account insertAnotherSetOfaccountRecord() {
        Datetime nowdatetime=datetime.now()-1;
        account anotheraccount = new account();
        anotheraccount.FirstName = 'FirstName';
        anotheraccount.LastName = 'LastName';
        anotheraccount.personmailingcity = 'city1';
        anotheraccount.personmailingstreet= 'AddressLine2';
        //anotherlead.City = 'City';
        anotheraccount.TritonId__c = 'triton id123';
        anotheraccount.personmailingpostalcode = '560048';
        anotheraccount.personhomephone = '9988776666';
        anotheraccount.personmobilephone = '9988776666';
        anotheraccount.personotherphone = '9988776666';
        anotheraccount.DOB__c = system.today();
        anotheraccount.BookingDate__c = system.today().addDays(-200);
        anotheraccount.HasBooking__c = true;
        anotheraccount.PersonEmail= 'StudentEmail1@email.com';
        anotheraccount.Email2__c = 'StudentEmail2@email.com';
        anotheraccount.Region__c = 'Region' ;
        //  newLead.Activity__c=.Activity;


        //anotherlead.isdupe__c = false;

        //insert anotheraccount;
        return anotheraccount;
    }

    public static Lead insertLeadRecord() {
        Datetime nowdatetime=datetime.now();
        Lead anotherlead = new Lead();
        anotherlead.FirstName = 'FirstName';
        anotherlead.LastName = 'LastName';
        // anotherlead.Address_Line1__c = 'AddressLine1';
        anotherlead.street = 'AddressLine2';
        anotherlead.city = 'city1';
        //anotherlead.City = 'City';
        anotherlead.TritonId__c = 'triton id123';
        anotherlead.PostalCode = '560048';
        anotherlead.phone = '9988776666';
        anotherlead.MobilePhone = '9988776666';
        anotherlead.OtherPhone__c = '9988776666';
        //anotherlead.Parent_Phone__c = '9988776666';
        anotherlead.DOB__c = system.today();
        anotherlead.Email = 'StudentEmail1@email.com';
        anotherlead.Email2__c = 'StudentEmail2@email.com';
       // anotherlead.Parent_Email__c = 'ParentEmail@email.com';
        //anotherlead.Invoice_Email__c = 'InvoiceEmail@email.com';
        anotherlead.Region__c = 'Region' ;
        //  newLead.Activity__c=.Activity;
        anotherlead.Program__c='MLY';
        anotherlead.product__c='APP';
        anotherlead.market__c = 'DEB';
        anotherlead.SalesOffice__c = 'DEB';
        anotherlead.InsertTime__c =nowdatetime;

        //anotherlead.isdupe__c = false;

        //insert anotherlead;
        return anotherlead;
    }

    public static list<account> insertmultipleAccountRecord() {
        Datetime nowdatetime=datetime.now()-1;
        account acc1 = new account();
        acc1.FirstName = 'FirstName';
        acc1.LastName = 'LastName';
        acc1.personmailingcity = 'city1';
        acc1.personmailingstreet= 'AddressLine2';
        //anotherlead.City = 'City';
        acc1.TritonId__c = 'triton id123';
        acc1.personmailingpostalcode = '560048';
        acc1.personhomephone = '9988776666';
        acc1.personmobilephone = '9988776666';
        acc1.personotherphone = '9988776666';
        acc1.DOB__c = system.today();
        acc1.BookingDate__c = system.today().addDays(-200);
        acc1.HasBooking__c = true;
        acc1.PersonEmail= 'StudentEmail1@email.com';
        acc1.Email2__c = 'StudentEmail2@email.com';
        acc1.Region__c = 'Region' ;

        account acc2 = new account();
        acc2.FirstName = 'FirstName2';
        acc2.LastName = 'LastName2';
        acc2.personmailingcity = 'city2';
        acc2.personmailingstreet= 'AddressLine2';
        //anotherlead.City = 'City';
        acc2.TritonId__c = 'triton id123';
        acc2.personmailingpostalcode = '560048';
        acc2.personhomephone = '9988776666';
        acc2.personmobilephone = '9988776666';
        acc2.personotherphone = '9988776666';
        acc2.DOB__c = system.today();
        acc2.BookingDate__c = system.today().addDays(-200);
        acc2.HasBooking__c = true;
        acc2.PersonEmail= 'StudentEmail1@email.com';
        acc2.Email2__c = 'StudentEmail2@email.com';
        acc2.Region__c = 'Region' ;

        list<account> twoAccs=new list<account>();
        twoAccs.add(acc1);
        twoAccs.add(acc2);
        return twoAccs;
    }

    public static list<account> accountsData() {
        Datetime nowdatetime=datetime.now()-1;
        account acc1 = new account();
        acc1.FirstName = 'edfes';
        acc1.LastName = 'efsaef';
        acc1.personmailingcity = 'sdfer';
        acc1.personmailingstreet= 'ZUMBA';
        //anotherlead.City = 'City';
        acc1.TritonId__c = '12345XY4';
        acc1.personmailingpostalcode = '001245';
        acc1.personhomephone = '4521458782';
        acc1.personmobilephone = '0017852576';
        acc1.personotherphone = '3569874521';
        acc1.DOB__c = system.today();
        acc1.BookingDate__c = system.today().addDays(-200);
        acc1.HasBooking__c = true;
        acc1.PersonEmail= 'trtsdh56@email.com';
        acc1.Email2__c = 'desfcrse4@email.com';
        acc1.Region__c = 'ZIMBAV' ;

        account acc2 = new account();
        acc2.FirstName = 'terfdef';
        acc2.LastName = 'abcsdf';
        acc2.personmailingcity = 'bangalore';
        acc2.personmailingstreet= 'SDFRT';
        //anotherlead.City = 'City';
        acc2.TritonId__c = 'triton id896';
        acc2.personmailingpostalcode = '891420';
        acc2.personhomephone = '0001245786';
        acc2.personmobilephone = '0001245786';
        acc2.personotherphone = '0001245786';
        acc2.DOB__c = system.today();
        acc2.BookingDate__c = system.today().addDays(-300);
        acc2.HasBooking__c = true;
        acc2.PersonEmail= 'rte567@email.com';
        acc2.Email2__c = 'retwyw32@email.com';
        acc2.Region__c = 'AUSTRA' ;

        list<account> twoAccs=new list<account>();
        twoAccs.add(acc1);
        twoAccs.add(acc2);
        return twoAccs;
    }


    Public static List<Account> createAccountRecords(Integer count) {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account a = new Account();
            a.Name = 'TestAcc-' + i;
            a.Region__c='Test';
            //a.Market__c='DEB';
            accList.add(a);
        }
        //insert accList;
        return accList;
    }

    public static account creatAcc() {
        Account a = new Account();
        a.Name = 'TestAcc-';
        //insert a;
        return a;

    }

    Public static List<Account> updateAccountRecords(List<Account> accList) {
        for (Account acc: accList) {
            acc.Region__c='Test123';
        }
        //update accList;
        return accList;
    }
}