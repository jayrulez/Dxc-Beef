using System;
using Dxc_Beef;
using System.Collections;
using System.Diagnostics;
using System.IO;
namespace Dxc_Beef.Test
{
	class Program
	{
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
					Ptr = pSource.GetBufferPointer(),
					Size = pSource.GetBufferSize(),
					Encoding = 0
				};

			IncludeHandler includeHandler = .(pLibrary, shadersPath);

			result = pCompiler.VT.Compile(pCompiler, &buffer, arguments.Ptr, (.)arguments.Count, &includeHandler, ref IDxcResult.sIID, var ppResult);
			if (result != .OK)
				return;

			IDxcResult* pResult = (.)ppResult;

			result = pResult.GetStatus(var status);

			if (status != .OK)
			{
				IDxcBlobEncoding* pErrors = null;
				result = pResult.GetErrorBuffer(out pErrors);
				if (pErrors != null && pErrors.GetBufferSize() > 0)
				{
					Debug.WriteLine(scope String((char8*)pErrors.GetBufferPointer()));
				}
				return;
			}

			IDxcBlob* pBlob = null;

			result = pResult.GetResult(out pBlob);
			if (result != .OK)
				return;

			List<uint8> data = scope .();

			data.AddRange(Span<uint8>((.)pBlob.GetBufferPointer(), pBlob.GetBufferSize()));

			String outputFile = Path.InternalCombine(.. scope .(), shadersPath, "cache", "compiled_shader.dxil");

			if (File.WriteAll(outputFile, data) case .Err)
			{
				Debug.WriteLine($"Failed to write compiled shader.");
				return;
			}

			Console.WriteLine("Shader compilation successful.\nOutput file: {0}\n", outputFile);

			Console.WriteLine("Press [Enter] to exit.");

			Console.Read();
		}
	}
}