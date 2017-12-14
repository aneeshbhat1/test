/**
 * Created by shravan.boddula on 7/7/2017.
 */
@isTest
public class DCMergePluginTest {
    //lead merge
    static testmethod void leadMergePlugin() {
        system.runAs(TestDataUtil.createUserRecord()) {
            List<Lead> leadList = TestdataUtil.createLeadList(4);
            insert leadList;
            Lead masterLead = TestdataUtil.createLead();
            insert masterLead;
            DCMergePlugin plugin = new DCMergePlugin();
            plugin.beforeMerge('00Q',masterLead,leadList);
            Set<Id> masterRecordSet = new Set<Id>();
            masterRecordSet.add(masterLead.id);
            //merge failed
            dupcheck.dc3Exception.MergeException myException = new dupcheck.dc3Exception.MergeException();
            plugin.mergeFailed('00Q',masterlead,masterRecordSet,myException);
            //after merge
            plugin.afterMerge('00Q',masterLead,masterRecordSet);

        }
    }

    //personal account merge
    static testmethod void accountMergePlugin() {
        system.runAs(TestDataUtil.createUserRecord()) {
            List<Account> accountList = TestdataUtil.createAccountList(2);
            Account masterAccount = TestdataUtil.creatAcc();
            insert masterAccount;
            DCMergePlugin plugin = new DCMergePlugin();
            Set<Id> masterRecordSet = new Set<Id>();
            masterRecordSet.add(masterAccount.id);
            //after merge
            plugin.afterMerge('001P',masterAccount,masterRecordSet);
        }
    }
}