; ModuleID = '/home/ponce/git/Dat3M/output/memcpy_s.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 16
@__const.main.b = private unnamed_addr constant [3 x i32] [i32 5, i32 6, i32 7], align 4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i32], align 16
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %2, metadata !14, metadata !DIExpression()), !dbg !18
  %5 = bitcast [4 x i32]* %2 to i8*, !dbg !18
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %5, i8* align 16 bitcast ([4 x i32]* @__const.main.a to i8*), i64 16, i1 false), !dbg !18
  call void @llvm.dbg.declare(metadata [3 x i32]* %3, metadata !19, metadata !DIExpression()), !dbg !23
  %6 = bitcast [3 x i32]* %3 to i8*, !dbg !23
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %6, i8* align 4 bitcast ([3 x i32]* @__const.main.b to i8*), i64 12, i1 false), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %7 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !26
  %8 = call i32 (i8*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i8*, i64, i32*, i64, ...)*)(i8* null, i64 12, i32* %7, i64 12), !dbg !27
  store i32 %8, i32* %4, align 4, !dbg !28
  %9 = load i32, i32* %4, align 4, !dbg !29
  %10 = icmp sgt i32 %9, 0, !dbg !30
  %11 = zext i1 %10 to i32, !dbg !30
  %12 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %11), !dbg !31
  %13 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !32
  %14 = call i32 (i32*, i64, i8*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i8*, i64, ...)*)(i32* %13, i64 12, i8* null, i64 12), !dbg !33
  store i32 %14, i32* %4, align 4, !dbg !34
  %15 = load i32, i32* %4, align 4, !dbg !35
  %16 = icmp sgt i32 %15, 0, !dbg !36
  %17 = zext i1 %16 to i32, !dbg !36
  %18 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %17), !dbg !37
  %19 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !38
  %20 = load i32, i32* %19, align 4, !dbg !38
  %21 = icmp eq i32 %20, 0, !dbg !39
  %22 = zext i1 %21 to i32, !dbg !39
  %23 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %22), !dbg !40
  %24 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !41
  %25 = load i32, i32* %24, align 4, !dbg !41
  %26 = icmp eq i32 %25, 0, !dbg !42
  %27 = zext i1 %26 to i32, !dbg !42
  %28 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %27), !dbg !43
  %29 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !44
  %30 = load i32, i32* %29, align 4, !dbg !44
  %31 = icmp eq i32 %30, 0, !dbg !45
  %32 = zext i1 %31 to i32, !dbg !45
  %33 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %32), !dbg !46
  %34 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !47
  store i32 5, i32* %34, align 4, !dbg !48
  %35 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !49
  store i32 6, i32* %35, align 4, !dbg !50
  %36 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !51
  store i32 7, i32* %36, align 4, !dbg !52
  %37 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !53
  %38 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !54
  %39 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %37, i64 8, i32* %38, i64 16), !dbg !55
  store i32 %39, i32* %4, align 4, !dbg !56
  %40 = load i32, i32* %4, align 4, !dbg !57
  %41 = icmp sgt i32 %40, 0, !dbg !58
  %42 = zext i1 %41 to i32, !dbg !58
  %43 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %42), !dbg !59
  %44 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !60
  %45 = load i32, i32* %44, align 4, !dbg !60
  %46 = icmp eq i32 %45, 0, !dbg !61
  %47 = zext i1 %46 to i32, !dbg !61
  %48 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %47), !dbg !62
  %49 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !63
  %50 = load i32, i32* %49, align 4, !dbg !63
  %51 = icmp eq i32 %50, 0, !dbg !64
  %52 = zext i1 %51 to i32, !dbg !64
  %53 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %52), !dbg !65
  %54 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !66
  %55 = load i32, i32* %54, align 4, !dbg !66
  %56 = icmp eq i32 %55, 7, !dbg !67
  %57 = zext i1 %56 to i32, !dbg !67
  %58 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %57), !dbg !68
  %59 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !69
  store i32 5, i32* %59, align 4, !dbg !70
  %60 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !71
  store i32 6, i32* %60, align 4, !dbg !72
  %61 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !73
  store i32 7, i32* %61, align 4, !dbg !74
  %62 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !75
  %63 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !76
  %64 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %62, i64 12, i32* %63, i64 12), !dbg !77
  store i32 %64, i32* %4, align 4, !dbg !78
  %65 = load i32, i32* %4, align 4, !dbg !79
  %66 = icmp sgt i32 %65, 0, !dbg !80
  %67 = zext i1 %66 to i32, !dbg !80
  %68 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %67), !dbg !81
  %69 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !82
  %70 = load i32, i32* %69, align 4, !dbg !82
  %71 = icmp eq i32 %70, 0, !dbg !83
  %72 = zext i1 %71 to i32, !dbg !83
  %73 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %72), !dbg !84
  %74 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !85
  %75 = load i32, i32* %74, align 4, !dbg !85
  %76 = icmp eq i32 %75, 0, !dbg !86
  %77 = zext i1 %76 to i32, !dbg !86
  %78 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %77), !dbg !87
  %79 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !88
  %80 = load i32, i32* %79, align 4, !dbg !88
  %81 = icmp eq i32 %80, 0, !dbg !89
  %82 = zext i1 %81 to i32, !dbg !89
  %83 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %82), !dbg !90
  %84 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !91
  store i32 5, i32* %84, align 4, !dbg !92
  %85 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !93
  store i32 6, i32* %85, align 4, !dbg !94
  %86 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !95
  store i32 7, i32* %86, align 4, !dbg !96
  %87 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !97
  %88 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !98
  %89 = call i32 (i32*, i64, i32*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (i32*, i64, i32*, i64, ...)*)(i32* %87, i64 12, i32* %88, i64 12), !dbg !99
  store i32 %89, i32* %4, align 4, !dbg !100
  %90 = load i32, i32* %4, align 4, !dbg !101
  %91 = icmp eq i32 %90, 0, !dbg !102
  %92 = zext i1 %91 to i32, !dbg !102
  %93 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %92), !dbg !103
  %94 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !104
  %95 = load i32, i32* %94, align 4, !dbg !104
  %96 = icmp eq i32 %95, 1, !dbg !105
  %97 = zext i1 %96 to i32, !dbg !105
  %98 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %97), !dbg !106
  %99 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !107
  %100 = load i32, i32* %99, align 4, !dbg !107
  %101 = icmp eq i32 %100, 2, !dbg !108
  %102 = zext i1 %101 to i32, !dbg !108
  %103 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %102), !dbg !109
  %104 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !110
  %105 = load i32, i32* %104, align 4, !dbg !110
  %106 = icmp eq i32 %105, 3, !dbg !111
  %107 = zext i1 %106 to i32, !dbg !111
  %108 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 %107), !dbg !112
  ret i32 0, !dbg !113
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

