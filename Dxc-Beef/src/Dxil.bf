using System;
namespace Dxc_Beef
{
	public static
	{
		public static mixin DXIL_FOURCC(var ch0, var ch1, var ch2, var ch3)
		{
			(uint32)(uint8)(ch0) | (uint32)(uint8)(ch1) << 8 | (uint32)(uint8)(ch2) << 16 | (uint32)(uint8)(ch3) << 24
		}
	}

	static class Dxil
	{
		public enum DxilFourCC
		{
		  DFCC_Container                = DXIL_FOURCC!('D', 'X', 'B', 'C'), // for back-compat with tools that look for DXBC containers
		  DFCC_ResourceDef              = DXIL_FOURCC!('R', 'D', 'E', 'F'),
		  DFCC_InputSignature           = DXIL_FOURCC!('I', 'S', 'G', '1'),
		  DFCC_OutputSignature          = DXIL_FOURCC!('O', 'S', 'G', '1'),
		  DFCC_PatchConstantSignature   = DXIL_FOURCC!('P', 'S', 'G', '1'),
		  DFCC_ShaderStatistics         = DXIL_FOURCC!('S', 'T', 'A', 'T'),
		  DFCC_ShaderDebugInfoDXIL      = DXIL_FOURCC!('I', 'L', 'D', 'B'),
		  DFCC_ShaderDebugName          = DXIL_FOURCC!('I', 'L', 'D', 'N'),
		  DFCC_FeatureInfo              = DXIL_FOURCC!('S', 'F', 'I', '0'),
		  DFCC_PrivateData              = DXIL_FOURCC!('P', 'R', 'I', 'V'),
		  DFCC_RootSignature            = DXIL_FOURCC!('R', 'T', 'S', '0'),
		  DFCC_DXIL                     = DXIL_FOURCC!('D', 'X', 'I', 'L'),
		  DFCC_PipelineStateValidation  = DXIL_FOURCC!('P', 'S', 'V', '0'),
		  DFCC_RuntimeData              = DXIL_FOURCC!('R', 'D', 'A', 'T'),
		  DFCC_ShaderHash               = DXIL_FOURCC!('H', 'A', 'S', 'H'),
		  DFCC_ShaderSourceInfo         = DXIL_FOURCC!('S', 'R', 'C', 'I'),
		  DFCC_CompilerVersion          = DXIL_FOURCC!('V', 'E', 'R', 'S'),
		}

		// DXIL version.
		public const uint32 kDxilMajor = 1;
		/* <py.lines('VALRULE-TEXT')>hctdb_instrhelp.get_dxil_version_minor()</py>*/
		// VALRULE-TEXT:BEGIN
		public const uint32 kDxilMinor = 8;
		// VALRULE-TEXT:END

		[Inline] public static  uint32 MakeDxilVersion(uint32 DxilMajor, uint32 DxilMinor) {
		  return 0 | (DxilMajor << 8) | (DxilMinor);
		}
		[Inline] public static  uint32 GetCurrentDxilVersion() {
		  return MakeDxilVersion(kDxilMajor, kDxilMinor);
		}
		[Inline] public static  uint32 GetDxilVersionMajor(uint32 DxilVersion) {
		  return (DxilVersion >> 8) & 0xFF;
		}
		[Inline] public static  uint32 GetDxilVersionMinor(uint32 DxilVersion) {
		  return DxilVersion & 0xFF;
		}
		// Return positive if v1 > v2, negative if v1 < v2, zero if equal
		[Inline] public static  int CompareVersions(uint32 Major1, uint32 Minor1, uint32 Major2,
		                           uint32 Minor2) {
		  if (Major1 != Major2) {
		    // Special case for Major == 0 (latest/unbound)
		    if (Major1 == 0 || Major2 == 0)
		      return Major1 > 0 ? -1 : 1;
		    return Major1 < Major2 ? -1 : 1;
		  }
		  if (Minor1 < Minor2)
		    return -1;
		  if (Minor1 > Minor2)
		    return 1;
		  return 0;
		}

		// Utility for updating major,minor to max of current and new.
		[Inline] public static  bool UpdateToMaxOfVersions(ref uint32 major, ref uint32 minor,
		                                  uint32 newMajor, uint32 newMinor) {
		  if (newMajor > major) {
		    major = newMajor;
		    minor = newMinor;
		    return true;
		  } else if (newMajor == major) {
		    if (newMinor > minor) {
		      minor = newMinor;
		      return true;
		    }
		  }
		  return false;
		}

		// Shader flags.
		public const uint32 kDisableOptimizations =
		    0x00000001; // D3D11_1_SB_GLOBAL_FLAG_SKIP_OPTIMIZATION
		public const uint32 kDisableMathRefactoring =
		    0x00000002; //~D3D10_SB_GLOBAL_FLAG_REFACTORING_ALLOWED
		public const uint32 kEnableDoublePrecision =
		    0x00000004; // D3D11_SB_GLOBAL_FLAG_ENABLE_DOUBLE_PRECISION_FLOAT_OPS
		public const uint32 kForceEarlyDepthStencil =
		    0x00000008; // D3D11_SB_GLOBAL_FLAG_FORCE_EARLY_DEPTH_STENCIL
		public const uint32 kEnableRawAndStructuredBuffers =
		    0x00000010; // D3D11_SB_GLOBAL_FLAG_ENABLE_RAW_AND_STRUCTURED_BUFFERS
		public const uint32 kEnableMinPrecision =
		    0x00000020; // D3D11_1_SB_GLOBAL_FLAG_ENABLE_MINIMUM_PRECISION
		public const uint32 kEnableDoubleExtensions =
		    0x00000040; // D3D11_1_SB_GLOBAL_FLAG_ENABLE_DOUBLE_EXTENSIONS
		public const uint32 kEnableMSAD =
		    0x00000080; // D3D11_1_SB_GLOBAL_FLAG_ENABLE_SHADER_EXTENSIONS
		public const uint32 kAllResourcesBound =
		    0x00000100; // D3D12_SB_GLOBAL_FLAG_ALL_RESOURCES_BOUND

		public const uint32 kNumOutputStreams = 4;
		public const uint32 kNumClipPlanes = 6;

		// TODO: move these to appropriate places (ShaderModel.cpp?)
		public const uint32 kMaxTempRegCount = 4096; // DXBC only
		public const uint32 kMaxCBufferSize = 4096;
		public const uint32 kMaxStructBufferStride = 2048;
		public const uint32 kMaxHSOutputControlPointsTotalScalars = 3968;
		public const uint32 kMaxHSOutputPatchConstantTotalScalars = 32 * 4;
		public const uint32 kMaxSignatureTotalVectors = 32;
		public const uint32 kMaxOutputTotalScalars = kMaxSignatureTotalVectors * 4;
		public const uint32 kMaxInputTotalScalars = kMaxSignatureTotalVectors * 4;
		public const uint32 kMaxClipOrCullDistanceElementCount = 2;
		public const uint32 kMaxClipOrCullDistanceCount = 2 * 4;
		public const uint32 kMaxGSOutputVertexCount = 1024;
		public const uint32 kMaxGSInstanceCount = 32;
		public const uint32 kMaxIAPatchControlPointCount = 32;
		const float kHSMaxTessFactorLowerBound = 1.0f;
		const float kHSMaxTessFactorUpperBound = 64.0f;
		public const uint32 kHSDefaultInputControlPointCount = 1;
		public const uint32 kMaxCSThreadsPerGroup = 1024;
		public const uint32 kMaxCSThreadGroupX = 1024;
		public const uint32 kMaxCSThreadGroupY = 1024;
		public const uint32 kMaxCSThreadGroupZ = 64;
		public const uint32 kMinCSThreadGroupX = 1;
		public const uint32 kMinCSThreadGroupY = 1;
		public const uint32 kMinCSThreadGroupZ = 1;
		public const uint32 kMaxCS4XThreadsPerGroup = 768;
		public const uint32 kMaxCS4XThreadGroupX = 768;
		public const uint32 kMaxCS4XThreadGroupY = 768;
		public const uint32 kMaxTGSMSize = 8192 * 4;
		public const uint32 kMaxGSOutputTotalScalars = 1024;
		public const uint32 kMaxMSASThreadsPerGroup = 128;
		public const uint32 kMaxMSASThreadGroupX = 128;
		public const uint32 kMaxMSASThreadGroupY = 128;
		public const uint32 kMaxMSASThreadGroupZ = 128;
		public const uint32 kMinMSASThreadGroupX = 1;
		public const uint32 kMinMSASThreadGroupY = 1;
		public const uint32 kMinMSASThreadGroupZ = 1;
		public const uint32 kMaxMSASPayloadBytes = 1024 * 16;
		public const uint32 kMaxMSOutputPrimitiveCount = 256;
		public const uint32 kMaxMSOutputVertexCount = 256;
		public const uint32 kMaxMSOutputTotalBytes = 1024 * 32;
		public const uint32 kMaxMSInputOutputTotalBytes = 1024 * 47;
		public const uint32 kMaxMSVSigRows = 32;
		public const uint32 kMaxMSPSigRows = 32;
		public const uint32 kMaxMSTotalSigRows = 32;
		public const uint32 kMaxMSSMSize = 1024 * 28;
		public const uint32 kMinWaveSize = 4;
		public const uint32 kMaxWaveSize = 128;

		const float kMaxMipLodBias = 15.99f;
		const float kMinMipLodBias = -16.0f;

		public const uint32 kResRetStatusIndex = 4;

		public enum ComponentType : uint32 {
		  Invalid = 0,
		  I1,
		  I16,
		  U16,
		  I32,
		  U32,
		  I64,
		  U64,
		  F16,
		  F32,
		  F64,
		  SNormF16,
		  UNormF16,
		  SNormF32,
		  UNormF32,
		  SNormF64,
		  UNormF64,
		  PackedS8x32,
		  PackedU8x32,
		  LastEntry
		};

		// Must match D3D_INTERPOLATION_MODE
		public enum InterpolationMode : uint8 {
		  Undefined = 0,
		  Constant = 1,
		  Linear = 2,
		  LinearCentroid = 3,
		  LinearNoperspective = 4,
		  LinearNoperspectiveCentroid = 5,
		  LinearSample = 6,
		  LinearNoperspectiveSample = 7,
		  Invalid = 8
		};

		// size of each scalar type in signature element in bits
		public enum SignatureDataWidth : uint8 {
		  Undefined = 0,
		  Bits16 = 16,
		  Bits32 = 32,
		};

		public enum SignatureKind {
		  Invalid = 0,
		  Input,
		  Output,
		  PatchConstOrPrim,
		};

