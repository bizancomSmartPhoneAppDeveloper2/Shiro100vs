//
//  VSModeViewController.m
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/14.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "VSModeViewController.h"

#import "AppDelegate.h"
#import "RankTableViewCell.h"
#import "VSRankTableViewCell.h"
#import "MyRankTableViewCell.h"

@interface VSModeViewController ()
{
	
@private
	
	AppDelegate *app;
	
	NSMutableArray *array_Like;
	
	BOOL bool_Error;

	NSInteger integer_Height;
	
}

@end

@implementation VSModeViewController

- (void)viewDidLoad
{
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	app = [[UIApplication sharedApplication] delegate];
	
	//tableviewのデリゲート、データソースを自分自身にする
	self.tableView.delegate   = self;
	self.tableView.dataSource = self;
	
	app.bool_MyRank = YES;
	bool_Error = NO;

}

- (void)viewWillAppear: (BOOL)animated
{
	
	if ( app.bool_MyRank ) {
		
		NSArray *array = [self serverdata: @"http://smartshinobu.miraiserver.com/shiro/likeshirorank.php"];
		
		array_Like = [[NSMutableArray alloc] init];
		
		NSInteger i = 0;
		
		for ( NSDictionary *dic in array ) {
			
			NSString *str_shiro = [dic objectForKey: @"shironame"];
			
			NSString *str_yeano;
			if ( [str_shiro isEqualToString: app.string_Shikan] ) {
				str_yeano = @"=";
			} else {
				str_yeano = @"≠";
			}
			
			//気に入っている城の名前と一緒であるかどうか
			NSLog( @"%d : %@ %@ %@", (int)i , str_shiro, str_yeano, app.string_Shikan );
			
			if ( [str_shiro isEqualToString: app.string_Shikan] ) {
				
				//自分が気に入っている城の前後のランキング情報を取る処理
				for ( NSInteger k = i - 1; k <= i + 1 ; k ++ ) {
					
					if ( ( k >= 0 ) && ( k < [array count] ) ) {
						
						NSDictionary *dic_now = [array objectAtIndex: k];
						
						NSMutableDictionary *dic_add = [[NSMutableDictionary alloc] initWithDictionary: dic_now];
						
						NSNumber *number = [NSNumber numberWithInteger: k + 1];
						
						[dic_add setObject: number forKey: @"rankno"];
				
						NSString *str_shiro = [dic_add objectForKey: @"shironame"];
						if ( [str_shiro isEqualToString: app.string_Shikan] ) {

							[dic_add setObject: @"now" forKey: @"genjyou"];
							
							NSInteger int_back = k - 1;
							if ( int_back < 0 ) {
								[dic_add setObject: @"NO"  forKey: @"back_data"];
							} else {
								[dic_add setObject: @"YES" forKey: @"back_data"];
								
								NSDictionary *dic_back  = [array objectAtIndex: int_back];
								NSString *str_tag_count = [dic_back objectForKey: @"tagcount"];
								NSInteger int_tag_back  = str_tag_count.integerValue;
								
								str_tag_count           = [dic_add  objectForKey: @"tagcount"];
								NSInteger int_tag_now   = str_tag_count.integerValue;
								
								str_tag_count = [NSString stringWithFormat:
												 @"下剋上するまで %d 枚", (int)( int_tag_back - int_tag_now )];
							
								[dic_add setObject: str_tag_count forKey: @"下剋上_1"];
							}
							
							NSInteger int_next = k + 1;
							if ( int_next > [array count] ) {
								[dic_add setObject: @"NO"  forKey: @"next_data"];
							} else {
								[dic_add setObject: @"YES" forKey: @"next_data"];
								
								NSString *str_tag_count = [dic_add  objectForKey: @"tagcount"];
								NSInteger int_tag_now   = str_tag_count.integerValue;

								NSDictionary *dic_next  = [array objectAtIndex: int_next];
								str_tag_count           = [dic_next objectForKey: @"tagcount"];
								NSInteger int_tag_next  = str_tag_count.integerValue;
								
								
								str_tag_count = [NSString stringWithFormat:
												 @"下剋上されるまで %d 枚", (int)( int_tag_now - int_tag_next )];
								
								[dic_add setObject: str_tag_count forKey: @"下剋上_2"];
							}
							
						} else {

							[dic_add setObject: @"now" forKey: @"genjyou"];
						}

						[array_Like addObject: dic_add];
						
					}
					
				}
				
				NSLog(@"array_Like のカウントは %d", (int)array_Like.count );
				
				break;
				
			}
			
			i ++;
			
		}
		
		[self.tableView reloadData];
		
		if ( bool_Error == YES ) {
			
			app.bool_MyRank = YES;
			
		} else {
			
			app.bool_MyRank = NO;
			
		}
		
	}
	
}

