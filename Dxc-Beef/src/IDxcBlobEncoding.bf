using System;
namespace Dxc_Beef
{
	public struct IDxcBlobEncoding : IDxcBlob
	{
		public static new Guid sIID = .(0x7241d424, 0x2646, 0x4191, 0x97, 0xc0, 0x98, 0xe9, 0x6e, 0x42, 0xfc, 0x68);

		public struct VTable : IDxcBlob.VTable
		{
			public function [CallingConvention(.Stdcall)] void(IDxcBlobEncoding* self, out bool* pKnown, out uint32 pCodePage) GetEncoding;
		}

		public new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}
	}
}