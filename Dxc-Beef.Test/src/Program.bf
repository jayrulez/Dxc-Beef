using System;
using Dxc_Beef;
using System.Collections;
using System.Diagnostics;
using System.IO;
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

			String shadersPath = Path.InternalCombine(.. scope .(), Directory.GetCurrentDirectory(.. scope String()), "shaders");

			result = pLibrary.VT.CreateBlobFromFile(pLibrary, Path.InternalCombine(.. scope .(), shadersPath, "shader.hlsl").ToScopedNativeWChar!(), &codePage, out pSource);
			if (result != .OK)
				return;

			List<char16*> arguments = scope .();
			{
				arguments.Add(scope String("-E").ToScopedNativeWChar!::());
				arguments.Add(scope String("PSMain").ToScopedNativeWChar!::());

				arguments.Add(scope String("-T").ToScopedNativeWChar!::());
				arguments.Add(scope String("ps_6_2").ToScopedNativeWChar!::());

				arguments.Add(scope String("-Qstrip_debug").ToScopedNativeWChar!::());
				arguments.Add(scope String("-Qstrip_reflect").ToScopedNativeWChar!::());

				arguments.Add(DXC_ARG_WARNINGS_ARE_ERRORS.ToScopedNativeWChar!::());
				arguments.Add(DXC_ARG_DEBUG.ToScopedNativeWChar!::());
				arguments.Add(DXC_ARG_PACK_MATRIX_ROW_MAJOR.ToScopedNativeWChar!::());
			}

			IDxcCompiler3* pCompiler = null;

			result = Dxc.CreateInstance(out pCompiler);
			if (result != .OK)
				return;

			DxcBuffer buffer = .()
				{
					Ptr = pSource.VT.GetBufferPointer(pSource),
					Size = pSource.VT.GetBufferSize(pSource),
					Encoding = 0
				};

			IncludeHandler includeHandler = .(pLibrary, shadersPath);

			result = pCompiler.VT.Compile(pCompiler, &buffer, arguments.Ptr, (.)arguments.Count, &includeHandler, ref IDxcResult.sIID, var ppResult);
			if (result != .OK)
				return;

			IDxcResult* pResult = (.)ppResult;

			result = pResult.VT.GetStatus(pResult, var status);

			if (status != .OK)
			{
				IDxcBlobEncoding* pErrors = null;
				result = pResult.VT.GetErrorBuffer(pResult, out pErrors);
				if (pErrors != null && pErrors.VT.GetBufferSize(pErrors) > 0)
				{
					Debug.WriteLine(scope String((char8*)pErrors.VT.GetBufferPointer(pErrors)));
				}
				return;
			}

			IDxcBlob* pBlob = null;

			result = pResult.VT.GetResult(pResult, out pBlob);
			if (result != .OK)
				return;

			List<uint8> data = scope .();

			data.AddRange(Span<uint8>((uint8*)pBlob.VT.GetBufferPointer(pBlob), pBlob.VT.GetBufferSize(pBlob)));

			String outputFile = Path.InternalCombine(.. scope .(), shadersPath, "cache", "compiled_shader.dxil");

			if (File.WriteAll(outputFile, data) case .Err)
			{
				Debug.WriteLine($"Failed to write compiled shader.");
				return;
			}

			Console.Read();
		}
	}
}