		// Must match D3D11_SHADER_VERSION_TYPE
		public enum ShaderKind {
		  Pixel = 0,
		  Vertex,
		  Geometry,
		  Hull,
		  Domain,
		  Compute,
		  Library,
		  RayGeneration,
		  Intersection,
		  AnyHit,
		  ClosestHit,
		  Miss,
		  Callable,
		  Mesh,
		  Amplification,
		  Node,
		  Invalid,

		  // Last* values identify the last shader kind recognized by the highest
		  // validator version before additional kinds were added.
		  Last_1_2 = Compute,
		  Last_1_4 = Callable,
		  Last_1_7 = Amplification,
		  Last_1_8 = Node,
		  LastValid = Last_1_8,
		};


		/*static_assert((unsigned)DXIL.ShaderKind.LastValid + 1 ==
		                  (unsigned)DXIL.ShaderKind.Invalid,
		              "otherwise, enum needs updating.");*/

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('SemanticKind-ENUM')>hctdb_instrhelp.get_enum_decl("SemanticKind", hide_val=True, sort_val=False)</py>*/
		// clang-format on
		// SemanticKind-ENUM:BEGIN
		// Semantic kind; Arbitrary or specific system value.
		public enum SemanticKind : uint32 {
		  Arbitrary,
		  VertexID,
		  InstanceID,
		  Position,
		  RenderTargetArrayIndex,
		  ViewPortArrayIndex,
		  ClipDistance,
		  CullDistance,
		  OutputControlPointID,
		  DomainLocation,
		  PrimitiveID,
		  GSInstanceID,
		  SampleIndex,
		  IsFrontFace,
		  Coverage,
		  InnerCoverage,
		  Target,
		  Depth,
		  DepthLessEqual,
		  DepthGreaterEqual,
		  StencilRef,
		  DispatchThreadID,
		  GroupID,
		  GroupIndex,
		  GroupThreadID,
		  TessFactor,
		  InsideTessFactor,
		  ViewID,
		  Barycentrics,
		  ShadingRate,
		  CullPrimitive,
		  StartVertexLocation,
		  StartInstanceLocation,
		  Invalid,
		};
		// SemanticKind-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('SigPointKind-ENUM')>hctdb_instrhelp.get_enum_decl("SigPointKind", hide_val=True, sort_val=False)</py>*/
		// clang-format on
		// SigPointKind-ENUM:BEGIN
		// Signature Point is more specific than shader stage or signature as it is
		// unique in both stage and item dimensionality or frequency.
		public enum SigPointKind : uint32 {
		  VSIn,    // Ordinary Vertex Shader input from Input Assembler
		  VSOut,   // Ordinary Vertex Shader output that may feed Rasterizer
		  PCIn,    // Patch Constant function non-patch inputs
		  HSIn,    // Hull Shader function non-patch inputs
		  HSCPIn,  // Hull Shader patch inputs - Control Points
		  HSCPOut, // Hull Shader function output - Control Point
		  PCOut,   // Patch Constant function output - Patch Constant data passed to
		           // Domain Shader
		  DSIn, // Domain Shader regular input - Patch Constant data plus system values
		  DSCPIn, // Domain Shader patch input - Control Points
		  DSOut,  // Domain Shader output - vertex data that may feed Rasterizer
		  GSVIn,  // Geometry Shader vertex input - qualified with primitive type
		  GSIn,   // Geometry Shader non-vertex inputs (system values)
		  GSOut,  // Geometry Shader output - vertex data that may feed Rasterizer
		  PSIn,   // Pixel Shader input
		  PSOut,  // Pixel Shader output
		  CSIn,   // Compute Shader input
		  MSIn,   // Mesh Shader input
		  MSOut,  // Mesh Shader vertices output
		  MSPOut, // Mesh Shader primitives output
		  ASIn,   // Amplification Shader input
		  Invalid,
		};
		// SigPointKind-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('SemanticInterpretationKind-ENUM')>hctdb_instrhelp.get_enum_decl("SemanticInterpretationKind", hide_val=True, sort_val=False)</py>*/
		// clang-format on
		// SemanticInterpretationKind-ENUM:BEGIN
		// Defines how a semantic is interpreted at a particular SignaturePoint
		public enum SemanticInterpretationKind : uint32 {
		  NA,         // Not Available
		  SV,         // Normal System Value
		  SGV,        // System Generated Value (sorted last)
		  Arb,        // Treated as Arbitrary
		  NotInSig,   // Not included in signature (intrinsic access)
		  NotPacked,  // Included in signature, but does not contribute to packing
		  Target,     // Special handling for SV_Target
		  TessFactor, // Special handling for tessellation factors
		  Shadow,     // Shadow element must be added to a signature for compatibility
		  ClipCull,   // Special packing rules for SV_ClipDistance or SV_CullDistance
		  Invalid,
		};
		// SemanticInterpretationKind-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('PackingKind-ENUM')>hctdb_instrhelp.get_enum_decl("PackingKind", hide_val=True, sort_val=False)</py>*/
		// clang-format on
		// PackingKind-ENUM:BEGIN
		// Kind of signature point
		public enum PackingKind : uint32 {
		  None,           // No packing should be performed
		  InputAssembler, // Vertex Shader input from Input Assembler
		  Vertex,         // Vertex that may feed the Rasterizer
		  PatchConstant,  // Patch constant signature
		  Target,         // Render Target (Pixel Shader Output)
		  Invalid,
		};
		// PackingKind-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('FPDenormMode-ENUM')>hctdb_instrhelp.get_enum_decl("Float32DenormMode", hide_val=False, sort_val=False)</py>*/
		// clang-format on
		// FPDenormMode-ENUM:BEGIN
		// float32 denorm behavior
		public enum Float32DenormMode : uint32 {
		  Any = 0,      // Undefined behavior for denormal numbers
		  Preserve = 1, // Preserve both input and output
		  FTZ = 2,      // Preserve denormal inputs. Flush denorm outputs
		  Reserve3 = 3, // Reserved Value. Not used for now
		  Reserve4 = 4, // Reserved Value. Not used for now
		  Reserve5 = 5, // Reserved Value. Not used for now
		  Reserve6 = 6, // Reserved Value. Not used for now
		  Reserve7 = 7, // Reserved Value. Not used for now
		};
		// FPDenormMode-ENUM:END

		public enum PackingStrategy : uint32 {
		  Default = 0,  // Choose default packing algorithm based on target (currently
		                // PrefixStable)
		  PrefixStable, // Maintain assumption that all elements are packed in order and
		                // stable as new elements are added.
		  Optimized, // Optimize packing of all elements together (all elements must be
		             // present, in the same order, for identical placement of any
		             // individual element)
		  Invalid,
		};

		public enum DefaultLinkage : uint32 {
		  Default = 0,
		  Internal = 1,
		  External = 2,
		};

		public enum SamplerKind : uint32 {
		  Default = 0,
		  Comparison,
		  Mono,
		  Invalid,
		};

		public enum ResourceClass { SRV = 0, UAV, CBuffer, Sampler, Invalid };

		public enum ResourceKind : uint32 {
		  Invalid = 0,
		  Texture1D,
		  Texture2D,
		  Texture2DMS,
		  Texture3D,
		  TextureCube,
		  Texture1DArray,
		  Texture2DArray,
		  Texture2DMSArray,
		  TextureCubeArray,
		  TypedBuffer,
		  RawBuffer,
		  StructuredBuffer,
		  CBuffer,
		  Sampler,
		  TBuffer,
		  RTAccelerationStructure,
		  FeedbackTexture2D,
		  FeedbackTexture2DArray,
		  NumEntries,
		};

		/// Whether the resource kind is a texture. This does not include
		/// FeedbackTextures.
		[Inline] public static  bool IsAnyTexture(ResourceKind resourceKind) {
		  return ResourceKind.Texture1D <= resourceKind &&
		         resourceKind <= ResourceKind.TextureCubeArray;
		}

		/// Whether the resource kind is an array of textures. This does not include
		/// FeedbackTextures.
		[Inline] public static  bool IsAnyArrayTexture(ResourceKind resourceKind) {
		  return ResourceKind.Texture1DArray <= resourceKind &&
		         resourceKind <= ResourceKind.TextureCubeArray;
		}

		/// Whether the resource kind is a Texture or FeedbackTexture with array
		/// dimension.
		[Inline] public static  bool IsArrayKind(ResourceKind resourceKind) {
		  return IsAnyArrayTexture(resourceKind) ||
		         resourceKind == ResourceKind.FeedbackTexture2DArray;
		}

		/// Whether the resource kind is a TextureCube or TextureCubeArray.
		[Inline] public static  bool IsAnyTextureCube(ResourceKind resourceKind) {
		  return ResourceKind.TextureCube == resourceKind ||
		         ResourceKind.TextureCubeArray == resourceKind;
		}

		[Inline] public static  bool IsStructuredBuffer(ResourceKind resourceKind) {
		  return resourceKind == ResourceKind.StructuredBuffer;
		}

		[Inline] public static  bool IsTypedBuffer(ResourceKind resourceKind) {
		  return resourceKind == ResourceKind.TypedBuffer;
		}

		[Inline] public static  bool IsTyped(ResourceKind resourceKind) {
		  return IsTypedBuffer(resourceKind) || IsAnyTexture(resourceKind);
		}

		[Inline] public static  bool IsRawBuffer(ResourceKind resourceKind) {
		  return resourceKind == ResourceKind.RawBuffer;
		}

		[Inline] public static  bool IsTBuffer(ResourceKind resourceKind) {
		  return resourceKind == ResourceKind.TBuffer;
		}

		/// Whether the resource kind is a FeedbackTexture.
		[Inline] public static  bool IsFeedbackTexture(ResourceKind resourceKind) {
		  return resourceKind == ResourceKind.FeedbackTexture2D ||
		         resourceKind == ResourceKind.FeedbackTexture2DArray;
		}

		// TODO: change opcodes.
		/* <py.lines('OPCODE-ENUM')>hctdb_instrhelp.get_enum_decl("OpCode")</py>*/
		// OPCODE-ENUM:BEGIN
		// Enumeration for operations specified by DXIL
		public enum OpCode : uint32 {
		  // Amplification shader instructions
		  DispatchMesh = 173, // Amplification shader intrinsic DispatchMesh

		  // AnyHit Terminals
		  AcceptHitAndEndSearch =
		      156, // Used in an any hit shader to abort the ray query and the
		           // intersection shader (if any). The current hit is committed and
		           // execution passes to the closest hit shader with the closest hit
		           // recorded so far
		  IgnoreHit = 155, // Used in an any hit shader to reject an intersection and
		                   // terminate the shader

		  // Binary float
		  FMax = 35, // returns a if a >= b, else b
		  FMin = 36, // returns a if a < b, else b

		  // Binary int with two outputs
		  IMul = 41, // multiply of 32-bit operands to produce the correct full 64-bit
		             // result.

