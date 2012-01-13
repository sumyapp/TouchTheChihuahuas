//
//  TouchTheDroidsAppDelegate.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchTheDroidsViewController;

@interface TouchTheDroidsAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet TouchTheDroidsViewController *viewController;

@end
