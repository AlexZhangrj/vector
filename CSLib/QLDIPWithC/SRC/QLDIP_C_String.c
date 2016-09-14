//
//  QLDIP_C_String.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_String.h"
#include <string.h>
//#include <strhash.h>
#include "QLDIP_C_Base.h"



void __QLDIP_C_StringSetContentCharArray(QLDIP_C_StringRef theString, const char * cstr);


QLDIP_C_StringRef QLDIP_C_StringCreate()
{
    QLDIP_C_StringRef retRef = NULL;
    int size = sizeof(QLDIP_C_String);
    retRef = (QLDIP_C_String *)QLDIP_C_allocWithInit(size);
    retRef->base.hasValue = QLDIP_C_BoolValue_false;
    retRef->base.objType = QLDIP_C_Object_type_String;
    retRef->base.refcount = 1;
    retRef->strLen = 0;
    retRef->string = NULL;
    return retRef;
}

QLDIP_C_StringRef QLDIP_C_StringCopy(QLDIP_C_StringRef theString)
{
    QLDIP_C_StringRef retRef = NULL;
    int size = sizeof(QLDIP_C_String);
    retRef = (QLDIP_C_String *)QLDIP_C_allocWithInit(size);
    retRef->base = theString->base;
    retRef->base.refcount = 1;
    retRef->strLen =  theString->strLen;
    
    char * retRefStr = (char *)QLDIP_C_malloc(sizeof(char) * (theString->strLen));
    memcpy(retRefStr, theString->string, theString->strLen);

    retRef->string = retRefStr;
    return retRef;
}

QLDIP_C_StringRef QLDIP_C_StringCreateWithByteArray(QLDIP_C_Byte * stringByte, QLDIP_C_Range byteRange, QLDIP_C_StringCoding stringCoding)
{
    printf("%s 这是一个未实现的方法", __func__);
    return NULL;
}


void QLDIP_C_StringDealloc(QLDIP_C_StringRef theString)
{
    if(NULL == theString) {
        return;
    }
    
    QLDIP_C_BoolValue hasValue = theString->base.hasValue;
    if (QLDIP_C_BoolValue_true == hasValue) {
        QLDIP_C_Dealloc(theString->string);
    }
    
    QLDIP_C_Dealloc(theString);
}

void QLDIP_C_StringSetContentCharArray(QLDIP_C_StringRef theString, const char * cstr)
{
    __QLDIP_C_StringSetContentCharArray(theString, cstr);
}

QLDIP_C_StringRef QLDIP_C_StringCreateWithCharArray(const char * cstr)
{
    QLDIP_C_StringRef ret = QLDIP_C_StringCreate();
    
    if (NULL == ret) {
        return ret;
    }
    
    __QLDIP_C_StringSetContentCharArray(ret, cstr);

    return ret;
}



const char * QLDIP_C_StringCharArrayFromString(QLDIP_C_StringRef string)
{
    if (NULL == string) {
        return NULL;
    }
    return string->string;
}

const char * QLDIP_C_StringUnsafeCharArrayFromStringByCopy(QLDIP_C_StringRef string)
{
    if (NULL == string) {
        return NULL;
    }

    char * ret = (char *)QLDIP_C_malloc(sizeof(char) * (string->strLen));
    memcpy(ret, string->string, string->strLen);
    return ret;
}

void __QLDIP_C_StringSetContentCharArray(QLDIP_C_StringRef theString, const char * cstr)
{
    if(NULL == theString) {
        return;
    }
    
    QLDIP_C_StringRef ret = theString;
    
    QLDIP_C_BoolValue hasValue = ret->base.hasValue;
    if (QLDIP_C_BoolValue_true == hasValue) {
        QLDIP_C_Dealloc(ret->string);
    }
    
    if (NULL == cstr) {
        ret->base.hasValue = QLDIP_C_BoolValue_false;
        ret->string = NULL;
        ret->strLen = 0;
    }else {
        ret->base.hasValue = QLDIP_C_BoolValue_true;
        ret->stringType = QLDIP_C_String_CString;
        ret->strLen = (uint32_t)strlen(cstr);
        char * string = (char *)QLDIP_C_malloc(sizeof(char) * (ret->strLen + 1));
        memcpy(string, cstr, ret->strLen + 1);
        ret->string = string;
    }
}


