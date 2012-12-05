//
//  SeatInfo.h
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatInfo : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (nonatomic) NSInteger totalNumbersOfSeats;
@property (nonatomic) NSInteger currentUsedNumbersOfSeats;
@property (nonatomic) NSInteger currentAvailableNumbersOfSeats;
@property (strong, nonatomic) NSString *usagePercentage;

@end
