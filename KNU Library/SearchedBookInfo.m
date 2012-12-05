//
//  SearchedBookInfo.m
//  KNU Library
//
//  Created by apple03 on 12. 5. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SearchedBookInfo.h"

@implementation SearchedBookInfo

@synthesize bookName;
@synthesize bookCNum;
@synthesize bookAuthor;
@synthesize bookPublisher;
@synthesize bookPubYear;
@synthesize bookPosition;
@synthesize bookCode;
@synthesize bookStatus;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookName         forKey:@"bookName"];
    [encoder encodeObject:self.bookCNum         forKey:@"bookCNum"];
    [encoder encodeObject:self.bookAuthor       forKey:@"bookAuthor"];
    [encoder encodeObject:self.bookPublisher    forKey:@"bookPublisher"];
    [encoder encodeObject:self.bookPubYear      forKey:@"bookPubYear"];
    [encoder encodeObject:self.bookPosition     forKey:@"bookPosition"];
    [encoder encodeObject:self.bookCode         forKey:@"bookCode"];
    [encoder encodeObject:self.bookStatus       forKey:@"bookStatus"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.bookName       = [decoder decodeObjectForKey:@"bookName"];
        self.bookCNum       = [decoder decodeObjectForKey:@"bookCNum"];  
        self.bookAuthor     = [decoder decodeObjectForKey:@"bookAuthor"];
        self.bookPublisher  = [decoder decodeObjectForKey:@"bookPublisher"];  
        self.bookPubYear    = [decoder decodeObjectForKey:@"bookPubYear"];  
        self.bookPosition   = [decoder decodeObjectForKey:@"bookPosition"]; 
        self.bookCode       = [decoder decodeObjectForKey:@"bookCode"];
        self.bookStatus     = [decoder decodeObjectForKey:@"bookStatus"];  
    }
    return self;
} 

@end
