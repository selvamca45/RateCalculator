//
//  DataModel.m
//  TTDNow
//
//  Created by Vishnu Priya on 06/04/16.
//  Copyright © 2016 HTC Global Services. All rights reserved.
//

#import "DataModel.h"
#import "DropDownModel.h"
//#import "TMBaseSynchronization.h"

@implementation DataModel
static DataModel *sharedInstance = nil;
NSMutableDictionary *defaultFiledDictionary=nil;
NSMutableDictionary *lovDataMapper=nil;
NSMutableDictionary *patientInformation = nil;
NSMutableDictionary *lovLists = nil;
NSDictionary *picturesDictionary =nil;
NSString *dropDownString;

+(id)shareManager
{
    if (sharedInstance == nil) {
        sharedInstance = [[DataModel alloc] init];
        
    }
    return  sharedInstance;
}


-(NSMutableArray*)getDefaultFieldForScreenName:(NSString*)screenName
{
    if (defaultFiledDictionary == nil) {
        defaultFiledDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultListFields" ofType:@"plist"]];
    }
    return [defaultFiledDictionary objectForKey:screenName];
}


-(NSString*)getLovWebserviceName:(NSString*)screenName
{
    if (lovDataMapper == nil) {
        lovDataMapper = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LovWebServiceMapping" ofType:@"plist"]];
    }
    return [lovDataMapper objectForKey:screenName];
}

