({
   afterScriptsLoaded:function(component,event,helper){
    },
    onInit:function(component,event,helper){
        var weekValues=[
            {Name:'Su',IsSelected:false},
            {Name:'M',IsSelected:false},
            {Name:'Tu',IsSelected:false},
            {Name:'W',IsSelected:false},
            {Name:'Th',IsSelected:false},
            {Name:'F',IsSelected:false},
            {Name:'Sa',IsSelected:false},
        ];
//        component.set('v.isDailyChecked',true);
        component.set('v.daysOfWeek',weekValues);
        var startDate = new Date();
        var endDate = new Date();
        endDate.setDate(startDate.getDate() + 1);
        component.set('v.StartDate',startDate.toISOString());
        component.set('v.endDate',endDate.toISOString());
    },
    onRepeatPatternChanged:function(component,event,helper){
        //debugger;
        if(component.get('v.isDailyChecked')){
            var picklist = component.find('dailyRepeatPicklist');
            component.set('v.isCustomPatternSelected',picklist.get('v.value') === 'Custom');
        }
        else if(component.get('v.isWeeklyChecked')){
            var picklist = component.find('weeklyRepeatPicklist');
            component.set('v.isCustomPatternSelected',picklist.get('v.value') === 'Custom');
        }
        else if(component.get('v.isMonthlyChecked')){
            var picklist = component.find('monthlyRepeatPicklist');
            component.set('v.isCustomPatternSelected',picklist.get('v.value') === 'Custom');
            var whenMonthlyDropdown = component.find('whenMonthlyDropdown');
            component.set('v.isRelativeForMonthlySelected',whenMonthlyDropdown.get('v.value') === 'Relative Days');
        }
        else{
            var picklist = component.find('yearlyRepeatPicklist');
            component.set('v.isRelativeForYearlySelected',picklist.get('v.value') === 'Relative Date');
        }

    },
    onWeekDayPatternChanged:function(component,event,helper){
        var weekName = event.target.id;
        var tempDaysOfWeek = component.get('v.daysOfWeek');
        tempDaysOfWeek.forEach(function(weekDay){
            if(weekName == weekDay.Name){
                weekDay.IsSelected = !weekDay.IsSelected;
            }
        });
        component.set('v.daysOfWeek',tempDaysOfWeek);
    },
    saveRecurence : function(component,event,helper){
        var startDate=component.get('v.StartDate');
        var endDate=component.get('v.endDate');
        var nextDates = [];
        var recurrence ;

         if(component.get('v.isDailyChecked')){
             var repeatPattern = component.find('dailyRepeatPicklist').get('v.value');
             if(repeatPattern === 'Every Day'){
                 recurrence = moment().recur(startDate,endDate).every().days();
             }
             else if(repeatPattern ==='Every other Day'){
                   recurrence = moment().recur(startDate,endDate).every(2).days();
             }
             else{
                  //debugger;
                  var customEveryDate = component.find('DailyEveryId').get('v.value');
                   recurrence = moment().recur(startDate,endDate).every(customEveryDate).days();
             }
         }
         else if (component.get('v.isWeeklyChecked')){
             var repeatPattern = component.find('weeklyRepeatPicklist').get('v.value');
             var weeklyPattern = [];
             component.get('v.daysOfWeek').forEach(function(day){
                if(day.IsSelected){
                    weeklyPattern.push(helper.getFullNameOfWeek(day.Name));
                }
             });

             if(repeatPattern === 'Every Week'){
                recurrence = moment().recur(startDate,endDate).every(weeklyPattern).daysOfWeek();
             }
             else if(repeatPattern === 'Every other Week'){
                 //recurrence = moment().recur(startDate,endDate).every(weeklyPattern).daysOfWeek().every(2).weeks();
             }
             else {

             }
         }
         else if (component.get('v.isMonthlyChecked')){
             var repeatPattern = component.find('monthlyRepeatPicklist').get('v.value');
             if(repeatPattern == 'Every Month'){
                 var whenMonthlyOption = component.find('whenMonthlyDropdown').get('v.value');
                 if(whenMonthlyOption == 'Specific Days'){
                     var dayOfMonth = component.find('monthlyDayId').get('v.value');
                     recurrence = moment.recur(startDate,endDate).every(dayOfMonth).daysOfMonth();
                 }
                 else{
                     var monthlyWhichWeekId = helper.getWeekNumberOfWeek(component.find('monthlyWhichWeekId').get('v.value'));
                     var monthlyRepeatWeekId = component.find('monthlyRepeatWeekId').get('v.value');
                     recurrence = moment.recur(startDate,endDate).every(monthlyRepeatWeekId).daysOfWeek().every(monthlyWhichWeekId).weeksOfMonthByDay();
                 }
             }
             else if( repeatPattern == 'Every other Month'){

             }
             else{

             }
         }
         else{
             var repeatPattern = component.find('monthlyRepeatPicklist').get('v.value');
             if(repeatPattern == 'Specific Date'){
                  recurrence = moment.recur(startDate,endDate).every().year();
             }
             else{
                var yearlyWhichWeekId = component.find('yearlyWhichWeekId').get('v.value');
                var yearlyRepeatWeekId = component.find('yearlyRepeatWeekId').get('v.value');
                var yearlyRepeatMonthId = component.find('yearlyRepeatMonthId').get('v.value');
                recurrence = moment.recur(startDate,endDate).every(yearlyRepeatMonthId).monthsOfYear().every(yearlyRepeatWeekId).daysOfWeek().every(helper.getWeekNumberOfWeek( yearlyWhichWeekId)).weeksOfMonthByDay();
             }

         }
         //debugger;
          if(startDate=="" || startDate== null  ){
              component.set('v.messageTitle','Warning');
              component.set('v.message','Please select Start Date to create recurrence!');
              component.set('v.showMessage',true);
              component.set('v.messageType','warning');
              setTimeout(function(){
              component.set('v.showMessage',false);
              }, 3000);
               console.log('em here');
               return;
           }
          debugger;
          var date1 =  new Date(new Date().toDateString());
          var startDate1 = new Date(new Date(startDate).toDateString());

          if(startDate1 < date1){
              console.log('em here'+startDate1+ '' +  date1);
                  component.set('v.messageTitle','Warning');
                  component.set('v.message','Start Date cannot be a past value.Please select a different date!');
                  component.set('v.showMessage',true);
                  component.set('v.messageType','warning');
                  setTimeout(function(){
                  component.set('v.showMessage',false);
                  }, 3000);
                  return;
                   }
           if(endDate=="" || endDate==null ){
               component.set('v.messageTitle','Warning');
               component.set('v.message','Please select End Date to create recurrence!');
               component.set('v.showMessage',true);
               component.set('v.messageType','warning');
               setTimeout(function(){
               component.set('v.showMessage',false);
                }, 3000);
                console.log('em here');
                 return;
                      }
            if(endDate < startDate ){
                component.set('v.messageTitle','Warning');
                component.set('v.message','End Date should be greater than start Date.Please select a different date!');
                component.set('v.showMessage',true);
                component.set('v.messageType','warning');
                setTimeout(function(){
                component.set('v.showMessage',false);
                }, 3000);
                return;
                 }

         helper.toggle(component);
         nextDates = recurrence.all("L");
         if(nextDates.length >=101 ){
         component.set('v.messageTitle','Warning');
         component.set('v.message','Unable to create recurrence as the maximum number of meetings in a recurrence cannot exceed 100. Please modify and try again!');
         component.set('v.showMessage',true);
         component.set('v.messageType','warning');
         setTimeout(function(){
         component.set('v.showMessage',false);
         }, 3000);
         return;
         }
         var action = component.get("c.getRecuranceDetails");
         var currentId = component.get("v.recordId");
         action.setParams({ campaignId : currentId, startEndDate : nextDates
              });
         action.setCallback(this,function(res){
            switch(res.getState()){
              case 'SUCCESS':
                 component.set('v.isComponentContentVisible',false);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     mode: 'pester',
                     type : 'success',
                     message: 'Campaign Recurrences are created!',
                     duration:1000
                 });
                 toastEvent.fire();
                  break;
              case 'INCOMPLETE':
                  break;
              case 'ERROR':
                  break;
          }
          helper.toggle(component);
         });
          $A.enqueueAction(action);
    },
	onRecurrencePatternChanged : function(component, event, helper) {
        component.set('v.isCustomPatternSelected',false);
        if(event.target){          
            var checkedStatus = event.target.value;
            var targetName = event.target.id;
            component.set('v.isDailyChecked',targetName === 'Daily');
            component.set('v.isWeeklyChecked',targetName === 'Weekly');
            component.set('v.isMonthlyChecked',targetName === 'Monthly');
            component.set('v.isYearlyChecked',targetName === 'Yearly');
           
            if(targetName === 'Daily'){
                var startDate = new Date();
                var endDate = new Date();
                endDate.setDate(startDate.getDate() + 1);
                component.set('v.StartDate',startDate.toISOString());
                component.set('v.endDate',endDate.toISOString());

            }
            else if(targetName === 'Weekly'){
                var startDate = new Date();
                var endDate = new Date();
                endDate.setDate(startDate.getDate() + 7);
                component.set('v.StartDate',startDate.toISOString());
                component.set('v.endDate',endDate.toISOString());

            }
            else if(targetName === 'Monthly'){
                 var startDate = new Date();
                 var endDate = new Date();
                 endDate.setDate(startDate.getDate() + helper.getDaysInMonth());
                component.set('v.StartDate',startDate.toISOString());
                component.set('v.endDate',endDate.toISOString());

            }
            else{
                var startDate = new Date();
                 var endDate = new Date();
                 endDate.setDate(startDate.getDate() + 365);
                component.set('v.StartDate',startDate.toISOString());
                component.set('v.endDate',endDate.toISOString());

            }
        }
	},
	onComponentShowClicked:function(component,event,helper){
	    component.set('v.isComponentContentVisible',true);
	},
	onModalCloseClicked:function(component,event,helper){
        component.set('v.isComponentContentVisible',false);
    }
})