- (void)viewDidAppear: (BOOL)animated
{
	
}

- (void)viewWillDisappear: (BOOL)animated
{
	
}

- (void)viewDidDisappear: (BOOL)animated
{
	
}

- (void)didReceiveMemoryWarning
{
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	
}

//テーブルのセルの数を返すためのメソッド
- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
	
	return array_Like.count;
	
}

//テーブルのセクションの数を返すためのメソッド
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
	
	return 1;
	
}

//テーブルのセルの内容を返すメソッド
- (UITableViewCell *)tableView: (UITableView *)tableView
		 cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	
	NSDictionary *dic = array_Like[indexPath.row];
	
	NSString *shiro_name = [dic objectForKey: @"shironame"];
	
	if ( [shiro_name isEqualToString: app.string_Shikan] ) {
		
		MyRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Shiro_MyRank"];
		
		integer_Height = tableView.frame.size.width - 16;
		
		cell.imageView_Shiro.translatesAutoresizingMaskIntoConstraints = YES;
		cell.imageView_Shiro.frame = CGRectMake( 8, 8, integer_Height, integer_Height );

		dispatch_queue_t q_global = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
		dispatch_queue_t q_main   = dispatch_get_main_queue();
		
		dispatch_async( q_global, ^{
			
			UIImage *image = [self WebImage: [dic objectForKey: @"imagename"]];
			
			dispatch_async( q_main, ^{
				
				cell.imageView_Shiro.image       = image;
				cell.imageView_Shiro.contentMode = UIViewContentModeScaleAspectFit;
				cell.imageView_Shiro.alpha       = 0.5;
				
			});
			
		});
		
		NSString *str_back = [dic objectForKey: @"back_data"];
		if ( [str_back isEqualToString: @"YES"] ) {
			
			cell.imageView_My_1.image = [UIImage imageNamed: @"war_taiji_2.png"];
			
			cell.label_Gekokyu_1.text = [dic objectForKey: @"下剋上_1"];

		}
		
		NSNumber *number = [dic objectForKey: @"rankno"];
		
		cell.label_Rank.text = [NSString stringWithFormat: @"第%d位", [number intValue]];
		
		//shirolabelを城の名前を表示するように設定
		cell.label_Shiro.text = shiro_name;

		//タグの投稿数の文字列を格納
		NSString *tagcount = [dic objectForKey: @"tagcount"];

		//ブロックに関する文字列を格納
		NSString *block = [dic objectForKey: @"block"];
		
		//taglabelをブロックとタグの投稿数を表示するように設定
		cell.label_Comment.text = [NSString stringWithFormat: @"ブロック:%@ タグの投稿数:%@", block, tagcount];
		
		NSString *str_next = [dic objectForKey: @"next_data"];
		if ( [str_next isEqualToString: @"YES"] ) {
			
			cell.imageView_My_2.image = [UIImage imageNamed: @"war_taiji_1.png"];
			
			cell.label_Gekokyu_2.text = [dic objectForKey: @"下剋上_2"];
			
		}

		//文字の色を変える
		cell.label_Gekokyu_1.textColor =
		cell.label_Rank.textColor      =
		cell.label_Shiro.textColor     =
		cell.label_Comment.textColor   =
		cell.label_Gekokyu_2.textColor = [UIColor colorWithRed: ( 30.0) / 255.0
														 green: (144.0) / 255.0
														  blue: (255.0) / 255.0
														 alpha: 1.0];

		return cell;
		
	} else {
		
		VSRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Shiro_VSRank"];
		
		dispatch_queue_t q_global = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
		dispatch_queue_t q_main   = dispatch_get_main_queue();
		
		cell.imageView_Shiro.image = nil;
		
		dispatch_async( q_global, ^{
			
			UIImage *image = [self WebImage: [dic objectForKey: @"imagename"]];
			
			dispatch_async( q_main, ^{
				
				cell.imageView_Shiro.image = image;
				cell.imageView_Shiro.contentMode = UIViewContentModeScaleAspectFit;
				
			});
			
		});
		
		NSNumber *number = [dic objectForKey: @"rankno"];
		
		cell.label_Rank.text = [NSString stringWithFormat: @"第%d位", [number intValue]];
		
		//shirolabelを城の名前を表示するように設定
		cell.label_Shiro.text = shiro_name;

		//タグの投稿数の文字列を格納
		NSString *tagcount = [dic objectForKey: @"tagcount"];
		
		//ブロックに関する文字列を格納
		NSString *block = [dic objectForKey: @"block"];
		
		//taglabelをブロックとタグの投稿数を表示するように設定
		cell.label_Comment.text = [NSString stringWithFormat: @"ブロック:%@ タグの投稿数:%@", block, tagcount];
		
		cell.imageView_VS_1.image = nil;
		cell.imageView_VS_2.image = nil;
		
//		cell.label_Rank.textColor    = [UIColor blackColor];
//		cell.label_Shiro.textColor   = [UIColor blackColor];
//		cell.label_Comment.textColor = [UIColor blackColor];
		
		return cell;

	}
	
	
