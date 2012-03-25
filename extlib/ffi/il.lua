local ffi = require( "ffi" )

ffi.cdef[[ 
      typedef unsigned int           ILenum;
      typedef unsigned char          ILboolean;
      typedef unsigned int           ILbitfield;
      typedef signed char            ILbyte;
      typedef signed short           ILshort;
      typedef int                    ILint;
      typedef size_t                 ILsizei;
      typedef unsigned char          ILubyte;
      typedef unsigned short         ILushort;
      typedef unsigned int           ILuint;
      typedef float                  ILfloat;
      typedef float                  ILclampf;
      typedef double                 ILdouble;
      typedef double                 ILclampd;
      typedef long long int          ILint64;
      typedef long long unsigned int ILuint64;

      typedef void* ILHANDLE;
      typedef void ( *fCloseRProc)(ILHANDLE);
      typedef ILboolean ( *fEofProc) (ILHANDLE);
      typedef ILint ( *fGetcProc) (ILHANDLE);
      typedef ILHANDLE ( *fOpenRProc) (char const *);
      typedef ILint ( *fReadProc) (void*, ILuint, ILuint, ILHANDLE);
      typedef ILint ( *fSeekRProc) (ILHANDLE, ILint, ILint);
      typedef ILint ( *fTellRProc) (ILHANDLE);
      typedef void ( *fCloseWProc)(ILHANDLE);
      typedef ILHANDLE ( *fOpenWProc) (char const *);
      typedef ILint ( *fPutcProc) (ILubyte, ILHANDLE);
      typedef ILint ( *fSeekWProc) (ILHANDLE, ILint, ILint);
      typedef ILint ( *fTellWProc) (ILHANDLE);
      typedef ILint ( *fWriteProc) (const void*, ILuint, ILuint, ILHANDLE);
      typedef void* ( *mAlloc)(const ILsizei);
      typedef void ( *mFree) (const void* const);
      typedef ILenum ( *IL_LOADPROC)(char const *);
      typedef ILenum ( *IL_SAVEPROC)(char const *);

      ILboolean   ilActiveFace(ILuint Number);
      ILboolean   ilActiveImage(ILuint Number);
      ILboolean   ilActiveLayer(ILuint Number);
      ILboolean   ilActiveMipmap(ILuint Number);
      ILboolean   ilApplyPal(char const * FileName);
      ILboolean   ilApplyProfile(char* InProfile, char* OutProfile);
      void        ilBindImage(ILuint Image);
      ILboolean   ilBlit(ILuint Source, ILint DestX, ILint DestY, ILint DestZ, ILuint SrcX, ILuint SrcY, ILuint SrcZ, ILuint Width, ILuint Height, ILuint Depth);
      ILboolean   ilClampNTSC(void);
      void        ilClearColour(ILclampf Red, ILclampf Green, ILclampf Blue, ILclampf Alpha);
      ILboolean   ilClearImage(void);
      ILuint      ilCloneCurImage(void);
      ILubyte*    ilCompressDXT(ILubyte *Data, ILuint Width, ILuint Height, ILuint Depth, ILenum DXTCFormat, ILuint *DXTCSize);
      ILboolean   ilCompressFunc(ILenum Mode);
      ILboolean   ilConvertImage(ILenum DestFormat, ILenum DestType);
      ILboolean   ilConvertPal(ILenum DestFormat);
      ILboolean   ilCopyImage(ILuint Src);
      ILuint      ilCopyPixels(ILuint XOff, ILuint YOff, ILuint ZOff, ILuint Width, ILuint Height, ILuint Depth, ILenum Format, ILenum Type, void *Data);
      ILuint      ilCreateSubImage(ILenum Type, ILuint Num);
      ILboolean   ilDefaultImage(void);
      void        ilDeleteImage(const ILuint Num);
      void        ilDeleteImages(ILsizei Num, const ILuint *Images);
      ILenum      ilDetermineType(char const * FileName);
      ILenum      ilDetermineTypeF(ILHANDLE File);
      ILenum      ilDetermineTypeL(const void *Lump, ILuint Size);
      ILboolean   ilDisable(ILenum Mode);
      ILboolean   ilDxtcDataToImage(void);
      ILboolean   ilDxtcDataToSurface(void);
      ILboolean   ilEnable(ILenum Mode);
      void        ilFlipSurfaceDxtcData(void);
      ILboolean   ilFormatFunc(ILenum Mode);
      void        ilGenImages(ILsizei Num, ILuint *Images);
      ILuint      ilGenImage(void);
      ILubyte*    ilGetAlpha(ILenum Type);
      ILboolean   ilGetBoolean(ILenum Mode);
      void        ilGetBooleanv(ILenum Mode, ILboolean *Param);
      ILubyte*    ilGetData(void);
      ILuint      ilGetDXTCData(void *Buffer, ILuint BufferSize, ILenum DXTCFormat);
      ILenum      ilGetError(void);
      ILint       ilGetInteger(ILenum Mode);
      void        ilGetIntegerv(ILenum Mode, ILint *Param);
      ILuint      ilGetLumpPos(void);
      ILubyte*    ilGetPalette(void);
      char const* ilGetString(ILenum StringName);
      void        ilHint(ILenum Target, ILenum Mode);
      ILboolean   ilInvertSurfaceDxtcDataAlpha(void);
      void        ilInit(void);
      ILboolean   ilImageToDxtcData(ILenum Format);
      ILboolean   ilIsDisabled(ILenum Mode);
      ILboolean   ilIsEnabled(ILenum Mode);
      ILboolean   ilIsImage(ILuint Image);
      ILboolean   ilIsValid(ILenum Type, char const * FileName);
      ILboolean   ilIsValidF(ILenum Type, ILHANDLE File);
      ILboolean   ilIsValidL(ILenum Type, void *Lump, ILuint Size);
      void        ilKeyColour(ILclampf Red, ILclampf Green, ILclampf Blue, ILclampf Alpha);
      ILboolean   ilLoad(ILenum Type, char const * FileName);
      ILboolean   ilLoadF(ILenum Type, ILHANDLE File);
      ILboolean   ilLoadImage(char const * FileName);
      ILboolean   ilLoadL(ILenum Type, const void *Lump, ILuint Size);
      ILboolean   ilLoadPal(char const * FileName);
      void        ilModAlpha(ILdouble AlphaValue);
      ILboolean   ilOriginFunc(ILenum Mode);
      ILboolean   ilOverlayImage(      ILuint Source, ILint XCoord, ILint YCoord, ILint ZCoord );
      void        ilPopAttrib(         void );
      void        ilPushAttrib(        ILuint Bits );
      void        ilRegisterFormat(    ILenum Format );
      ILboolean   ilRegisterLoad(      char const * Ext, IL_LOADPROC Load );
      ILboolean   ilRegisterMipNum(    ILuint Num );
      ILboolean   ilRegisterNumFaces(  ILuint Num );
      ILboolean   ilRegisterNumImages( ILuint Num );
      void        ilRegisterOrigin(    ILenum Origin );
      void        ilRegisterPal(       void *Pal, ILuint Size, ILenum Type );
      ILboolean   ilRegisterSave(      char const * Ext, IL_SAVEPROC Save );
      void        ilRegisterType(      ILenum Type );
      ILboolean   ilRemoveLoad(        char const* Ext );
      ILboolean   ilRemoveSave(        char const* Ext );
      void        ilResetMemory(       void );
      void        ilResetRead(         void );
      void        ilResetWrite(        void );
      ILboolean   ilSave(              ILenum Type, char const * FileName );
      ILuint      ilSaveF(             ILenum Type, ILHANDLE File );
      ILboolean   ilSaveImage(         char const * FileName );
      ILuint      ilSaveL(             ILenum Type, void *Lump, ILuint Size );
      ILboolean   ilSavePal(           char const* FileName );
      ILboolean   ilSetAlpha(          ILdouble AlphaValue );
      ILboolean   ilSetData(           void *Data );
      ILboolean   ilSetDuration(       ILuint Duration );
      void        ilSetInteger(        ILenum Mode, ILint Param );
      void        ilSetMemory(         mAlloc, mFree );
      void        ilSetPixels(         ILint XOff, ILint YOff, ILint ZOff, ILuint Width, ILuint Height, ILuint Depth, ILenum Format, ILenum Type, void *Data );
      void        ilSetRead(           fOpenRProc, fCloseRProc, fEofProc, fGetcProc, fReadProc, fSeekRProc, fTellRProc );
      void        ilSetString(         ILenum Mode, const char *String );
      void        ilSetWrite(          fOpenWProc, fCloseWProc, fPutcProc, fSeekWProc, fTellWProc, fWriteProc );
      void        ilShutDown(          void );
      ILboolean   ilSurfaceToDxtcData( ILenum Format);
      ILboolean   ilTexImage(          ILuint Width, ILuint Height, ILuint Depth, ILubyte NumChannels, ILenum Format, ILenum Type, void *Data);
      ILboolean   ilTexImageDxtc(      ILint w, ILint h, ILint d, ILenum DxtFormat, const ILubyte* data);
      ILenum      ilTypeFromExt(       char const * FileName);
      ILboolean   ilTypeFunc(          ILenum Mode);
      ILboolean   ilLoadData(          char const * FileName, ILuint Width, ILuint Height, ILuint Depth, ILubyte Bpp);
      ILboolean   ilLoadDataF(         ILHANDLE File, ILuint Width, ILuint Height, ILuint Depth, ILubyte Bpp);
      ILboolean   ilLoadDataL(         void *Lump, ILuint Size, ILuint Width, ILuint Height, ILuint Depth, ILubyte Bpp);
      ILboolean   ilSaveData(          char const * FileName);
]]

return il