		  // Binary int
		  IMax = 37, // IMax(a,b) returns a if a > b, else b
		  IMin = 38, // IMin(a,b) returns a if a < b, else b

		  // Binary uint with carry or borrow
		  UAddc = 44, // uint32 add of 32-bit operand with the carry
		  USubb = 45, // uint32 subtract of 32-bit operands with the borrow

		  // Binary uint with two outputs
		  UDiv = 43, // uint32 divide of the 32-bit operand src0 by the 32-bit operand
		             // src1.
		  UMul = 42, // multiply of 32-bit operands to produce the correct full 64-bit
		             // result.

		  // Binary uint
		  UMax = 39, // uint32 integer maximum. UMax(a,b) = a > b ? a : b
		  UMin = 40, // uint32 integer minimum. UMin(a,b) = a < b ? a : b

		  // Bitcasts with different sizes
		  BitcastF16toI16 = 125, // bitcast between different sizes
		  BitcastF32toI32 = 127, // bitcast between different sizes
		  BitcastF64toI64 = 129, // bitcast between different sizes
		  BitcastI16toF16 = 124, // bitcast between different sizes
		  BitcastI32toF32 = 126, // bitcast between different sizes
		  BitcastI64toF64 = 128, // bitcast between different sizes

		  // Comparison Samples
		  SampleCmpBias = 255, // samples a texture after applying the input bias to the
		                       // mipmap level and compares a single component against
		                       // the specified comparison value
		  SampleCmpGrad =
		      254, // samples a texture using a gradient and compares a single component
		           // against the specified comparison value

		  // Compute/Mesh/Amplification/Node shader
		  FlattenedThreadIdInGroup = 96, // provides a flattened index for a given
		                                 // thread within a given group (SV_GroupIndex)
		  GroupId = 94,                  // reads the group ID (SV_GroupID)
		  ThreadId = 93,                 // reads the thread ID
		  ThreadIdInGroup =
		      95, // reads the thread ID within the group (SV_GroupThreadID)

		  // Create/Annotate Node Handles
		  AllocateNodeOutputRecords = 238, // returns a handle for the output records
		  AnnotateNodeHandle = 249,        // annotate handle with node properties
		  AnnotateNodeRecordHandle = 251, // annotate handle with node record properties
		  CreateNodeInputRecordHandle = 250, // create a handle for an InputRecord
		  CreateNodeOutputHandle = 247,      // Creates a handle to a NodeOutput
		  IndexNodeHandle = 248, // returns the handle for the location in the output
		                         // node array at the indicated index

		  // Derivatives
		  CalculateLOD = 81, // calculates the level of detail
		  DerivCoarseX = 83, // computes the rate of change per stamp in x direction.
		  DerivCoarseY = 84, // computes the rate of change per stamp in y direction.
		  DerivFineX = 85,   // computes the rate of change per pixel in x direction.
		  DerivFineY = 86,   // computes the rate of change per pixel in y direction.

		  // Domain and hull shader
		  LoadOutputControlPoint = 103, // LoadOutputControlPoint
		  LoadPatchConstant = 104,      // LoadPatchConstant

		  // Domain shader
		  DomainLocation = 105, // DomainLocation

		  // Dot product with accumulate
		  Dot2AddHalf = 162,     // 2D half dot product with accumulate to float
		  Dot4AddI8Packed = 163, // signed dot product of 4 x i8 vectors packed into
		                         // i32, with accumulate to i32
		  Dot4AddU8Packed = 164, // uint32 dot product of 4 x u8 vectors packed into
		                         // i32, with accumulate to i32

		  // Dot
		  Dot2 = 54, // Two-dimensional vector dot-product
		  Dot3 = 55, // Three-dimensional vector dot-product
		  Dot4 = 56, // Four-dimensional vector dot-product

		  // Double precision
		  LegacyDoubleToFloat = 132,  // legacy fuction to convert double to float
		  LegacyDoubleToSInt32 = 133, // legacy fuction to convert double to int32
		  LegacyDoubleToUInt32 = 134, // legacy fuction to convert double to uint32
		  MakeDouble = 101,           // creates a double value
		  SplitDouble = 102,          // splits a double into low and high parts

		  // Extended Command Information
		  StartInstanceLocation =
		      257, // returns the StartInstanceLocation from Draw*Instanced
		  StartVertexLocation =
		      256, // returns the BaseVertexLocation from DrawIndexedInstanced or
		           // StartVertexLocation from DrawInstanced

		  // Geometry shader
		  CutStream =
		      98, // completes the current primitive topology at the specified stream
		  EmitStream = 97,        // emits a vertex to a given stream
		  EmitThenCutStream = 99, // equivalent to an EmitStream followed by a CutStream
		  GSInstanceID = 100,     // GSInstanceID

		  // Get Pointer to Node Record in Address Space 6
		  GetNodeRecordPtr =
		      239, // retrieve node input/output record pointer in address space 6

		  // Get handle from heap
		  AnnotateHandle = 216,          // annotate handle with resource properties
		  CreateHandleFromBinding = 217, // create resource handle from binding
		  CreateHandleFromHeap = 218,    // create resource handle from heap

		  // Graphics shader
		  ViewID = 138, // returns the view index

		  // Helper Lanes
		  IsHelperLane = 221, // returns true on helper lanes in pixel shaders

		  // Hull shader
		  OutputControlPointID = 107, // OutputControlPointID
		  StorePatchConstant = 106,   // StorePatchConstant

		  // Hull, Domain and Geometry shaders
		  PrimitiveID = 108, // PrimitiveID

		  // Indirect Shader Invocation
		  CallShader = 159, // Call a shader in the callable shader table supplied
		                    // through the DispatchRays() API
		  ReportHit = 158,  // returns true if hit was accepted
		  TraceRay = 157,   // initiates raytrace

		  // Inline Ray Query
		  AllocateRayQuery = 178, // allocates space for RayQuery and return handle
		  RayQuery_Abort = 181,   // aborts a ray query
		  RayQuery_CandidateGeometryIndex = 203, // returns candidate hit geometry index
		  RayQuery_CandidateInstanceContributionToHitGroupIndex =
		      214, // returns candidate hit InstanceContributionToHitGroupIndex
		  RayQuery_CandidateInstanceID = 202,    // returns candidate hit instance ID
		  RayQuery_CandidateInstanceIndex = 201, // returns candidate hit instance index
		  RayQuery_CandidateObjectRayDirection =
		      206, // returns candidate object ray direction
		  RayQuery_CandidateObjectRayOrigin =
		      205, // returns candidate hit object ray origin
		  RayQuery_CandidateObjectToWorld3x4 =
		      186, // returns matrix for transforming from object-space to world-space
		           // for a candidate hit.
		  RayQuery_CandidatePrimitiveIndex =
		      204, // returns candidate hit geometry index
		  RayQuery_CandidateProceduralPrimitiveNonOpaque =
		      190, // returns if current candidate procedural primitive is non opaque
		  RayQuery_CandidateTriangleBarycentrics =
		      193, // returns candidate triangle hit barycentrics
		  RayQuery_CandidateTriangleFrontFace =
		      191, // returns if current candidate triangle is front facing
		  RayQuery_CandidateTriangleRayT =
		      199, // returns float representing the parametric point on the ray for the
		           // current candidate triangle hit.
		  RayQuery_CandidateType =
		      185, // returns uint candidate type (CANDIDATE_TYPE) of the current hit
		           // candidate in a ray query, after Proceed() has returned true
		  RayQuery_CandidateWorldToObject3x4 =
		      187, // returns matrix for transforming from world-space to object-space
		           // for a candidate hit.
		  RayQuery_CommitNonOpaqueTriangleHit =
		      182, // commits a non opaque triangle hit
		  RayQuery_CommitProceduralPrimitiveHit =
		      183,                               // commits a procedural primitive hit
		  RayQuery_CommittedGeometryIndex = 209, // returns committed hit geometry index
		  RayQuery_CommittedInstanceContributionToHitGroupIndex =
		      215, // returns committed hit InstanceContributionToHitGroupIndex
		  RayQuery_CommittedInstanceID = 208,    // returns committed hit instance ID
		  RayQuery_CommittedInstanceIndex = 207, // returns committed hit instance index
		  RayQuery_CommittedObjectRayDirection =
		      212, // returns committed object ray direction
		  RayQuery_CommittedObjectRayOrigin =
		      211, // returns committed hit object ray origin
		  RayQuery_CommittedObjectToWorld3x4 =
		      188, // returns matrix for transforming from object-space to world-space
		           // for a Committed hit.
		  RayQuery_CommittedPrimitiveIndex =
		      210, // returns committed hit geometry index
		  RayQuery_CommittedRayT =
		      200, // returns float representing the parametric point on the ray for the
		           // current committed hit.
		  RayQuery_CommittedStatus = 184, // returns uint status (COMMITTED_STATUS) of
		                                  // the committed hit in a ray query
		  RayQuery_CommittedTriangleBarycentrics =
		      194, // returns committed triangle hit barycentrics
		  RayQuery_CommittedTriangleFrontFace =
		      192, // returns if current committed triangle is front facing
		  RayQuery_CommittedWorldToObject3x4 =
		      189, // returns matrix for transforming from world-space to object-space
		           // for a Committed hit.
		  RayQuery_Proceed = 180,  // advances a ray query
		  RayQuery_RayFlags = 195, // returns ray flags
		  RayQuery_RayTMin = 198,  // returns float representing the parametric starting
		                           // point for the ray.
		  RayQuery_TraceRayInline = 179,    // initializes RayQuery for raytrace
		  RayQuery_WorldRayDirection = 197, // returns world ray direction
		  RayQuery_WorldRayOrigin = 196,    // returns world ray origin

		  // Legacy floating-point
		  LegacyF16ToF32 = 131, // legacy fuction to convert half (f16) to float (f32)
		                        // (this is not related to min-precision)
		  LegacyF32ToF16 = 130, // legacy fuction to convert float (f32) to half (f16)
		                        // (this is not related to min-precision)

		  // Library create handle from resource struct (like HL intrinsic)
		  CreateHandleForLib =
		      160, // create resource handle from resource struct for library

		  // Mesh shader instructions
		  EmitIndices = 169, // emit a primitive's vertex indices in a mesh shader
		  GetMeshPayload =
		      170, // get the mesh payload which is from amplification shader
		  SetMeshOutputCounts = 168, // Mesh shader intrinsic SetMeshOutputCounts
		  StorePrimitiveOutput =
		      172,                 // stores the value to mesh shader primitive output
		  StoreVertexOutput = 171, // stores the value to mesh shader vertex output

		  // Other
		  CycleCounterLegacy = 109, // CycleCounterLegacy

		  // Packing intrinsics
		  Pack4x8 = 220, // packs vector of 4 signed or uint32 values into a packed
		                 // datatype, drops or clamps unused bits

