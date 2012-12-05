//
//  MyBookInfoParser.h
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyBookInfoParser;

@protocol MyBookInfoParserDelegate <NSObject>

- (void)MyBookInfoParserDidFinishParsing:(MyBookInfoParser *)myBookInfoParser;

@end

@interface MyBookInfoParser : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData* receivedData;
@property (strong, nonatomic) NSMutableArray *myBooksInfoList;
@property (strong, nonatomic) id delegate;

- (void)handleDataWithString:(NSString *)htmlString;

@end
