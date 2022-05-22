using System;
namespace Dxc_Beef
{
	public struct IDxcLibrary : COM_Resource
	{
		public static new Guid sIID = .(0xe5204dc7, 0xd18c, 0x4c3c, 0xbd, 0xfb, 0x85, 0x16, 0x73, 0x98, 0x0f, 0xe7);
		public static new Guid sCLSID = CLSID_DxcLibrary;

		public struct VTable : COM_Resource.VTable
		{
			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, IMalloc *pMalloc) SetMalloc;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self,
				IDxcBlob *pBlob, uint32 offset, uint32 length, out IDxcBlob *ppResult) CreateBlobFromBlob;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				char16* pFileName, uint32* codePage,
				out IDxcBlobEncoding *pBlobEncoding
				) CreateBlobFromFile;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self,
				void* pText, uint32 size, uint32 codePage,
				out IDxcBlobEncoding *pBlobEncoding
				) CreateBlobWithEncodingFromPinned;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				void* pText, uint32 size, uint32 codePage,
				out IDxcBlobEncoding *pBlobEncoding
				) CreateBlobWithEncodingOnHeapCopy;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				void* pText, IMalloc *pIMalloc, uint32 size, uint32 codePage,
				out IDxcBlobEncoding *pBlobEncoding
				) CreateBlobWithEncodingOnMalloc;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				 out IDxcIncludeHandler *ppResult) CreateIncludeHandler;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IStream *ppStream) CreateStreamFromBlobReadOnly;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IDxcBlobEncoding *pBlobEncoding) GetBlobAsUtf8;

			public function [CallingConvention(.Stdcall)] HResult(IDxcLibrary * self, 
				IDxcBlob *pBlob, out IDxcBlobEncoding *pBlobEncoding) GetBlobAsWide;
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