		  // Pixel shader
		  AttributeAtVertex =
		      137,              // returns the values of the attributes at the vertex.
		  Coverage = 91,        // returns the coverage mask input in a pixel shader
		  Discard = 82,         // discard the current pixel
		  EvalCentroid = 89,    // evaluates an input attribute at pixel center
		  EvalSampleIndex = 88, // evaluates an input attribute at a sample location
		  EvalSnapped =
		      87, // evaluates an input attribute at pixel center with an offset
		  InnerCoverage = 92, // returns underestimated coverage input from conservative
		                      // rasterization in a pixel shader
		  SampleIndex =
		      90, // returns the sample index in a sample-frequency pixel shader

		  // Quad Wave Ops
		  QuadOp = 123,         // returns the result of a quad-level operation
		  QuadReadLaneAt = 122, // reads from a lane in the quad
		  QuadVote = 222,       // compares boolean accross a quad

		  // Quaternary
		  Bfi = 53, // Given a bit range from the LSB of a number, places that number of
		            // bits in another number at any offset

		  // Ray Dispatch Arguments
		  DispatchRaysDimensions =
		      146, // The Width and Height values from the D3D12_DISPATCH_RAYS_DESC
		           // structure provided to the originating DispatchRays() call.
		  DispatchRaysIndex =
		      145, // The current x and y location within the Width and Height

		  // Ray Transforms
		  ObjectToWorld =
		      151, // Matrix for transforming from object-space to world-space.
		  WorldToObject =
		      152, // Matrix for transforming from world-space to object-space.

		  // Ray Vectors
		  WorldRayDirection = 148, // The world-space direction for the current ray.
		  WorldRayOrigin = 147,    // The world-space origin for the current ray.

		  // Ray object space Vectors
		  ObjectRayDirection = 150, // Object-space direction for the current ray.
		  ObjectRayOrigin = 149,    // Object-space origin for the current ray.

		  // RayT
		  RayTCurrent =
		      154, // float representing the current parametric ending point for the ray
		  RayTMin =
		      153, // float representing the parametric starting point for the ray.

		  // Raytracing hit uint System Values
		  HitKind = 143, // Returns the value passed as HitKind in ReportIntersection().
		                 // If intersection was reported by fixed-function triangle
		                 // intersection, HitKind will be one of
		                 // HIT_KIND_TRIANGLE_FRONT_FACE or HIT_KIND_TRIANGLE_BACK_FACE.

		  // Raytracing object space uint System Values, raytracing tier 1.1
		  GeometryIndex = 213, // The autogenerated index of the current geometry in the
		                       // bottom-level structure

		  // Raytracing object space uint System Values
		  InstanceID =
		      141, // The user-provided InstanceID on the bottom-level acceleration
		           // structure instance within the top-level structure
		  InstanceIndex = 142, // The autogenerated index of the current instance in the
		                       // top-level structure
		  PrimitiveIndex = 161, // PrimitiveIndex for raytracing shaders

		  // Raytracing uint System Values
		  RayFlags = 144, // uint containing the current ray flags.

		  // Resources - gather
		  TextureGather = 73,     // gathers the four texels that would be used in a
		                          // bi-linear filtering operation
		  TextureGatherCmp = 74,  // same as TextureGather, except this instrution
		                          // performs comparison on texels, similar to SampleCmp
		  TextureGatherRaw = 223, // Gather raw elements from 4 texels with no type
		                          // conversions (SRV type is constrained)

		  // Resources - sample
		  RenderTargetGetSampleCount =
		      77, // gets the number of samples for a render target
		  RenderTargetGetSamplePosition =
		      76,      // gets the position of the specified sample
		  Sample = 60, // samples a texture
		  SampleBias =
		      61, // samples a texture after applying the input bias to the mipmap level
		  SampleCmp = 64, // samples a texture and compares a single component against
		                  // the specified comparison value
		  SampleCmpLevel = 224,    // samples a texture and compares a single component
		                           // against the specified comparison value
		  SampleCmpLevelZero = 65, // samples a texture and compares a single component
		                           // against the specified comparison value
		  SampleGrad = 63,  // samples a texture using a gradient to influence the way
		                    // the sample location is calculated
		  SampleLevel = 62, // samples a texture using a mipmap-level offset
		  Texture2DMSGetSamplePosition =
		      75, // gets the position of the specified sample

		  // Resources
		  BufferLoad = 68,          // reads from a TypedBuffer
		  BufferStore = 69,         // writes to a RWTypedBuffer
		  BufferUpdateCounter = 70, // atomically increments/decrements the hidden
		                            // 32-bit counter stored with a Count or Append UAV
		  CBufferLoad = 58,         // loads a value from a constant buffer resource
		  CBufferLoadLegacy = 59,   // loads a value from a constant buffer resource
		  CheckAccessFullyMapped =
		      71, // determines whether all values from a Sample, Gather, or Load
		          // operation accessed mapped tiles in a tiled resource
		  CreateHandle = 57,    // creates the handle to a resource
		  GetDimensions = 72,   // gets texture size information
		  RawBufferLoad = 139,  // reads from a raw buffer and structured buffer
		  RawBufferStore = 140, // writes to a RWByteAddressBuffer or RWStructuredBuffer
		  TextureLoad = 66,     // reads texel data without any filtering or sampling
		  TextureStore = 67,    // reads texel data without any filtering or sampling
		  TextureStoreSample = 225, // stores texel data at specified sample index

		  // Sampler Feedback
		  WriteSamplerFeedback =
		      174, // updates a feedback texture for a sampling operation
		  WriteSamplerFeedbackBias = 175,  // updates a feedback texture for a sampling
		                                   // operation with a bias on the mipmap level
		  WriteSamplerFeedbackGrad = 177,  // updates a feedback texture for a sampling
		                                   // operation with explicit gradients
		  WriteSamplerFeedbackLevel = 176, // updates a feedback texture for a sampling
		                                   // operation with a mipmap-level offset

		  // Synchronization
		  AtomicBinOp = 78,           // performs an atomic operation on two operands
		  AtomicCompareExchange = 79, // atomic compare and exchange to memory
		  Barrier = 80,               // inserts a memory barrier in the shader
		  BarrierByMemoryHandle =
		      245, // Request a barrier for just the memory used by the specified object
		  BarrierByMemoryType = 244, // Request a barrier for a set of memory types
		                             // and/or thread group execution sync
		  BarrierByNodeRecordHandle =
		      246, // Request a barrier for just the memory used by the node record

		  // Temporary, indexable, input, output registers
		  LoadInput = 4,        // Loads the value from shader input
		  MinPrecXRegLoad = 2,  // Helper load operation for minprecision
		  MinPrecXRegStore = 3, // Helper store operation for minprecision
		  StoreOutput = 5,      // Stores the value to shader output
		  TempRegLoad = 0,      // Helper load operation
		  TempRegStore = 1,     // Helper store operation

		  // Tertiary float
		  FMad = 46, // floating point multiply & add
		  Fma = 47,  // fused multiply-add

		  // Tertiary int
		  IMad = 48, // Signed integer multiply & add
		  Ibfe = 51, // Integer bitfield extract
		  Msad = 50, // masked Sum of Absolute Differences.

		  // Tertiary uint
		  UMad = 49, // uint32 integer multiply & add
		  Ubfe = 52, // uint32 integer bitfield extract

		  // Unary float - rounding
		  Round_ne = 26, // floating-point round to integral float.
		  Round_ni = 27, // floating-point round to integral float.
		  Round_pi = 28, // floating-point round to integral float.
		  Round_z = 29,  // floating-point round to integral float.

		  // Unary float
		  Acos = 15, // Returns the arccosine of the specified value. Input should be a
		             // floating-point value within the range of -1 to 1.
		  Asin = 16, // Returns the arccosine of the specified value. Input should be a
		             // floating-point value within the range of -1 to 1
		  Atan = 17, // Returns the arctangent of the specified value. The return value
		             // is within the range of -PI/2 to PI/2.
		  Cos = 12,  // returns cosine(theta) for theta in radians.
		  Exp = 21,  // returns 2^exponent
		  FAbs = 6,  // returns the absolute value of the input value.
		  Frc = 22,  // extract fracitonal component.
		  Hcos = 18, // returns the hyperbolic cosine of the specified value.
		  Hsin = 19, // returns the hyperbolic sine of the specified value.
		  Htan = 20, // returns the hyperbolic tangent of the specified value.
		  IsFinite = 10, // Returns true if x is finite, false otherwise.
		  IsInf = 9,     // Returns true if x is +INF or -INF, false otherwise.
		  IsNaN = 8,     // Returns true if x is NAN or QNAN, false otherwise.
		  IsNormal = 11, // returns IsNormal
		  Log = 23,      // returns log base 2.
		  Rsqrt = 25,    // returns reciprocal square root (1 / sqrt(src)
		  Saturate = 7,  // clamps the result of a single or double precision floating
		                 // point value to [0.0f...1.0f]
		  Sin = 13,      // returns sine(theta) for theta in radians.
		  Sqrt = 24,     // returns square root
		  Tan = 14,      // returns tan(theta) for theta in radians.

		  // Unary int
		  Bfrev = 30,       // Reverses the order of the bits.
		  Countbits = 31,   // Counts the number of bits in the input integer.
		  FirstbitLo = 32,  // Returns the location of the first set bit starting from
		                    // the lowest order bit and working upward.
		  FirstbitSHi = 34, // Returns the location of the first set bit from the
		                    // highest order bit based on the sign.

		  // Unary uint
		  FirstbitHi = 33, // Returns the location of the first set bit starting from
		                   // the highest order bit and working downward.

		  // Unpacking intrinsics
		  Unpack4x8 = 219, // unpacks 4 8-bit signed or uint32 values into int32 or
		                   // int16 vector

		  // Wave
		  WaveActiveAllEqual = 115, // returns 1 if all the lanes have the same value
		  WaveActiveBallot = 116, // returns a struct with a bit set for each lane where
		                          // the condition is true
		  WaveActiveBit = 120,   // returns the result of the operation across all lanes
		  WaveActiveOp = 119,    // returns the result the operation across waves
		  WaveAllBitCount = 135, // returns the count of bits set to 1 across the wave
		  WaveAllTrue = 114, // returns 1 if all the lanes evaluate the value to true
		  WaveAnyTrue = 113, // returns 1 if any of the lane evaluates the value to true
		  WaveGetLaneCount = 112, // returns the number of lanes in the wave
		  WaveGetLaneIndex = 111, // returns the index of the current lane in the wave
		  WaveIsFirstLane = 110,  // returns 1 for the first lane in the wave
		  WaveMatch =
		      165, // returns the bitmask of active lanes that have the same value
		  WaveMultiPrefixBitCount = 167, // returns the count of bits set to 1 on groups
		                                 // of lanes identified by a bitmask
		  WaveMultiPrefixOp = 166,  // returns the result of the operation on groups of
		                            // lanes identified by a bitmask
		  WavePrefixBitCount = 136, // returns the count of bits set to 1 on prior lanes
		  WavePrefixOp = 121,      // returns the result of the operation on prior lanes
		  WaveReadLaneAt = 117,    // returns the value from the specified lane
		  WaveReadLaneFirst = 118, // returns the value from the first lane

