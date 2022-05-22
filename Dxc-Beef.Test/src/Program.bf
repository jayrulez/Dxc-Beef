using System;
using Dxc_Beef;
using System.Collections;
namespace Dxc_Beef.Test
{
	class Program
	{
		public static void Test1()
		{
			IDxcUtils* dxcUtils = null;
			var result = Dxc.CreateInstance(out dxcUtils);
			if (result != .OK)
				return;
			uint32 codePage = 0;

			IDxcBlobEncoding* pBlob = null;

			var fileName = scope String("shader-binary.dxil").ToScopedNativeWChar!();
			//var fileName = scope String("shader.hlsl").ToScopedNativeWChar!();

			result = dxcUtils.VT.LoadFile(dxcUtils, fileName, &codePage, out pBlob);
			if (result != .OK)
				return;

			Console.WriteLine($"File size: {pBlob.VT.GetBufferSize(pBlob)}");

			IDxcContainerReflection* container = null;
			result = Dxc.CreateInstance(out container);
			if (result != .OK)
				return;

			result = container.VT.Load(container, pBlob);
			if (result != .OK)
				return;

			result = container.VT.GetPartCount(container, let pPartCount);
			if (result != .OK)
				return;

			uint32 partCount = pPartCount;

			for (int i = 0; i < partCount; i++)
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

			for (int i = 0; i < count; i++)
			{
				Console.WriteLine($"{scope String(v[i])}");
			}

			IDxcPdbUtils* pdbUtils = null;

			Dxc.CreateInstance(out pdbUtils);

			result = pdbUtils.VT.Load(pdbUtils, pBlob);
			if (result != .OK)
				return;

			/*
			IDxcResult* compileResult = null;

			result = pdbUtils.VT.CompileForFullPDB(pdbUtils, out compileResult);
			if(result != .OK)
				return;*/

			result = pdbUtils.VT.GetSourceCount(pdbUtils, var pSourceCount);
			if (result != .OK)
				return;

			result = pdbUtils.VT.GetArgCount(pdbUtils, var pArgCount);
			if (result != .OK)
				return;

			result = pdbUtils.VT.GetName(pdbUtils, var name);
			if (result != .OK)
				return;

			IDxcBlob* fullPdbBlob = null;

			result = pdbUtils.VT.GetFullPDB(pdbUtils, out fullPdbBlob);
			if (result != .OK)
				return;
		}

		public static void Main(String[] args)
		{
			IDxcLibrary* pLibrary = null;
			var result = Dxc.CreateInstance(out pLibrary);
			if (result != .OK)
				return;

			IDxcBlobEncoding* pSource = null;

			uint32 codePage = 0;

			result = pLibrary.VT.CreateBlobFromFile(pLibrary, scope String("shader.hlsl").ToScopedNativeWChar!(), &codePage, out pSource);
			if (result != .OK)
				return;

			char16* pTarget = scope String("ps_6_0").ToScopedNativeWChar!();
			char16* pEntryPoint = scope String("PSMain").ToScopedNativeWChar!();

			List<char16*> arguments = scope .();
			Queue<char16*> dynamicArguments = scope .();
			arguments.Add(scope String("/Zi").ToScopedNativeWChar!());
			arguments.Add(scope String("/Qembed_debug").ToScopedNativeWChar!());
			uint32 space = 0;

			/*if(){

			}*/

			arguments.Add(scope String("-auto-binding-space").ToScopedNativeWChar!());
			dynamicArguments.Add(scope String(space.ToString(.. scope .())).ToScopedNativeWChar!());
			arguments.AddRange(dynamicArguments);

			IDxcOperationResult* pResult = null;
			IDxcCompiler* pCompiler = null;

			result = Dxc.CreateInstance(out pCompiler);
			if (result != .OK)
				return;

			result = pCompiler.VT.Compile(pCompiler, pSource, scope String("shader.hlsl").ToScopedNativeWChar!(), pEntryPoint, pTarget, arguments.Ptr, (.)arguments.Count, null, 0, null, out pResult);
			if (result != .OK)
				return;

			result = pResult.VT.GetStatus(pResult, var status);

			if (status != .OK)
			{
				IDxcBlobEncoding* pErrors = null;
				result = pResult.VT.GetErrorBuffer(pResult, out pErrors);
				if (pErrors != null && pErrors.VT.GetBufferSize(pErrors) > 0)
				{
					Console.WriteLine(scope String((char8*)pErrors.VT.GetBufferPointer(pErrors)));
				}
				return;
			}

			Console.Read();
		}
	}
}