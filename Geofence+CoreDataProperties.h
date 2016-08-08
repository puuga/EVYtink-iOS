//
//  Geofence+CoreDataProperties.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/13/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Geofence.h"

NS_ASSUME_NONNULL_BEGIN

@interface Geofence (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *placeName;
@property (nullable, nonatomic, retain) NSNumber *lattitude;
@property (nullable, nonatomic, retain) NSNumber *longtitude;
@property (nullable, nonatomic, retain) NSString *messageIn;
@property (nullable, nonatomic, retain) NSString *messageOut;
@property (nullable, nonatomic, retain) NSNumber *radius;
@property (nullable, nonatomic, retain) NSData *region;
@property (nullable, nonatomic, retain) NSString *objId;

@end

NS_ASSUME_NONNULL_END