		  // WaveMatrix
		  WaveMatrix_Add = 237, // Element-wise accumulate, or broadcast add of fragment
		                        // into accumulator
		  WaveMatrix_Annotate =
		      226, // Annotate a wave matrix pointer with the type information
		  WaveMatrix_Depth =
		      227,               // Returns depth (K) value for matrix of specified type
		  WaveMatrix_Fill = 228, // Fill wave matrix with scalar value
		  WaveMatrix_LoadGroupShared = 230, // Load wave matrix from group shared array
		  WaveMatrix_LoadRawBuf = 229,      // Load wave matrix from raw buffer
		  WaveMatrix_Multiply =
		      233, // Mutiply left and right wave matrix and store in accumulator
		  WaveMatrix_MultiplyAccumulate =
		      234, // Mutiply left and right wave matrix and accumulate into accumulator
		  WaveMatrix_ScalarOp =
		      235, // Perform scalar operation on each element of wave matrix
		  WaveMatrix_StoreGroupShared = 232, // Store wave matrix to group shared array
		  WaveMatrix_StoreRawBuf = 231,      // Store wave matrix to raw buffer
		  WaveMatrix_SumAccumulate = 236, // Sum rows or columns of an input matrix into
		                                  // an existing accumulator fragment matrix

		  // Work Graph intrinsics
		  FinishedCrossGroupSharing = 243, // returns true if the current thread group
		                                   // is the last to access the input
		  GetInputRecordCount = 242, // returns the number of records that have been
		                             // coalesced into the current thread group
		  GetRemainingRecursionLevels =
		      253, // returns how many levels of recursion remain
		  IncrementOutputCount =
		      240, // Select the next logical output count for an EmptyNodeOutput for
		           // the whole group or per thread.
		  NodeOutputIsValid = 252, // returns true if the specified output node is
		                           // present in the work graph
		  OutputComplete =
		      241, // indicates all outputs for a given records are complete

		  NumOpCodes_Dxil_1_0 = 137,
		  NumOpCodes_Dxil_1_1 = 139,
		  NumOpCodes_Dxil_1_2 = 141,
		  NumOpCodes_Dxil_1_3 = 162,
		  NumOpCodes_Dxil_1_4 = 165,
		  NumOpCodes_Dxil_1_5 = 216,
		  NumOpCodes_Dxil_1_6 = 222,
		  NumOpCodes_Dxil_1_7 = 226,
		  NumOpCodes_Dxil_1_8 = 258,

		  NumOpCodes = 258 // exclusive last value of enumeration
		};
		// OPCODE-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('OPCODECLASS-ENUM')>hctdb_instrhelp.get_enum_decl("OpCodeClass")</py>*/
		// clang-format on
		// OPCODECLASS-ENUM:BEGIN
		// Groups for DXIL operations with equivalent function templates
		public enum OpCodeClass : uint32 {
		  // Amplification shader instructions
		  DispatchMesh,

		  // AnyHit Terminals
		  AcceptHitAndEndSearch,
		  IgnoreHit,

		  // Binary uint with carry or borrow
		  BinaryWithCarryOrBorrow,

		  // Binary uint with two outputs
		  BinaryWithTwoOuts,

		  // Binary uint
		  Binary,

		  // Bitcasts with different sizes
		  BitcastF16toI16,
		  BitcastF32toI32,
		  BitcastF64toI64,
		  BitcastI16toF16,
		  BitcastI32toF32,
		  BitcastI64toF64,

		  // Comparison Samples
		  SampleCmpBias,
		  SampleCmpGrad,

		  // Compute/Mesh/Amplification/Node shader
		  FlattenedThreadIdInGroup,
		  GroupId,
		  ThreadId,
		  ThreadIdInGroup,

		  // Create/Annotate Node Handles
		  AllocateNodeOutputRecords,
		  AnnotateNodeHandle,
		  AnnotateNodeRecordHandle,
		  CreateNodeInputRecordHandle,
		  IndexNodeHandle,
		  createNodeOutputHandle,

		  // Derivatives
		  CalculateLOD,
		  Unary,

		  // Domain and hull shader
		  LoadOutputControlPoint,
		  LoadPatchConstant,

		  // Domain shader
		  DomainLocation,

		  // Dot product with accumulate
		  Dot2AddHalf,
		  Dot4AddPacked,

		  // Dot
		  Dot2,
		  Dot3,
		  Dot4,

		  // Double precision
		  LegacyDoubleToFloat,
		  LegacyDoubleToSInt32,
		  LegacyDoubleToUInt32,
		  MakeDouble,
		  SplitDouble,

		  // Extended Command Information
		  StartInstanceLocation,
		  StartVertexLocation,

		  // Geometry shader
		  CutStream,
		  EmitStream,
		  EmitThenCutStream,
		  GSInstanceID,

		  // Get Pointer to Node Record in Address Space 6
		  GetNodeRecordPtr,

		  // Get handle from heap
		  AnnotateHandle,
		  CreateHandleFromBinding,
		  CreateHandleFromHeap,

		  // Graphics shader
		  ViewID,

		  // Helper Lanes
		  IsHelperLane,

		  // Hull shader
		  OutputControlPointID,
		  StorePatchConstant,

		  // Hull, Domain and Geometry shaders
		  PrimitiveID,

		  // Indirect Shader Invocation
		  CallShader,
		  ReportHit,
		  TraceRay,

		  // Inline Ray Query
		  AllocateRayQuery,
		  RayQuery_Abort,
		  RayQuery_CommitNonOpaqueTriangleHit,
		  RayQuery_CommitProceduralPrimitiveHit,
		  RayQuery_Proceed,
		  RayQuery_StateMatrix,
		  RayQuery_StateScalar,
		  RayQuery_StateVector,
		  RayQuery_TraceRayInline,

		  // LLVM Instructions
		  LlvmInst,

		  // Legacy floating-point
		  LegacyF16ToF32,
		  LegacyF32ToF16,

		  // Library create handle from resource struct (like HL intrinsic)
		  CreateHandleForLib,

		  // Mesh shader instructions
		  EmitIndices,
		  GetMeshPayload,
		  SetMeshOutputCounts,
		  StorePrimitiveOutput,
		  StoreVertexOutput,

		  // Other
		  CycleCounterLegacy,

		  // Packing intrinsics
		  Pack4x8,

		  // Pixel shader
		  AttributeAtVertex,
		  Coverage,
		  Discard,
		  EvalCentroid,
		  EvalSampleIndex,
		  EvalSnapped,
		  InnerCoverage,
		  SampleIndex,

		  // Quad Wave Ops
		  QuadOp,
		  QuadReadLaneAt,
		  QuadVote,

		  // Quaternary
		  Quaternary,

		  // Ray Dispatch Arguments
		  DispatchRaysDimensions,
		  DispatchRaysIndex,

		  // Ray Transforms
		  ObjectToWorld,
		  WorldToObject,

		  // Ray Vectors
		  WorldRayDirection,
		  WorldRayOrigin,

		  // Ray object space Vectors
		  ObjectRayDirection,
		  ObjectRayOrigin,

		  // RayT
		  RayTCurrent,
		  RayTMin,

		  // Raytracing hit uint System Values
		  HitKind,

		  // Raytracing object space uint System Values, raytracing tier 1.1
		  GeometryIndex,

		  // Raytracing object space uint System Values
		  InstanceID,
		  InstanceIndex,
		  PrimitiveIndex,

		  // Raytracing uint System Values
		  RayFlags,

		  // Resources - gather
		  TextureGather,
		  TextureGatherCmp,
		  TextureGatherRaw,

		  // Resources - sample
		  RenderTargetGetSampleCount,
		  RenderTargetGetSamplePosition,
		  Sample,
		  SampleBias,
		  SampleCmp,
		  SampleCmpLevel,
		  SampleCmpLevelZero,
		  SampleGrad,
		  SampleLevel,
		  Texture2DMSGetSamplePosition,

		  // Resources
		  BufferLoad,
		  BufferStore,
		  BufferUpdateCounter,
		  CBufferLoad,
		  CBufferLoadLegacy,
		  CheckAccessFullyMapped,
		  CreateHandle,
		  GetDimensions,
		  RawBufferLoad,
		  RawBufferStore,
		  TextureLoad,
		  TextureStore,
		  TextureStoreSample,

		  // Sampler Feedback
		  WriteSamplerFeedback,
		  WriteSamplerFeedbackBias,
		  WriteSamplerFeedbackGrad,
		  WriteSamplerFeedbackLevel,

		  // Synchronization
		  AtomicBinOp,
		  AtomicCompareExchange,
		  Barrier,
		  BarrierByMemoryHandle,
		  BarrierByMemoryType,
		  BarrierByNodeRecordHandle,

		  // Temporary, indexable, input, output registers
		  LoadInput,
		  MinPrecXRegLoad,
		  MinPrecXRegStore,
		  StoreOutput,
		  TempRegLoad,
		  TempRegStore,

		  // Tertiary uint
		  Tertiary,

		  // Unary float
		  IsSpecialFloat,

		  // Unary int
		  UnaryBits,

		  // Unpacking intrinsics
		  Unpack4x8,

		  // Wave
		  WaveActiveAllEqual,
		  WaveActiveBallot,
		  WaveActiveBit,
		  WaveActiveOp,
		  WaveAllOp,
		  WaveAllTrue,
		  WaveAnyTrue,
		  WaveGetLaneCount,
		  WaveGetLaneIndex,
		  WaveIsFirstLane,
		  WaveMatch,
		  WaveMultiPrefixBitCount,
		  WaveMultiPrefixOp,
		  WavePrefixOp,
		  WaveReadLaneAt,
		  WaveReadLaneFirst,

		  // WaveMatrix
		  WaveMatrix_Accumulate,
		  WaveMatrix_Annotate,
		  WaveMatrix_Depth,
		  WaveMatrix_Fill,
		  WaveMatrix_LoadGroupShared,
		  WaveMatrix_LoadRawBuf,
		  WaveMatrix_Multiply,
		  WaveMatrix_ScalarOp,
		  WaveMatrix_StoreGroupShared,
		  WaveMatrix_StoreRawBuf,

		  // Work Graph intrinsics
		  FinishedCrossGroupSharing,
		  GetInputRecordCount,
		  GetRemainingRecursionLevels,
		  IncrementOutputCount,
		  NodeOutputIsValid,
		  OutputComplete,

