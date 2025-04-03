; ModuleID = 'tests/clhlock.c'
source_filename = "tests/clhlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_clh = type { i32, ptr }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !28
@nodes = global ptr null, align 8, !dbg !50
@lock = global ptr null, align 8, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [10 x i8] c"clhlock.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !43

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !68
  %6 = ptrtoint ptr %5 to i64, !dbg !69
  store i64 %6, ptr %3, align 8, !dbg !67
  %7 = load ptr, ptr @nodes, align 8, !dbg !72
  %8 = load i64, ptr %3, align 8, !dbg !73
  %9 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %7, i64 %8, !dbg !72
  store ptr %9, ptr %4, align 8, !dbg !71
  %10 = load ptr, ptr %4, align 8, !dbg !74
  call void @ck_spinlock_clh_lock(ptr noundef @lock, ptr noundef %10), !dbg !75
  %11 = load i32, ptr @x, align 4, !dbg !76
  %12 = add nsw i32 %11, 1, !dbg !76
  store i32 %12, ptr @x, align 4, !dbg !76
  %13 = load i32, ptr @y, align 4, !dbg !77
  %14 = add nsw i32 %13, 1, !dbg !77
  store i32 %14, ptr @y, align 4, !dbg !77
  call void @ck_spinlock_clh_unlock(ptr noundef %4), !dbg !78
  ret ptr null, !dbg !79
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !80 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8, !dbg !90
  %7 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %6, i32 0, i32 0, !dbg !91
  store i32 1, ptr %7, align 8, !dbg !92
  call void @ck_pr_fence_store_atomic(), !dbg !93
  %8 = load ptr, ptr %3, align 8, !dbg !94
  %9 = load ptr, ptr %4, align 8, !dbg !95
  %10 = call ptr @ck_pr_fas_ptr(ptr noundef %8, ptr noundef %9), !dbg !96
  store ptr %10, ptr %5, align 8, !dbg !97
  %11 = load ptr, ptr %5, align 8, !dbg !98
  %12 = load ptr, ptr %4, align 8, !dbg !99
  %13 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %12, i32 0, i32 1, !dbg !100
  store ptr %11, ptr %13, align 8, !dbg !101
  call void @ck_pr_fence_load(), !dbg !102
  br label %14, !dbg !103

14:                                               ; preds = %19, %2
  %15 = load ptr, ptr %5, align 8, !dbg !104
  %16 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %15, i32 0, i32 0, !dbg !104
  %17 = call i32 @ck_pr_md_load_uint(ptr noundef %16), !dbg !104
  %18 = icmp eq i32 %17, 1, !dbg !105
  br i1 %18, label %19, label %20, !dbg !103

19:                                               ; preds = %14
  call void @ck_pr_stall(), !dbg !106
  br label %14, !dbg !103, !llvm.loop !107

20:                                               ; preds = %14
  call void @ck_pr_fence_lock(), !dbg !110
  ret void, !dbg !111
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_unlock(ptr noundef %0) #0 !dbg !112 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !119
  %5 = getelementptr inbounds ptr, ptr %4, i64 0, !dbg !119
  %6 = load ptr, ptr %5, align 8, !dbg !119
  %7 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %6, i32 0, i32 1, !dbg !120
  %8 = load ptr, ptr %7, align 8, !dbg !120
  store ptr %8, ptr %3, align 8, !dbg !121
  call void @ck_pr_fence_unlock(), !dbg !122
  %9 = load ptr, ptr %2, align 8, !dbg !123
  %10 = load ptr, ptr %9, align 8, !dbg !123
  %11 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %10, i32 0, i32 0, !dbg !123
  call void @ck_pr_md_store_uint(ptr noundef %11, i32 noundef 0), !dbg !123
  %12 = load ptr, ptr %3, align 8, !dbg !124
  %13 = load ptr, ptr %2, align 8, !dbg !125
  store ptr %12, ptr %13, align 8, !dbg !126
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !128 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  %5 = alloca %struct.ck_spinlock_clh, align 8
  %6 = alloca %struct.ck_spinlock_clh, align 8
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_clh_init(ptr noundef @lock, ptr noundef %5), !dbg !165
  %7 = call ptr @malloc(i64 noundef 48) #5, !dbg !166
  store ptr %7, ptr @nodes, align 8, !dbg !167
  store i32 0, ptr %4, align 4, !dbg !168
  br label %8, !dbg !170

