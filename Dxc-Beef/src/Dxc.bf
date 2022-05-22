using System;

namespace Dxc_Beef
{
	public struct IStream : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x8BA5FB08, 0x5195, 0x40e2, 0xAC, 0x58, 0x0D, 0x98, 0x9C, 0x3A, 0x01, 0x02);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			//public function [CallingConvention(.Stdcall)] void(IStream* self) GetBufferPointer;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public static
	{
		public static mixin DXC_FOURCC(var ch0, var ch1, var ch2, var ch3)
		{
			(uint32)(uint8)(ch0) | (uint32)(uint8)(ch1) << 8 | (uint32)(uint8)(ch2) << 16 | (uint32)(uint8)(ch3) << 24
		}

		public const uint32 DXC_PART_PDB =                     DXC_FOURCC!('I', 'L', 'D', 'B');
		public const uint32 DXC_PART_PDB_NAME      =           DXC_FOURCC!('I', 'L', 'D', 'N');
		public const uint32 DXC_PART_PRIVATE_DATA    =         DXC_FOURCC!('P', 'R', 'I', 'V');
		public const uint32 DXC_PART_ROOT_SIGNATURE  =         DXC_FOURCC!('R', 'T', 'S', '0');
		public const uint32 DXC_PART_DXIL             =        DXC_FOURCC!('D', 'X', 'I', 'L');
		public const uint32 DXC_PART_REFLECTION_DATA   =       DXC_FOURCC!('S', 'T', 'A', 'T');
		public const uint32 DXC_PART_SHADER_HASH       =       DXC_FOURCC!('H', 'A', 'S', 'H');
		public const uint32 DXC_PART_INPUT_SIGNATURE   =       DXC_FOURCC!('I', 'S', 'G', '1');
		public const uint32 DXC_PART_OUTPUT_SIGNATURE     =    DXC_FOURCC!('O', 'S', 'G', '1');
		public const uint32 DXC_PART_PATCH_CONSTANT_SIGNATURE= DXC_FOURCC!('P', 'S', 'G', '1');

		public const String DXC_ARG_DEBUG = "-Zi";
		public const String DXC_ARG_SKIP_VALIDATION = "-Vd";
		public const String DXC_ARG_SKIP_OPTIMIZATIONS= "-Od";
		public const String DXC_ARG_PACK_MATRIX_ROW_MAJOR= "-Zpr";
		public const String DXC_ARG_PACK_MATRIX_COLUMN_MAJOR= "-Zpc";
		public const String DXC_ARG_AVOID_FLOW_CONTROL= "-Gfa";
		public const String DXC_ARG_PREFER_FLOW_CONTROL= "-Gfp";
		public const String DXC_ARG_ENABLE_STRICTNESS= "-Ges";
		public const String DXC_ARG_ENABLE_BACKWARDS_COMPATIBILITY= "-Gec";
		public const String DXC_ARG_IEEE_STRICTNESS= "-Gis";
		public const String DXC_ARG_OPTIMIZATION_LEVEL0= "-O0";
		public const String DXC_ARG_OPTIMIZATION_LEVEL1= "-O1";
		public const String DXC_ARG_OPTIMIZATION_LEVEL2= "-O2";
		public const String DXC_ARG_OPTIMIZATION_LEVEL3= "-O3";
		public const String DXC_ARG_WARNINGS_ARE_ERRORS ="-WX";
		public const String DXC_ARG_RESOURCES_MAY_ALIAS ="-res_may_alias";
		public const String DXC_ARG_ALL_RESOURCES_BOUND= "-all_resources_bound";
		public const String DXC_ARG_DEBUG_NAME_FOR_SOURCE ="-Zss";
		public const String DXC_ARG_DEBUG_NAME_FOR_BINARY ="-Zsb";

		// For convenience, equivalent definitions to CP_UTF8 and CP_UTF16.
		public const uint32 DXC_CP_UTF8 = 65001;
		public const uint32 DXC_CP_UTF16= 1200;
		public const uint32 DXC_CP_UTF32= 12000;
		// Use DXC_CP_ACP for: Binary;  ANSI Text;  Autodetect UTF with BOM
		public const uint32 DXC_CP_ACP = 0;

#if BF_PLATFORM_WINDOWS
		public const uint32 DXC_CP_WIDE = DXC_CP_UTF16;
#else
		public const uint32 DXC_CP_WIDE =  DXC_CP_UTF32;
#endif
	}

	[CRepr]
	struct DxcShaderHash {
		public uint32 Flags;
		public uint8[16] HashDigest;
	}

	[CRepr]
	struct IMalloc;

	public static class Dxc
	{
		public static function Windows.COM_IUnknown.HResult(
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv
			) DxcCreateInstanceProc = => DxcCreateInstance;

		public static function Windows.COM_IUnknown.HResult(
			in IMalloc* pMalloc,
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv
			) DxcCreateInstance2Proc = => DxcCreateInstance2;

		/// <summary>
		/// Creates a single uninitialized object of the class associated with a specified CLSID.
		/// </summary>
		/// <param name="rclsid">
		/// The CLSID associated with the data and code that will be used to create the object.
		/// </param>
		/// <param name="riid">
		/// A reference to the identifier of the interface to be used to communicate
		/// with the object.
		/// </param>
		/// <param name="ppv">
		/// Address of pointer variable that receives the interface pointer requested
		/// in riid. Upon successful return, *ppv contains the requested interface
		/// pointer. Upon failure, *ppv contains NULL.</param>
		/// <remarks>
		/// While this function is similar to CoCreateInstance, there is no COM involvement.
		/// </remarks>

		[CallingConvention(.Stdcall), CLink, Import("dxcompiler.lib")]
		public static extern Windows.COM_IUnknown.HResult DxcCreateInstance(
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv);
		
		[CallingConvention(.Stdcall), CLink, Import("dxcompiler.lib")]
		public static extern Windows.COM_IUnknown.HResult DxcCreateInstance2(
			in IMalloc* pMalloc,
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv);
	}

	
	public struct IDxcBlob : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x8BA5FB08, 0x5195, 0x40e2, 0xAC, 0x58, 0x0D, 0x98, 0x9C, 0x3A, 0x01, 0x02);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] void(IDxcBlob* self) GetBufferPointer;
			public function [CallingConvention(.Stdcall)] int(IDxcBlob* self) GetBufferSize;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcBlobEncoding : IDxcBlob
	{
		public static new Guid sIID = .(0x7241d424, 0x2646, 0x4191, 0x97, 0xc0, 0x98, 0xe9, 0x6e, 0x42, 0xfc, 0x68);

		public struct VTable : IDxcBlob.VTable
		{
			public function [CallingConvention(.Stdcall)] void(IDxcBlobEncoding* self, out bool* pKnown, out uint32* pCodePage) GetEncoding;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcBlobWide : IDxcBlobEncoding
	{
		public static new Guid sIID = .(0xA3F84EAB,0x0FAA,0x497E,0xA3, 0x9C,0xEE, 0x6E, 0xD6, 0x0B, 0x2D, 0x84);

		public struct VTable : IDxcBlobEncoding.VTable
		{
			public function [CallingConvention(.Stdcall)] char16*(IDxcBlobWide* self) GetStringPointer;
			public function [CallingConvention(.Stdcall)] int(IDxcBlobWide* self) GetStringLength;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcBlobUtf8 : IDxcBlobEncoding
	{
		public static new Guid sIID = .(0x3DA636C9, 0xBA71, 0x4024, 0xA3, 0x01, 0x30, 0xCB, 0xF1, 0x25, 0x30, 0x5B);

		public struct VTable : IDxcBlobEncoding.VTable
		{
			public function [CallingConvention(.Stdcall)] char8*(IDxcBlobUtf8* self) GetStringPointer;
			public function [CallingConvention(.Stdcall)] int(IDxcBlobUtf8* self) GetStringLength;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

#if BF_PLATFORM_WINDOWS
	typealias IDxcBlobUtf16 = IDxcBlobWide;
#endif
	
	public struct IDxcIncludeHandler  : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x7f61fc7d, 0x950d, 0x467f, 0xb3, 0xe3, 0x3c, 0x02, 0xfb, 0x49, 0x18, 0x7c);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcIncludeHandler* self, char16* pFilename, out IDxcBlob** ppIncludeSource) LoadSource;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	[CRepr]
	struct DxcBuffer
	{
		public void* Ptr;
		public int Size;
		public uint Encoding;
	}

	typealias DxcText = DxcBuffer;

	[CRepr]
	public struct DxcDefine
	{
		public char16* Name;
		public char16* Value;
	}

	public struct IDxcCompilerArgs : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x73EFFE2A, 0x70DC, 0x45F8, 0x96, 0x90, 0xEF, 0xF6, 0x4C, 0x02, 0x42, 0x9D);
		public static Guid sCLSID = CLSID_DxcCompilerArgs;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] char16**(IDxcCompilerArgs * self) GetArguments;
			public function [CallingConvention(.Stdcall)] uint32(IDxcCompilerArgs * self) GetCount;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompilerArgs * self,
				char16** pArguments,       // Array of pointers to arguments to add
				uint32 argCount                                // Number of arguments to add
				) AddArguments;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompilerArgs * self,
				char8** pArguments,         // Array of pointers to UTF-8 arguments to add
				uint32 argCount                                // Number of arguments to add
				) AddArgumentsUTF8;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompilerArgs * self,
				DxcDefine *pDefines, // Array of defines
				uint32 defineCount   // Number of defines
				) AddDefines;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcUtils  : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x4605C4CB, 0x2019, 0x492A, 0xAD, 0xA4, 0x65, 0xF2, 0x0B, 0xB7, 0xD6, 0x7F);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Create a sub-blob that holds a reference to the outer blob and points to its memory.
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				IDxcBlob *pBlob, uint32 offset, uint32 length, out IDxcBlob **ppResult
			) CreateBlobFromBlob;

			// For codePage, use 0 (or DXC_CP_ACP) for raw binary or ANSI code page

			// Creates a blob referencing existing memory, with no copy.
			// User must manage the memory lifetime separately.
			// (was: CreateBlobWithEncodingFromPinned)
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				void* pData, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
			) CreateBlobFromPinned;

			// Create blob, taking ownership of memory allocated with supplied allocator.
			// (was: CreateBlobWithEncodingOnMalloc)
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				void* pData, IMalloc *pIMalloc, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
			) MoveToBlob;

			////
			// New blobs and copied contents are allocated with the current allocator

			// Copy blob contents to memory owned by the new blob.
			// (was: CreateBlobWithEncodingOnHeapCopy)
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				void* pData, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
			) CreateBlob;

			// (was: CreateBlobFromFile)
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				char16* pFileName, uint32* pCodePage,
				out IDxcBlobEncoding **pBlobEncoding
			) LoadFile;

			// Create default file-based include handler
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				IDxcBlob *pBlob, out IStream **ppStream
			) CreateReadOnlyStreamFromBlob;

			// Create default file-based include handler
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				out IDxcIncludeHandler **ppResult
			) CreateDefaultIncludeHandler;

			// Convert or return matching encoded text blobs
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				IDxcBlob *pBlob, out IDxcBlobUtf8 **pBlobEncoding
			) GetBlobAsUtf8;


			// Renamed from GetBlobAsUtf16 to GetBlobAsWide
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				 IDxcBlob *pBlob, out IDxcBlobWide **pBlobEncoding
			) GetBlobAsWide;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				DxcBuffer *pShader,
				uint32 DxcPart,
				out void **ppPartData,
				out uint32 *pPartSizeInBytes
			) GetDxilContainerPart;

			// Create reflection interface from serialized Dxil container, or DXC_PART_REFLECTION_DATA.
			// TBD: Require part header for RDAT?  (leaning towards yes)
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				DxcBuffer *pData, ref Guid iid, void **ppvReflection
			) CreateReflection;
			
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				char16* pSourceName,               // Optional file name for pSource. Used in errors and include handlers.
				char16* pEntryPoint,               // Entry point name. (-E)
				char16* pTargetProfile,                // Shader profile to compile. (-T)
				char16* *pArguments, // Array of pointers to arguments
				uint32 argCount,                         // Number of arguments
				DxcDefine *pDefines,                  // Array of defines
				uint32 defineCount,                      // Number of defines
				out IDxcCompilerArgs **ppArgs        // Arguments you can use with Compile() method
			) BuildArguments;

			// Takes the shader PDB and returns the hash and the container inside it
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcUtils* self,
				IDxcBlob *pPDBBlob, out IDxcBlob **ppHash, out IDxcBlob **ppContainer
			) GetPDBContents;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}


	// For use with IDxcResult::[Has|Get]Output dxcOutKind argument
	// Note: text outputs returned from version 2 APIs are UTF-8 or UTF-16 based on -encoding option
	[CRepr]
	enum DXC_OUT_KIND {
	  DXC_OUT_NONE = 0,
	  DXC_OUT_OBJECT = 1,         // IDxcBlob - Shader or library object
	  DXC_OUT_ERRORS = 2,         // IDxcBlobUtf8 or IDxcBlobWide
	  DXC_OUT_PDB = 3,            // IDxcBlob
	  DXC_OUT_SHADER_HASH = 4,    // IDxcBlob - DxcShaderHash of shader or shader with source info (-Zsb/-Zss)
	  DXC_OUT_DISASSEMBLY = 5,    // IDxcBlobUtf8 or IDxcBlobWide - from Disassemble
	  DXC_OUT_HLSL = 6,           // IDxcBlobUtf8 or IDxcBlobWide - from Preprocessor or Rewriter
	  DXC_OUT_TEXT = 7,           // IDxcBlobUtf8 or IDxcBlobWide - other text, such as -ast-dump or -Odump
	  DXC_OUT_REFLECTION = 8,     // IDxcBlob - RDAT part with reflection data
	  DXC_OUT_ROOT_SIGNATURE = 9, // IDxcBlob - Serialized root signature output
	  DXC_OUT_EXTRA_OUTPUTS  = 10,// IDxcExtraResults - Extra outputs
	  DXC_OUT_REMARKS = 11,       // IDxcBlobUtf8 or IDxcBlobUtf16 - text directed at stdout

	  DXC_OUT_FORCE_DWORD = 0xFFFFFFFF
	}
	
	public struct IDxcResult : IDxcOperationResult 
	{
		public static new Guid sIID = .(0x58346CDA, 0xDDE7, 0x4497, 0x94, 0x61, 0x6F, 0x87, 0xAF, 0x5E, 0x06, 0x59);

		public struct VTable : IDxcOperationResult.VTable
		{
			public function [CallingConvention(.Stdcall)] bool(IDxcResult * self, DXC_OUT_KIND dxcOutKin) HasOutput;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcResult * self,
				DXC_OUT_KIND dxcOutKind,
    			ref Guid iid,
				out void **ppvObject,
    			out IDxcBlobWide **ppOutputName) GetOutput;

			
			public function [CallingConvention(.Stdcall)] uint32(IDxcResult * self) GetNumOutputs;
			public function [CallingConvention(.Stdcall)] DXC_OUT_KIND(IDxcResult * self, uint32 index) GetOutputByIndex;
			public function [CallingConvention(.Stdcall)] DXC_OUT_KIND(IDxcResult * self) PrimaryOutput;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public static
	{
		public const String DXC_EXTRA_OUTPUT_NAME_STDOUT =  "*stdout*";
		public const String DXC_EXTRA_OUTPUT_NAME_STDERR = "*stderr*";
	}

	public struct IDxcExtraOutputs : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x319b37a2,0xa5c2,0x494a,0xa5,0xde,0x48,0x01,0xb2,0xfa,0xf9,0x89);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] uint32(IDxcExtraOutputs * self) GetOutputCount;

			public function [CallingConvention(.Stdcall)] HResult(IDxcExtraOutputs * self,
				uint32 uIndex,
    			ref Guid iid, out void **ppvObject,
    			out IDxcBlobWide **ppOutputType,
    			out IDxcBlobWide **ppOutputName) GetOutput;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcCompiler3 : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x228B4687, 0x5A6A, 0x4730, 0x90, 0x0C, 0x97, 0x02, 0xB2, 0x20, 0x3F, 0x54);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			
			// Compile a single entry point to the target shader model,
			// Compile a library to a library target (-T lib_*),
			// Compile a root signature (-T rootsig_*), or
			// Preprocess HLSL source (-P)
			public function [CallingConvention(.Stdcall)] HResult(IDxcCompiler3 * self,
				DxcBuffer *pSource,                // Source text to compile
			    char16* *pArguments, // Array of pointers to arguments
			    uint32 argCount,                         // Number of arguments
			    IDxcIncludeHandler *pIncludeHandler, // user-provided interface to handle #include directives (optional)
			    ref Guid riid, out void**ppResult      // IDxcResult: status, buffer, and errors
				) Compile;

			// Disassemble a program.
			public function [CallingConvention(.Stdcall)] HResult(IDxcCompiler3 * self,
				DxcBuffer *pObject,                // Program to disassemble: dxil container or bitcode.
				ref Guid riid, out void**ppResult      // IDxcResult: status, disassembly text, and errors
				) Disassemble;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public static
	{
		public static uint32 DxcValidatorFlags_Default = 0;
		public static uint32 DxcValidatorFlags_InPlaceEdit = 1;  // Validator is allowed to update shader blob in-place.
		public static uint32 DxcValidatorFlags_RootSignatureOnly = 2;
		public static uint32 DxcValidatorFlags_ModuleOnly = 4;
		public static uint32 DxcValidatorFlags_ValidMask = 0x7;
	}

	public struct IDxcValidator : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xA6E82BD2, 0x1FD7, 0x4826, 0x98, 0x11, 0x28, 0x57, 0xE7, 0x97, 0xF4, 0x9A);
		public static Guid sCLSID = CLSID_DxcValidator;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Validate a shader.
			public function [CallingConvention(.Stdcall)] HResult(IDxcValidator * self,
				IDxcBlob *pShader,                       // Shader to validate.
				uint32 Flags,                            // Validation flags.
				out IDxcOperationResult **ppResult   // Validation output status, buffer, and errors
				) Validate;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcValidator2 : IDxcValidator
	{
		public static new Guid sIID = .(0x458e1fd1, 0xb1b2, 0x4750, 0xa6, 0xe1, 0x9c, 0x10, 0xf0, 0x3b, 0xed, 0x92);

		public struct VTable : IDxcValidator.VTable
		{
			// Validate a shader.
			public function [CallingConvention(.Stdcall)] HResult(IDxcValidator2 * self,
				IDxcBlob *pShader,                       // Shader to validate.
				uint32 Flags,                            // Validation flags.
				DxcBuffer *pOptDebugBitcode,         // Optional debug module bitcode to provide line numbers
				out IDxcOperationResult **ppResult   // Validation output status, buffer, and errors
				) ValidateWithDebug;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcContainerBuilder : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x334b1f50, 0x2292, 0x4b35, 0x99, 0xa1, 0x25, 0x58, 0x8d, 0x8c, 0x17, 0xfe);
		public static Guid sCLSID = CLSID_DxcContainerBuilder;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Loads DxilContainer to the builder
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerBuilder * self,IDxcBlob *pDxilContainerHeader) Load;

			// Part to add to the container
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerBuilder * self, uint32 fourCC, IDxcBlob *pSource) AddPart;

			// Remove the part with fourCC
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerBuilder * self, uint32 fourCC) RemovePart;

			// Builds a container of the given container builder state
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerBuilder * self, out IDxcOperationResult **ppResult) SerializeContainer;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcAssembler : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x091f7a26, 0x1c1f, 0x4948, 0x90, 0x4b, 0xe6, 0xe3, 0xa8, 0xa7, 0x71, 0xd5);
		public static Guid sCLSID = CLSID_DxcAssembler;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Assemble dxil in ll or llvm bitcode to DXIL container.
			public function [CallingConvention(.Stdcall)] HResult(IDxcAssembler * self,
				IDxcBlob *pShader,                       // Shader to assemble.
				out IDxcOperationResult **ppResult   // Assembly output status, buffer, and errors
				) AssembleToContainer;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcContainerReflection : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xd2c21b26, 0x8350, 0x4bdc, 0x97, 0x6a, 0x33, 0x1c, 0xe6, 0xf4, 0xc5, 0x4c);
		public static Guid sCLSID = CLSID_DxcContainerReflection;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Container to load.
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, IDxcBlob *pContainer) Load;
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, out uint32 *pResult) GetPartCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, uint32 idx, out uint32 *pResult) GetPartKind;
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, uint32 idx, out IDxcBlob **ppResult) GetPartContent;
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, uint32 kind, out uint32 *pResult) FindFirstPartKind;
			public function [CallingConvention(.Stdcall)] HResult(IDxcContainerReflection * self, uint32 idx, ref Guid iid, void **ppvObject) GetPartReflection;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcOptimizerPass : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xAE2CD79F, 0xCC22, 0x453F, 0x9B, 0x6B, 0xB1, 0x24, 0xE7, 0xA5, 0x20, 0x4C);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizerPass * self, out char16 *ppResult) GetOptionName;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizerPass * self, out char16 *ppResult) GetDescription;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizerPass * self, out uint32 *pCount) GetOptionArgCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizerPass * self, uint32 argIndex, out char16 *ppResult) GetOptionArgName;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizerPass * self, uint32 argIndex, out char16 *ppResult) GetOptionArgDescription;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcOptimizer : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x25740E2E, 0x9CBA, 0x401B, 0x91, 0x19, 0x4F, 0xB4, 0x2F, 0x39, 0xF2, 0x70);
		public static Guid sCLSID = CLSID_DxcOptimizer;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self, out uint32 *pCount) GetAvailablePassCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self, uint32 index, out IDxcOptimizerPass** ppResult) GetAvailablePass;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self,
				IDxcBlob *pBlob,
				char16* *ppOptions, uint32 optionCount,
				out IDxcBlob **pOutputModule,
				out IDxcBlobEncoding **ppOutputText
				) RunOptimizer;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public static{
		public const uint32 DxcVersionInfoFlags_None = 0;
		public const uint32 DxcVersionInfoFlags_Debug = 1; // Matches VS_FF_DEBUG
		public const uint32 DxcVersionInfoFlags_Internal = 2; // Internal Validator (non-signing)
	}

	public struct IDxcVersionInfo : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xb04f5b50, 0x2059, 0x4f12, 0xa8, 0xff, 0xa1, 0xe0, 0xcd, 0xe1, 0xcc, 0x7e);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcVersionInfo * self, out uint32 *pMajor, out uint32 *pMinor) GetVersion;
			public function [CallingConvention(.Stdcall)] HResult(IDxcVersionInfo * self, out uint32 *pFlags) GetFlags;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcVersionInfo2 : IDxcVersionInfo
	{
		public static new Guid sIID = .(0xfb6904c4, 0x42f0, 0x4b62, 0x9c, 0x46, 0x98, 0x3a, 0xf7, 0xda, 0x7c, 0x83);

		public struct VTable : IDxcVersionInfo.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcVersionInfo2 * self,
				out uint32 *pCommitCount,           // The total number commits.
				out char8 **pCommitHash  // The SHA of the latest commit. (Must be CoTaskMemFree()'d!)
				) GetCommitInfo;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcVersionInfo3 : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x5e13e843, 0x9d25, 0x473c, 0x9a, 0xd2, 0x03, 0xb2, 0xd0, 0xb4, 0x4b, 0x1e);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			// Assemble dxil in ll or llvm bitcode to DXIL container.
			public function [CallingConvention(.Stdcall)] HResult(IDxcVersionInfo3 * self,
				out char8 **pVersionString // Custom version string for compiler. (Must be CoTaskMemFree()'d!)
				) GetCustomVersionString;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	[CRepr]
	struct DxcArgPair {
	  public char16 *pName;// wchar
	  public char16 *pValue;// wchar
	}

	typealias BSTR = void*;

	public struct IDxcPdbUtils : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xE6C9647E, 0x9D6A, 0x4C3B, 0xB9, 0x4C, 0x52, 0x4B, 0x5A, 0x6C, 0x34, 0x3D);
		public static Guid sCLSID = CLSID_DxcPdbUtils;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, IDxcBlob *pPdbOrDxil) Load;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out uint32 *pCount) GetSourceCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out IDxcBlobEncoding **ppResult) GetSource;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out BSTR *pResult) GetSourceName;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out uint32 *pCount) GetFlagCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out BSTR *pResult) GetFlag;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out uint32 *pCount) GetArgCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out BSTR *pResult) GetArg;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out uint32 *pCount) GetArgPairCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out BSTR *pName, out BSTR *pValue) GetArgPair;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out uint32 *pCount) GetDefineCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  uint32 uIndex, out BSTR *pResult) GetDefine;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out BSTR *pResult) GetTargetProfile;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out BSTR *pResult) GetEntryPoint;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out BSTR *pResult) GetMainFileName;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out IDxcBlob **ppResult) GetHash;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out BSTR *pResult) GetName;

			public function [CallingConvention(.Stdcall)] bool(IDxcPdbUtils * self) IsFullPDB;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out IDxcBlob **ppFullPDB) GetFullPDB;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out IDxcVersionInfo **ppVersionInfo) GetVersionInfo;

			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  IDxcCompiler3 *pCompiler) SetCompiler;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self, out IDxcResult **ppResult) CompileForFullPDB;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  DxcArgPair *pArgPairs, uint32 uNumArgPairs) OverrideArgs;
			public function [CallingConvention(.Stdcall)] HResult(IDxcPdbUtils * self,  char16 *pRootSignature) OverrideRootSignature;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	////////////////////////////////////////////////////////////
	
	public struct IDxcOperationResult : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xCEDB484A,0xD4E9,0x445A,0xB9, 0x91,0xCA, 0x21, 0xCA, 0x15, 0x7D, 0xC2);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out HResult* pStatus) GetStatus;

			// GetResult returns the main result of the operation.
			// This corresponds to:
			// DXC_OUT_OBJECT - Compile() with shader or library target
			// DXC_OUT_DISASSEMBLY - Disassemble()
			// DXC_OUT_HLSL - Compile() with -P
			// DXC_OUT_ROOT_SIGNATURE - Compile() with rootsig_* target
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out IDxcBlob **ppResult) GetResult;

			// GetErrorBuffer Corresponds to DXC_OUT_ERRORS.
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out IDxcBlobEncoding **ppErrors) GetErrorBuffer;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	////////////////////////////////////////////////////////////


	// Legacy

	// NOTE: IDxcUtils replaces IDxcLibrary
	public struct IDxcLibrary : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xe5204dc7, 0xd18c, 0x4c3c, 0xbd, 0xfb, 0x85, 0x16, 0x73, 0x98, 0x0f, 0xe7);
		public static Guid sCLSID = CLSID_DxcLibrary;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, IMalloc *pMalloc) SetMalloc;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self,
				IDxcBlob *pBlob, uint32 offset, uint32 length, out IDxcBlob **ppResult) CreateBlobFromBlob;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				char16* pFileName, uint32* codePage,
				out IDxcBlobEncoding **pBlobEncoding
				) CreateBlobFromFile;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self,
				void* pText, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
				) CreateBlobWithEncodingFromPinned;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				void* pText, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
				) CreateBlobWithEncodingOnHeapCopy;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				void* pText, IMalloc *pIMalloc, uint32 size, uint32 codePage,
				out IDxcBlobEncoding **pBlobEncoding
				) CreateBlobWithEncodingOnMalloc;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				 out IDxcIncludeHandler **ppResult) CreateIncludeHandler;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IStream **ppStream) CreateStreamFromBlobReadOnly;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IDxcBlobEncoding **pBlobEncoding) GetBlobAsUtf8;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IDxcBlobEncoding **pBlobEncoding) GetBlobAsWide;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}
	
	public struct IDxcCompiler : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x8c210bf3, 0x011f, 0x4422, 0x8d, 0x70, 0x6f, 0x9a, 0xcb, 0x8d, 0xb6, 0x17);
		public static Guid sCLSID = CLSID_DxcCompiler;

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompiler* self,
				IDxcBlob* pSource, // Source text to compile
				char16* pSourceName, // Optional file name for pSource. Used in errors and include handlers.
				char16* pEntryPoint, // entry point name
				char16* pTargetProfile, // shader profile to compile
				char16** pArguments, // Array of pointers to arguments
				uint32 argCount, // Number of arguments
				DxcDefine *pDefines, // Array of defines
				uint32 defineCount, // Number of defines
				IDxcIncludeHandler *pIncludeHandler, // user-provided interface to handle #include directives (optional)
				out IDxcOperationResult** ppResult // Compiler output status, buffer, and errors
				) Compile;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompiler* self,
			  	IDxcBlob *pSource,                       // Source text to preprocess
			  	char16* pSourceName,               // Optional file name for pSource. Used in errors and include handlers.
			  	char16** pArguments, // Array of pointers to arguments
			  	uint32 argCount,                         // Number of arguments
			 	DxcDefine *pDefines,                  // Array of defines
			  	uint32 defineCount,                      // Number of defines
			  	IDxcIncludeHandler *pIncludeHandler, // user-provided interface to handle #include directives (optional)
			  	out IDxcOperationResult **ppResult   // Preprocessor output status, buffer, and errors
			) Preprocess;

			public function [CallingConvention(.Stdcall)] HResult(
				IDxcCompiler* self,
				IDxcBlob *pSource,                         // Program to disassemble.
				out IDxcBlobEncoding **ppDisassembly   // Disassembly text.
			)Disassemble;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcCompiler2 : IDxcCompiler
	{
		public static new Guid sIID = .(0xA005A9D9, 0xB8BB, 0x4594, 0xB5, 0xC9, 0x0E, 0x63, 0x3B, 0xEC, 0x4D, 0x37);
		public static new Guid sCLSID = CLSID_DxcCompiler;

		public struct VTable : IDxcCompiler.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult (
				IDxcCompiler2* self,
			    IDxcBlob *pSource,                       // Source text to compile
			    char16* pSourceName,               // Optional file name for pSource. Used in errors and include handlers.
			    char16* pEntryPoint,               // Entry point name
			    char16* pTargetProfile,                // Shader profile to compile
			    char16** pArguments, // Array of pointers to arguments
			    uint32 argCount,                         // Number of arguments
			    DxcDefine *pDefines,                  // Array of defines
			    uint32 defineCount,                      // Number of defines
			    IDxcIncludeHandler *pIncludeHandler, // user-provided interface to handle #include directives (optional)
			    IDxcOperationResult **ppResult,  // Compiler output status, buffer, and errors
			    out char16 *ppDebugBlobName,// Suggested file name for debug blob. (Must be CoTaskMemFree()'d!)
			    out IDxcBlob **ppDebugBlob       // Debug blob
			  ) CompileWithDebug;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	public struct IDxcLinker : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xF1B5BE2A, 0x62DD, 0x4327, 0xA1, 0xC2, 0x42, 0xAC, 0x1E, 0x1E, 0x78, 0xE6);
		public static Guid sCLSID = CLSID_DxcLinker;

		public struct VTable : IDxcCompiler.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult (
				IDxcLinker* self,
				char16* pLibName,          // Name of the library.
    			IDxcBlob *pLib                 // Library blob.
				) RegisterLibrary;
			
			public function [CallingConvention(.Stdcall)] HResult (
				IDxcLinker* self,
				char16* pEntryName,        // Entry point name
				char16* pTargetProfile,        // shader profile to link
				char16** pLibNames,       // Array of library names to link
				uint32 libCount,               // Number of libraries to link
				char16** pArguments, // Array of pointers to arguments
				uint32 argCount,               // Number of arguments
				out IDxcOperationResult **ppResult  // Linker output status, buffer, and errors
				) Link;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}

	/*
	public struct DxcDiaDataSource : Windows.COM_IUnknown
	{
		public static Guid sCLSID = CLSID_DxcDiaDataSource;
	}
	*/
}