		  NumOpClasses_Dxil_1_0 = 93,
		  NumOpClasses_Dxil_1_1 = 95,
		  NumOpClasses_Dxil_1_2 = 97,
		  NumOpClasses_Dxil_1_3 = 118,
		  NumOpClasses_Dxil_1_4 = 120,
		  NumOpClasses_Dxil_1_5 = 143,
		  NumOpClasses_Dxil_1_6 = 149,
		  NumOpClasses_Dxil_1_7 = 153,
		  NumOpClasses_Dxil_1_8 = 183,

		  NumOpClasses = 183 // exclusive last value of enumeration
		};
		// OPCODECLASS-ENUM:END

		// Operand Index for every OpCodeClass.
		public static class OperandIndex {
		// Opcode is always operand 0.
		public const uint32 kOpcodeIdx = 0;

		// Unary operators.
		public const uint32 kUnarySrc0OpIdx = 1;

		// Binary operators.
		public const uint32 kBinarySrc0OpIdx = 1;
		public const uint32 kBinarySrc1OpIdx = 2;

		// Trinary operators.
		public const uint32 kTrinarySrc0OpIdx = 1;
		public const uint32 kTrinarySrc1OpIdx = 2;
		public const uint32 kTrinarySrc2OpIdx = 3;

		// LoadInput.
		public const uint32 kLoadInputIDOpIdx = 1;
		public const uint32 kLoadInputRowOpIdx = 2;
		public const uint32 kLoadInputColOpIdx = 3;
		public const uint32 kLoadInputVertexIDOpIdx = 4;

		// StoreOutput, StoreVertexOutput, StorePrimitiveOutput
		public const uint32 kStoreOutputIDOpIdx = 1;
		public const uint32 kStoreOutputRowOpIdx = 2;
		public const uint32 kStoreOutputColOpIdx = 3;
		public const uint32 kStoreOutputValOpIdx = 4;
		public const uint32 kStoreOutputVPIDOpIdx = 5;

		// DomainLocation.
		public const uint32 kDomainLocationColOpIdx = 1;

		// BufferLoad.
		public const uint32 kBufferLoadHandleOpIdx = 1;
		public const uint32 kBufferLoadCoord0OpIdx = 2;
		public const uint32 kBufferLoadCoord1OpIdx = 3;

		// BufferStore.
		public const uint32 kBufferStoreHandleOpIdx = 1;
		public const uint32 kBufferStoreCoord0OpIdx = 2;
		public const uint32 kBufferStoreCoord1OpIdx = 3;
		public const uint32 kBufferStoreVal0OpIdx = 4;
		public const uint32 kBufferStoreVal1OpIdx = 5;
		public const uint32 kBufferStoreVal2OpIdx = 6;
		public const uint32 kBufferStoreVal3OpIdx = 7;
		public const uint32 kBufferStoreMaskOpIdx = 8;

		// RawBufferLoad.
		public const uint32 kRawBufferLoadHandleOpIdx = 1;
		public const uint32 kRawBufferLoadIndexOpIdx = 2;
		public const uint32 kRawBufferLoadElementOffsetOpIdx = 3;
		public const uint32 kRawBufferLoadMaskOpIdx = 4;
		public const uint32 kRawBufferLoadAlignmentOpIdx = 5;

		// RawBufferStore
		public const uint32 kRawBufferStoreHandleOpIdx = 1;
		public const uint32 kRawBufferStoreIndexOpIdx = 2;
		public const uint32 kRawBufferStoreElementOffsetOpIdx = 3;
		public const uint32 kRawBufferStoreVal0OpIdx = 4;
		public const uint32 kRawBufferStoreVal1OpIdx = 5;
		public const uint32 kRawBufferStoreVal2OpIdx = 6;
		public const uint32 kRawBufferStoreVal3OpIdx = 7;
		public const uint32 kRawBufferStoreMaskOpIdx = 8;
		public const uint32 kRawBufferStoreAlignmentOpIdx = 8;

		// TextureStore.
		public const uint32 kTextureStoreHandleOpIdx = 1;
		public const uint32 kTextureStoreCoord0OpIdx = 2;
		public const uint32 kTextureStoreCoord1OpIdx = 3;
		public const uint32 kTextureStoreCoord2OpIdx = 4;
		public const uint32 kTextureStoreVal0OpIdx = 5;
		public const uint32 kTextureStoreVal1OpIdx = 6;
		public const uint32 kTextureStoreVal2OpIdx = 7;
		public const uint32 kTextureStoreVal3OpIdx = 8;
		public const uint32 kTextureStoreMaskOpIdx = 9;

		// TextureGather.
		public const uint32 kTextureGatherTexHandleOpIdx = 1;
		public const uint32 kTextureGatherSamplerHandleOpIdx = 2;
		public const uint32 kTextureGatherCoord0OpIdx = 3;
		public const uint32 kTextureGatherCoord1OpIdx = 4;
		public const uint32 kTextureGatherCoord2OpIdx = 5;
		public const uint32 kTextureGatherCoord3OpIdx = 6;
		public const uint32 kTextureGatherOffset0OpIdx = 7;
		public const uint32 kTextureGatherOffset1OpIdx = 8;
		public const uint32 kTextureGatherChannelOpIdx = 9;
		// TextureGatherCmp.
		public const uint32 kTextureGatherCmpCmpValOpIdx = 11;

		// TextureSample.
		public const uint32 kTextureSampleTexHandleOpIdx = 1;
		public const uint32 kTextureSampleSamplerHandleOpIdx = 2;
		public const uint32 kTextureSampleCoord0OpIdx = 3;
		public const uint32 kTextureSampleCoord1OpIdx = 4;
		public const uint32 kTextureSampleCoord2OpIdx = 5;
		public const uint32 kTextureSampleCoord3OpIdx = 6;
		public const uint32 kTextureSampleOffset0OpIdx = 7;
		public const uint32 kTextureSampleOffset1OpIdx = 8;
		public const uint32 kTextureSampleOffset2OpIdx = 9;
		public const uint32 kTextureSampleClampOpIdx = 10;

		// TextureLoad.
		public const uint32 kTextureLoadOffset0OpIdx = 6;
		public const uint32 kTextureLoadOffset1OpIdx = 8;
		public const uint32 kTextureLoadOffset2OpIdx = 9;

		// AtomicBinOp.
		public const uint32 kAtomicBinOpHandleOpIdx = 1;
		public const uint32 kAtomicBinOpCoord0OpIdx = 3;
		public const uint32 kAtomicBinOpCoord1OpIdx = 4;
		public const uint32 kAtomicBinOpCoord2OpIdx = 5;

		// AtomicCmpExchange.
		public const uint32 kAtomicCmpExchangeCoord0OpIdx = 2;
		public const uint32 kAtomicCmpExchangeCoord1OpIdx = 3;
		public const uint32 kAtomicCmpExchangeCoord2OpIdx = 4;

		// CreateHandle
		public const uint32 kCreateHandleResClassOpIdx = 1;
		public const uint32 kCreateHandleResIDOpIdx = 2;
		public const uint32 kCreateHandleResIndexOpIdx = 3;
		public const uint32 kCreateHandleIsUniformOpIdx = 4;

		// CreateHandleFromResource
		public const uint32 kCreateHandleForLibResOpIdx = 1;

		// CreateHandleFromHeap
		public const uint32 kCreateHandleFromHeapHeapIndexOpIdx = 1;
		public const uint32 kCreateHandleFromHeapSamplerHeapOpIdx = 2;
		public const uint32 kCreateHandleFromHeapNonUniformIndexOpIdx = 3;

		// CreateHandleFromBinding
		public const uint32 kCreateHandleFromBindingResIndexOpIdx = 2;

		// TraceRay
		public const uint32 kTraceRayRayDescOpIdx = 7;
		public const uint32 kTraceRayPayloadOpIdx = 15;
		public const uint32 kTraceRayNumOp = 16;

		// TraceRayInline
		public const uint32 kTraceRayInlineRayDescOpIdx = 5;
		public const uint32 kTraceRayInlineNumOp = 13;

		// Emit/Cut
		public const uint32 kStreamEmitCutIDOpIdx = 1;

		// StoreVectorOutput/StorePrimitiveOutput.
		public const uint32 kMSStoreOutputIDOpIdx = 1;
		public const uint32 kMSStoreOutputRowOpIdx = 2;
		public const uint32 kMSStoreOutputColOpIdx = 3;
		public const uint32 kMSStoreOutputVIdxOpIdx = 4;
		public const uint32 kMSStoreOutputValOpIdx = 5;

		// TODO: add operand index for all the OpCodeClass.
		} // namespace OperandIndex

		// Atomic binary operation kind.
		public enum AtomicBinOpCode : uint32 {
		  Add,
		  And,
		  Or,
		  Xor,
		  IMin,
		  IMax,
		  UMin,
		  UMax,
		  Exchange,
		  Invalid // Must be last.
		};

		// Barrier/fence modes.
		public enum BarrierMode : uint32 {
		  Invalid = 0,
		  SyncThreadGroup = 0x00000001,
		  UAVFenceGlobal = 0x00000002,
		  UAVFenceThreadGroup = 0x00000004,
		  TGSMFence = 0x00000008,
		};

		// Address space.
		public const uint32 kDefaultAddrSpace = 0;
		public const uint32 kDeviceMemoryAddrSpace = 1;
		public const uint32 kCBufferAddrSpace = 2;
		public const uint32 kTGSMAddrSpace = 3;
		public const uint32 kGenericPointerAddrSpace = 4;
		public const uint32 kImmediateCBufferAddrSpace = 5;
		public const uint32 kNodeRecordAddrSpace = 6;

		// Input primitive, must match D3D_PRIMITIVE
		public enum InputPrimitive : uint32 {
		  Undefined = 0,
		  Point = 1,
		  Line = 2,
		  Triangle = 3,
		  Reserved4 = 4,
		  Reserved5 = 5,
		  LineWithAdjacency = 6,
		  TriangleWithAdjacency = 7,
		  ControlPointPatch1 = 8,
		  ControlPointPatch2 = 9,
		  ControlPointPatch3 = 10,
		  ControlPointPatch4 = 11,
		  ControlPointPatch5 = 12,
		  ControlPointPatch6 = 13,
		  ControlPointPatch7 = 14,
		  ControlPointPatch8 = 15,
		  ControlPointPatch9 = 16,
		  ControlPointPatch10 = 17,
		  ControlPointPatch11 = 18,
		  ControlPointPatch12 = 19,
		  ControlPointPatch13 = 20,
		  ControlPointPatch14 = 21,
		  ControlPointPatch15 = 22,
		  ControlPointPatch16 = 23,
		  ControlPointPatch17 = 24,
		  ControlPointPatch18 = 25,
		  ControlPointPatch19 = 26,
		  ControlPointPatch20 = 27,
		  ControlPointPatch21 = 28,
		  ControlPointPatch22 = 29,
		  ControlPointPatch23 = 30,
		  ControlPointPatch24 = 31,
		  ControlPointPatch25 = 32,
		  ControlPointPatch26 = 33,
		  ControlPointPatch27 = 34,
		  ControlPointPatch28 = 35,
		  ControlPointPatch29 = 36,
		  ControlPointPatch30 = 37,
		  ControlPointPatch31 = 38,
		  ControlPointPatch32 = 39,

