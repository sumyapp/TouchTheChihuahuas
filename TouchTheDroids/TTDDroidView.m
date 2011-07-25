//
//  TTDDroidView.m
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TTDDroidView.h"

@implementation TTDDroidView
@dynamic angle;
@dynamic colorType;
@synthesize delegate;
@synthesize number;
@synthesize targetPosX;
@synthesize targetPosY;
@synthesize velocity;

- (NSString*)description {
    return [NSString stringWithFormat:@"droidColor = %d, droidNumber = %d, droidPosX = %f, droidPosY = %f, droidWidth = %f, droidHeight = %f, angle = %f,  droidTargetPosX = %f, droidTargetPosY = %f", _colorType, number, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, _angle, targetPosX, targetPosY];
}

- (void)setFrame:(CGRect)frame {
    if(CGRectIsNull(_orgFrame) || CGRectIsEmpty(_orgFrame)) {
        _orgFrame = frame;
    }
    [super setFrame:frame];
}

- (CGRect)orgFrame {
    return _orgFrame;
}

- (void)setAngle:(float)angle {
    LOG_METHOD
    _angle = angle;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [self setTransform:rotate];
}

- (float)getAngle {
    LOG_METHOD
    return _angle;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LOG_METHOD
    [delegate droidViewTouched:self];
}

- (void)setColorType:(int)color {
    LOG_METHOD
    _colorType = color;
    switch (color) {
        case droid_Green:
            [droidImageView setImage:[UIImage imageNamed:@"droid_green.png"]];
            break;
        case droid_GColor:
            [droidImageView setImage:[UIImage imageNamed:@"droid_gcolor.png"]];
            break;
        default:
            LOG(@"WARNING: this swich section not use");
            break;
    }
}

- (int)getColorType {
    LOG_METHOD
    return _colorType;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        droidImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [droidImageView setImage:[UIImage imageNamed:@"droid_gcolor.png"]];
        [droidImageView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:droidImageView];
        
        _orgFrame = frame;
    }
    return self;
}

- (void)dealloc {
    LOG_METHOD
    [super dealloc];
    [droidImageView release], droidImageView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