//	NSNumber *number = [dic objectForKey: @"rankno"];
//	
//	cell.label_Rank.text = [NSString stringWithFormat: @"第%d位", [number intValue]];
//	
//	//shirolabelを城の名前を表示するように設定
//	cell.label_Shiro.text = [dic objectForKey: @"shironame"];
//	//タグの投稿数の文字列を格納
//	
//	NSString *tagcount = [dic objectForKey: @"tagcount"];
//	//ブロックに関する文字列を格納
//	NSString *block = [dic objectForKey: @"block"];
//	
//	//taglabelをブロックとタグの投稿数を表示するように設定
//	cell.label_Comment.text = [NSString stringWithFormat: @"ブロック:%@\nタグの投稿数:%@", block, tagcount];
//	
//	//自分が気に入っている城であるかどうか
//	if ( [cell.label_Shiro.text isEqualToString: app.string_Shikan] ) {
//		
//		//文字の色を変える
//		cell.label_Rank.textColor    = [UIColor colorWithRed: ( 30.0) / 255.0
//													   green: (144.0) / 255.0
//														blue: (255.0) / 255.0
//													   alpha: 1.0];
//		
//		cell.label_Shiro.textColor   = [UIColor colorWithRed: ( 30.0) / 255.0
//													   green: (144.0) / 255.0
//														blue: (255.0) / 255.0
//													   alpha: 1.0];
//		
//		cell.label_Comment.textColor = [UIColor colorWithRed: ( 30.0) / 255.0
//													   green: (144.0) / 255.0
//														blue: (255.0) / 255.0
//													   alpha: 1.0];
//		
//	} else {
//		
//		cell.label_Rank.textColor    = [UIColor blackColor];
//		cell.label_Shiro.textColor   = [UIColor blackColor];
//		cell.label_Comment.textColor = [UIColor blackColor];
//		
//	}
	
	return nil;
	
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{

	NSDictionary *dic = array_Like[indexPath.row];
	
	NSString *shiro_name = [dic objectForKey: @"shironame"];
	
	if ( [shiro_name isEqualToString: app.string_Shikan] ) {
		
		return tableView.frame.size.width;

	}
	
	return 116;

}

//JSONのデータをarray_Like型で返すメソッド
- (NSArray *)JSONArrayData: (NSString *)url
{
	
	//NSErrorの初期化
	NSError *err = nil;
	
	//url先にあるデータをNSDataとして格納
	NSData *data = [self webdata: url];
	//dataを元にJSONオブジェクトを生成
	
	NSArray *_array = [NSJSONSerialization JSONObjectWithData: data
													  options: NSJSONReadingMutableContainers
														error: &err];
	
	if ( err ) {
		
		NSLog( @"%@", err );
		
		[self setAlertTitle: @"エラー"
					message: @"サーバーにつながっていません！！"];
		
		bool_Error = YES;
		
	}
	
	//値を返す
	return _array;
	
}

