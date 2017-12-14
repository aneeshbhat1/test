/**************************************************************************************
Apex Class Name    : APTS_Constants
Version            : 1.0
Created Date       : September 19 2017
Function           : Created for adding constants used in applications.
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/19/2017              Original Version
*******************************************************************************/
public class APTS_Constants {
    
    //Added by Arjun to check get Unique Id based on Linetype in Proposal Line item
    public static final String PROPOSALLINEITEM_TYPE_PRODUCTSERVICE= 'Product/Service';
    public static final String PROPOSALLINEITEM_TYPE_OPTION= 'Option';

    public static final String ProductType_COURSE= 'Course';

    public static final String LINEITEM_UOM_EACH= 'Each';
    public static final String LINEITEM_UOM_WEEK= 'Week';
    public static final String LINEITEM_UOM_HOUR= 'Hour';
    public static final String LINEITEM_UOM_MONTH= 'Month';
    public static final String LINEITEM_UOM_DAY= 'Day';
    public static final String LINEITEM_UOM_YEAR= 'Year';
    public static final String FIXEDFAREFLIGHTCODE= 'FTEFX';
    public static final Integer COURSEOFFSET= 4;




    //added by mitul for checking APTTUS Adjustment Type Price Override
    public static final String PRODUCT_ADJUSTMENT_TYPE_PRICE_OVERRIDE = 'Price Override';
    public static final String VALIDATE_CART_PAGE_ACTION_FINALIZE = 'Finalize';

    //added by mitul to add checkpoints for validation of total discount
    public static final String VALIDATE_CART_GRAND_TOTAL = 'Grand Total';

    //added by mitul for adding product subtype books
    public static final String PRODUCT_SUB_TYPE_BOOKS = 'Books';

    //added by mitul for SFA-18, required value for UK
    public static final String PRODUCT_COUNTRY_UK_VALUE = 'GB';
    public static final String PRODUCT_TYPE_ACCOMODATION = 'Accommodation';
    public static final String PRODUCT_SUB_TYPE_HOST_FAMILY = 'Host Family';
    public static final String PRODUCT_SUB_TYPE_HOTEL = 'Hotel';
    public static final String PRODUCT_SUB_TYPE_RESIDENCE = 'Residence';
    public static final String PRODUCT_FAMILY_JUNIOR_COURSES = 'Junior Course';

    //added by mitul for SFA-120 for course quantity roll up
    public static final String PRODUCT_LANGUAGE_ENGLISH = 'English';
    public static final String PRODUCT_LANGUAGE_NON_ENGLISH = 'Non English';
    public static final String PRODUCT_CODE_NON_ENGLISH = 'COLN';
    public static final String PRODUCT_CODE_ENGLISH = 'COL';
    public static final String LINE_ITEM_PRICING_STATUS_PENDING = 'Pending';
    public static final String PRODUCT_SUB_TYPE_Season_Supplements = 'Season Supplements';
    public static final String PRODUCT_TYPE_COURSE = 'Course';
}