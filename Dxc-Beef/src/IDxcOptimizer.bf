using System;
namespace Dxc_Beef
{
	public struct IDxcOptimizer : COM_Resource
	{
		public static new Guid sIID = .(0x25740E2E, 0x9CBA, 0x401B, 0x91, 0x19, 0x4F, 0xB4, 0x2F, 0x39, 0xF2, 0x70);
		public static new Guid sCLSID = CLSID_DxcOptimizer;

		public struct VTable : COM_Resource.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self, out uint32 pCount) GetAvailablePassCount;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self, uint32 index, out IDxcOptimizerPass* ppResult) GetAvailablePass;
			public function [CallingConvention(.Stdcall)] HResult(IDxcOptimizer * self,
				IDxcBlob *pBlob,
				char16* *ppOptions, uint32 optionCount,
				out IDxcBlob *pOutputModule,
				out IDxcBlobEncoding *ppOutputText
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
}