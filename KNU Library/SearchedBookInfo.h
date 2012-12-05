//
//  SearchedBookInfo.h
//  KNU Library
//
//  Created by apple03 on 12. 5. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchedBookInfo : NSObject<NSCoding>

@property (strong, nonatomic) NSString *bookName;
@property (strong, nonatomic) NSString *bookCNum;
@property (strong, nonatomic) NSString *bookAuthor;
@property (strong, nonatomic) NSString *bookPublisher;
@property (strong, nonatomic) NSString *bookPubYear;
@property (strong, nonatomic) NSString *bookPosition;
@property (strong, nonatomic) NSString *bookCode;
@property (strong, nonatomic) NSString *bookStatus;

@end
