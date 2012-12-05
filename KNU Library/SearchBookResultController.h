//
//  SearchBookResultController.h
//  KNU Library
//
//  Created by 용빈 배 on 12. 5. 21..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchedBookInfo.h"

#define SEARCH_RESULT_HEIGHT 131
#define SEARCH_MSG_HEIGHT 120

@class SearchBookResultController;

@protocol SearchBookResultControllerDelegate <NSObject>

- (void)SearchBookResultControllerDidShowBookSearchDetail:(SearchedBookInfo *)searchedBookInfo;

@end

@interface SearchBookResultController : UITableViewController<NSURLConnectionDelegate>

@property (strong, nonatomic) NSString *searchKeyword;
@property (nonatomic) NSInteger sizeOfBooksToSearch;
//@property (nonatomic) NSInteger numberOfPageToSearch;

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableArray *searchResultBookList;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic) BOOL isLoadingFinished;
@property (strong, nonatomic) id delegate;

@end
