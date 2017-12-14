/**
 * Created by aneesh.bhat on 06-Sep-17.
 */
({
    toggle: function (cmp) {
      var spinner = cmp.find("modalDialog");
      $A.util.toggleClass(spinner, "slds-hide");
  }
})