//
//  SpaceShip.m
//  TunnelInvader
//
//  Created by Luis Antonio Rodriguez on 1/8/14.
//  Copyright (c) 2014 Luis Antonio Rodriguez. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip

+(id)spaceShipWithImage: (NSString*) s location:(CGPoint) p {
    SpaceShip* ret = (SpaceShip*)[SKSpriteNode spriteNodeWithImageNamed:s];
    ret.position = p;
    ret.scale = 0.5;
    return ret;
};

@end
