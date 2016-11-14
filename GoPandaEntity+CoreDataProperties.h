//
//  GoPandaEntity+CoreDataProperties.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 28.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GoPandaEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoPandaEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isAccelerometerON;

@end

NS_ASSUME_NONNULL_END
