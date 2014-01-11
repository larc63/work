//
//  MyScene.m
//  TunnelInvader
//
//  Created by Luis Antonio Rodriguez on 1/8/14.
//  Copyright (c) 2014 Luis Antonio Rodriguez. All rights reserved.
//


#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Press spacebar to start";
        myLabel.fontSize = 65;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        
        CGPoint location = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMinY(self.frame) + 20);
        self.sprite = [SpaceShip spaceShipWithImage:@"Spaceship" location:location];
        [self addChild:self.sprite];
        
    }
    return self;
}

//-(void)mouseDown:(NSEvent *)theEvent {
//     /* Called when a mouse click occurs */
//
//
//
//
//
//
//    [sprite runAction:[SKAction repeatActionForever:action]];
//
//
//}

-(void)keyDown:(NSEvent *)theEvent{
    NSString* s = [theEvent charactersIgnoringModifiers];
    NSLog(@"keypressed : %@", s);
    if ([s isEqualToString:@"a"]) {
        //move left
        NSLog(@"move left");
        SKAction *action = [SKAction moveBy:CGVectorMake(-20, 0) duration:0.5];
        [self.sprite runAction:action];
    }else if ([s isEqualToString:@"d"]) {
        //move right
        NSLog(@"move right");
        SKAction *action = [SKAction moveBy:CGVectorMake(20, 0) duration:0.5];
        [self.sprite runAction:action];
    }if ([s isEqualToString:@"w"]) {
        //move up
        NSLog(@"move up");
    }if ([s isEqualToString:@"s"]) {
        //move down
        NSLog(@"move down");
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
