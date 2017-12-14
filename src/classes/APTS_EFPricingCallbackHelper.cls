/**************************************************************************************
Apex Class Name    : APTS_EFPricingCallbackHelper
Version            : 1.0
Created Date       : September 15 2017
Function           : Created for adding complex pricing calculations.
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/14/2017              Original Version
*******************************************************************************/
public class APTS_EFPricingCallbackHelper{

    /*
    Description : Helper Method to calculate course pricing based on Matrix for more than 1 course added
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    public static Double updateCoursePricingOnMatrix(Apttus_Config2__LineItem__c item, Double currentThreshHold, Map<Id,List<Apttus_Config2__PriceMatrixEntry__c>> lineItemPriceMatrixMap){

        try{

            if(item.Apttus_Config2__Quantity__c < currentThreshHold){

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice = (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c);
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                    currentThreshHold = currentThreshHold - item.Apttus_Config2__Quantity__c;
                }
            }
            else if(item.Apttus_Config2__Quantity__c > currentThreshHold){

                //if threshold is in minus make it 0 for calcualtions
                if(currentThreshHold < 0){
                    currentThreshHold = 0;
                }

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice = (item.Apttus_Config2__SellingTerm__c * currentThreshHold * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c) + (item.Apttus_Config2__SellingTerm__c * (item.Apttus_Config2__Quantity__c - currentThreshHold) * lineItemPriceMatrixMap.get(item.Id).get(1).Apttus_Config2__AdjustmentAmount__c);
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                    currentThreshHold = currentThreshHold - item.Apttus_Config2__Quantity__c;
                }
            }
            else if(item.Apttus_Config2__Quantity__c == currentThreshHold){

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice  = (item.Apttus_Config2__SellingTerm__c * currentThreshHold * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c) ;
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                    currentThreshHold = currentThreshHold - item.Apttus_Config2__Quantity__c;
                }
            }
        }
        catch (Exception ex) {
            system.debug('Exception in APTS_EFPricingCallbackHelper updateCoursePricingOnMatrix :--- ');
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'APTS_EFPricingCallbackHelper', 'updateCoursePricingOnMatrix', item.Id);
        }
        
        //return the current threshold for next calculation
        return currentThreshHold;
    }

    /*
    Description : Helper Method to calculate course pricing based on Matrix for more than 1 course added
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    public static void updatePricingForComparitive(Apttus_Config2__LineItem__c item, Double currentThreshHold, Map<Id,List<Apttus_Config2__PriceMatrixEntry__c>> lineItemPriceMatrixMap){

        try{

            if(item.Apttus_Config2__Quantity__c < currentThreshHold){

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice = (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c);
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                }
            }
            else if(item.Apttus_Config2__Quantity__c > currentThreshHold){

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice = (item.Apttus_Config2__SellingTerm__c * currentThreshHold * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c) 
                                            + (item.Apttus_Config2__SellingTerm__c * (item.Apttus_Config2__Quantity__c - currentThreshHold) * lineItemPriceMatrixMap.get(item.Id).get(1).Apttus_Config2__AdjustmentAmount__c);
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                }
            }
            else if(item.Apttus_Config2__Quantity__c == currentThreshHold){

                if(lineItemPriceMatrixMap.containsKey(item.Id) && !(lineItemPriceMatrixMap.get(item.Id)).isEmpty()){

                    //need to calculate extended price and derive the base price
                    double extendedPrice  = (item.Apttus_Config2__SellingTerm__c * currentThreshHold * lineItemPriceMatrixMap.get(item.Id).get(0).Apttus_Config2__AdjustmentAmount__c) ;
                    item.Apttus_Config2__BasePrice__c = extendedPrice / (item.Apttus_Config2__SellingTerm__c * item.Apttus_Config2__Quantity__c);
                }
            }
        }
        catch (Exception ex) {
            system.debug('Exception in APTS_EFPricingCallbackHelper updatePricingForComparitive :--- ');
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'APTS_EFPricingCallbackHelper', 'updatePricingForComparitive', item.Id);
        }
    }
}