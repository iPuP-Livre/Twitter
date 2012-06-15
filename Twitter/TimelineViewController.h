//
//  TimelineViewController.h
//  Twitter
//
//  Created by Marian PAUL on 09/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterTLManager.h"

@interface TimelineViewController : UITableViewController <TwitterTLManagerDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
}
@end