8:                                                ; preds = %16, %0
  %9 = load i32, ptr %4, align 4, !dbg !171
  %10 = icmp slt i32 %9, 3, !dbg !173
  br i1 %10, label %11, label %19, !dbg !174

11:                                               ; preds = %8
  %12 = load ptr, ptr @nodes, align 8, !dbg !178
  %13 = load i32, ptr %4, align 4, !dbg !179
  %14 = sext i32 %13 to i64, !dbg !178
  %15 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %12, i64 %14, !dbg !178
  call void @ck_spinlock_clh_init(ptr noundef %15, ptr noundef %6), !dbg !180
  br label %16, !dbg !181

16:                                               ; preds = %11
  %17 = load i32, ptr %4, align 4, !dbg !182
  %18 = add nsw i32 %17, 1, !dbg !182
  store i32 %18, ptr %4, align 4, !dbg !182
  br label %8, !dbg !183, !llvm.loop !184

19:                                               ; preds = %8
  store i32 0, ptr %4, align 4, !dbg !186
  br label %20, !dbg !188

20:                                               ; preds = %34, %19
  %21 = load i32, ptr %4, align 4, !dbg !189
  %22 = icmp slt i32 %21, 3, !dbg !191
  br i1 %22, label %23, label %37, !dbg !192

23:                                               ; preds = %20
  %24 = load i32, ptr %4, align 4, !dbg !193
  %25 = sext i32 %24 to i64, !dbg !196
  %26 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %25, !dbg !196
  %27 = load i32, ptr %4, align 4, !dbg !197
  %28 = sext i32 %27 to i64, !dbg !198
  %29 = inttoptr i64 %28 to ptr, !dbg !199
  %30 = call i32 @pthread_create(ptr noundef %26, ptr noundef null, ptr noundef @run, ptr noundef %29), !dbg !200
  %31 = icmp ne i32 %30, 0, !dbg !201
  br i1 %31, label %32, label %33, !dbg !202

32:                                               ; preds = %23
  call void @exit(i32 noundef 1) #6, !dbg !203
  unreachable, !dbg !203

33:                                               ; preds = %23
  br label %34, !dbg !205

34:                                               ; preds = %33
  %35 = load i32, ptr %4, align 4, !dbg !206
  %36 = add nsw i32 %35, 1, !dbg !206
  store i32 %36, ptr %4, align 4, !dbg !206
  br label %20, !dbg !207, !llvm.loop !208

37:                                               ; preds = %20
  store i32 0, ptr %4, align 4, !dbg !210
  br label %38, !dbg !212

38:                                               ; preds = %50, %37
  %39 = load i32, ptr %4, align 4, !dbg !213
  %40 = icmp slt i32 %39, 3, !dbg !215
  br i1 %40, label %41, label %53, !dbg !216

41:                                               ; preds = %38
  %42 = load i32, ptr %4, align 4, !dbg !217
  %43 = sext i32 %42 to i64, !dbg !220
  %44 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %43, !dbg !220
  %45 = load ptr, ptr %44, align 8, !dbg !220
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null), !dbg !221
  %47 = icmp ne i32 %46, 0, !dbg !222
  br i1 %47, label %48, label %49, !dbg !223

48:                                               ; preds = %41
  call void @exit(i32 noundef 1) #6, !dbg !224
  unreachable, !dbg !224

49:                                               ; preds = %41
  br label %50, !dbg !226

50:                                               ; preds = %49
  %51 = load i32, ptr %4, align 4, !dbg !227
  %52 = add nsw i32 %51, 1, !dbg !227
  store i32 %52, ptr %4, align 4, !dbg !227
  br label %38, !dbg !228, !llvm.loop !229

53:                                               ; preds = %38
  %54 = load i32, ptr @x, align 4, !dbg !231
  %55 = icmp eq i32 %54, 3, !dbg !231
  br i1 %55, label %56, label %59, !dbg !231

