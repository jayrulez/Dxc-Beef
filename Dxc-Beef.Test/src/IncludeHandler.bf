using System;
using System.IO;
namespace Dxc_Beef.Test
{
	public struct IncludeHandler : IDxcIncludeHandler
	{
		public this(IDxcLibrary* pLibrary, in String basePath)
		{
			m_pLibrary = pLibrary;
			m_BasePath = basePath;

			function [CallingConvention(.Stdcall)] HResult(IncludeHandler* this, ref Guid riid, void** result) queryInterface = => InternalQueryInterface;
			function [CallingConvention(.Stdcall)] uint32(IncludeHandler* this) addRef = => InternalAddRef;
			function [CallingConvention(.Stdcall)] uint32(IncludeHandler* this) release = => InternalRelease;
			function [CallingConvention(.Stdcall)] HResult(IncludeHandler* this, char16* pFilename, out IDxcBlob* ppIncludeSource) loadSource = => InternalLoadSource;

			mDVT = .();
			mDVT.QueryInterface = (.)(void*)queryInterface;
			mDVT.AddRef = (.)(void*)addRef;
			mDVT.Release = (.)(void*)release;
			mDVT.LoadSource = (.)(void*)loadSource;

			mVT = &mDVT;
		}

		private HResult InternalLoadSource(char16* pFilename, out IDxcBlob* ppIncludeSource)
		{
			IDxcBlobEncoding* pSource = null;

			String path = Path.InternalCombine(.. scope .(), m_BasePath, scope String(pFilename));

			HResult result = m_pLibrary.CreateBlobFromFile(path, null, out pSource);

			if (result == .OK && pSource != null)
				ppIncludeSource = pSource;
			else
				ppIncludeSource = ?;

			return result;
		}

		public new HResult LoadSource(in StringView pFilename, out IDxcBlob* ppIncludeSource)
			=> InternalLoadSource(pFilename.ToScopedNativeWChar!(), out ppIncludeSource);

		private HResult InternalQueryInterface(ref Guid riid, void** result)
		{
			return (.)0x80004001;
		}

		private uint32 InternalAddRef()
		{
			return (.)0x80004001;
		}

		private uint32 InternalRelease()
		{
			return (.)0x80004001;
		}

		private new VTable* VT
		{
			get
			{
				return (.)mVT;
			}
		}

		private IDxcIncludeHandler.VTable mDVT;
		private IDxcLibrary* m_pLibrary = null;
		private String m_BasePath = null;
	}
}