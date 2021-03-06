/**
 * @author Arkadiusz Celej
 * @version 1.00
 * @description Action to mass update Program
 *
 * @id AG_ChangeProgram   ActionGrid custom action id that is added to the name field.
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
      return "Change Program";
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
      var TEXT_MESSAGE = "Changed {0} Opportunities" + IsPlural() + ", review the record" + IsPlural() + " with Preview or Browse Records.";
      var TEXT_BATCH_EDIT_RESULTS = "Batch Edit Results";
      var TEXT_YES = "Preview records";
      var TEXT_NO = "No";


      function getControllingFieldValue(objectDesctibe, controllingField, dependentField, dependentFieldValue){
        var picklists = sfdc.getDependentPicklistValues(objectDesctibe, controllingField, dependentField);
        for(key in picklists){
          if (picklists.hasOwnProperty(key)) {
            if(typeof picklists[key] != 'function' && picklists[key].indexOf(dependentFieldValue) > -1){
              return key;
            }
          }
        }
      }

      function Process(Program){
        var controllingProduct = getControllingFieldValue(context.objectDescribe,'Product__c','Program__c', Program);
        var ids = [];
        for (var i = 0; i < context.selectedRows.length; i++) {
          ids.push(context.selectedRows[i].id);
        };

        //Query for the data that needs to be passed into new records.
        var results = sfdc.query("SELECT Id, Market__c FROM " + CurrentObject.object.Name + " WHERE Id IN('" + ids.join("','") + "')");

        //Loop through each result and pull the data.
        var records = [];
        if(Program && controllingProduct){
          for (var i in results) {
            var record = new sforce.SObject('Opportunity');
            for (var j in ids) {
              if(ids[j] === results[i].Id){
                record.Id = results[i].Id;
                record.Product__c = controllingProduct;
                record.Program__c = Program;
                records.push(record);
                break;
              };
            };
          };
        }else{
          alert('Action aborted. Program value must be provided');
          return;
        }
        var onfailure = function(error) {
          alert(TEXT_ERROR + (error.message || error.faultstring));
        };

        sforce.connection.update(records, {
          onSuccess: function(results) {
            // Get the new record Ids
            var recordIds = [];
            $.each(results, function(i, row) {
              if (row.errors) {
                onfailure(row.errors);
                return;
              }
              recordIds.push(row.id);
            });
            if (results.length == recordIds.length) {
              var message = kendo.format(TEXT_MESSAGE, results.length);
              var buttons = [{
                label: TEXT_YES,
                click: function() {
                  window.open(kendo.format("/apex/CRMC_PP__crmc_grid?object={0}&Ids={1}", 'Opportunity', recordIds.join()));
                }
              }
              ];
              kendoPopup.popupWithButtons(TEXT_BATCH_EDIT_RESULTS, message, buttons);
              context.actionGrid.refresh();
            }
          },
          onFailure: onfailure
        });
      }

      function GetPicklist(table, field){

        //Get the object describe.
        var fields = sfdc.getSObjectDescribe(table).fields;
        //Loop through table fields.
        for (var i = 0; i < fields.length; i++) {
          //Find the picklist.
          if (fields[i].name === field){
            //return the values.
            return fields[i].picklistValues;
          }
        };
      }

      kendoEntry.entry("Batch Edit Opportunity Program",
        [
          {name: "Program__c", label: 'Program', type: "picklist", values: GetPicklist('Opportunity', 'Program__c'), required: true}
        ],
        {width: 350},
        null,
        function(selectedValues) {
          var Program = selectedValues["Program__c"].value;
          Process(Program);
        });
    }
  });
});
