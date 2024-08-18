using System;
namespace Dxc_Beef
{
	[CRepr]struct IDxcContainerReflection : IUnknown
	{
		public new const Guid IID = .(0xd2c21b26, 0x8350, 0x4bdc, 0x97, 0x6a, 0x33, 0x1c, 0xe6, 0xf4, 0xc5, 0x4c);
		public const Guid sCLSID = CLSID_DxcContainerReflection;

		public new VTable* VT { get => (.)mVT; }

		[CRepr]public struct VTable : IUnknown.VTable
		{
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, IDxcBlob* pContainer) Load;
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, uint32* pResult) GetPartCount;
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, uint32 idx, uint32* pResult) GetPartKind;
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, uint32 idx, IDxcBlob** ppResult) GetPartContent;
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, uint32 kind, uint32* pResult) FindFirstPartKind;
			protected new function [CallingConvention(.Stdcall)] HRESULT(SelfOuter* self, uint32 idx, in Guid iid, void** ppvObject) GetPartReflection;
		}


		public HRESULT Load(IDxcBlob* pContainer) mut => VT.[Friend]Load(&this, pContainer);

		public HRESULT GetPartCount(uint32* pResult) mut => VT.[Friend]GetPartCount(&this, pResult);

		public HRESULT GetPartKind(uint32 idx, uint32* pResult) mut => VT.[Friend]GetPartKind(&this, idx, pResult);

		public HRESULT GetPartContent(uint32 idx, IDxcBlob** ppResult) mut => VT.[Friend]GetPartContent(&this, idx, ppResult);

		public HRESULT FindFirstPartKind(uint32 kind, uint32* pResult) mut => VT.[Friend]FindFirstPartKind(&this, kind, pResult);

		public HRESULT GetPartReflection(uint32 idx, in Guid iid, void** ppvObject) mut => VT.[Friend]GetPartReflection(&this, idx, iid, ppvObject);
	}
}