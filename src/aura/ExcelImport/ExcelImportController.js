/**
 * Created by aneesh.bhat on 09-Jun-17.
 */
({
    doInit:function(component,event,helper){
        var templatesAction = component.get("c.getTemplates");
        templatesAction.setCallback(this, function(response){
                    switch(response.getState()){
                        case 'SUCCESS':
                            var templates = JSON.parse(response.getReturnValue());
                            debugger;
                            component.set("v.files",templates);
                            var message = component.find("warningMessage");
                            var fileThumbnails = component.find("fileThumbnails");
                            if(templates == null || templates.length==0){
                                $A.util.removeClass(message,'slds-hide');
                                $A.util.addClass(message,'slds-show');
                            }
                            else{
                                $A.util.removeClass(message,'slds-show');
                                $A.util.addClass(message,'slds-hide');
                            }
                            break;
                        case 'INCOMPLETE':
                            break;
                        case 'ERROR':
                            break;
                    }
                });
          $A.enqueueAction(templatesAction);
          //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
          component.set('v.lcHost', window.location.hostname);

          var frameSrc = '/apex/UploadFileControl?lcHost=' + component.get('v.lcHost');
          console.log('frameSrc:' , frameSrc);
          component.set('v.frameSrc', frameSrc);
          var chatterPostAction = component.get("c.CreateChatterPost");
          //Add message listener
          window.addEventListener("message", function(event) {
              // Handle the message
              if(event.data.state == 'LOADED'){
                  //Set vfHost which will be used later to send message
                  component.set('v.vfHost', event.data.vfHost);
              }

              if(event.data.state == 'uploadFileSelected'){
                  component.find('uploadFileButton').set('v.disabled', false);
              }

              if(event.data.state == 'fileUploadprocessed'){
                  component.find('uploadFileButton').set('v.disabled', true);
                  if(event.data.messageType == 'success'){
                         chatterPostAction.setParams({
                                        newFileId: event.data.fileId,
                                        chatterGroupName:''
                                    });
                        chatterPostAction.setCallback(this, function(response){
                                    var message; var type;
                                    switch(response.getState()){
                                        case 'SUCCESS':
                                            var status = response.getReturnValue();
                                            if(status == '1'){
                                                message = 'Your excel was uploaded successfully!';
                                                type = 'success';
                                            }
                                            else if(status == '2'){
                                                 message = 'Your excel was uploaded successfully!';
                                                 type = 'success';
                                            }
                                            else if(status == '3'){
                                                 message = 'There was an error loading the file!';
                                                 type = 'error';
                                            }

                                            break;
                                        case 'INCOMPLETE':{
                                            message = 'There was an error loading the file!';
                                            type = 'error';
                                        }
                                            break;
                                        case 'ERROR':{
                                            message = 'There was an error loading the file!';
                                            type = 'error';
                                        }
                                            break;
                                    }

                                    helper.toggle(component);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        mode: 'pester',
                                        type : 'success',
                                        message: 'Your excel was uploaded successfully!',
                                        duration:500
                                    });
                                    toastEvent.fire();
                                });
                        $A.enqueueAction(chatterPostAction);
                    }
                  else if(event.data.messageType == 'error'){
                        helper.toggle(component);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: 'pester',
                            type : 'error',
                            message: event.data.message,
                            duration:500
                        });
                        toastEvent.fire();
                  }
              }
          }, false);
    },
    sendMessage: function(component, event, helper) {
          helper.toggle(component);

          //Prepare message in the format required in VF page
          var message = {
              "uploadFile" : true
          } ;
          //Send message to VF
          helper.sendMessage(component, helper, message);
      }
})