		  LastEntry,
		};

		// Primitive topology, must match D3D_PRIMITIVE_TOPOLOGY
		public enum PrimitiveTopology : uint32 {
		  Undefined = 0,
		  PointList = 1,
		  LineList = 2,
		  LineStrip = 3,
		  TriangleList = 4,
		  TriangleStrip = 5,

		  LastEntry,
		};

		// Must match D3D_TESSELLATOR_DOMAIN
		public enum TessellatorDomain {
		  Undefined = 0,
		  IsoLine = 1,
		  Tri = 2,
		  Quad = 3,

		  LastEntry,
		};

		// Must match D3D_TESSELLATOR_OUTPUT_PRIMITIVE
		public enum TessellatorOutputPrimitive {
		  Undefined = 0,
		  Point = 1,
		  Line = 2,
		  TriangleCW = 3,
		  TriangleCCW = 4,

		  LastEntry,
		};

		public enum MeshOutputTopology {
		  Undefined = 0,
		  Line = 1,
		  Triangle = 2,

		  LastEntry,
		};

		// Tessellator partitioning, must match D3D_TESSELLATOR_PARTITIONING
		public enum TessellatorPartitioning : uint32 {
		  Undefined = 0,
		  Integer,
		  Pow2,
		  FractionalOdd,
		  FractionalEven,

		  LastEntry,
		};

		public enum NodeLaunchType {
		  Invalid = 0,
		  Broadcasting,
		  Coalescing,
		  Thread,

		  LastEntry
		};

		public enum NodeIOFlags : uint32 {
		  None = 0x0,
		  Input = 0x1,
		  Output = 0x2,
		  ReadWrite = 0x4,
		  EmptyRecord = 0x8, // EmptyNodeOutput[Array], EmptyNodeInput
		  NodeArray = 0x10,  // NodeOutputArray, EmptyNodeOutputArray

		  // Record granularity (enum in 2 bits)
		  ThreadRecord = 0x20,   // [RW]ThreadNodeInputRecord, ThreadNodeOutputRecords
		  GroupRecord = 0x40,    // [RW]GroupNodeInputRecord, GroupNodeOutputRecords
		  DispatchRecord = 0x60, // [RW]DispatchNodeInputRecord
		  RecordGranularityMask = 0x60,

		  NodeIOKindMask = 0x7F,

		  TrackRWInputSharing = 0x100, // TrackRWInputSharing tracked on all non-empty
		                               // input/output record/node types
		  GloballyCoherent = 0x200,    // applies to RWDispatchNodeInputRecord

		  // Mask for node/record properties beyond NodeIOKind
		  RecordFlagsMask = 0x300,
		  NodeFlagsMask = 0x100,
		};

		public enum NodeIOKind : uint32 {
		  Invalid = 0,

		  EmptyInput =
		      (uint32)NodeIOFlags.EmptyRecord | (uint32)NodeIOFlags.Input,
		  NodeOutput = (uint32)NodeIOFlags.ReadWrite | (uint32)NodeIOFlags.Output,
		  NodeOutputArray = (uint32)NodeIOFlags.ReadWrite |
		                    (uint32)NodeIOFlags.Output |
		                    (uint32)NodeIOFlags.NodeArray,
		  EmptyOutput =
		      (uint32)NodeIOFlags.EmptyRecord | (uint32)NodeIOFlags.Output,
		  EmptyOutputArray = (uint32)NodeIOFlags.EmptyRecord |
		                     (uint32)NodeIOFlags.Output |
		                     (uint32)NodeIOFlags.NodeArray,

		  DispatchNodeInputRecord =
		      (uint32)NodeIOFlags.Input | (uint32)NodeIOFlags.DispatchRecord,
		  GroupNodeInputRecords =
		      (uint32)NodeIOFlags.Input | (uint32)NodeIOFlags.GroupRecord,
		  ThreadNodeInputRecord =
		      (uint32)NodeIOFlags.Input | (uint32)NodeIOFlags.ThreadRecord,

		  RWDispatchNodeInputRecord = (uint32)NodeIOFlags.ReadWrite |
		                              (uint32)NodeIOFlags.Input |
		                              (uint32)NodeIOFlags.DispatchRecord,
		  RWGroupNodeInputRecords = (uint32)NodeIOFlags.ReadWrite |
		                            (uint32)NodeIOFlags.Input |
		                            (uint32)NodeIOFlags.GroupRecord,
		  RWThreadNodeInputRecord = (uint32)NodeIOFlags.ReadWrite |
		                            (uint32)NodeIOFlags.Input |
		                            (uint32)NodeIOFlags.ThreadRecord,

		  GroupNodeOutputRecords = (uint32)NodeIOFlags.ReadWrite |
		                           (uint32)NodeIOFlags.Output |
		                           (uint32)NodeIOFlags.GroupRecord,
		  ThreadNodeOutputRecords = (uint32)NodeIOFlags.ReadWrite |
		                            (uint32)NodeIOFlags.Output |
		                            (uint32)NodeIOFlags.ThreadRecord,
		};

		// Kind of quad-level operation
		public enum QuadOpKind {
		  ReadAcrossX = 0, // returns the value from the other lane in the quad in the
		                   // horizontal direction
		  ReadAcrossY = 1, // returns the value from the other lane in the quad in the
		                   // vertical direction
		  ReadAcrossDiagonal = 2, // returns the value from the lane across the quad in
		                          // horizontal and vertical direction
		};

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('WAVEBITOPKIND-ENUM')>hctdb_instrhelp.get_enum_decl("WaveBitOpKind")</py>*/
		// clang-format on
		// WAVEBITOPKIND-ENUM:BEGIN
		// Kind of bitwise cross-lane operation
		public enum WaveBitOpKind : uint32 {
		  And = 0, // bitwise and of values
		  Or = 1,  // bitwise or of values
		  Xor = 2, // bitwise xor of values
		};
		// WAVEBITOPKIND-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('WAVEOPKIND-ENUM')>hctdb_instrhelp.get_enum_decl("WaveOpKind")</py>*/
		// clang-format on
		// WAVEOPKIND-ENUM:BEGIN
		// Kind of cross-lane operation
		public enum WaveOpKind : uint32 {
		  Max = 3,     // maximum value
		  Min = 2,     // minimum value
		  Product = 1, // product of values
		  Sum = 0,     // sum of values
		};
		// WAVEOPKIND-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('WAVEMULTIPREFIXOPKIND-ENUM')>hctdb_instrhelp.get_enum_decl("WaveMultiPrefixOpKind")</py>*/
		// clang-format on
		// WAVEMULTIPREFIXOPKIND-ENUM:BEGIN
		// Kind of cross-lane for multi-prefix operation
		public enum WaveMultiPrefixOpKind : uint32 {
		  And = 1,     // bitwise and of values
		  Or = 2,      // bitwise or of values
		  Product = 4, // product of values
		  Sum = 0,     // sum of values
		  Xor = 3,     // bitwise xor of values
		};
		// WAVEMULTIPREFIXOPKIND-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('SIGNEDOPKIND-ENUM')>hctdb_instrhelp.get_enum_decl("SignedOpKind")</py>*/
		// clang-format on
		// SIGNEDOPKIND-ENUM:BEGIN
		// Sign vs. uint32 operands for operation
		public enum SignedOpKind : uint32 {
		  Signed = 0,   // signed integer or floating-point operands
		  Unsigned = 1, // unsigned integer operands
		};
		// SIGNEDOPKIND-ENUM:END

		// clang-format off
		  // Python lines need to be not formatted.
		  /* <py.lines('QUADVOTEOPKIND-ENUM')>hctdb_instrhelp.get_enum_decl("QuadVoteOpKind")</py>*/
		// clang-format on
		// QUADVOTEOPKIND-ENUM:BEGIN
		// Kind of cross-quad vote operation
		public enum QuadVoteOpKind : uint32 {
		  All = 1, // true if all conditions are true in this quad
		  Any = 0, // true if any condition is true in this quad
		};
		// QUADVOTEOPKIND-ENUM:END

		// Kind of control flow hint
		public enum ControlFlowHint : uint32 {
		  Undefined = 0,
		  Branch = 1,
		  Flatten = 2,
		  FastOpt = 3,
		  AllowUavCondition = 4,
		  ForceCase = 5,
		  Call = 6,
		  // Loop and Unroll is using llvm.loop.unroll Metadata.

		  LastEntry,
		};

		// XYZW component mask.
		const uint8 kCompMask_X = 0x1;
		const uint8 kCompMask_Y = 0x2;
		const uint8 kCompMask_Z = 0x4;
		const uint8 kCompMask_W = 0x8;
		const uint8 kCompMask_All = 0xF;

		public enum LowPrecisionMode {
		  Undefined = 0,
		  UseMinPrecision,
		  UseNativeLowPrecision
		};

		// Corresponds to RAY_FLAG_* in HLSL
		public enum RayFlag : uint32 {
		  None = 0x00,
		  ForceOpaque = 0x01,
		  ForceNonOpaque = 0x02,
		  AcceptFirstHitAndEndSearch = 0x04,
		  SkipClosestHitShader = 0x08,
		  CullBackFacingTriangles = 0x10,
		  CullFrontFacingTriangles = 0x20,
		  CullOpaque = 0x40,
		  CullNonOpaque = 0x80,
		  SkipTriangles = 0x100,
		  SkipProceduralPrimitives = 0x200,
		};

		// Packing/unpacking intrinsics
		public enum UnpackMode : uint8 {
		  Unsigned = 0, // not sign extended
		  Signed = 1,   // sign extended
		};

		public enum PackMode : uint8 {
		  Trunc = 0,  // Pack low bits, drop the rest
		  UClamp = 1, // Unsigned clamp - [0, 255] for 8-bits
		  SClamp = 2, // Signed clamp - [-128, 127] for 8-bits
		};

		// Corresponds to HIT_KIND_* in HLSL
		public enum HitKind : uint8 {
		  None = 0x00,
		  TriangleFrontFace = 0xFE,
		  TriangleBackFace = 0xFF,
		};

		public enum SamplerFeedbackType : uint8 {
		  MinMip = 0,
		  MipRegionUsed = 1,
		  LastEntry = 2
		};