-(NSDictionary*)getImageArray
{
    if(picturesDictionary == nil)
    {
        picturesDictionary= [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageMap" ofType:@"plist"]];
    }

    return picturesDictionary;
}


-(void)setPatientDetails:(id)patientData
{
    if (patientInformation ==nil) {
        patientInformation = [[NSMutableDictionary alloc] init];
    }
    [patientInformation removeAllObjects];
    [patientInformation addEntriesFromDictionary:patientData];
}
-(id)getPatientData
{
    return patientInformation;
}


-(NSArray*)getLovListforPlaceHolder:(NSString*)stringType
{
    
    if (lovLists == nil) {
        lovLists = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LovLists" ofType:@"plist"]];
    }
    NSArray *temp =[lovLists objectForKey:stringType];
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    for (id dict in temp) {
        DropDownModel *model = [[DropDownModel alloc] init];
        model.modelIdString = [dict objectForKey:@"ID"];
        model.modelDataString = [dict objectForKey:@"Name"];
        [listArray addObject:model];
    }
    return listArray;

}

-(NSArray*)getLovListforResponseData:(id)dataArray
{
    
    
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    for (id dict in dataArray) {
        DropDownModel *model = [[DropDownModel alloc] init];
        model.modelIdString = [dict objectForKey:@"uuid"];
        model.modelDataString = [dict objectForKey:@"displayString"];
        [listArray addObject:model];
    }
    return listArray;
    
}

-(void)getLovDataforPlaceHolder:(NSString*)stringType withDelegate:(id)delegate
{
    _delegate =delegate;
    dropDownString = [self getLovWebserviceName:[stringType lowercaseString]];
    if (dropDownString !=nil) {
//        [self connectServerForScreen:dropDownString];
    }
    else
    {
        id array=[self getDropDownListForPlaceholder:stringType];
        if([self.delegate respondsToSelector:@selector(loadDataForArray:)])
        {
            [self.delegate loadDataForArray:array];
        }
    }

}

-(NSMutableArray *)getDropDownListForPlaceholder:(NSString*)strType{
   NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    
    
//    if([strType isEqualToString:@"Travel Mode"]){
//        dataArray = [NetwrokManager sharedInstance].trvlModelLovArray;
//    }
//    else if([strType isEqualToString:@"From Country"]||[strType isEqualToString:@"To Country"]){
//        dataArray = [NetwrokManager sharedInstance].countryListLovArray;
//    }
//    else if([strType isEqualToString:@"Project"]){
//        dataArray = [NetwrokManager sharedInstance].projectListLovArray;
//    }
//    else if([strType isEqualToString:@"Cost Centre"]){
//        dataArray = [NetwrokManager sharedInstance].costCenterListLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Allowance Type"]){
//        dataArray = [NetwrokManager sharedInstance].travelAllowanceTypeLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Type"]){
//        dataArray = [NetwrokManager sharedInstance].trvlTypeLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Classification"]){
//        dataArray = [NetwrokManager sharedInstance].trvlClassificationListLovArray;
//    }
//    else if([strType isEqualToString:@"Advance Type"]){
//        dataArray = [NetwrokManager sharedInstance].trvlAdvanceTypeListLovArray;
//    }
//    else if([strType isEqualToString:@"Currency"]){
//        dataArray = [NetwrokManager sharedInstance].currencyListLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Category"]){
//        dataArray = [NetwrokManager sharedInstance].trvlCategoryListLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Sub Category"]){
//        dataArray = [NetwrokManager sharedInstance].trvlSubCategoryListLovArray;
//    }
//    else if([strType isEqualToString:@"Travel Scope"]){
//        dataArray = [NetwrokManager sharedInstance].trvlScopeListLovArray;
//    }
//    else if ([strType isEqualToString:@"Domestic Travel Mode"]){
//        dataArray = [NetwrokManager sharedInstance].domesticTravelModeLovArray;
//    }
//    else if ([strType isEqualToString:@"International Travel Mode"]){
//        dataArray = [NetwrokManager sharedInstance].internationalTravelModeLovArray;
//    }
//    else if ([strType isEqualToString:@"Domestic Allowance Type"]){
//        dataArray = [NetwrokManager sharedInstance].domesticAllowanceTypeLovArray;
//    }
//    else if ([strType isEqualToString:@"International Allowance Type"]){
//        dataArray = [NetwrokManager sharedInstance].internationalAlowanceTypeLovArray;
//    }
//    else if([strType isEqualToString:@"Upload"] || [strType isEqualToString:@"Camera"]){
//        dataArray = [NetwrokManager sharedInstance].uploadListLovArray;
//    }
//    else if ([strType isEqualToString:@"Status"]){
//        dataArray = [NetwrokManager sharedInstance].advanceStatusLovArray;
//    }
//    else if ([strType isEqualToString:@"Title"]){
//        dataArray = [NetwrokManager sharedInstance].titleListLovArray;
//    }
//    else if ([strType isEqualToString:@"Document Type"]){
//        dataArray = [NetwrokManager sharedInstance].docTypeLovArray;
//    }
//    else if ([strType isEqualToString:@"Letter Type"]){
//        dataArray = [NetwrokManager sharedInstance].letterTypeLovArray;
//    }
//    else if ([strType isEqualToString:@"DocumentID Type"]){
//        dataArray = [NetwrokManager sharedInstance].docIDTypeLovArray;
//    }
//    else if ([strType isEqualToString:@"Insurance Type"]){
//        dataArray = [NetwrokManager sharedInstance].insuranceTypeLovArray;
//    }
//    else if ([strType isEqualToString:@"Relationship"]){
//        dataArray = [NetwrokManager sharedInstance].relationshipLovArray;
//    }
//    else{
//        dataArray = [NetwrokManager sharedInstance].yesNoListLovArray;
//    }
//    NSMutableArray *listArray = [[NSMutableArray alloc] init];
//
//    for (int id1=0;id1<[dataArray count];id1++) {
//        LOVDataModel *model1=[dataArray objectAtIndex:id1];
//        DropDownModel *model = [[DropDownModel alloc] init];
//        if (model1.costCenterId) {
//            model.modelCostIdString = [model1.costCenterId stringValue];
//        }
//        if (model1.categoryId) {
//            model.modelCategoryString = [model1.categoryId stringValue];
//        }
//        if(model1.status)
//        {
//            model.status = model1.status;
//        }
//        if (model1.type) {
//            model.type = model1.type;
//        }
//        model.modelIdString = [model1.lovId stringValue];
//        model.modelDataString = model1.lovValue;
//        [listArray addObject:model];
//    }
    return dataArray;//listArray;
}


@end