/*
 UTF-8 valid format list:
 0xxxxxxx
 110xxxxx 10xxxxxx
 1110xxxx 10xxxxxx 10xxxxxx
 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
 */
char *filter_none_utf8_chars(char *src, int *len)
{
    unsigned char *p;
    unsigned char *pSub;
    unsigned char *pStrEnd;
    unsigned char *pCharEnd;
    int bytes;
    unsigned char *filtered;
    unsigned char *pDest;
    unsigned char *pInvalidCharStart;
    pStrEnd = (unsigned char *)src + (*len);
    p = (unsigned char *)src;
    pInvalidCharStart = NULL;
    while (p < pStrEnd)
    {
        if (*p < 0x80)
        {
            p++;
            continue;
        }
        if ((*p & 0xE0) == 0xC0)  //110xxxxx
        {
            bytes = 1;
        }
        else if ((*p & 0xF0) == 0xE0) //1110xxxx
        {
            bytes = 2;
        }
        else if ((*p & 0xF8) == 0xF0) //11110xxx
        {
            bytes = 3;
        }
        else if ((*p & 0xFC) == 0xF8) //111110xx
        {
            bytes = 4;
        }
        else if ((*p & 0xFE) == 0xFC) //1111110x
        {
            bytes = 5;
        }
        else
        {
            pInvalidCharStart = p;
            break;
        }
        
        p++;
        pCharEnd = p + bytes;
        if (pCharEnd > pStrEnd)
        {
            pInvalidCharStart = p - 1;
            break;
        }
        for (; p<pCharEnd; p++)
        {
            if ((*p & 0xC0) != 0x80)
            {
                break;
            }
        }
        if (p != pCharEnd)
        {
            pInvalidCharStart = pCharEnd - (bytes + 1);
            break;
        }
    }
    if (pInvalidCharStart == NULL) //all chars are valid
    {
        return src;
    }
    
    filtered = (unsigned char *)malloc(sizeof(char) * (*len));
    if (filtered == NULL)
    {
        *len = 0;
        *src = '\0';
        return src;
    }
    
    pDest = filtered;
    bytes = (char *)pInvalidCharStart - src;
    if (bytes > 0)
    {
        memcpy(pDest, src, bytes);
        pDest += bytes;
    }
    
    p = pInvalidCharStart + 1; //skip this invalid char
    while (p < pStrEnd)
    {
        if (*p < 0x80)
        {
            *pDest++ = *p++;
            continue;
        }
        if ((*p & 0xE0) == 0xC0)  //110xxxxx
        {
            bytes = 1;
        }
        else if ((*p & 0xF0) == 0xE0) //1110xxxx
        {
            bytes = 2;
        }
        else if ((*p & 0xF8) == 0xF0) //11110xxx
        {
            bytes = 3;
        }
        else if ((*p & 0xFC) == 0xF8) //111110xx
        {
            bytes = 4;
        }
        else if ((*p & 0xFE) == 0xFC) //1111110x
        {
            bytes = 5;
        }
        else  //invalid char
        {
            p++;
            continue;
        }
        
        pSub = p + 1;
        pCharEnd = pSub + bytes;
        if (pCharEnd > pStrEnd)
        {
            p++;
            continue;
        }
        for (; pSub<pCharEnd; pSub++)
        {
            if ((*pSub & 0xC0) != 0x80)
            {
                break;
            }
        }
        if (pSub != pCharEnd)
        {
            p++;
            continue;
        }
        
        bytes += 1;
        memcpy(pDest,  pSub-bytes, bytes);
        pDest += bytes;
        p += bytes;
    }
    
    *len = pDest - filtered;
    memcpy(src, filtered, *len);
    * (src + (*len)) = '\0';
    free(filtered);
    return src;
}



#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <memory.h>

#ifdef WIN32
#define uint8_t  unsigned __int8
#define uint16_t unsigned __int16
#define uint32_t unsigned __int32
#define uint64_t unsigned __int64

