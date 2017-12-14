/**
 * @author Arkadiusz Celej
 * @version 1.00
 * @description Action to Set Brochure Not Sent on connected SBR Tasks
 *
 * @id AG_DoNotSendBrochure       ActionGrid custom action id that is added to the name field.
 * @param kendoEntry              ActionGrid helper for Kendo UI modal entry forms.
 * @param kendoPopup              ActionGrid helper for Kendo UI model message windows.
 * @param sfdc                    ActionGrid helper for Salesforce REST API's
 */
crmc.require(["KendoEntry", "KendoPopup", "sfdc"], function(kendoEntry, kendoPopup, sfdc) {

  var CurrentObject = {
    object: {Name: "Opportunity", Plural: "Opportunities"},
  };

  var IsContext = function(object){
    objects = [
      {Name: "Opportunity", Plural: "Opportunities"}
    ];
    for (var i = 0; i < objects.length; i++) {
      if(objects[i].Name === object){
        CurrentObject.object = objects[i];
        return true;
      }
    };
    return false;
  };

  crmc.addCustomAction({
    "itemID": "AG_ChangeProgram",
    "isAvailable": function (context) {
      var isCorrectContext = IsContext(context.objectDescribe.name) ;
      var multipleSelected = context.selectedRows && context.selectedRows.length > 0;
      var isEnabled = this.featureSecurity.getSetting(context.objectDescribe.name, this.itemID) !== false
      return isCorrectContext && multipleSelected && isEnabled;
    },
    "getLabel": function (context) {
      return "Do Not Send Brochures";
    },
    "createSubmenuItems": function (context) {
      return [];
    },
    "click": function (context) {

      function IsPlural(){
        return (context.selectedRows.length === 1 ? "" : "s");
      }
      /** Language strings.*/
      var TEXT_ERROR = "There was an error: ";
      var TEXT_MESSAGE = "Changed {0} Task" + IsPlural() + ".";
      var TEXT_BATCH_EDIT_RESULTS = "Batch Edit Results";
      var TASK_RESULT_VALUE = 'Will not Send Brochure';

      function Process() {
          var ids = [];
          for (var i = 0; i < context.selectedRows.length; i++) {
              ids.push(context.selectedRows[i].id);
          };

          //Query for the data that needs to be passed into new records.
          var sbrTasks = sfdc.query("SELECT Id FROM Task WHERE IsClosed <> True AND TaskResult__c <> \'" + TASK_RESULT_VALUE + "\' AND RecordType.DeveloperName IN ('SBRTask','SBR_Task_Read_Only') AND WhatId IN ('" + ids.join("','") + "')");

          //Loop through each result and pull the data.
          var records = [];

          for (var i = 0; i < sbrTasks.length; i++) {
              var record = new sforce.SObject('Task');
              record.Id = sbrTasks[i].Id;
              record.TaskResult__c = TASK_RESULT_VALUE;
              record.Status = 'Completed';
              records.push(record);
          };

          var onfailure = function (error) {
              alert(TEXT_ERROR + (error.message || error.faultstring));
          };

          if (records.length > 0) {
              sforce.connection.update(records, {
                  onSuccess: function (results) {
                      // Get the new record Ids
                      var recordIds = [];
                      $.each(results, function (i, row) {
                          if (row.errors) {
                              onfailure(row.errors);
                              return;
                          }
                          recordIds.push(row.id);
                      });
                      if (results.length == recordIds.length) {
                          var message = kendo.format(TEXT_MESSAGE, results.length);
                          kendoPopup.popupWithButtons(TEXT_BATCH_EDIT_RESULTS, message, []);
                          context.actionGrid.refresh();
                      }
                  },
                  onFailure: onfailure
              });
          }else{
              kendoPopup.popupWithButtons(TEXT_BATCH_EDIT_RESULTS, 'No SBR Task records to update', []);
          }
      }

      Process();
    }
  });
});
