({
    doInit : function(component, event, helper){
        helper.getData(component, event);
    },
    
    handleApplicationEvent:function(component, event, helper){
        console.log('Got event from vf ',event.getParam('selectedOpportunities'));
    }
})