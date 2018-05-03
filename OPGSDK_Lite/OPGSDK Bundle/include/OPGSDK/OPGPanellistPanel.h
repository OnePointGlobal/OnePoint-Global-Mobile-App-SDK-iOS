//
//  OPGPanellistPanel.h
//  OnePointSDK
//
//  Created by OnePoint Global on 17/10/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGPanellistPanel : NSObject<NSCoding>
/*! @brief statusMessage : Authentication Status. */
@property (nonatomic,strong) NSString *statusMessage;

/*! @brief isSuccess : bool value of true indicates success and false indicates failure. */
@property (nonatomic,strong) NSNumber *isSuccess;
/*!
 * @brief panelPanelistArray : Array of OPGPanelPanellist objects
 */
@property(nonatomic,strong) NSArray *panelPanelistArray;
/*!
 * @brief panelsArray : Array of OPGPanel objects
 */
@property(nonatomic,strong) NSArray *panelsArray;
/*!
 * @brief themesArray : Array of OPGTheme objects
 */
@property(nonatomic,strong) NSArray *themesArray;
/*!
 * @brief surveyPanelArray : Array of OPGSurveyPanel objects
 */
@property(nonatomic,strong) NSArray *surveyPanelArray;


@end