		public enum WaveMatrixKind : uint8 {
		  Left = 0,
		  Right = 1,
		  LeftColAcc = 2,
		  RightRowAcc = 3,
		  Accumulator = 4,
		  NumKinds = 5,
		  MaskSide = 1,
		  MaskClass = 6, // 0 = Left/Right, 2 = Fragment, 4 = Accumulator
		};

		/* <py.lines('WAVEMATRIXSCALAROPCODE-ENUM')>hctdb_instrhelp.get_enum_decl("WaveMatrixScalarOpCode")</py>*/
		// WAVEMATRIXSCALAROPCODE-ENUM:BEGIN
		// Operation for WaveMatrix_ScalarOp
		public enum WaveMatrixScalarOpCode : uint32 {
		  Add = 0,
		  Divide = 3,
		  Invalid = 4,
		  Multiply = 2,
		  Subtract = 1,
		};
		// WAVEMATRIXSCALAROPCODE-ENUM:END

		// Corresponds to MEMORY_TYPE_FLAG enums in HLSL
		public enum MemoryTypeFlag : uint32 {
		  UavMemory = 0x00000001,         // UAV_MEMORY
		  GroupSharedMemory = 0x00000002, // GROUP_SHARED_MEMORY
		  NodeInputMemory = 0x00000004,   // NODE_INPUT_MEMORY
		  NodeOutputMemory = 0x00000008,  // NODE_OUTPUT_MEMORY
		  AllMemory = 0x0000000F,         // ALL_MEMORY
		  ValidMask = 0x0000000F,
		  NodeFlags = NodeInputMemory | NodeOutputMemory,
		  LegacyFlags = UavMemory | GroupSharedMemory,
		  GroupFlags = GroupSharedMemory,
		};

		// Corresponds to SEMANTIC_FLAG enums in HLSL
		public enum BarrierSemanticFlag : uint32 {
		  GroupSync = 0x00000001,   // GROUP_SYNC
		  GroupScope = 0x00000002,  // GROUP_SCOPE
		  DeviceScope = 0x00000004, // DEVICE_SCOPE
		  ValidMask = 0x00000007,
		  GroupFlags = GroupSync | GroupScope,
		};

		// Constant for Container.
		const uint8 DxilProgramSigMaskX = 1;
		const uint8 DxilProgramSigMaskY = 2;
		const uint8 DxilProgramSigMaskZ = 4;
		const uint8 DxilProgramSigMaskW = 8;

		// DFCC_FeatureInfo is a uint64_t value with these flags.
		public const uint64 ShaderFeatureInfo_Doubles = 0x0001;
		public const uint64
		    ShaderFeatureInfo_ComputeShadersPlusRawAndStructuredBuffersViaShader4X =
		        0x0002;
		public const uint64 ShaderFeatureInfo_UAVsAtEveryStage = 0x0004;
		public const uint64 ShaderFeatureInfo_64UAVs = 0x0008;
		public const uint64 ShaderFeatureInfo_MinimumPrecision = 0x0010;
		public const uint64 ShaderFeatureInfo_11_1_DoubleExtensions = 0x0020;
		public const uint64 ShaderFeatureInfo_11_1_ShaderExtensions = 0x0040;
		public const uint64 ShaderFeatureInfo_LEVEL9ComparisonFiltering = 0x0080;
		public const uint64 ShaderFeatureInfo_TiledResources = 0x0100;
		public const uint64 ShaderFeatureInfo_StencilRef = 0x0200;
		public const uint64 ShaderFeatureInfo_InnerCoverage = 0x0400;
		public const uint64 ShaderFeatureInfo_TypedUAVLoadAdditionalFormats = 0x0800;
		public const uint64 ShaderFeatureInfo_ROVs = 0x1000;
		public const uint64
		    ShaderFeatureInfo_ViewportAndRTArrayIndexFromAnyShaderFeedingRasterizer =
		        0x2000;
		public const uint64 ShaderFeatureInfo_WaveOps = 0x4000;
		public const uint64 ShaderFeatureInfo_Int64Ops = 0x8000;

		// SM 6.1+
		public const uint64 ShaderFeatureInfo_ViewID = 0x10000;
		public const uint64 ShaderFeatureInfo_Barycentrics = 0x20000;

		// SM 6.2+
		public const uint64 ShaderFeatureInfo_NativeLowPrecision = 0x40000;

		// SM 6.4+
		public const uint64 ShaderFeatureInfo_ShadingRate = 0x80000;

		// SM 6.5+
		public const uint64 ShaderFeatureInfo_Raytracing_Tier_1_1 = 0x100000;
		public const uint64 ShaderFeatureInfo_SamplerFeedback = 0x200000;

		// SM 6.6+
		public const uint64 ShaderFeatureInfo_AtomicInt64OnTypedResource = 0x400000;
		public const uint64 ShaderFeatureInfo_AtomicInt64OnGroupShared = 0x800000;
		public const uint64 ShaderFeatureInfo_DerivativesInMeshAndAmpShaders = 0x1000000;
		public const uint64 ShaderFeatureInfo_ResourceDescriptorHeapIndexing = 0x2000000;
		public const uint64 ShaderFeatureInfo_SamplerDescriptorHeapIndexing = 0x4000000;

		public const uint64 ShaderFeatureInfo_AtomicInt64OnHeapResource = 0x10000000;

		// SM 6.7+
		public const uint64 ShaderFeatureInfo_AdvancedTextureOps = 0x20000000;
		public const uint64 ShaderFeatureInfo_WriteableMSAATextures = 0x40000000;

		// SM 6.8+
		public const uint64 ShaderFeatureInfo_SampleCmpGradientOrBias = 0x80000000;
		public const uint64 ShaderFeatureInfo_ExtendedCommandInfo = 0x100000000;

		// Experimental SM 6.9+ - Reserved, not yet supported.
		// WaveMMA slots in between two SM 6.6 feature bits.
		public const uint64 ShaderFeatureInfo_WaveMMA = 0x8000000;

		// Maximum count without rolling over into another 64-bit field is 40,
		// so the last flag we can use for a feature requirement is: 0x8000000000
		// This is because of the following set of flags, considered optional
		// and ignored by the runtime if not recognized:
		// D3D11_OPTIONAL_FEATURE_FLAGS 0x7FFFFF0000000000
		public const uint32 ShaderFeatureInfoCount = 33;
		/*static_assert(ShaderFeatureInfoCount <= 40,
		              "ShaderFeatureInfo flags must fit within the first 40 bits; "
		              "after that we need to expand the FeatureInfo blob part and "
		              "start defining a new set of flags for ShaderFeatureInfo2.");*/

		// OptFeatureInfo flags in higher bits of DFCC_FeatureInfo uint64_t value.
		// This section is for flags that do not necessarily indicate a required
		// feature, but are used to indicate something about the shader.
		// Some of these flags may not actually show up in DFCC_FeatureInfo, instead
		// only being used in intermediate feature info and in RDAT's FeatureInfo.

		// Create flag here for any derivative use.  This allows call-graph validation
		// in the runtime to detect misuse of derivatives for an entry point that cannot
		// support it, or to determine when the flag
		// ShaderFeatureInfo_DerivativesInMeshAndAmpShaders is required.
		public const uint64 OptFeatureInfo_UsesDerivatives = 0x0000010000000000UL;
		// OptFeatureInfo_RequiresGroup tracks whether a function requires a visible
		// group that supports things like groupshared memory and group sync.
		public const uint64 OptFeatureInfo_RequiresGroup = 0x0000020000000000UL;

		public const uint64 OptFeatureInfoShift = 40;
		public const uint32 OptFeatureInfoCount = 2;
		/*static_assert(OptFeatureInfoCount <= 23,
		              "OptFeatureInfo flags must fit in 23 bits; after that we need to "
		              "expand the FeatureInfo blob part and start defining a new set "
		              "of flags for OptFeatureInfo2.");*/

		// DxilSubobjectType must match D3D12_STATE_SUBOBJECT_TYPE, with
		// certain values reserved, since they cannot be used from Dxil.
		public enum SubobjectKind : uint32 {
		  StateObjectConfig = 0,
		  GlobalRootSignature = 1,
		  LocalRootSignature = 2,
		  // 3-7 are reserved (not supported in Dxil)
		  SubobjectToExportsAssociation = 8,
		  RaytracingShaderConfig = 9,
		  RaytracingPipelineConfig = 10,
		  HitGroup = 11,
		  RaytracingPipelineConfig1 = 12,
		  NumKinds // aka D3D12_STATE_SUBOBJECT_TYPE_MAX_VALID
		};

		[Inline] public static  bool IsValidSubobjectKind(SubobjectKind kind) {
		  return (kind < SubobjectKind.NumKinds &&
		          (kind <= SubobjectKind.LocalRootSignature ||
		           kind >= SubobjectKind.SubobjectToExportsAssociation));
		}

		public enum StateObjectFlags : uint32 {
		  AllowLocalDependenciesOnExternalDefinitions = 0x1,
		  AllowExternalDependenciesOnLocalDefinitions = 0x2,
		  AllowStateObjectAdditions = 0x4,
		  ValidMask_1_4 = 0x3,
		  ValidMask = 0x7,
		};

		public enum HitGroupType : uint32 {
		  Triangle = 0x0,
		  ProceduralPrimitive = 0x1,
		  LastEntry,
		};

		public enum RaytracingPipelineFlags : uint32 {
		  None = 0x0,
		  SkipTriangles = 0x100,
		  SkipProceduralPrimitives = 0x200,
		  ValidMask = 0x300,
		};

		public enum CommittedStatus : uint32 {
		  CommittedNothing = 0,
		  CommittedTriangleHit = 1,
		  CommittedProceduralPrimitiveHit = 2,
		};

		public enum CandidateType : uint32 {
		  CandidateNonOpaqueTriangle = 0,
		  CandidateProceduralPrimitive = 1,
		};

		public enum PayloadAccessQualifier : uint32 {
		  NoAccess = 0,
		  Read = 1,
		  Write = 2,
		  ReadWrite = 3
		};

		public enum PayloadAccessShaderStage : uint32 {
		  Caller = 0,
		  Closesthit = 1,
		  Miss = 2,
		  Anyhit = 3,
		  Invalid = 0xffffffffu
		};

		// Allocate 4 bits per shader stage:
		//     bits 0-1 for payload access qualifiers
		//     bits 2-3 reserved for future use
		const uint32 PayloadAccessQualifierBitsPerStage = 4;
		const uint32 PayloadAccessQualifierValidMaskPerStage = 3;
		const uint32 PayloadAccessQualifierValidMask = 0x00003333;

		[Inline] public static  bool IsValidHitGroupType(HitGroupType type) {
		  return (type >= HitGroupType.Triangle && type < HitGroupType.LastEntry);
		}
	}
}