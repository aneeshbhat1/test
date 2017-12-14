({
    doInit: function(component, event, helper) {
      //helper.setInfoText(component,values);
        helper.setInitialData(component);
    },
    handleClick: function(component, event, helper) {
      var mainDiv = component.find('main-div');
      $A.util.addClass(mainDiv, 'slds-is-open');
    },
    onOptionsSet:function(component,event,helper){
        helper.setInitialData(component);
    },
    handleSelection: function(component, event, helper) {
        var options_Internal = component.get('v.options_internal');
        var infoText = '';
        options_Internal.forEach(function(option){
            if(option.isSelected){
                infoText+=(option.label+',');
            }
        });
        infoText.trim(',');
        component.set('v.infoText',(infoText)?infoText:'Select an option...');
        component.set('v.selectedItems',helper.getSelectedValues(component));
    },

    handleMouseLeave: function(component, event, helper) {
      component.set("v.dropdownOver",false);
      var mainDiv = component.find('main-div');
      $A.util.removeClass(mainDiv, 'slds-is-open');
    },

    handleMouseEnter: function(component, event, helper) {
      component.set("v.dropdownOver",true);
    },

    handleMouseOutButton: function(component, event, helper) {
      window.setTimeout(
        $A.getCallback(function() {
          if (component.isValid()) {
            //if dropdown over, user has hovered over the dropdown, so don't close.
            if (component.get("v.dropdownOver")) {
              return;
            }
            var mainDiv = component.find('main-div');
            $A.util.removeClass(mainDiv, 'slds-is-open');
          }
        }), 200
      );
    }
  }
})