#define int8_t  __int8
#define int16_t __int16
#define int32_t __int32
#endif

int unicode_to_utf8(uint16_t *in, int insize, uint8_t **out)
{
    int i = 0;
    int outsize = 0;
    int charscount = 0;
    uint8_t *result = NULL;
    uint8_t *tmp = NULL;
    
    charscount = insize / sizeof(uint16_t);
    result = (uint8_t *)malloc(charscount * 3 + 1);
    memset(result, 0, charscount * 3 + 1);
    tmp = result;
    
    for (i = 0; i < charscount; i++)
    {
        uint16_t unicode = in[i];
        
        if (unicode >= 0x0000 && unicode <= 0x007f)
        {
            *tmp = (uint8_t)unicode;
            tmp += 1;
            outsize += 1;
        }
        else if (unicode >= 0x0080 && unicode <= 0x07ff)
        {
            *tmp = 0xc0 | (unicode >> 6);
            tmp += 1;
            *tmp = 0x80 | (unicode & (0xff >> 2));
            tmp += 1;
            outsize += 2;
        }
        else if (unicode >= 0x0800 && unicode <= 0xffff)
        {
            *tmp = 0xe0 | (unicode >> 12);
            tmp += 1;
            *tmp = 0x80 | (unicode >> 6 & 0x00ff);
            tmp += 1;
            *tmp = 0x80 | (unicode & (0xff >> 2));
            tmp += 1;
            outsize += 3;
        }
        
    }
    
    *tmp = '\0';
    *out = result;
    return 0;
}

int utf8_to_unicode(uint8_t *in, uint16_t **out, int *outsize)
{
    uint8_t *p = in;
    uint16_t *result = NULL;
    int resultsize = 0;
    uint8_t *tmp = NULL;
    
    result = (uint16_t *)malloc(strlen(in) * 2 + 2); /* should be enough */
    memset(result, 0, strlen(in) * 2 + 2);
    tmp = (uint8_t *)result;
    
    while(*p)
    {
        if (*p >= 0x00 && *p <= 0x7f)
        {
            *tmp = *p;
            tmp++;
            *tmp = '\0';
            resultsize += 2;
        }
        else if ((*p & (0xff << 5))== 0xc0)
        {
            uint16_t t = 0;
            uint8_t t1 = 0;
            uint8_t t2 = 0;
            
            t1 = *p & (0xff >> 3);
            p++;
            t2 = *p & (0xff >> 2);
            
            *tmp = t2 | ((t1 & (0xff >> 6)) << 6);//t1 >> 2;
            tmp++;
            
            *tmp = t1 >> 2;//t2 | ((t1 & (0xff >> 6)) << 6);
            tmp++;
            
            resultsize += 2;
        }
        else if ((*p & (0xff << 4))== 0xe0)
        {
            uint16_t t = 0;
            uint8_t t1 = 0;
            uint8_t t2 = 0;
            uint8_t t3 = 0;
            
            t1 = *p & (0xff >> 3);
            p++;
            t2 = *p & (0xff >> 2);
            p++;
            t3 = *p & (0xff >> 2);
            
            //Little Endian
            *tmp = ((t2 & (0xff >> 6)) << 6) | t3;//(t1 << 4) | (t2 >> 2);
            tmp++;
            
            *tmp = (t1 << 4) | (t2 >> 2);//((t2 & (0xff >> 6)) << 6) | t3;
            tmp++;
            resultsize += 2;
        }
        
        p++;
    }
    
    *tmp = '\0';
    tmp++;
    *tmp = '\0';
    resultsize += 2;
    
    *out = result;
    *outsize = resultsize;
    return 0;
}

void dump_utf8(uint8_t *utf8)
{
    uint8_t *p = utf8;
    
    while(*p)
    {
        printf("%02X", *p);
        p++;
    }
    putchar('\n');
}

void dump_unicode(uint16_t *utf16, int size)
{
    uint8_t *p = (uint8_t *)utf16;
    int i = 0;
    
    for (i = 0; i < size; i++)
    {
        printf("%02X", *p);
        p++;
    }
    putchar('\n');
}

#if 0

