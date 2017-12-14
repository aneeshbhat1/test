({
	getData : function(component) {
        var _this = this;
		var action = component.get('c.getMyStatistics');
        action.setCallback(this, function(request){
            if(request.getState() == 'SUCCESS'){
                var response = request.getReturnValue();
                component.set('v.data',response);
                component.set('v.dataLoaded',true);
            }else if(request.getState() == 'ERROR'){
                var toast = $A.get("e.force:showToast");
                if(toast){
                    toast.setParams({
                        title: 'Error!',
                        message: 'Error during retrieving data.'
                    });
                    toast.fire();
                }else{
                    alert('Error during retrieving data.');
                }
            }
            
            window.setTimeout(
                $A.getCallback(function() {
                    try{
                    _this.everyTwoSeconds(component);
                    }catch(ex){
                        //after setTimeout component might be destroyed. This catch is to prevent showing error message
                    }
                }),
                2000);
        });
        $A.enqueueAction(action);
	},
    everyTwoSeconds : function(component){
        this.getData(component);
    }
})