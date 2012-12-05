//
//  MyBookRenewer.h
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 6. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyBookRenewer;

@protocol MyBookRenewerDelegate <NSObject>

- (void)MyBookRenwerDidFinishRenew:(MyBookRenewer *)myBookRenewer;

@end

@interface MyBookRenewer : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *cookie;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (strong, nonatomic) id delegate;

@end
