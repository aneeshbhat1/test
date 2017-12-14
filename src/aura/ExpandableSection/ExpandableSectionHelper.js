/**
 * Created by aneesh.bhat on 28-Jul-17.
 */
({
    toggle: function (cmp) {
            var spinner = cmp.find("sectionHeader");
            $A.util.toggleClass(spinner, "slds-is-open");

            var spinner = cmp.find("content");
            $A.util.toggleClass(spinner, "slds-hide");
        }
})