using System;
using System.IO;
namespace Dxc_Beef
{
	public struct IDxcIncludeHandler  : Windows.COM_IUnknown
	{
		public static Guid sIID = .(0x7f61fc7d, 0x950d, 0x467f, 0xb3, 0xe3, 0x3c, 0x02, 0xfb, 0x49, 0x18, 0x7c);

		public struct VTable : Windows.COM_IUnknown.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcIncludeHandler* self, char16* pFilename, out IDxcBlob* ppIncludeSource) LoadSource;
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