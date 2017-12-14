/**
 * Created by aneesh.bhat on 06-Sep-17.
 */
({
    onModalStateToggled:function(component,event,helper){
//        helper.toggle(component);
        component.set('v.isComponentContentVisible',false);
    },
    onModalSubmitClicked:function(component,event,helper){
        debugger;
        var childComponent = component.find('inviteToCampaignComponent');
        childComponent.onInviteToCampaign();
    },
    onComponentShowClicked:function(component,event,helper){
//        helper.toggle(component);
     	component.set('v.isComponentContentVisible',true);
    }
})