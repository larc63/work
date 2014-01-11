//
//  WallPieceFactory.h
//  TunnelInvader
//
//  Created by Luis Antonio Rodriguez on 1/11/14.
//  Copyright (c) 2014 Luis Antonio Rodriguez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define WALL_PIECE_HEIGHT       10.0

@interface WallPieceFactory : SKSpriteNode
+(id)wallPieceWithWidth:(NSNumber*) width;
@end
