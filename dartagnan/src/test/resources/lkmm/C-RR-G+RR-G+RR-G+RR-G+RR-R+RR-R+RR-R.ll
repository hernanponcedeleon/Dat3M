; ModuleID = '/home/ponce/git/Dat3M/output/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x0 = dso_local global i32 0, align 4, !dbg !0
@r1_1 = dso_local global i32 0, align 4, !dbg !40
@x1 = dso_local global i32 0, align 4, !dbg !26
@r2_1 = dso_local global i32 0, align 4, !dbg !42
@r1_2 = dso_local global i32 0, align 4, !dbg !44
@x2 = dso_local global i32 0, align 4, !dbg !30
@r2_2 = dso_local global i32 0, align 4, !dbg !46
@r1_3 = dso_local global i32 0, align 4, !dbg !48
@x3 = dso_local global i32 0, align 4, !dbg !32
@r2_3 = dso_local global i32 0, align 4, !dbg !50
@r1_4 = dso_local global i32 0, align 4, !dbg !52
@x4 = dso_local global i32 0, align 4, !dbg !34
@r2_4 = dso_local global i32 0, align 4, !dbg !54
@r1_5 = dso_local global i32 0, align 4, !dbg !56
@x5 = dso_local global i32 0, align 4, !dbg !36
@r2_5 = dso_local global i32 0, align 4, !dbg !58
@r1_6 = dso_local global i32 0, align 4, !dbg !60
@x6 = dso_local global i32 0, align 4, !dbg !38
@r2_6 = dso_local global i32 0, align 4, !dbg !62
@r1_7 = dso_local global i32 0, align 4, !dbg !64
@r2_7 = dso_local global i32 0, align 4, !dbg !66
@.str = private unnamed_addr constant [184 x i8] c"!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1))\00", align 1
@.str.1 = private unnamed_addr constant [77 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !76 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !80, metadata !DIExpression()), !dbg !81
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x0 to i8*), i32 noundef 1) #5, !dbg !82
  store i32 %2, i32* @r1_1, align 4, !dbg !83
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !84
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x1 to i8*), i32 noundef 1) #5, !dbg !85
  store i32 %3, i32* @r2_1, align 4, !dbg !86
  ret i8* null, !dbg !87
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !88 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !89, metadata !DIExpression()), !dbg !90
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x1 to i8*), i32 noundef 1) #5, !dbg !91
  store i32 %2, i32* @r1_2, align 4, !dbg !92
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !93
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x2 to i8*), i32 noundef 1) #5, !dbg !94
  store i32 %3, i32* @r2_2, align 4, !dbg !95
  ret i8* null, !dbg !96
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !97 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !98, metadata !DIExpression()), !dbg !99
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x2 to i8*), i32 noundef 1) #5, !dbg !100
  store i32 %2, i32* @r1_3, align 4, !dbg !101
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !102
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x3 to i8*), i32 noundef 1) #5, !dbg !103
  store i32 %3, i32* @r2_3, align 4, !dbg !104
  ret i8* null, !dbg !105
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_4(i8* noundef %0) #0 !dbg !106 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !107, metadata !DIExpression()), !dbg !108
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x3 to i8*), i32 noundef 1) #5, !dbg !109
  store i32 %2, i32* @r1_4, align 4, !dbg !110
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !111
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x4 to i8*), i32 noundef 1) #5, !dbg !112
  store i32 %3, i32* @r2_4, align 4, !dbg !113
  ret i8* null, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_5(i8* noundef %0) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !116, metadata !DIExpression()), !dbg !117
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !118
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x4 to i8*), i32 noundef 1) #5, !dbg !119
  store i32 %2, i32* @r1_5, align 4, !dbg !120
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x5 to i8*), i32 noundef 1) #5, !dbg !121
  store i32 %3, i32* @r2_5, align 4, !dbg !122
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !123
  ret i8* null, !dbg !124
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_6(i8* noundef %0) #0 !dbg !125 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !126, metadata !DIExpression()), !dbg !127
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !128
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x5 to i8*), i32 noundef 1) #5, !dbg !129
  store i32 %2, i32* @r1_6, align 4, !dbg !130
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x6 to i8*), i32 noundef 1) #5, !dbg !131
  store i32 %3, i32* @r2_6, align 4, !dbg !132
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !133
  ret i8* null, !dbg !134
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_7(i8* noundef %0) #0 !dbg !135 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !136, metadata !DIExpression()), !dbg !137
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !138
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x6 to i8*), i32 noundef 1) #5, !dbg !139
  store i32 %2, i32* @r1_7, align 4, !dbg !140
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x0 to i8*), i32 noundef 1) #5, !dbg !141
  store i32 %3, i32* @r2_7, align 4, !dbg !142
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !143
  ret i8* null, !dbg !144
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_8(i8* noundef %0) #0 !dbg !145 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !146, metadata !DIExpression()), !dbg !147
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x0 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !148
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x1 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !149
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x2 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !150
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x3 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !151
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x4 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !152
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x5 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !153
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x6 to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !154
  ret i8* null, !dbg !155
}

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !156 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !159, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %9 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !164
  call void @llvm.dbg.value(metadata i64* %2, metadata !165, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %10 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !166
  call void @llvm.dbg.value(metadata i64* %3, metadata !167, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %11 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !168
  call void @llvm.dbg.value(metadata i64* %4, metadata !169, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %12 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_4, i8* noundef null) #5, !dbg !170
  call void @llvm.dbg.value(metadata i64* %5, metadata !171, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %13 = call i32 @pthread_create(i64* noundef nonnull %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_5, i8* noundef null) #5, !dbg !172
  call void @llvm.dbg.value(metadata i64* %6, metadata !173, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %14 = call i32 @pthread_create(i64* noundef nonnull %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_6, i8* noundef null) #5, !dbg !174
  call void @llvm.dbg.value(metadata i64* %7, metadata !175, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %15 = call i32 @pthread_create(i64* noundef nonnull %7, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_7, i8* noundef null) #5, !dbg !176
  call void @llvm.dbg.value(metadata i64* %8, metadata !177, metadata !DIExpression(DW_OP_deref)), !dbg !163
  %16 = call i32 @pthread_create(i64* noundef nonnull %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_8, i8* noundef null) #5, !dbg !178
  %17 = load i64, i64* %1, align 8, !dbg !179
  call void @llvm.dbg.value(metadata i64 %17, metadata !159, metadata !DIExpression()), !dbg !163
  %18 = call i32 @pthread_join(i64 noundef %17, i8** noundef null) #5, !dbg !180
  %19 = load i64, i64* %2, align 8, !dbg !181
  call void @llvm.dbg.value(metadata i64 %19, metadata !165, metadata !DIExpression()), !dbg !163
  %20 = call i32 @pthread_join(i64 noundef %19, i8** noundef null) #5, !dbg !182
  %21 = load i64, i64* %3, align 8, !dbg !183
  call void @llvm.dbg.value(metadata i64 %21, metadata !167, metadata !DIExpression()), !dbg !163
  %22 = call i32 @pthread_join(i64 noundef %21, i8** noundef null) #5, !dbg !184
  %23 = load i64, i64* %4, align 8, !dbg !185
  call void @llvm.dbg.value(metadata i64 %23, metadata !169, metadata !DIExpression()), !dbg !163
  %24 = call i32 @pthread_join(i64 noundef %23, i8** noundef null) #5, !dbg !186
  %25 = load i64, i64* %5, align 8, !dbg !187
  call void @llvm.dbg.value(metadata i64 %25, metadata !171, metadata !DIExpression()), !dbg !163
  %26 = call i32 @pthread_join(i64 noundef %25, i8** noundef null) #5, !dbg !188
  %27 = load i64, i64* %6, align 8, !dbg !189
  call void @llvm.dbg.value(metadata i64 %27, metadata !173, metadata !DIExpression()), !dbg !163
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null) #5, !dbg !190
  %29 = load i64, i64* %7, align 8, !dbg !191
  call void @llvm.dbg.value(metadata i64 %29, metadata !175, metadata !DIExpression()), !dbg !163
  %30 = call i32 @pthread_join(i64 noundef %29, i8** noundef null) #5, !dbg !192
  %31 = load i64, i64* %8, align 8, !dbg !193
  call void @llvm.dbg.value(metadata i64 %31, metadata !177, metadata !DIExpression()), !dbg !163
  %32 = call i32 @pthread_join(i64 noundef %31, i8** noundef null) #5, !dbg !194
  %33 = load i32, i32* @r2_7, align 4, !dbg !195
  %34 = icmp eq i32 %33, 0, !dbg !195
  %35 = load i32, i32* @r1_1, align 4, !dbg !195
  %36 = icmp eq i32 %35, 1, !dbg !195
  %or.cond = select i1 %34, i1 %36, i1 false, !dbg !195
  %37 = load i32, i32* @r2_1, align 4, !dbg !195
  %38 = icmp eq i32 %37, 0, !dbg !195
  %or.cond3 = select i1 %or.cond, i1 %38, i1 false, !dbg !195
  %39 = load i32, i32* @r1_2, align 4, !dbg !195
  %40 = icmp eq i32 %39, 1, !dbg !195
  %or.cond5 = select i1 %or.cond3, i1 %40, i1 false, !dbg !195
  %41 = load i32, i32* @r2_2, align 4, !dbg !195
  %42 = icmp eq i32 %41, 0, !dbg !195
  %or.cond7 = select i1 %or.cond5, i1 %42, i1 false, !dbg !195
  %43 = load i32, i32* @r1_3, align 4, !dbg !195
  %44 = icmp eq i32 %43, 1, !dbg !195
  %or.cond9 = select i1 %or.cond7, i1 %44, i1 false, !dbg !195
  %45 = load i32, i32* @r2_3, align 4, !dbg !195
  %46 = icmp eq i32 %45, 0, !dbg !195
  %or.cond11 = select i1 %or.cond9, i1 %46, i1 false, !dbg !195
  %47 = load i32, i32* @r1_4, align 4, !dbg !195
  %48 = icmp eq i32 %47, 1, !dbg !195
  %or.cond13 = select i1 %or.cond11, i1 %48, i1 false, !dbg !195
  %49 = load i32, i32* @r2_4, align 4, !dbg !195
  %50 = icmp eq i32 %49, 0, !dbg !195
  %or.cond15 = select i1 %or.cond13, i1 %50, i1 false, !dbg !195
  %51 = load i32, i32* @r1_5, align 4, !dbg !195
  %52 = icmp eq i32 %51, 1, !dbg !195
  %or.cond17 = select i1 %or.cond15, i1 %52, i1 false, !dbg !195
  %53 = load i32, i32* @r2_5, align 4, !dbg !195
  %54 = icmp eq i32 %53, 0, !dbg !195
  %or.cond19 = select i1 %or.cond17, i1 %54, i1 false, !dbg !195
  %55 = load i32, i32* @r1_6, align 4, !dbg !195
  %56 = icmp eq i32 %55, 1, !dbg !195
  %or.cond21 = select i1 %or.cond19, i1 %56, i1 false, !dbg !195
  %57 = load i32, i32* @r2_6, align 4, !dbg !195
  %58 = icmp eq i32 %57, 0, !dbg !195
  %or.cond23 = select i1 %or.cond21, i1 %58, i1 false, !dbg !195
  %59 = load i32, i32* @r1_7, align 4, !dbg !195
  %60 = icmp eq i32 %59, 1, !dbg !195
  %or.cond25 = select i1 %or.cond23, i1 %60, i1 false, !dbg !195
  br i1 %or.cond25, label %61, label %62, !dbg !195

61:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([184 x i8], [184 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.1, i64 0, i64 0), i32 noundef 98, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !195
  unreachable, !dbg !195

62:                                               ; preds = %0
  ret i32 0, !dbg !198
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!68, !69, !70, !71, !72, !73, !74}
!llvm.ident = !{!75}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x0", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "dbafb2cd139d33a606f4c8b7719d2341")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!0, !26, !30, !32, !34, !36, !38, !40, !42, !44, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x1", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "dbafb2cd139d33a606f4c8b7719d2341")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "x2", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "x3", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "x4", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "x5", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "x6", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "r1_2", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "r2_2", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r1_3", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r2_3", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r1_4", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r2_4", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r1_5", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r2_5", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r1_6", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r2_6", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r1_7", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r2_7", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!68 = !{i32 7, !"Dwarf Version", i32 5}
!69 = !{i32 2, !"Debug Info Version", i32 3}
!70 = !{i32 1, !"wchar_size", i32 4}
!71 = !{i32 7, !"PIC Level", i32 2}
!72 = !{i32 7, !"PIE Level", i32 2}
!73 = !{i32 7, !"uwtable", i32 1}
!74 = !{i32 7, !"frame-pointer", i32 2}
!75 = !{!"Ubuntu clang version 14.0.6"}
!76 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 10, type: !77, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!77 = !DISubroutineType(types: !78)
!78 = !{!24, !24}
!79 = !{}
!80 = !DILocalVariable(name: "arg", arg: 1, scope: !76, file: !28, line: 10, type: !24)
!81 = !DILocation(line: 0, scope: !76)
!82 = !DILocation(line: 11, column: 9, scope: !76)
!83 = !DILocation(line: 11, column: 7, scope: !76)
!84 = !DILocation(line: 12, column: 2, scope: !76)
!85 = !DILocation(line: 13, column: 9, scope: !76)
!86 = !DILocation(line: 13, column: 7, scope: !76)
!87 = !DILocation(line: 14, column: 2, scope: !76)
!88 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 17, type: !77, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!89 = !DILocalVariable(name: "arg", arg: 1, scope: !88, file: !28, line: 17, type: !24)
!90 = !DILocation(line: 0, scope: !88)
!91 = !DILocation(line: 18, column: 9, scope: !88)
!92 = !DILocation(line: 18, column: 7, scope: !88)
!93 = !DILocation(line: 19, column: 2, scope: !88)
!94 = !DILocation(line: 20, column: 9, scope: !88)
!95 = !DILocation(line: 20, column: 7, scope: !88)
!96 = !DILocation(line: 21, column: 2, scope: !88)
!97 = distinct !DISubprogram(name: "thread_3", scope: !28, file: !28, line: 24, type: !77, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!98 = !DILocalVariable(name: "arg", arg: 1, scope: !97, file: !28, line: 24, type: !24)
!99 = !DILocation(line: 0, scope: !97)
!100 = !DILocation(line: 25, column: 9, scope: !97)
!101 = !DILocation(line: 25, column: 7, scope: !97)
!102 = !DILocation(line: 26, column: 2, scope: !97)
!103 = !DILocation(line: 27, column: 9, scope: !97)
!104 = !DILocation(line: 27, column: 7, scope: !97)
!105 = !DILocation(line: 28, column: 2, scope: !97)
!106 = distinct !DISubprogram(name: "thread_4", scope: !28, file: !28, line: 31, type: !77, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!107 = !DILocalVariable(name: "arg", arg: 1, scope: !106, file: !28, line: 31, type: !24)
!108 = !DILocation(line: 0, scope: !106)
!109 = !DILocation(line: 32, column: 9, scope: !106)
!110 = !DILocation(line: 32, column: 7, scope: !106)
!111 = !DILocation(line: 33, column: 2, scope: !106)
!112 = !DILocation(line: 34, column: 9, scope: !106)
!113 = !DILocation(line: 34, column: 7, scope: !106)
!114 = !DILocation(line: 35, column: 2, scope: !106)
!115 = distinct !DISubprogram(name: "thread_5", scope: !28, file: !28, line: 38, type: !77, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!116 = !DILocalVariable(name: "arg", arg: 1, scope: !115, file: !28, line: 38, type: !24)
!117 = !DILocation(line: 0, scope: !115)
!118 = !DILocation(line: 39, column: 2, scope: !115)
!119 = !DILocation(line: 40, column: 9, scope: !115)
!120 = !DILocation(line: 40, column: 7, scope: !115)
!121 = !DILocation(line: 41, column: 9, scope: !115)
!122 = !DILocation(line: 41, column: 7, scope: !115)
!123 = !DILocation(line: 42, column: 2, scope: !115)
!124 = !DILocation(line: 43, column: 2, scope: !115)
!125 = distinct !DISubprogram(name: "thread_6", scope: !28, file: !28, line: 46, type: !77, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!126 = !DILocalVariable(name: "arg", arg: 1, scope: !125, file: !28, line: 46, type: !24)
!127 = !DILocation(line: 0, scope: !125)
!128 = !DILocation(line: 47, column: 2, scope: !125)
!129 = !DILocation(line: 48, column: 9, scope: !125)
!130 = !DILocation(line: 48, column: 7, scope: !125)
!131 = !DILocation(line: 49, column: 9, scope: !125)
!132 = !DILocation(line: 49, column: 7, scope: !125)
!133 = !DILocation(line: 50, column: 2, scope: !125)
!134 = !DILocation(line: 51, column: 2, scope: !125)
!135 = distinct !DISubprogram(name: "thread_7", scope: !28, file: !28, line: 54, type: !77, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!136 = !DILocalVariable(name: "arg", arg: 1, scope: !135, file: !28, line: 54, type: !24)
!137 = !DILocation(line: 0, scope: !135)
!138 = !DILocation(line: 55, column: 2, scope: !135)
!139 = !DILocation(line: 56, column: 9, scope: !135)
!140 = !DILocation(line: 56, column: 7, scope: !135)
!141 = !DILocation(line: 57, column: 9, scope: !135)
!142 = !DILocation(line: 57, column: 7, scope: !135)
!143 = !DILocation(line: 58, column: 2, scope: !135)
!144 = !DILocation(line: 59, column: 2, scope: !135)
!145 = distinct !DISubprogram(name: "thread_8", scope: !28, file: !28, line: 62, type: !77, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!146 = !DILocalVariable(name: "arg", arg: 1, scope: !145, file: !28, line: 62, type: !24)
!147 = !DILocation(line: 0, scope: !145)
!148 = !DILocation(line: 63, column: 2, scope: !145)
!149 = !DILocation(line: 64, column: 2, scope: !145)
!150 = !DILocation(line: 65, column: 2, scope: !145)
!151 = !DILocation(line: 66, column: 2, scope: !145)
!152 = !DILocation(line: 67, column: 2, scope: !145)
!153 = !DILocation(line: 68, column: 2, scope: !145)
!154 = !DILocation(line: 69, column: 2, scope: !145)
!155 = !DILocation(line: 70, column: 2, scope: !145)
!156 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 73, type: !157, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!157 = !DISubroutineType(types: !158)
!158 = !{!29}
!159 = !DILocalVariable(name: "t1", scope: !156, file: !28, line: 78, type: !160)
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !161, line: 27, baseType: !162)
!161 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!162 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!163 = !DILocation(line: 0, scope: !156)
!164 = !DILocation(line: 80, column: 2, scope: !156)
!165 = !DILocalVariable(name: "t2", scope: !156, file: !28, line: 78, type: !160)
!166 = !DILocation(line: 81, column: 2, scope: !156)
!167 = !DILocalVariable(name: "t3", scope: !156, file: !28, line: 78, type: !160)
!168 = !DILocation(line: 82, column: 2, scope: !156)
!169 = !DILocalVariable(name: "t4", scope: !156, file: !28, line: 78, type: !160)
!170 = !DILocation(line: 83, column: 2, scope: !156)
!171 = !DILocalVariable(name: "t5", scope: !156, file: !28, line: 78, type: !160)
!172 = !DILocation(line: 84, column: 2, scope: !156)
!173 = !DILocalVariable(name: "t6", scope: !156, file: !28, line: 78, type: !160)
!174 = !DILocation(line: 85, column: 2, scope: !156)
!175 = !DILocalVariable(name: "t7", scope: !156, file: !28, line: 78, type: !160)
!176 = !DILocation(line: 86, column: 2, scope: !156)
!177 = !DILocalVariable(name: "t8", scope: !156, file: !28, line: 78, type: !160)
!178 = !DILocation(line: 87, column: 2, scope: !156)
!179 = !DILocation(line: 89, column: 15, scope: !156)
!180 = !DILocation(line: 89, column: 2, scope: !156)
!181 = !DILocation(line: 90, column: 15, scope: !156)
!182 = !DILocation(line: 90, column: 2, scope: !156)
!183 = !DILocation(line: 91, column: 15, scope: !156)
!184 = !DILocation(line: 91, column: 2, scope: !156)
!185 = !DILocation(line: 92, column: 15, scope: !156)
!186 = !DILocation(line: 92, column: 2, scope: !156)
!187 = !DILocation(line: 93, column: 15, scope: !156)
!188 = !DILocation(line: 93, column: 2, scope: !156)
!189 = !DILocation(line: 94, column: 15, scope: !156)
!190 = !DILocation(line: 94, column: 2, scope: !156)
!191 = !DILocation(line: 95, column: 15, scope: !156)
!192 = !DILocation(line: 95, column: 2, scope: !156)
!193 = !DILocation(line: 96, column: 15, scope: !156)
!194 = !DILocation(line: 96, column: 2, scope: !156)
!195 = !DILocation(line: 98, column: 2, scope: !196)
!196 = distinct !DILexicalBlock(scope: !197, file: !28, line: 98, column: 2)
!197 = distinct !DILexicalBlock(scope: !156, file: !28, line: 98, column: 2)
!198 = !DILocation(line: 100, column: 2, scope: !156)
