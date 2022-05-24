using System;
namespace Dxc_Beef
{
	public struct IDxcOperationResult : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0xCEDB484A,0xD4E9,0x445A,0xB9, 0x91,0xCA, 0x21, 0xCA, 0x15, 0x7D, 0xC2);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out HResult pStatus) GetStatus;

			// GetResult returns the main result of the operation.
			// This corresponds to:
			// DXC_OUT_OBJECT - Compile() with shader or library target
			// DXC_OUT_DISASSEMBLY - Disassemble()
			// DXC_OUT_HLSL - Compile() with -P
			// DXC_OUT_ROOT_SIGNATURE - Compile() with rootsig_* target
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out IDxcBlob *ppResult) GetResult;

			// GetErrorBuffer Corresponds to DXC_OUT_ERRORS.
			public function [CallingConvention(.Stdcall)] HResult(IDxcOperationResult * self, out IDxcBlobEncoding *ppErrors) GetErrorBuffer;
		}

		private new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}

		public HResult GetStatus(out HResult pStatus) mut
		{
			return VT.GetStatus(&this, out pStatus);
		}

		public HResult GetResult(out IDxcBlob *ppResult) mut
		{
			return VT.GetResult(&this, out ppResult);
		}

		public HResult GetErrorBuffer(out IDxcBlobEncoding *ppErrors) mut
		{
			return VT.GetErrorBuffer(&this, out ppErrors);
		}
	}
}