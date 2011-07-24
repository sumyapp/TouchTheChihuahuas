//
//  TTDDroidView.h
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    droid_GColor = 0,
    droid_Green
};

@protocol TTDDroidViewDelegate;

@interface TTDDroidView : UIView {
    UIImageView *droidImageView;
    float _angle;
    int _colorType;
    
    id delegate;
    int number;
    float targetPosX;
    float targetPosY;
    float velocity;
}
- (NSString*)description;
@property (nonatomic) int colorType;
@property (nonatomic) float angle;
@property (assign, readwrite) id delegate;
@property int number;
@property float targetPosX;
@property float targetPosY;
@property float velocity;
@end

@protocol TTDDroidViewDelegate
- (void)droidViewTouched:(TTDDroidView*)droidView;
@end