//url先にあるデータを返すメソッド
- (NSData *)webdata: (NSString *)url
{
	
	//URLを生成
	NSURL *dataurl = [NSURL URLWithString: url];
	
	//リクエスト生成
	NSURLRequest *request = [NSURLRequest requestWithURL: dataurl
											 cachePolicy: NSURLRequestUseProtocolCachePolicy
										 timeoutInterval: 10];
	
	//レスポンスを生成
	NSHTTPURLResponse *response;
	//NSErrorの初期化
	NSError *err = nil;
	
	//requestによって返ってきたデータを生成
	NSData *data = [NSURLConnection sendSynchronousRequest: request
										 returningResponse: &response
													 error: &err];
	
	if ( err ) {
		
		NSLog( @"%@", err );
		
		[self setAlertTitle: @"エラー"
					message: @"サーバーにつながっていません！！"];
		
		bool_Error = YES;
		
	}
	
	return data;
}

//JSONのデータをNSDictionary型で返すメソッド
- (NSDictionary *)JSONDictinaryData: (NSString *)url
{
	
	//NSErrorの初期化
	NSError *err = nil;
	//url先にあるデータをNSDataとして格納
	NSData *data = [self webdata:url];
	
	//dataを元にJSONオブジェクトを生成
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: data
														options: NSJSONReadingMutableContainers
														  error: &err];
	
	if ( err ) {
		
		NSLog( @"%@", err );
		
		[self setAlertTitle: @"エラー"
					message: @"サーバーにつながっていません！！"];
		
		bool_Error = YES;
		
	}
	
	//値を返す
	return dic;
	
}

//url先にある画像のデータを返すメソッド
- (UIImage *)WebImage: (NSString *)url
{
	
	//url先にあるデータをNSDataとして格納
	NSData *data = [self webdata: url];
	
	//dataを元にUIImageを生成
	UIImage *img = [UIImage imageWithData: data];
	
	//値を返す
	return img;
	
}

- (NSArray *)serverdata: (NSString *)url
{
	
	//requestによって返ってきたデータを生成
	NSData *data = [self webdata: url];
	
	//データを元に文字列を生成
	NSString *str = [[NSString alloc] initWithData: data
										  encoding: NSUTF8StringEncoding];
	
	//余計な文字列を削除
	str = [str stringByReplacingOccurrencesOfString:
		   @"<!--/* Miraiserver \"NO ADD\" http://www.miraiserver.com */-->" withString: @""];
	str = [str stringByReplacingOccurrencesOfString:
		   @"<script type=\"text/javascript\" src=\"http://17787372.ranking.fc2.com/analyze.js\" charset=\"utf-8\"></script>" withString:@""];
	
	//NSErrorの初期化
	NSError *err = nil;
	//strをNSData型の変数に変換
	NSData *trimdata = [str dataUsingEncoding: NSUTF8StringEncoding];
	
	//dataを元にJSONオブジェクトを生成
	NSArray *_array = [NSJSONSerialization JSONObjectWithData: trimdata
													  options: NSJSONReadingMutableContainers
														error: &err];
	
	if ( err ) {
		
		NSLog( @"%@", err );
		
		[self setAlertTitle: @"エラー"
					message: @"サーバーにつながっていません！！"];
		
		bool_Error = YES;
		
	}
	
	//値を返す
	return _array;
	
}

- (void)setAlertTitle: (NSString *)title
			  message: (NSString *)message
{
	
	Class class = NSClassFromString( @"UIAlertController" );
	
	if ( class ) {
		// iOS 8の時の処理
		// UIAlertControllerを使ってアラートを表示
		UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
																	   message: message
																preferredStyle: UIAlertControllerStyleAlert];
		
		[alert addAction: [UIAlertAction actionWithTitle: @"OK"
												   style: UIAlertActionStyleDefault
												 handler: nil]];
		
		[self presentViewController: alert animated: YES completion: nil];
		
	} else {
		// iOS 7の時の処理
		// UIAlertViewを使ってアラートを表示
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
														message: message
													   delegate: nil
											  cancelButtonTitle: nil
											  otherButtonTitles: @"OK", nil];
		
		[alert show];
		
	}
	
}

@end
