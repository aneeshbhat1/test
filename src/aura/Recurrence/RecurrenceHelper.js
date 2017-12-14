/**
 * Created by aneesh.bhat on 08-Sep-17.
 */
({
    getFullNameOfWeek:function(weekName){
        var weekValues={};
        weekValues['Su'] = 'Sunday';
        weekValues['M'] = 'Monday';
        weekValues['Tu'] = 'Tuesday';
        weekValues['W'] = 'Wednesday';
        weekValues['Th'] = 'Thursday';
        weekValues['F'] = 'Friday';
        weekValues['Sa'] = 'Saturday';
        return weekValues[weekName];
    },
    getWeekNumberOfWeek:function(weekNumberName){
        var weekNumber={};
        weekNumber['First'] = 0;
        weekNumber['Second'] =1;
        weekNumber['Third'] = 2;
        weekNumber['Fourth'] = 3;
        weekNumber['Last'] = 4;
        return weekNumber[weekNumberName];
    },
    getDaysInMonth : function(){
       var now = new Date();
       return new Date(now.getFullYear(), now.getMonth()+1, 0).getDate();
    },
    toggle: function (cmp) {
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }
})