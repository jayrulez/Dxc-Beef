using System;

namespace Dxc_Beef
{
	public static class Dxc
	{
		private static function Windows.COM_IUnknown.HResult(
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv
			) DxcCreateInstanceProc = => DxcCreateInstance;

		private static function Windows.COM_IUnknown.HResult(
			in IMalloc* pMalloc,
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv
			) DxcCreateInstance2Proc = => DxcCreateInstance2;

		/// <summary>
		/// Creates a single uninitialized object of the class associated with a specified CLSID.
		/// </summary>
		/// <param name="rclsid">
		/// The CLSID associated with the data and code that will be used to create the object.
		/// </param>
		/// <param name="riid">
		/// A reference to the identifier of the interface to be used to communicate
		/// with the object.
		/// </param>
		/// <param name="ppv">
		/// Address of pointer variable that receives the interface pointer requested
		/// in riid. Upon successful return, *ppv contains the requested interface
		/// pointer. Upon failure, *ppv contains NULL.</param>
		/// <remarks>
		/// While this function is similar to CoCreateInstance, there is no COM involvement.
		/// </remarks>

		[CallingConvention(.Stdcall), CLink, Import("dxcompiler.lib")]
		private static extern Windows.COM_IUnknown.HResult DxcCreateInstance(
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv);

		[CallingConvention(.Stdcall), CLink, Import("dxcompiler.lib")]
		private static extern Windows.COM_IUnknown.HResult DxcCreateInstance2(
			in IMalloc* pMalloc,
			ref Guid rclsid,
			ref Guid riid,
			out void* ppv);

		public static Windows.COM_IUnknown.HResult CreateInstance<T>(out T* ppv) where T : COM_Resource
		{
			void* ptr = null;
			//Console.WriteLine($"CLSID:{T.sCLSID.GetString(.. scope .())}, IID:{T.sIID.GetString(.. scope .())}");
			var result = DxcCreateInstance(ref T.sCLSID, ref T.sIID, out ptr);

			ppv = (.)ptr;

			return result;
		}
	}

	/*
	public struct DxcDiaDataSource : Windows.COM_IUnknown
	{
		public static Guid sCLSID = CLSID_DxcDiaDataSource;
	}
	*/
}