//TEST CFStringRef  CFStringCreateWithCString(CFAllocatorRef alloc, const char *cStr, CFStringEncoding encoding) {
//CFIndex len = strlen(cStr);
//__CFStringCreateImmutableFunnel3(alloc, cStr, len, encoding, false, false, false, true, false, ALLOCATORSFREEFUNC, 0);


CFStringRef __CFStringCreateImmutableFunnel3(
                                             CFAllocatorRef alloc, const void *bytes, CFIndex numBytes, CFStringEncoding encoding) {
    uint32_t hasNullByte = 1;
    CFMutableStringRef str = NULL;
    CFVarWidthCharBuffer vBuf;
    CFIndex size;
    Boolean useLengthByte = false;
    Boolean useNullByte = false;
    Boolean useInlineData = false;
    
#if INSTRUMENT_SHARED_STRINGS
    const char *recordedEncoding;
    char encodingBuffer[128];
    if (encoding == kCFStringEncodingUnicode) recordedEncoding = "Unicode";
    else if (encoding == kCFStringEncodingASCII) recordedEncoding = "ASCII";
    else if (encoding == kCFStringEncodingUTF8) recordedEncoding = "UTF8";
    else if (encoding == kCFStringEncodingMacRoman) recordedEncoding = "MacRoman";
    else {
        snprintf(encodingBuffer, sizeof(encodingBuffer), "0x%lX", (unsigned long)encoding);
        recordedEncoding = encodingBuffer;
    }
#endif
    
    if (alloc == NULL) alloc = __CFGetDefaultAllocator();
    
    if (contentsDeallocator == ALLOCATORSFREEFUNC) {
        contentsDeallocator = alloc;
    } else if (contentsDeallocator == NULL) {
        contentsDeallocator = __CFGetDefaultAllocator();
    }
    
    if ((NULL != kCFEmptyString) && (numBytes == 0) && _CFAllocatorIsSystemDefault(alloc)) {	// If we are using the system default allocator, and the string is empty, then use the empty string!
        if (noCopy && (contentsDeallocator != kCFAllocatorNull)) {	// See 2365208... This change was done after Sonata; before we didn't free the bytes at all (leak).
            CFAllocatorDeallocate(contentsDeallocator, (void *)bytes);
        }
        return (CFStringRef)CFRetain(kCFEmptyString);	// Quick exit; won't catch all empty strings, but most
    }
    
    // At this point, contentsDeallocator is either same as alloc, or kCFAllocatorNull, or something else, but not NULL
    
    vBuf.shouldFreeChars = false;	// We use this to remember to free the buffer possibly allocated by decode
    
    // Record whether we're starting out with an ASCII-superset string, because we need to know this later for the string ROM; this may get changed later if we successfully convert down from Unicode.  We only record this once because __CFCanUseEightBitCFStringForBytes() can be expensive.
    Boolean stringSupportsEightBitCFRepresentation = encoding != kCFStringEncodingUnicode && __CFCanUseEightBitCFStringForBytes((const uint8_t *)bytes, numBytes, encoding);
    
    // We may also change noCopy within this function if we have to decode the string into an external buffer.  We do not want to avoid the use of the string ROM merely because we tried to be efficient and reuse the decoded buffer for the CFString's external storage.  Therefore, we use this variable to track whether we actually can ignore the noCopy flag (which may or may not be set anyways).
    Boolean stringROMShouldIgnoreNoCopy = false;
    
    // First check to see if the data needs to be converted...
    // ??? We could be more efficient here and in some cases (Unicode data) eliminate a copy
    
    if ((encoding == kCFStringEncodingUnicode && possiblyExternalFormat) || (encoding != kCFStringEncodingUnicode && ! stringSupportsEightBitCFRepresentation)) {
        const void *realBytes = (uint8_t *) bytes + (hasLengthByte ? 1 : 0);
        CFIndex realNumBytes = numBytes - (hasLengthByte ? 1 : 0);
        Boolean usingPassedInMemory = false;
        
        vBuf.allocator = kCFAllocatorSystemDefault;	// We don't want to use client's allocator for temp stuff
        vBuf.chars.unicode = NULL;	// This will cause the decode function to allocate memory if necessary
        
        if (!__CFStringDecodeByteStream3((const uint8_t *)realBytes, realNumBytes, encoding, false, &vBuf, &usingPassedInMemory, converterFlags)) {
            // Note that if the string can't be created, we don't free the buffer, even if there is a contents deallocator. This is on purpose.
            return NULL;
        }
        
        encoding = vBuf.isASCII ? kCFStringEncodingASCII : kCFStringEncodingUnicode;
        
        // Update our flag according to whether the decoded buffer is ASCII
        stringSupportsEightBitCFRepresentation = vBuf.isASCII;
        
        if (!usingPassedInMemory) {
            
            // Because __CFStringDecodeByteStream3() allocated our buffer, it's OK for us to free it if we can get the string from the ROM.
            stringROMShouldIgnoreNoCopy = true;
            
            // Make the parameters fit the new situation
            numBytes = vBuf.isASCII ? vBuf.numChars : (vBuf.numChars * sizeof(UniChar));
            hasLengthByte = hasNullByte = false;
            
            // Get rid of the original buffer if its not being used
            if (noCopy && (contentsDeallocator != kCFAllocatorNull)) {
                CFAllocatorDeallocate(contentsDeallocator, (void *)bytes);
            }
            contentsDeallocator = alloc;	// At this point we are using the string's allocator, as the original buffer is gone...
            
            // See if we can reuse any storage the decode func might have allocated
            // We do this only for Unicode, as otherwise we would not have NULL and Length bytes
            
            if (vBuf.shouldFreeChars && (alloc == vBuf.allocator) && encoding == kCFStringEncodingUnicode) {
                vBuf.shouldFreeChars = false;	// Transferring ownership to the CFString
                bytes = CFAllocatorReallocate(vBuf.allocator, (void *)vBuf.chars.unicode, numBytes, 0);	// Tighten up the storage
                noCopy = true;
#if INSTRUMENT_SHARED_STRINGS
                if (encoding == kCFStringEncodingASCII) recordedEncoding = "ForeignASCII-NoCopy";
                else recordedEncoding = "ForeignUnicode-NoCopy";
#endif
            } else {
#if INSTRUMENT_SHARED_STRINGS
                if (encoding == kCFStringEncodingASCII) recordedEncoding = "ForeignASCII-Copy";
                else recordedEncoding = "ForeignUnicode-Copy";
#endif
                bytes = vBuf.chars.unicode;
                noCopy = false;			// Can't do noCopy anymore
                // If vBuf.shouldFreeChars is true, the buffer will be freed as intended near the end of this func
            }
            
        }
        
        // At this point, all necessary input arguments have been changed to reflect the new state
        
    } else if (encoding == kCFStringEncodingUnicode && tryToReduceUnicode) {	// Check to see if we can reduce Unicode to ASCII
        CFIndex cnt;
        CFIndex len = numBytes / sizeof(UniChar);
        Boolean allASCII = true;
        
        for (cnt = 0; cnt < len; cnt++) if (((const UniChar *)bytes)[cnt] > 127) {
            allASCII = false;
            break;
        }
        
        if (allASCII) {	// Yes we can!
            uint8_t *ptr, *mem;
            Boolean newHasLengthByte = __CFCanUseLengthByte(len);
            numBytes = (len + 1 + (newHasLengthByte ? 1 : 0)) * sizeof(uint8_t);	// NULL and possible length byte
            // See if we can use that temporary local buffer in vBuf...
            if (numBytes >= __kCFVarWidthLocalBufferSize) {
                mem = ptr = (uint8_t *)CFAllocatorAllocate(alloc, numBytes, 0);
                if (__CFOASafe) __CFSetLastAllocationEventName(mem, "CFString (store)");
            } else {
                mem = ptr = (uint8_t *)(vBuf.localBuffer);
            }
            if (mem) {	// If we can't allocate memory for some reason, use what we had (that is, as if we didn't have all ASCII)
                // Copy the Unicode bytes into the new ASCII buffer
                hasLengthByte = newHasLengthByte;
                hasNullByte = true;
                if (hasLengthByte) *ptr++ = (uint8_t)len;
                for (cnt = 0; cnt < len; cnt++) ptr[cnt] = (uint8_t)(((const UniChar *)bytes)[cnt]);
                ptr[len] = 0;
                if (noCopy && (contentsDeallocator != kCFAllocatorNull)) {
                    CFAllocatorDeallocate(contentsDeallocator, (void *)bytes);
                }
                // Now make everything look like we had an ASCII buffer to start with
                bytes = mem;
                encoding = kCFStringEncodingASCII;
                contentsDeallocator = alloc;	// At this point we are using the string's allocator, as the original buffer is gone...
                noCopy = (numBytes >= __kCFVarWidthLocalBufferSize);	// If we had to allocate it, make sure it's kept around
                numBytes--;		// Should not contain the NULL byte at end...
                stringSupportsEightBitCFRepresentation = true; // We're ASCII now!
                stringROMShouldIgnoreNoCopy = true; // We allocated this buffer, so we should feel free to get rid of it if we can use the string ROM
#if INSTRUMENT_SHARED_STRINGS
                recordedEncoding = "U->A";
#endif
            }
        }
        
        // At this point, all necessary input arguments have been changed to reflect the new state
    }
    
#if USE_STRING_ROM || ENABLE_TAGGED_POINTER_STRINGS || INSTRUMENT_SHARED_STRINGS
    CFIndex lengthByte = (hasLengthByte ? 1 : 0);
    CFIndex realNumBytes = numBytes - lengthByte;
    const uint8_t *realBytes = bytes + lengthByte;
#endif
    
    
    if (!str) {
        // Now determine the necessary size
#if INSTRUMENT_SHARED_STRINGS || USE_STRING_ROM
        Boolean stringSupportsROM = stringSupportsEightBitCFRepresentation;
#endif
        
#if INSTRUMENT_SHARED_STRINGS
        if (stringSupportsROM) __CFRecordStringAllocationEvent(recordedEncoding, realBytes, realNumBytes);
#endif
        
#if USE_STRING_ROM
        CFStringRef romResult = NULL;
        
        
        if (stringSupportsROM) {
            // Disable the string ROM if necessary
            static char sDisableStringROM = -1;
            if (sDisableStringROM == -1) sDisableStringROM = !! __CFgetenv("CFStringDisableROM");
            
            if (sDisableStringROM == 0) romResult = __CFSearchStringROM((const char *)realBytes, realNumBytes);
        }
        /* if we get a result from our ROM, and noCopy is set, then deallocate the buffer immediately */
        if (romResult) {
            if (noCopy && (contentsDeallocator != kCFAllocatorNull)) {
                CFAllocatorDeallocate(contentsDeallocator, (void *)bytes);
            }
            
            /* these don't get used again, but clear them for consistency */
            noCopy = false;
            bytes = NULL;
            
            /* set our result to the ROM result which is not really mutable, of course, but that's OK because we don't try to modify it. */
            str = (CFMutableStringRef)romResult;
            
#if INSTRUMENT_TAGGED_POINTER_STRINGS
            _CFTaggedPointerStringStats.stringROMCount++;
#endif
        }
        
        if (! romResult) {
#else
            if (1) {
#endif
                
#if INSTRUMENT_SHARED_STRINGS
                if (stringSupportsROM) __CFRecordStringAllocationEvent(recordedEncoding, realBytes, realNumBytes);
#endif
#if INSTRUMENT_TAGGED_POINTER_STRINGS
                _CFTaggedPointerStringStats.otherStringCount++;
#endif
                
                // Now determine the necessary size
                
                if (noCopy) {
                    
                    size = sizeof(void *);				// Pointer to the buffer
                    if ((0) || (contentsDeallocator != alloc && contentsDeallocator != kCFAllocatorNull)) {
                        size += sizeof(void *);	// The contentsDeallocator
                    }
                    if (!hasLengthByte) size += sizeof(CFIndex);	// Explicit length
                    useLengthByte = hasLengthByte;
                    useNullByte = hasNullByte;
                    
                } else {	// Inline data; reserve space for it
                    
                    useInlineData = true;
                    size = numBytes;
                    
                    if (hasLengthByte || (encoding != kCFStringEncodingUnicode && __CFCanUseLengthByte(numBytes))) {
                        useLengthByte = true;
                        if (!hasLengthByte) size += 1;
                    } else {
                        size += sizeof(CFIndex);	// Explicit length
                    }
                    if (hasNullByte || encoding != kCFStringEncodingUnicode) {
                        useNullByte = true;
                        size += 1;
                    }
                }
                
#ifdef STRING_SIZE_STATS
                // Dump alloced CFString size info every so often
                static int cnt = 0;
                static unsigned sizes[256] = {0};
                int allocedSize = size + sizeof(CFRuntimeBase);
                if (allocedSize < 255) sizes[allocedSize]++; else sizes[255]++;
                if ((++cnt % 1000) == 0) {
                    printf ("\nTotal: %d\n", cnt);
                    int i; for (i = 0; i < 256; i++) printf("%03d: %5d%s", i, sizes[i], ((i % 8) == 7) ? "\n" : " ");
                }
#endif
                
                // Finally, allocate!
#if DEPLOYMENT_RUNTIME_SWIFT
                // Swift.String is 3 pointers, so we have to allocate to the largest of the two (some variants of __CFString are smaller than swift Strings)
                CFIndex swiftStringSize = sizeof(CFRuntimeBase) + (sizeof(void *) * 3);
                if (swiftStringSize > size) size = swiftStringSize;
#endif
                str = (CFMutableStringRef)_CFRuntimeCreateInstance(alloc, __kCFStringTypeID, size, NULL);
                if (str) {
                    if (__CFOASafe) __CFSetLastAllocationEventName(str, "CFString (immutable)");
                    
                    CFOptionFlags allocBits = (0) ? __kCFHasContentsDeallocator : (contentsDeallocator == alloc ? __kCFNotInlineContentsDefaultFree : (contentsDeallocator == kCFAllocatorNull ? __kCFNotInlineContentsNoFree : __kCFNotInlineContentsCustomFree));
                    __CFStrSetInfoBits(str,
                                       (useInlineData ? __kCFHasInlineContents : allocBits) |
                                       ((encoding == kCFStringEncodingUnicode) ? __kCFIsUnicode : 0) |
                                       (useNullByte ? __kCFHasNullByte : 0) |
                                       (useLengthByte ? __kCFHasLengthByte : 0));
                    
                    if (!useLengthByte) {
                        CFIndex length = numBytes - (hasLengthByte ? 1 : 0);
                        if (encoding == kCFStringEncodingUnicode) length /= sizeof(UniChar);
                        __CFStrSetExplicitLength(str, length);
                    }
                    
                    if (useInlineData) {
                        uint8_t *contents = (uint8_t *)__CFStrContents(str);
                        if (useLengthByte && !hasLengthByte) *contents++ = (uint8_t)numBytes;
                        memmove(contents, bytes, numBytes);
                        if (useNullByte) contents[numBytes] = 0;
                    } else {
                        __CFStrSetContentPtr(str, bytes);
                        if (__CFStrHasContentsDeallocator(str)) __CFStrSetContentsDeallocator(str, contentsDeallocator); 
                    }
                } else {
                    if (noCopy && (contentsDeallocator != kCFAllocatorNull)) {
                        CFAllocatorDeallocate(contentsDeallocator, (void *)bytes); 
                    }
                }
            }
        }
        if (vBuf.shouldFreeChars) CFAllocatorDeallocate(vBuf.allocator, (void *)bytes);
        
#if 0
#warning Debug code
        const uint8_t *contents = (uint8_t *)__CFStrContents(str);
        CFIndex len = __CFStrLength2(str, contents);
        
        if (__CFStrIsEightBit(str)) {
            contents += __CFStrSkipAnyLengthByte(str);
            if (!__CFBytesInASCII(contents, len)) {
                printf("CFString with 8 bit backing store not ASCII: %p, \"%.*s\"\n", str, (int)len, contents);
            }
        }
#endif
        return str;
    }


void test() {
__CFStringCreateImmutableFunnel3(alloc, cStr, len, encoding, false, false, false, true, false, ALLOCATORSFREEFUNC, 0);
}


#endif


















