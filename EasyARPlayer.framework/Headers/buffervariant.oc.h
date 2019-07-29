#import <Foundation/Foundation.h>

typedef enum _BufferVariantType
{
    Unknown = -1,
    RawBytes = 0,
    Image = 1,
    YUVRef = 2,
} BufferVariantType;

/**
 * 存储大块Buffer，用于在原生(iOS)和内容(TypeScript)之间传递
 */
@interface easyar_BufferVariant : NSObject

-(instancetype)initWithRawBytes:(NSData*)data;
-(instancetype)initWithImageBytes:(NSData*)data;
-(instancetype)initWithYUVBuffer:(int)pixelFormat yAddr:(void *)yAddr ySize:(int)ySize uvAddr:(void*)uvAddr uvSize:(int)uvSize;

-(NSInteger)size;

-(BufferVariantType)getVariantType;

@end
