using System;
namespace Dxc_Beef
{
	public struct IDxcAssembler : COM_Resource
	{
		public static new Guid sIID = .(0x091f7a26, 0x1c1f, 0x4948, 0x90, 0x4b, 0xe6, 0xe3, 0xa8, 0xa7, 0x71, 0xd5);
		public static new Guid sCLSID = CLSID_DxcAssembler;

		public struct VTable : COM_Resource.VTable
		{
			// Assemble dxil in ll or llvm bitcode to DXIL container.
			public function [CallingConvention(.Stdcall)] HResult(
				IDxcAssembler* self,
				IDxcBlob* pShader, // Shader to assemble.
				out IDxcOperationResult* ppResult // Assembly output status, buffer, and errors
				) AssembleToContainer;
		}

		private new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}

		public HResult AssembleToContainer(IDxcBlob* pShader, out IDxcOperationResult* ppResult) mut
		{
			return VT.AssembleToContainer(&this, pShader, out ppResult);
		}
	}
}