//
//  TTDDroidView.m
//  TouchTheDroids
//
//  Created by sumy on 11/07/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TTDDroidView.h"

@implementation TTDDroidView
@dynamic colorType;
@synthesize number;
@synthesize delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LOG_METHOD
    [delegate destroyDroid:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"droidColor = %d, droidNumber = %d, droidPosX = %f, droidPosY = %f, droidWidth = %f, droidHeight = %f", _colorType, number, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height];
}

- (void)setColorType:(int)color {
    LOG_METHOD
    _colorType = color;
    switch (color) {
        case droid_Green:
            [self setImage:[UIImage imageNamed:@"tiwawa_white.png"]];
            break;
        case droid_GColor:
            [self setImage:[UIImage imageNamed:@"tiwawa_white.png"]];
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
        [self setImage:[UIImage imageNamed:@"tiwawa_white.png"]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)dealloc {
    LOG_METHOD
    [super dealloc];
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
