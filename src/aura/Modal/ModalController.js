/**
 * Created by aneesh.bhat on 06-Sep-17.
 */
({
    onCloseClicked:function(component,event,helper){
        var closeEvent = component.getEvent("closeModalEvent");
        closeEvent.fire();
    },
    onModalSubmitClicked:function(component,event,helper){
        debugger;
        var submitEvent = component.getEvent("modalSubmitClickEvent");
        submitEvent.fire();
    }
})