using System;
namespace Dxc_Beef
{
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

#if BF_PLATFORM_WINDOWS
	typealias IDxcBlobUtf16 = IDxcBlobWide;
#endif
}