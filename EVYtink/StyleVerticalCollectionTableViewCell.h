//
//  StyleVerticalCollectionTableViewCell.h
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StyleVerticalCollectionTableViewCellDelegate <NSObject>

-(void)showSelected:(NSIndexPath *)indexPath indexRows:(NSIndexPath *)indexRow;

@required
@end


@interface StyleVerticalCollectionTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionStyleVertical;
@property (nonatomic,strong) NSMutableArray *arrBook;

@property (nonatomic,strong) NSIndexPath *indexRow;


@property (assign, nonatomic) id<StyleVerticalCollectionTableViewCellDelegate> delegate;


@end
