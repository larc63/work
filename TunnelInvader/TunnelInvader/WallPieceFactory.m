//
//  WallPieceFactory.m
//  TunnelInvader
//
//  Created by Luis Antonio Rodriguez on 1/11/14.
//  Copyright (c) 2014 Luis Antonio Rodriguez. All rights reserved.
//

#import "WallPieceFactory.h"

@implementation WallPieceFactory

+(id)wallPieceWithWidth:(NSNumber*) width{
    SKSpriteNode* ret = [SKSpriteNode spriteNodeWithImageNamed:@"Wall"];
    ret.size = CGSizeMake([width floatValue], WALL_PIECE_HEIGHT);
    return ret;
}

@end
