/**
 * Created by Aneesh on 24-11-2017.
 */
({
    doInit:function(component,event,helper){
        var getHostAction = component.get('c.getServerURL');
        getHostAction.setCallback(this,function(res){
            switch(res.getState()){
                  case 'SUCCESS':
                      var serverURL = res.getReturnValue();
                      component.set('v.serverURL',serverURL);
                      break;
                  case 'INCOMPLETE':
                      break;
                  case 'ERROR':
                      break;
              }
        });
        $A.enqueueAction(getHostAction);
    },
    onSelectedObjectChanged:function(component, event,helper){
        debugger;
        var getRecordsAction = component.get('c.getRecords');
        getRecordsAction.setParams({
           prefix : component.get('v.selectedObject')
        });
        getRecordsAction.setCallback(this,function(res){
            switch(res.getState()){
                  case 'SUCCESS':
                      var records = res.getReturnValue();
                      component.set('v.records',records);
                      break;
                  case 'INCOMPLETE':
                      break;
                  case 'ERROR':
                      break;
              }
        });
        $A.enqueueAction(getRecordsAction);
    },
    ongenerateTemplateClicked:function(component,event,helper){
        debugger;
        //var = window.location.url.host;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": 'https://composer.congamerge.com?serverUrl='+component.get('v.serverURL')+'&id=' + component.get('v.selectedRecord')
        });
        urlEvent.fire();

    }
})