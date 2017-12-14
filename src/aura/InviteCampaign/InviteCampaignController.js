/**
 * Created by thejasvi.a on 4-Sept-17.
 */
({
    doInit:function(component, event, helper){
        debugger;
        var today = new Date();
        component.set("v.selectedfrom", today.toISOString());      

        var action = component.get("c.getInitialCampaignData");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.wrapperClassList", response.getReturnValue());
            }
        });
        action.setParams({
           recordId : component.get('v.recordId'),           
           datefrom : today.toISOString(),           
        });

	    $A.enqueueAction(action);


       var meetingTypesAction = component.get("c.getMeetingTypes");
       meetingTypesAction.setCallback(this,function(res){
           debugger;
          switch(res.getState()){
              case 'SUCCESS':
                  var meetingTypes = JSON.parse(res.getReturnValue());
                  component.set('v.meetingtypes',meetingTypes);
                  break;
              case 'INCOMPLETE':
                  break;
              case 'ERROR':
                  break;
          }
       });
       $A.enqueueAction(meetingTypesAction);

       var meetingCityAction = component.get("c.getMeetingCity");
        meetingCityAction.setParams({
                  recordId : component.get('v.recordId')
               });
       meetingCityAction.setCallback(this,function(res){
          switch(res.getState()){
              case 'SUCCESS':
                  var meetingCities = JSON.parse(res.getReturnValue());
                  component.set('v.meetingcities',meetingCities);
                  break;
              case 'INCOMPLETE':
                  break;
              case 'ERROR':
                  break;
          }
       });
       $A.enqueueAction(meetingCityAction);

        var programsAction = component.get("c.getProgram");
        programsAction.setParams({
                  recordId : component.get('v.recordId')
               });
        programsAction.setCallback(this,function(res){
            switch(res.getState()){
                case 'SUCCESS':
                    var programs = JSON.parse(res.getReturnValue());
                    var programSort = programs.sort();
                    component.set('v.programs',programSort);
                    break;
                case 'INCOMPLETE':
                    break;
                case 'ERROR':
                    break;
                }
            });
        $A.enqueueAction(programsAction);

        var salesofficesAction = component.get("c.getsalesoffice");
        salesofficesAction.setParams({
                          recordId : component.get('v.recordId')
                       });
        salesofficesAction.setCallback(this,function(res){
            switch(res.getState()){
                case 'SUCCESS':
                    var salesoffices = JSON.parse(res.getReturnValue());
                    component.set('v.salesoffices',salesoffices);
                    break;
                case 'INCOMPLETE':
                    break;
                case 'ERROR':
                    break;
                }
            });
        $A.enqueueAction(salesofficesAction);
    },
    getCampaigns:function(component, event, helper){
        helper.toggle(component);
        var selectedSalesOffice= component.get('v.selectedSalesOffice');
        var selectedProgram= component.get('v.selectedProgram');
        var selectedMeetingType=component.get('v.selectedMeetingType');
        var selectedMeetingCity=component.get('v.selectedMeetingCity');
        var selectedTo=component.get('v.selectedTo');
        var selectedfrom=component.get('v.selectedfrom');        

        var action = component.get('c.getCampaignsWithFilter');
        action.setParams({
           recordId : component.get('v.recordId'),
           salesoffice : JSON.stringify(selectedSalesOffice) ,
           program : JSON.stringify(selectedProgram) ,
           meetingType : JSON.stringify(selectedMeetingType) ,
           meetingCity :  JSON.stringify(selectedMeetingCity),
           datefrom : selectedfrom,
           dateto : selectedTo
        });

        action.setCallback(this,function(res){
           switch(res.getState()){
               case 'SUCCESS':
                    component.set('v.wrapperClassList',res.getReturnValue());
                   break;
               case 'INCOMPLETE':
                   break;
               case 'ERROR':
                   break;
           }
           helper.toggle(component);
        });
        $A.enqueueAction(action);

    },
    pushCampaigns:function(component, event, helper){
        debugger;
        var wrapperClassList=component.get('v.wrapperClassList');
        var wrapperClassList2=JSON.stringify(wrapperClassList);
        var ids=new Array();
        var returnedCampaignList =[];
        for (var i=0; i<wrapperClassList.length; i++) {
         if (wrapperClassList[i].isChecked ) {
                if(new Date(wrapperClassList[i].objWrapperCampaign.DateFrom__c) < new Date()){
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       mode: 'pester',
                       type : 'success',
                       message: 'Cannot add meeting to the opportunity as it has already passed. Kindly select another meeting!',
                       duration:500
                   });
                   toastEvent.fire();
                   return;
                }
                else{
                    returnedCampaignList.push(wrapperClassList[i].objWrapperCampaign);
                }
            }
        }

        if(returnedCampaignList.length == 0 ){
            component.set('v.messageTitle','Warning');
            component.set('v.message','Please select at least one campaign to invite!');
            component.set('v.showMessage',true);
            component.set('v.messageType','warning');
            setTimeout(function(){
                        component.set('v.showMessage',false);
                        }, 3000);
            return;
        }

        helper.toggle(component);
        var returnCampaignList=JSON.stringify(returnedCampaignList);
        var oppId = component.get('v.recordId');
        var action = component.get('c.AddCampaigns');
                action.setParams({
                   incomingCampaignList : returnCampaignList,
                   OpportunityId : oppId
                });
         action.setCallback(this,function(res){
             		debugger;
                   switch(res.getState()){
                       case 'SUCCESS':
                                component.set('v.messageTitle','Success');
                                component.set('v.message','Opportunity invited successfully!');
                                component.set('v.showMessage',true);
                                component.set('v.messageType','info');
                                setTimeout(function(){
                                            component.set('v.showMessage',false);
                                            }, 3000);
                                for (var i=0; i<wrapperClassList.length; i++) {
                                    if (wrapperClassList[i].isChecked ) {
                                         wrapperClassList[i].invitedCount++;
                                        wrapperClassList[i].isChecked = false;
                                    }
                                }
                                component.set('v.wrapperClassList',wrapperClassList);
                           break;
                       case 'INCOMPLETE':
                           break;
                       case 'ERROR':
                            component.set('v.messageTitle','Error');
                            component.set('v.message','This opportunity is already a member of the selected campaign(s). Please modify your selection and try again!');
                            component.set('v.showMessage',true);
                            component.set('v.messageType','error');
                            setTimeout(function(){
                                        component.set('v.showMessage',false);
                                        }, 3000);
                           break;
                   }
                   helper.toggle(component);
                });
          $A.enqueueAction(action);
    }
})