56:                                               ; preds = %53
  %57 = load i32, ptr @y, align 4, !dbg !231
  %58 = icmp eq i32 %57, 3, !dbg !231
  br label %59

59:                                               ; preds = %56, %53
  %60 = phi i1 [ false, %53 ], [ %58, %56 ], !dbg !232
  %61 = xor i1 %60, true, !dbg !231
  %62 = zext i1 %61 to i32, !dbg !231
  %63 = sext i32 %62 to i64, !dbg !231
  %64 = icmp ne i64 %63, 0, !dbg !231
  br i1 %64, label %65, label %67, !dbg !231

65:                                               ; preds = %59
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #7, !dbg !231
  unreachable, !dbg !231

66:                                               ; No predecessors!
  br label %68, !dbg !231

67:                                               ; preds = %59
  br label %68, !dbg !231

68:                                               ; preds = %67, %66
  %69 = load ptr, ptr @nodes, align 8, !dbg !233
  call void @free(ptr noundef %69), !dbg !234
  ret i32 0, !dbg !235
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_init(ptr noundef %0, ptr noundef %1) #0 !dbg !236 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8, !dbg !241
  %6 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %5, i32 0, i32 1, !dbg !242
  store ptr null, ptr %6, align 8, !dbg !243
  %7 = load ptr, ptr %4, align 8, !dbg !244
  %8 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %7, i32 0, i32 0, !dbg !245
  store i32 0, ptr %8, align 8, !dbg !246
  %9 = load ptr, ptr %4, align 8, !dbg !247
  %10 = load ptr, ptr %3, align 8, !dbg !248
  store ptr %9, ptr %10, align 8, !dbg !249
  call void @ck_pr_barrier(), !dbg !250
  ret void, !dbg !251
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store_atomic() #0 !dbg !252 {
  call void @ck_pr_fence_strict_store_atomic(), !dbg !256
  ret void, !dbg !256
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !257 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !262
  %7 = load ptr, ptr %4, align 8, !dbg !262
  %8 = call ptr asm sideeffect "1:;ldarx $0, 0, $1;stdcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, ptr %7) #8, !dbg !262, !srcloc !265
  store ptr %8, ptr %5, align 8, !dbg !262
  %9 = load ptr, ptr %5, align 8, !dbg !262
  ret ptr %9, !dbg !262
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 !dbg !266 {
  call void @ck_pr_fence_strict_load(), !dbg !267
  ret void, !dbg !267
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !268 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !272
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #8, !dbg !272, !srcloc !274
  store i32 %5, ptr %3, align 4, !dbg !272
  %6 = load i32, ptr %3, align 4, !dbg !272
  ret i32 %6, !dbg !272
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !275 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #8, !dbg !276, !srcloc !277
  ret void, !dbg !278
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !279 {
  call void @ck_pr_fence_strict_lock(), !dbg !280
  ret void, !dbg !280
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store_atomic() #0 !dbg !281 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !282, !srcloc !283
  ret void, !dbg !282
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 !dbg !284 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !285, !srcloc !286
  ret void, !dbg !285
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !287 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !288, !srcloc !289
  ret void, !dbg !288
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !290 {
  call void @ck_pr_fence_strict_unlock(), !dbg !291
  ret void, !dbg !291
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !292 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !296
  %6 = load i32, ptr %4, align 4, !dbg !296
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #8, !dbg !296, !srcloc !298
  ret void, !dbg !296
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !299 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !300, !srcloc !301
  ret void, !dbg !300
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !302 {
  call void asm sideeffect "", "~{memory}"() #8, !dbg !304, !srcloc !305
  ret void, !dbg !306
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !30, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !27, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/clhlock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "5a15870b5dfc2dfc5b27464e1e257b19")
!4 = !{!5, !10, !11, !20, !24, !26}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 32, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !8, line: 40, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!9 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_clh_t", file: !13, line: 43, baseType: !14)
!13 = !DIFile(filename: "include/spinlock/clh.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "322aa46b9b9d14e37fa2ad3ef8618ff8")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_clh", file: !13, line: 39, size: 128, elements: !15)
!15 = !{!16, !18}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "wait", scope: !14, file: !13, line: 40, baseType: !17, size: 32)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "previous", scope: !14, file: !13, line: 41, baseType: !19, size: 64, offset: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 50, baseType: !22)
!21 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !8, line: 87, baseType: !23)
!23 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!27 = !{!0, !28, !31, !38, !43, !48, !50}
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 62, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 62, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 80, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 10)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 62, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 248, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 31)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !11, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 12, type: !11, isLocal: false, isDefinition: true)
!52 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 8, !"PIC Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 1}
!59 = !{!"Homebrew clang version 19.1.7"}
!60 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !61, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!10, !10}
!63 = !{}
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !60, file: !3, line: 14, type: !10)
!65 = !DILocation(line: 14, column: 17, scope: !60)
!66 = !DILocalVariable(name: "tid", scope: !60, file: !3, line: 16, type: !5)
!67 = !DILocation(line: 16, column: 14, scope: !60)
!68 = !DILocation(line: 16, column: 32, scope: !60)
!69 = !DILocation(line: 16, column: 21, scope: !60)
!70 = !DILocalVariable(name: "thread_node", scope: !60, file: !3, line: 18, type: !11)
!71 = !DILocation(line: 18, column: 24, scope: !60)
!72 = !DILocation(line: 18, column: 39, scope: !60)
!73 = !DILocation(line: 18, column: 45, scope: !60)
!74 = !DILocation(line: 20, column: 33, scope: !60)
!75 = !DILocation(line: 20, column: 5, scope: !60)
!76 = !DILocation(line: 22, column: 6, scope: !60)
!77 = !DILocation(line: 23, column: 6, scope: !60)
!78 = !DILocation(line: 25, column: 5, scope: !60)
!79 = !DILocation(line: 27, column: 5, scope: !60)
!80 = distinct !DISubprogram(name: "ck_spinlock_clh_lock", scope: !13, file: !13, line: 69, type: !81, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !83, !19}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!84 = !DILocalVariable(name: "queue", arg: 1, scope: !80, file: !13, line: 69, type: !83)
!85 = !DILocation(line: 69, column: 47, scope: !80)
!86 = !DILocalVariable(name: "thread", arg: 2, scope: !80, file: !13, line: 69, type: !19)
!87 = !DILocation(line: 69, column: 78, scope: !80)
!88 = !DILocalVariable(name: "previous", scope: !80, file: !13, line: 71, type: !19)
!89 = !DILocation(line: 71, column: 26, scope: !80)
!90 = !DILocation(line: 74, column: 2, scope: !80)
!91 = !DILocation(line: 74, column: 10, scope: !80)
!92 = !DILocation(line: 74, column: 15, scope: !80)
!93 = !DILocation(line: 75, column: 2, scope: !80)
!94 = !DILocation(line: 81, column: 27, scope: !80)
!95 = !DILocation(line: 81, column: 34, scope: !80)
!96 = !DILocation(line: 81, column: 13, scope: !80)
!97 = !DILocation(line: 81, column: 11, scope: !80)
!98 = !DILocation(line: 82, column: 21, scope: !80)
!99 = !DILocation(line: 82, column: 2, scope: !80)
!100 = !DILocation(line: 82, column: 10, scope: !80)
!101 = !DILocation(line: 82, column: 19, scope: !80)
!102 = !DILocation(line: 85, column: 2, scope: !80)
!103 = !DILocation(line: 86, column: 2, scope: !80)
!104 = !DILocation(line: 86, column: 9, scope: !80)
!105 = !DILocation(line: 86, column: 42, scope: !80)
!106 = !DILocation(line: 87, column: 3, scope: !80)
!107 = distinct !{!107, !103, !108, !109}
!108 = !DILocation(line: 87, column: 15, scope: !80)
!109 = !{!"llvm.loop.mustprogress"}
!110 = !DILocation(line: 89, column: 2, scope: !80)
!111 = !DILocation(line: 90, column: 2, scope: !80)
!112 = distinct !DISubprogram(name: "ck_spinlock_clh_unlock", scope: !13, file: !13, line: 94, type: !113, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !83}
!115 = !DILocalVariable(name: "thread", arg: 1, scope: !112, file: !13, line: 94, type: !83)
!116 = !DILocation(line: 94, column: 49, scope: !112)
!117 = !DILocalVariable(name: "previous", scope: !112, file: !13, line: 96, type: !19)
!118 = !DILocation(line: 96, column: 26, scope: !112)
!119 = !DILocation(line: 105, column: 13, scope: !112)
!120 = !DILocation(line: 105, column: 24, scope: !112)
!121 = !DILocation(line: 105, column: 11, scope: !112)
!122 = !DILocation(line: 110, column: 2, scope: !112)
!123 = !DILocation(line: 111, column: 2, scope: !112)
!124 = !DILocation(line: 118, column: 12, scope: !112)
!125 = !DILocation(line: 118, column: 3, scope: !112)
!126 = !DILocation(line: 118, column: 10, scope: !112)
!127 = !DILocation(line: 119, column: 2, scope: !112)
!128 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !129, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!129 = !DISubroutineType(types: !130)
!130 = !{!30}
!131 = !DILocalVariable(name: "threads", scope: !128, file: !3, line: 32, type: !132)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !133, size: 192, elements: !155)
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !134, line: 31, baseType: !135)
!134 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !136, line: 118, baseType: !137)
!136 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !138, size: 64)
!138 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !136, line: 103, size: 65536, elements: !139)
!139 = !{!140, !141, !151}
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !138, file: !136, line: 104, baseType: !9, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !138, file: !136, line: 105, baseType: !142, size: 64, offset: 64)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !136, line: 57, size: 192, elements: !144)
!144 = !{!145, !149, !150}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !143, file: !136, line: 58, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!147 = !DISubroutineType(types: !148)
!148 = !{null, !10}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !143, file: !136, line: 59, baseType: !10, size: 64, offset: 64)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !143, file: !136, line: 60, baseType: !142, size: 64, offset: 128)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !138, file: !136, line: 106, baseType: !152, size: 65408, offset: 128)
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !153)
!153 = !{!154}
!154 = !DISubrange(count: 8176)
!155 = !{!156}
!156 = !DISubrange(count: 3)
!157 = !DILocation(line: 32, column: 15, scope: !128)
!158 = !DILocalVariable(name: "tids", scope: !128, file: !3, line: 33, type: !159)
!159 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 96, elements: !155)
!160 = !DILocation(line: 33, column: 9, scope: !128)
!161 = !DILocalVariable(name: "i", scope: !128, file: !3, line: 34, type: !30)
!162 = !DILocation(line: 34, column: 9, scope: !128)
!163 = !DILocalVariable(name: "unowned", scope: !128, file: !3, line: 36, type: !12)
!164 = !DILocation(line: 36, column: 23, scope: !128)
!165 = !DILocation(line: 37, column: 5, scope: !128)
!166 = !DILocation(line: 39, column: 34, scope: !128)
!167 = !DILocation(line: 39, column: 11, scope: !128)
!168 = !DILocation(line: 40, column: 12, scope: !169)
!169 = distinct !DILexicalBlock(scope: !128, file: !3, line: 40, column: 5)
!170 = !DILocation(line: 40, column: 10, scope: !169)
!171 = !DILocation(line: 40, column: 17, scope: !172)
!172 = distinct !DILexicalBlock(scope: !169, file: !3, line: 40, column: 5)
!173 = !DILocation(line: 40, column: 19, scope: !172)
!174 = !DILocation(line: 40, column: 5, scope: !169)
!175 = !DILocalVariable(name: "unowned_node", scope: !176, file: !3, line: 42, type: !12)
!176 = distinct !DILexicalBlock(scope: !172, file: !3, line: 41, column: 5)
!177 = !DILocation(line: 42, column: 27, scope: !176)
!178 = !DILocation(line: 43, column: 31, scope: !176)
!179 = !DILocation(line: 43, column: 37, scope: !176)
!180 = !DILocation(line: 43, column: 9, scope: !176)
!181 = !DILocation(line: 44, column: 5, scope: !176)
!182 = !DILocation(line: 40, column: 32, scope: !172)
!183 = !DILocation(line: 40, column: 5, scope: !172)
!184 = distinct !{!184, !174, !185, !109}
!185 = !DILocation(line: 44, column: 5, scope: !169)
!186 = !DILocation(line: 46, column: 12, scope: !187)
!187 = distinct !DILexicalBlock(scope: !128, file: !3, line: 46, column: 5)
!188 = !DILocation(line: 46, column: 10, scope: !187)
!189 = !DILocation(line: 46, column: 17, scope: !190)
!190 = distinct !DILexicalBlock(scope: !187, file: !3, line: 46, column: 5)
!191 = !DILocation(line: 46, column: 19, scope: !190)
!192 = !DILocation(line: 46, column: 5, scope: !187)
!193 = !DILocation(line: 48, column: 37, scope: !194)
!194 = distinct !DILexicalBlock(scope: !195, file: !3, line: 48, column: 13)
!195 = distinct !DILexicalBlock(scope: !190, file: !3, line: 47, column: 5)
!196 = !DILocation(line: 48, column: 29, scope: !194)
!197 = !DILocation(line: 48, column: 69, scope: !194)
!198 = !DILocation(line: 48, column: 60, scope: !194)
!199 = !DILocation(line: 48, column: 52, scope: !194)
!200 = !DILocation(line: 48, column: 13, scope: !194)
!201 = !DILocation(line: 48, column: 72, scope: !194)
!202 = !DILocation(line: 48, column: 13, scope: !195)
!203 = !DILocation(line: 50, column: 13, scope: !204)
!204 = distinct !DILexicalBlock(scope: !194, file: !3, line: 49, column: 9)
!205 = !DILocation(line: 52, column: 5, scope: !195)
!206 = !DILocation(line: 46, column: 32, scope: !190)
!207 = !DILocation(line: 46, column: 5, scope: !190)
!208 = distinct !{!208, !192, !209, !109}
!209 = !DILocation(line: 52, column: 5, scope: !187)
!210 = !DILocation(line: 54, column: 12, scope: !211)
!211 = distinct !DILexicalBlock(scope: !128, file: !3, line: 54, column: 5)
!212 = !DILocation(line: 54, column: 10, scope: !211)
!213 = !DILocation(line: 54, column: 17, scope: !214)
!214 = distinct !DILexicalBlock(scope: !211, file: !3, line: 54, column: 5)
!215 = !DILocation(line: 54, column: 19, scope: !214)
!216 = !DILocation(line: 54, column: 5, scope: !211)
!217 = !DILocation(line: 56, column: 34, scope: !218)
!218 = distinct !DILexicalBlock(scope: !219, file: !3, line: 56, column: 13)
!219 = distinct !DILexicalBlock(scope: !214, file: !3, line: 55, column: 5)
!220 = !DILocation(line: 56, column: 26, scope: !218)
!221 = !DILocation(line: 56, column: 13, scope: !218)
!222 = !DILocation(line: 56, column: 44, scope: !218)
!223 = !DILocation(line: 56, column: 13, scope: !219)
!224 = !DILocation(line: 58, column: 13, scope: !225)
!225 = distinct !DILexicalBlock(scope: !218, file: !3, line: 57, column: 9)
!226 = !DILocation(line: 60, column: 5, scope: !219)
!227 = !DILocation(line: 54, column: 32, scope: !214)
!228 = !DILocation(line: 54, column: 5, scope: !214)
!229 = distinct !{!229, !216, !230, !109}
!230 = !DILocation(line: 60, column: 5, scope: !211)
!231 = !DILocation(line: 62, column: 5, scope: !128)
!232 = !DILocation(line: 0, scope: !128)
!233 = !DILocation(line: 64, column: 10, scope: !128)
!234 = !DILocation(line: 64, column: 5, scope: !128)
!235 = !DILocation(line: 66, column: 5, scope: !128)
!236 = distinct !DISubprogram(name: "ck_spinlock_clh_init", scope: !13, file: !13, line: 46, type: !81, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!237 = !DILocalVariable(name: "lock", arg: 1, scope: !236, file: !13, line: 46, type: !83)
!238 = !DILocation(line: 46, column: 47, scope: !236)
!239 = !DILocalVariable(name: "unowned", arg: 2, scope: !236, file: !13, line: 46, type: !19)
!240 = !DILocation(line: 46, column: 77, scope: !236)
!241 = !DILocation(line: 49, column: 2, scope: !236)
!242 = !DILocation(line: 49, column: 11, scope: !236)
!243 = !DILocation(line: 49, column: 20, scope: !236)
!244 = !DILocation(line: 50, column: 2, scope: !236)
!245 = !DILocation(line: 50, column: 11, scope: !236)
!246 = !DILocation(line: 50, column: 16, scope: !236)
!247 = !DILocation(line: 51, column: 10, scope: !236)
!248 = !DILocation(line: 51, column: 3, scope: !236)
!249 = !DILocation(line: 51, column: 8, scope: !236)
!250 = !DILocation(line: 52, column: 2, scope: !236)
!251 = !DILocation(line: 53, column: 2, scope: !236)
!252 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !253, file: !253, line: 108, type: !254, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!253 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!254 = !DISubroutineType(types: !255)
!255 = !{null}
!256 = !DILocation(line: 108, column: 1, scope: !252)
!257 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !258, file: !258, line: 306, type: !259, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!258 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!259 = !DISubroutineType(types: !260)
!260 = !{!10, !10, !10}
!261 = !DILocalVariable(name: "target", arg: 1, scope: !257, file: !258, line: 306, type: !10)
!262 = !DILocation(line: 306, column: 1, scope: !257)
!263 = !DILocalVariable(name: "v", arg: 2, scope: !257, file: !258, line: 306, type: !10)
!264 = !DILocalVariable(name: "previous", scope: !257, file: !258, line: 306, type: !10)
!265 = !{i64 2147776132}
!266 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !253, file: !253, line: 112, type: !254, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!267 = !DILocation(line: 112, column: 1, scope: !266)
!268 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !258, file: !258, line: 113, type: !269, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!269 = !DISubroutineType(types: !270)
!270 = !{!17, !24}
!271 = !DILocalVariable(name: "target", arg: 1, scope: !268, file: !258, line: 113, type: !24)
!272 = !DILocation(line: 113, column: 1, scope: !268)
!273 = !DILocalVariable(name: "r", scope: !268, file: !258, line: 113, type: !17)
!274 = !{i64 2147765731}
!275 = distinct !DISubprogram(name: "ck_pr_stall", scope: !258, file: !258, line: 56, type: !254, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!276 = !DILocation(line: 59, column: 2, scope: !275)
!277 = !{i64 264764}
!278 = !DILocation(line: 61, column: 2, scope: !275)
!279 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !253, file: !253, line: 118, type: !254, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!280 = !DILocation(line: 118, column: 1, scope: !279)
!281 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !258, file: !258, line: 78, type: !254, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!282 = !DILocation(line: 78, column: 1, scope: !281)
!283 = !{i64 2147761182}
!284 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !258, file: !258, line: 82, type: !254, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!285 = !DILocation(line: 82, column: 1, scope: !284)
!286 = !{i64 2147761996}
!287 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !258, file: !258, line: 88, type: !254, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!288 = !DILocation(line: 88, column: 1, scope: !287)
!289 = !{i64 2147763196}
!290 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !253, file: !253, line: 119, type: !254, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!291 = !DILocation(line: 119, column: 1, scope: !290)
!292 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !258, file: !258, line: 143, type: !293, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!293 = !DISubroutineType(types: !294)
!294 = !{null, !26, !17}
!295 = !DILocalVariable(name: "target", arg: 1, scope: !292, file: !258, line: 143, type: !26)
!296 = !DILocation(line: 143, column: 1, scope: !292)
!297 = !DILocalVariable(name: "v", arg: 2, scope: !292, file: !258, line: 143, type: !17)
!298 = !{i64 2147769378}
!299 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !258, file: !258, line: 89, type: !254, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!300 = !DILocation(line: 89, column: 1, scope: !299)
!301 = !{i64 2147763393}
!302 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !303, file: !303, line: 37, type: !254, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!303 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!304 = !DILocation(line: 40, column: 2, scope: !302)
!305 = !{i64 320465}
!306 = !DILocation(line: 41, column: 2, scope: !302)
