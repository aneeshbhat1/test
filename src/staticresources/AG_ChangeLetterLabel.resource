/**
 * @author Arkadiusz Celej
 * @version 1.00
 * @description Action to mass update Program
 *
 * @id AG_ChangeLetterLabel   ActionGrid custom action id that is added to the name field.
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
    "itemID": "AG_ChangeLetterLabel",
    "isAvailable": function (context) {
      var isCorrectContext = IsContext(context.objectDescribe.name) ;
      var multipleSelected = context.selectedRows && context.selectedRows.length > 0;
      var isEnabled = this.featureSecurity.getSetting(context.objectDescribe.name, this.itemID) !== false
      return isCorrectContext && multipleSelected && isEnabled;
    },
    "getLabel": function (context) {
      return "Change Letter/Label";
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

      function Process(letter, label){
        //Loop through each result and pull the data.
        var records = [];
        if(letter || label){
          for (var i = 0; i < context.selectedRows.length; i++) {
            var record = new sforce.SObject('Opportunity');
            record.Id = context.selectedRows[i].id;
            if(letter){
              record.Letter__c = letter;
            }
            if(label){
              record.Label__c = label;
            }
            records.push(record);
          };
          console.log('records',records);
        }else{
          alert('Action aborted. Letter or Label value must be provided');
          return;
        }
        var onfailure = function(error) {
          kendoPopup.popupWithButtons('Action Error!', error.message || error.faultstring, []);
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
              kendoPopup.popupWithButtons(TEXT_BATCH_EDIT_RESULTS, message, []);
              context.actionGrid.refresh();
            }
          },
          onFailure: onfailure
        });
      }
      
      function getCongaTemplates(type){
        if(context.selectedRows.length < 1){
          return [];
        }
        var firstOpportunityId = context.selectedRows[0].id;
        var opps = sfdc.query("SELECT Id, Market__c FROM Opportunity WHERE Id = \'"+ firstOpportunityId +"\'");
        if(opps.length > 0){
          market = opps[0].Market__c;
        }else{
          return [];
        }
        var results = sfdc.query("SELECT Id, APXTConga4__Name__c FROM APXTConga4__Conga_Template__c WHERE Market__c = \'"+ market +"\' AND APXTConga4__Template_Type__c = \'"+ type +"\'");
        return results
      }
      
      function getLetters(){
        var letters = getCongaTemplates('Letter');
        return convertToPicklist(letters);
      }
      
      function getLabels(){
        var labels = getCongaTemplates('Label');
        return convertToPicklist(labels);
      }
      
      function convertToPicklist(lst){
        var picklist = [];
        for(var i = 0 ; i < lst.length; i++){
          var item = {
            value: lst[i].Id,
            label: lst[i].APXTConga4__Name__c
          }
          picklist.push(item);
        }
        return picklist;
      }

      kendoEntry.entry("Batch Edit Opportunity Letter/Label",
        [
          {name: "Letter__c", label: 'Letter', type: "picklist",  values: getLetters(), required: true},
          {name: "Label__c" , label: 'Label' , type: "picklist",  values: getLabels() , required: true}
        ],
        {width: 350},
        null,
        function(selectedValues) {
          var letter = selectedValues["Letter__c"].value;
          var label = selectedValues["Label__c"].value;
          Process(letter, label);
        });
    }
  });
});
