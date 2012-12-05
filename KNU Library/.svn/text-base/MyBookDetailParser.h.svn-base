//
//  MyBookDetailParser.h
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

// bookID를 가지고 도서의 상세정보를 파싱해 SearchedBookInfo 구조체를 만드는 것이 목적

#import <Foundation/Foundation.h>
#import "SearchedBookInfo.h"

@class MyBookDetailParser;

@protocol MyBookDetailParserDelegate <NSObject>

- (void)MyBookDetailParserDidFinishParsing:(SearchedBookInfo *)searchedBookInfo;

@end

@interface MyBookDetailParser : NSObject<NSURLConnectionDelegate>

@property (strong, nonatomic) SearchedBookInfo *myBookDetailInfo;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (strong, nonatomic) id delegate;

- (void)handleDataWithString:(NSString *)htmlString;

@end
