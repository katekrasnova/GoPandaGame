//
//  DPHandlesGoPandaEntity.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 29.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoPandaEntity.h"

@protocol DPHandlesGoPandaEntity <NSObject>

- (void)receiveGoPandaEntity: (GoPandaEntity *)incomingGoPandaEntity;

@end