declare dso_local i32 @memcpy_s(...) #3

declare dso_local i32 @assert(...) #3

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!9 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 5, type: !11, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DILocalVariable(name: "a", scope: !9, file: !10, line: 7, type: !15)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 128, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 4)
!18 = !DILocation(line: 7, column: 9, scope: !9)
!19 = !DILocalVariable(name: "b", scope: !9, file: !10, line: 8, type: !20)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 96, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 3)
!23 = !DILocation(line: 8, column: 9, scope: !9)
!24 = !DILocalVariable(name: "ret", scope: !9, file: !10, line: 10, type: !13)
!25 = !DILocation(line: 10, column: 9, scope: !9)
!26 = !DILocation(line: 13, column: 41, scope: !9)
!27 = !DILocation(line: 13, column: 11, scope: !9)
!28 = !DILocation(line: 13, column: 9, scope: !9)
!29 = !DILocation(line: 14, column: 12, scope: !9)
!30 = !DILocation(line: 14, column: 16, scope: !9)
!31 = !DILocation(line: 14, column: 5, scope: !9)
!32 = !DILocation(line: 17, column: 20, scope: !9)
!33 = !DILocation(line: 17, column: 11, scope: !9)
!34 = !DILocation(line: 17, column: 9, scope: !9)
!35 = !DILocation(line: 18, column: 12, scope: !9)
!36 = !DILocation(line: 18, column: 16, scope: !9)
!37 = !DILocation(line: 18, column: 5, scope: !9)
!38 = !DILocation(line: 19, column: 12, scope: !9)
!39 = !DILocation(line: 19, column: 17, scope: !9)
!40 = !DILocation(line: 19, column: 5, scope: !9)
!41 = !DILocation(line: 20, column: 12, scope: !9)
!42 = !DILocation(line: 20, column: 17, scope: !9)
!43 = !DILocation(line: 20, column: 5, scope: !9)
!44 = !DILocation(line: 21, column: 12, scope: !9)
!45 = !DILocation(line: 21, column: 17, scope: !9)
!46 = !DILocation(line: 21, column: 5, scope: !9)
!47 = !DILocation(line: 22, column: 5, scope: !9)
!48 = !DILocation(line: 22, column: 10, scope: !9)
!49 = !DILocation(line: 23, column: 5, scope: !9)
!50 = !DILocation(line: 23, column: 10, scope: !9)
!51 = !DILocation(line: 24, column: 5, scope: !9)
!52 = !DILocation(line: 24, column: 10, scope: !9)
!53 = !DILocation(line: 27, column: 20, scope: !9)
!54 = !DILocation(line: 27, column: 38, scope: !9)
!55 = !DILocation(line: 27, column: 11, scope: !9)
!56 = !DILocation(line: 27, column: 9, scope: !9)
!57 = !DILocation(line: 28, column: 12, scope: !9)
!58 = !DILocation(line: 28, column: 16, scope: !9)
!59 = !DILocation(line: 28, column: 5, scope: !9)
!60 = !DILocation(line: 29, column: 12, scope: !9)
!61 = !DILocation(line: 29, column: 17, scope: !9)
!62 = !DILocation(line: 29, column: 5, scope: !9)
!63 = !DILocation(line: 30, column: 12, scope: !9)
!64 = !DILocation(line: 30, column: 17, scope: !9)
!65 = !DILocation(line: 30, column: 5, scope: !9)
!66 = !DILocation(line: 31, column: 12, scope: !9)
!67 = !DILocation(line: 31, column: 17, scope: !9)
!68 = !DILocation(line: 31, column: 5, scope: !9)
!69 = !DILocation(line: 32, column: 5, scope: !9)
!70 = !DILocation(line: 32, column: 10, scope: !9)
!71 = !DILocation(line: 33, column: 5, scope: !9)
!72 = !DILocation(line: 33, column: 10, scope: !9)
!73 = !DILocation(line: 34, column: 5, scope: !9)
!74 = !DILocation(line: 34, column: 10, scope: !9)
!75 = !DILocation(line: 37, column: 20, scope: !9)
!76 = !DILocation(line: 37, column: 38, scope: !9)
!77 = !DILocation(line: 37, column: 11, scope: !9)
!78 = !DILocation(line: 37, column: 9, scope: !9)
!79 = !DILocation(line: 38, column: 12, scope: !9)
!80 = !DILocation(line: 38, column: 16, scope: !9)
!81 = !DILocation(line: 38, column: 5, scope: !9)
!82 = !DILocation(line: 39, column: 12, scope: !9)
!83 = !DILocation(line: 39, column: 17, scope: !9)
!84 = !DILocation(line: 39, column: 5, scope: !9)
!85 = !DILocation(line: 40, column: 12, scope: !9)
!86 = !DILocation(line: 40, column: 17, scope: !9)
!87 = !DILocation(line: 40, column: 5, scope: !9)
!88 = !DILocation(line: 41, column: 12, scope: !9)
!89 = !DILocation(line: 41, column: 17, scope: !9)
!90 = !DILocation(line: 41, column: 5, scope: !9)
!91 = !DILocation(line: 42, column: 5, scope: !9)
!92 = !DILocation(line: 42, column: 10, scope: !9)
!93 = !DILocation(line: 43, column: 5, scope: !9)
!94 = !DILocation(line: 43, column: 10, scope: !9)
!95 = !DILocation(line: 44, column: 5, scope: !9)
!96 = !DILocation(line: 44, column: 10, scope: !9)
!97 = !DILocation(line: 47, column: 20, scope: !9)
!98 = !DILocation(line: 47, column: 38, scope: !9)
!99 = !DILocation(line: 47, column: 11, scope: !9)
!100 = !DILocation(line: 47, column: 9, scope: !9)
!101 = !DILocation(line: 48, column: 12, scope: !9)
!102 = !DILocation(line: 48, column: 16, scope: !9)
!103 = !DILocation(line: 48, column: 5, scope: !9)
!104 = !DILocation(line: 49, column: 12, scope: !9)
!105 = !DILocation(line: 49, column: 17, scope: !9)
!106 = !DILocation(line: 49, column: 5, scope: !9)
!107 = !DILocation(line: 50, column: 12, scope: !9)
!108 = !DILocation(line: 50, column: 17, scope: !9)
!109 = !DILocation(line: 50, column: 5, scope: !9)
!110 = !DILocation(line: 51, column: 12, scope: !9)
!111 = !DILocation(line: 51, column: 17, scope: !9)
!112 = !DILocation(line: 51, column: 5, scope: !9)
!113 = !DILocation(line: 53, column: 2, scope: !9)
