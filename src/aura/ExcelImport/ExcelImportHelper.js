/**
 * Created by aneesh.bhat on 12-Jun-17.
 */
({
    toggle: function (cmp) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
     sendMessage: function(component, helper, message){
            //Send message to VF
            message.origin = window.location.hostname;
            var vfWindow = component.find("vfFrame").getElement().contentWindow;
            vfWindow.postMessage(message, component.get("v.vfHost"));
        }
})