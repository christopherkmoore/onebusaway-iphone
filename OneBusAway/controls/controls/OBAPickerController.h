//
//  OBAPickerController.h
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/12/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OBAPickerController;
@protocol OBAPickerDelegate <NSObject>

- (void)picker:(OBAPickerController*)picker didSelectTimeInterval:(NSTimeInterval)timeInterval;

@end

@interface OBAPickerController : UIViewController
@property(nonatomic,weak) id<OBAPickerDelegate> delegate;

@end
