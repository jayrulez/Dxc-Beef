using System;
using Dxc_Beef;
namespace Dxc_Beef.Test
{
	class Program
	{
		public static void Main(String[] args)
		{
			IDxcUtils* dxcUtils = null;
			var result = Dxc.CreateInstance(out dxcUtils);
			if(result != .OK)
				return;
			uint32 codePage = 0;

			IDxcBlobEncoding* pBlob = null;

			var fileName = scope String("shader-binary.dxil").ToScopedNativeWChar!();
			//var fileName = scope String("shader.hlsl").ToScopedNativeWChar!();

			result = dxcUtils.VT.LoadFile(dxcUtils, fileName, &codePage, out pBlob);
			if(result != .OK)
				return;

			Console.WriteLine($"File size: {pBlob.VT.GetBufferSize(pBlob)}");

			IDxcContainerReflection* container = null;
			result = Dxc.CreateInstance(out container);
			if(result != .OK)
				return;

			result = container.VT.Load(container, pBlob);
			if(result != .OK)
				return;

			result = container.VT.GetPartCount(container, let pPartCount);
			if(result != .OK)
				return;

			uint32 partCount = pPartCount;

			for(int i = 0; i < partCount; i++)
			{
				result = container.VT.GetPartKind(container, (.)i, var pPartKind);
				Console.WriteLine($"Part kind: {pPartKind}");
			}

			IDxcCompilerArgs* compilerArgs = null;

			Dxc.CreateInstance(out compilerArgs);

			Console.WriteLine(compilerArgs.VT.GetCount(compilerArgs));

			var arg1 = scope String("arg1").ToScopedNativeWChar!();

			compilerArgs.VT.AddArguments(compilerArgs, &arg1, 1);

			int count = compilerArgs.VT.GetCount(compilerArgs);
			Console.WriteLine(count);

			char16** v = compilerArgs.VT.GetArguments(compilerArgs);

			for(int i = 0; i < count; i++){
				Console.WriteLine($"{scope String(v[i])}");
			}

			IDxcPdbUtils* pdbUtils = null;

			Dxc.CreateInstance(out pdbUtils);

			result = pdbUtils.VT.Load(pdbUtils, pBlob);
			if(result != .OK)
				return;

			/*
			IDxcResult* compileResult = null;

			result = pdbUtils.VT.CompileForFullPDB(pdbUtils, out compileResult);
			if(result != .OK)
				return;*/

			result = pdbUtils.VT.GetSourceCount(pdbUtils, var pSourceCount);
			if(result != .OK)
				return;

			result = pdbUtils.VT.GetArgCount(pdbUtils, var pArgCount);
			if(result != .OK)
				return;

			result = pdbUtils.VT.GetName(pdbUtils, var name);
			if(result != .OK)
				return;

			IDxcBlob* fullPdbBlob = null;

			result = pdbUtils.VT.GetFullPDB(pdbUtils, out fullPdbBlob);
			if(result != .OK)
				return;

			Console.Read();
		}
	}
}