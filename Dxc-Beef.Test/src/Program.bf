using System;
using Dxc_Beef;
namespace Dxc_Beef.Test
{
	class Program
	{
		public static void Main(String[] args)
		{
			/*void* dxc = null;

			Dxc.DxcCreateInstance(ref CLSID_DxcCompiler, ref IDxcCompiler3.sIID, out dxc);

			IDxcCompiler3* compiler = (.)(void*)dxc;
			*/

			void* compilerArgsPtr = null;

			Dxc.DxcCreateInstance(ref IDxcCompilerArgs.sCLSID, ref IDxcCompilerArgs.sIID, out compilerArgsPtr);

			IDxcCompilerArgs* compilerArgs = (IDxcCompilerArgs*)(void*)compilerArgsPtr;

			Console.WriteLine(compilerArgs.VT.GetCount(compilerArgs));

			var arg1 = scope String("arg1").ToScopedNativeWChar!();

			compilerArgs.VT.AddArguments(compilerArgs, &arg1, 1);

			int count = compilerArgs.VT.GetCount(compilerArgs);
			Console.WriteLine(count);

			char16** v = compilerArgs.VT.GetArguments(compilerArgs);

			for(int i = 0; i < count; i++){
				Console.WriteLine($"{scope String(v[i])}");
			}

			Console.Read();
		}
	}
}