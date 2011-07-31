//
//  TTDDroidView.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    droid_Green = 0,
    droid_GColor
};

@protocol TTDDroidViewDelegate;

@interface TTDDroidView : UIImageView {
    int _colorType;
    int number;
    id delegate;
}
- (NSString*)description;
@property (nonatomic) int colorType;
@property int number;
@property (assign, readwrite) id delegate;
@end

@protocol TTDDroidViewDelegate
- (void)destroyDroid:(TTDDroidView*)droidView;
@end