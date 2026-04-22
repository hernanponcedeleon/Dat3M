; ModuleID = 'benchmarks/ck/clhlock.c'
source_filename = "benchmarks/ck/clhlock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_clh = type { i32, ptr }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !29
@nodes = dso_local global ptr null, align 8, !dbg !50
@lock = dso_local global ptr null, align 8, !dbg !48
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !31
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/clhlock.c\00", align 1, !dbg !37
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !42

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
    #dbg_declare(ptr %3, !66, !DIExpression(), !67)
  %5 = load ptr, ptr %2, align 8, !dbg !68
  %6 = ptrtoint ptr %5 to i64, !dbg !69
  store i64 %6, ptr %3, align 8, !dbg !67
    #dbg_declare(ptr %4, !70, !DIExpression(), !71)
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

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_clh_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !80 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !84, !DIExpression(), !85)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !86, !DIExpression(), !87)
    #dbg_declare(ptr %5, !88, !DIExpression(), !89)
  %6 = load ptr, ptr %4, align 8, !dbg !90
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %6, i32 0, i32 0, !dbg !91
  store i32 1, ptr %7, align 8, !dbg !92
  call void @ck_pr_fence_store_atomic(), !dbg !93
  %8 = load ptr, ptr %3, align 8, !dbg !94
  %9 = load ptr, ptr %4, align 8, !dbg !95
  %10 = call ptr @ck_pr_fas_ptr(ptr noundef %8, ptr noundef %9), !dbg !96
  store ptr %10, ptr %5, align 8, !dbg !97
  %11 = load ptr, ptr %5, align 8, !dbg !98
  %12 = load ptr, ptr %4, align 8, !dbg !99
  %13 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %12, i32 0, i32 1, !dbg !100
  store ptr %11, ptr %13, align 8, !dbg !101
  call void @ck_pr_fence_load(), !dbg !102
  br label %14, !dbg !103

14:                                               ; preds = %19, %2
  %15 = load ptr, ptr %5, align 8, !dbg !104
  %16 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %15, i32 0, i32 0, !dbg !105
  %17 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %16), !dbg !106
  %18 = icmp eq i32 %17, 1, !dbg !107
  br i1 %18, label %19, label %20, !dbg !103

19:                                               ; preds = %14
  call void @ck_pr_stall(), !dbg !108
  br label %14, !dbg !103, !llvm.loop !109

20:                                               ; preds = %14
  call void @ck_pr_fence_lock(), !dbg !112
  ret void, !dbg !113
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_clh_unlock(ptr noundef %0) #0 !dbg !114 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !117, !DIExpression(), !118)
    #dbg_declare(ptr %3, !119, !DIExpression(), !120)
  %4 = load ptr, ptr %2, align 8, !dbg !121
  %5 = getelementptr inbounds ptr, ptr %4, i64 0, !dbg !121
  %6 = load ptr, ptr %5, align 8, !dbg !121
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %6, i32 0, i32 1, !dbg !122
  %8 = load ptr, ptr %7, align 8, !dbg !122
  store ptr %8, ptr %3, align 8, !dbg !123
  call void @ck_pr_fence_unlock(), !dbg !124
  %9 = load ptr, ptr %2, align 8, !dbg !125
  %10 = load ptr, ptr %9, align 8, !dbg !126
  %11 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %10, i32 0, i32 0, !dbg !127
  call void @ck_pr_md_store_uint(ptr noundef %11, i32 noundef zeroext 0), !dbg !128
  %12 = load ptr, ptr %3, align 8, !dbg !129
  %13 = load ptr, ptr %2, align 8, !dbg !130
  store ptr %12, ptr %13, align 8, !dbg !131
  ret void, !dbg !132
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !133 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct.ck_spinlock_clh, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !136, !DIExpression(), !142)
    #dbg_declare(ptr %3, !143, !DIExpression(), !144)
    #dbg_declare(ptr %4, !145, !DIExpression(), !146)
  call void @ck_spinlock_clh_init(ptr noundef @lock, ptr noundef %4), !dbg !147
  %6 = call ptr @malloc(i64 noundef 48) #4, !dbg !148
  store ptr %6, ptr @nodes, align 8, !dbg !149
  store i32 0, ptr %3, align 4, !dbg !150
  br label %7, !dbg !152

7:                                                ; preds = %15, %0
  %8 = load i32, ptr %3, align 4, !dbg !153
  %9 = icmp slt i32 %8, 3, !dbg !155
  br i1 %9, label %10, label %18, !dbg !156

10:                                               ; preds = %7
    #dbg_declare(ptr %5, !157, !DIExpression(), !159)
  %11 = load ptr, ptr @nodes, align 8, !dbg !160
  %12 = load i32, ptr %3, align 4, !dbg !161
  %13 = sext i32 %12 to i64, !dbg !160
  %14 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %11, i64 %13, !dbg !160
  call void @ck_spinlock_clh_init(ptr noundef %5, ptr noundef %14), !dbg !162
  br label %15, !dbg !163

15:                                               ; preds = %10
  %16 = load i32, ptr %3, align 4, !dbg !164
  %17 = add nsw i32 %16, 1, !dbg !164
  store i32 %17, ptr %3, align 4, !dbg !164
  br label %7, !dbg !165, !llvm.loop !166

18:                                               ; preds = %7
  store i32 0, ptr %3, align 4, !dbg !168
  br label %19, !dbg !170

19:                                               ; preds = %33, %18
  %20 = load i32, ptr %3, align 4, !dbg !171
  %21 = icmp slt i32 %20, 3, !dbg !173
  br i1 %21, label %22, label %36, !dbg !174

22:                                               ; preds = %19
  %23 = load i32, ptr %3, align 4, !dbg !175
  %24 = sext i32 %23 to i64, !dbg !178
  %25 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %24, !dbg !178
  %26 = load i32, ptr %3, align 4, !dbg !179
  %27 = sext i32 %26 to i64, !dbg !180
  %28 = inttoptr i64 %27 to ptr, !dbg !181
  %29 = call signext i32 @pthread_create(ptr noundef %25, ptr noundef null, ptr noundef @run, ptr noundef %28), !dbg !182
  %30 = icmp ne i32 %29, 0, !dbg !183
  br i1 %30, label %31, label %32, !dbg !183

31:                                               ; preds = %22
  call void @exit(i32 noundef signext 1) #5, !dbg !184
  unreachable, !dbg !184

32:                                               ; preds = %22
  br label %33, !dbg !186

33:                                               ; preds = %32
  %34 = load i32, ptr %3, align 4, !dbg !187
  %35 = add nsw i32 %34, 1, !dbg !187
  store i32 %35, ptr %3, align 4, !dbg !187
  br label %19, !dbg !188, !llvm.loop !189

36:                                               ; preds = %19
  store i32 0, ptr %3, align 4, !dbg !191
  br label %37, !dbg !193

37:                                               ; preds = %49, %36
  %38 = load i32, ptr %3, align 4, !dbg !194
  %39 = icmp slt i32 %38, 3, !dbg !196
  br i1 %39, label %40, label %52, !dbg !197

40:                                               ; preds = %37
  %41 = load i32, ptr %3, align 4, !dbg !198
  %42 = sext i32 %41 to i64, !dbg !201
  %43 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %42, !dbg !201
  %44 = load ptr, ptr %43, align 8, !dbg !201
  %45 = call signext i32 @pthread_join(ptr noundef %44, ptr noundef null), !dbg !202
  %46 = icmp ne i32 %45, 0, !dbg !203
  br i1 %46, label %47, label %48, !dbg !203

47:                                               ; preds = %40
  call void @exit(i32 noundef signext 1) #5, !dbg !204
  unreachable, !dbg !204

48:                                               ; preds = %40
  br label %49, !dbg !206

49:                                               ; preds = %48
  %50 = load i32, ptr %3, align 4, !dbg !207
  %51 = add nsw i32 %50, 1, !dbg !207
  store i32 %51, ptr %3, align 4, !dbg !207
  br label %37, !dbg !208, !llvm.loop !209

52:                                               ; preds = %37
  %53 = load i32, ptr @x, align 4, !dbg !211
  %54 = icmp eq i32 %53, 3, !dbg !214
  br i1 %54, label %55, label %58, !dbg !215

55:                                               ; preds = %52
  %56 = load i32, ptr @y, align 4, !dbg !216
  %57 = icmp eq i32 %56, 3, !dbg !217
  br i1 %57, label %59, label %58, !dbg !218

58:                                               ; preds = %55, %52
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 61, ptr noundef @__func__.main), !dbg !218
  br label %59, !dbg !218

59:                                               ; preds = %58, %55
  %60 = load ptr, ptr @nodes, align 8, !dbg !219
  call void @free(ptr noundef %60), !dbg !220
  ret i32 0, !dbg !221
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_clh_init(ptr noundef %0, ptr noundef %1) #0 !dbg !222 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !223, !DIExpression(), !224)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !225, !DIExpression(), !226)
  %5 = load ptr, ptr %4, align 8, !dbg !227
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %5, i32 0, i32 1, !dbg !228
  store ptr null, ptr %6, align 8, !dbg !229
  %7 = load ptr, ptr %4, align 8, !dbg !230
  %8 = getelementptr inbounds nuw %struct.ck_spinlock_clh, ptr %7, i32 0, i32 0, !dbg !231
  store i32 0, ptr %8, align 8, !dbg !232
  %9 = load ptr, ptr %4, align 8, !dbg !233
  %10 = load ptr, ptr %3, align 8, !dbg !234
  store ptr %9, ptr %10, align 8, !dbg !235
  call void @ck_pr_barrier(), !dbg !236
  ret void, !dbg !237
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #2

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #2

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_store_atomic() #0 !dbg !238 {
  call void @ck_pr_fence_strict_store_atomic(), !dbg !242
  ret void, !dbg !242
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !243 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !247, !DIExpression(), !248)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !249, !DIExpression(), !248)
    #dbg_declare(ptr %5, !250, !DIExpression(), !248)
  %6 = load ptr, ptr %3, align 8, !dbg !248
  %7 = load ptr, ptr %4, align 8, !dbg !248
  %8 = call ptr asm sideeffect "1:ldarx $0, 0, $1;stdcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, ptr %7) #6, !dbg !248, !srcloc !251
  store ptr %8, ptr %5, align 8, !dbg !248
  %9 = load ptr, ptr %5, align 8, !dbg !248
  ret ptr %9, !dbg !248
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_load() #0 !dbg !252 {
  call void @ck_pr_fence_strict_load(), !dbg !253
  ret void, !dbg !253
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !254 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !257, !DIExpression(), !258)
    #dbg_declare(ptr %3, !259, !DIExpression(), !258)
  %4 = load ptr, ptr %2, align 8, !dbg !258
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !258, !srcloc !260
  store i32 %5, ptr %3, align 4, !dbg !258
  %6 = load i32, ptr %3, align 4, !dbg !258
  ret i32 %6, !dbg !258
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !261 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !262, !srcloc !263
  ret void, !dbg !264
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !265 {
  call void @ck_pr_fence_strict_lock(), !dbg !266
  ret void, !dbg !266
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_store_atomic() #0 !dbg !267 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !268, !srcloc !269
  ret void, !dbg !268
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_load() #0 !dbg !270 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !271, !srcloc !272
  ret void, !dbg !271
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !273 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !274, !srcloc !275
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !276 {
  call void @ck_pr_fence_strict_unlock(), !dbg !277
  ret void, !dbg !277
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !278 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !281, !DIExpression(), !282)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !283, !DIExpression(), !282)
  %5 = load ptr, ptr %3, align 8, !dbg !282
  %6 = load i32, ptr %4, align 4, !dbg !282
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !282, !srcloc !284
  ret void, !dbg !282
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !285 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !286, !srcloc !287
  ret void, !dbg !286
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !288 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !290, !srcloc !291
  ret void, !dbg !292
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/clhlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "0af09b1974609271dca9b2d2cb44f584")
!4 = !{!5, !8, !9, !18, !21, !22, !25, !27}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 23, baseType: !7)
!6 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!7 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_clh_t", file: !11, line: 43, baseType: !12)
!11 = !DIFile(filename: "../ck/include/spinlock/clh.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "322aa46b9b9d14e37fa2ad3ef8618ff8")
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_clh", file: !11, line: 39, size: 128, elements: !13)
!13 = !{!14, !16}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "wait", scope: !12, file: !11, line: 40, baseType: !15, size: 32)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "previous", scope: !12, file: !11, line: 41, baseType: !17, size: 64, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 5, baseType: !20)
!19 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!20 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !23, line: 4, baseType: !24)
!23 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!24 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!28 = !{!0, !29, !31, !37, !42, !48, !50}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !21, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 248, elements: !35)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!35 = !{!36}
!36 = !DISubrange(count: 31)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 192, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 24)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 61, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 40, elements: !46)
!45 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!46 = !{!47}
!47 = !DISubrange(count: 5)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !9, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 12, type: !9, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 2}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Homebrew clang version 22.1.8"}
!60 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !61, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!8, !8}
!63 = !{}
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !60, file: !3, line: 14, type: !8)
!65 = !DILocation(line: 14, column: 17, scope: !60)
!66 = !DILocalVariable(name: "tid", scope: !60, file: !3, line: 16, type: !5)
!67 = !DILocation(line: 16, column: 14, scope: !60)
!68 = !DILocation(line: 16, column: 32, scope: !60)
!69 = !DILocation(line: 16, column: 21, scope: !60)
!70 = !DILocalVariable(name: "thread_node", scope: !60, file: !3, line: 18, type: !9)
!71 = !DILocation(line: 18, column: 24, scope: !60)
!72 = !DILocation(line: 18, column: 39, scope: !60)
!73 = !DILocation(line: 18, column: 45, scope: !60)
!74 = !DILocation(line: 20, column: 33, scope: !60)
!75 = !DILocation(line: 20, column: 5, scope: !60)
!76 = !DILocation(line: 22, column: 6, scope: !60)
!77 = !DILocation(line: 23, column: 6, scope: !60)
!78 = !DILocation(line: 25, column: 5, scope: !60)
!79 = !DILocation(line: 27, column: 5, scope: !60)
!80 = distinct !DISubprogram(name: "ck_spinlock_clh_lock", scope: !11, file: !11, line: 69, type: !81, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !83, !17}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!84 = !DILocalVariable(name: "queue", arg: 1, scope: !80, file: !11, line: 69, type: !83)
!85 = !DILocation(line: 69, column: 47, scope: !80)
!86 = !DILocalVariable(name: "thread", arg: 2, scope: !80, file: !11, line: 69, type: !17)
!87 = !DILocation(line: 69, column: 78, scope: !80)
!88 = !DILocalVariable(name: "previous", scope: !80, file: !11, line: 71, type: !17)
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
!104 = !DILocation(line: 86, column: 26, scope: !80)
!105 = !DILocation(line: 86, column: 36, scope: !80)
!106 = !DILocation(line: 86, column: 9, scope: !80)
!107 = !DILocation(line: 86, column: 42, scope: !80)
!108 = !DILocation(line: 87, column: 3, scope: !80)
!109 = distinct !{!109, !103, !110, !111}
!110 = !DILocation(line: 87, column: 15, scope: !80)
!111 = !{!"llvm.loop.mustprogress"}
!112 = !DILocation(line: 89, column: 2, scope: !80)
!113 = !DILocation(line: 90, column: 2, scope: !80)
!114 = distinct !DISubprogram(name: "ck_spinlock_clh_unlock", scope: !11, file: !11, line: 94, type: !115, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !83}
!117 = !DILocalVariable(name: "thread", arg: 1, scope: !114, file: !11, line: 94, type: !83)
!118 = !DILocation(line: 94, column: 49, scope: !114)
!119 = !DILocalVariable(name: "previous", scope: !114, file: !11, line: 96, type: !17)
!120 = !DILocation(line: 96, column: 26, scope: !114)
!121 = !DILocation(line: 105, column: 13, scope: !114)
!122 = !DILocation(line: 105, column: 24, scope: !114)
!123 = !DILocation(line: 105, column: 11, scope: !114)
!124 = !DILocation(line: 110, column: 2, scope: !114)
!125 = !DILocation(line: 111, column: 22, scope: !114)
!126 = !DILocation(line: 111, column: 21, scope: !114)
!127 = !DILocation(line: 111, column: 31, scope: !114)
!128 = !DILocation(line: 111, column: 2, scope: !114)
!129 = !DILocation(line: 118, column: 12, scope: !114)
!130 = !DILocation(line: 118, column: 3, scope: !114)
!131 = !DILocation(line: 118, column: 10, scope: !114)
!132 = !DILocation(line: 119, column: 2, scope: !114)
!133 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 30, type: !134, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!134 = !DISubroutineType(types: !135)
!135 = !{!21}
!136 = !DILocalVariable(name: "threads", scope: !133, file: !3, line: 32, type: !137)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !138, size: 192, elements: !140)
!138 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !139, line: 2, baseType: !8)
!139 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!140 = !{!141}
!141 = !DISubrange(count: 3)
!142 = !DILocation(line: 32, column: 15, scope: !133)
!143 = !DILocalVariable(name: "i", scope: !133, file: !3, line: 33, type: !21)
!144 = !DILocation(line: 33, column: 9, scope: !133)
!145 = !DILocalVariable(name: "unowned", scope: !133, file: !3, line: 35, type: !10)
!146 = !DILocation(line: 35, column: 23, scope: !133)
!147 = !DILocation(line: 36, column: 5, scope: !133)
!148 = !DILocation(line: 38, column: 34, scope: !133)
!149 = !DILocation(line: 38, column: 11, scope: !133)
!150 = !DILocation(line: 39, column: 12, scope: !151)
!151 = distinct !DILexicalBlock(scope: !133, file: !3, line: 39, column: 5)
!152 = !DILocation(line: 39, column: 10, scope: !151)
!153 = !DILocation(line: 39, column: 17, scope: !154)
!154 = distinct !DILexicalBlock(scope: !151, file: !3, line: 39, column: 5)
!155 = !DILocation(line: 39, column: 19, scope: !154)
!156 = !DILocation(line: 39, column: 5, scope: !151)
!157 = !DILocalVariable(name: "ptr", scope: !158, file: !3, line: 41, type: !9)
!158 = distinct !DILexicalBlock(scope: !154, file: !3, line: 40, column: 5)
!159 = !DILocation(line: 41, column: 28, scope: !158)
!160 = !DILocation(line: 42, column: 37, scope: !158)
!161 = !DILocation(line: 42, column: 43, scope: !158)
!162 = !DILocation(line: 42, column: 9, scope: !158)
!163 = !DILocation(line: 43, column: 5, scope: !158)
!164 = !DILocation(line: 39, column: 32, scope: !154)
!165 = !DILocation(line: 39, column: 5, scope: !154)
!166 = distinct !{!166, !156, !167, !111}
!167 = !DILocation(line: 43, column: 5, scope: !151)
!168 = !DILocation(line: 45, column: 12, scope: !169)
!169 = distinct !DILexicalBlock(scope: !133, file: !3, line: 45, column: 5)
!170 = !DILocation(line: 45, column: 10, scope: !169)
!171 = !DILocation(line: 45, column: 17, scope: !172)
!172 = distinct !DILexicalBlock(scope: !169, file: !3, line: 45, column: 5)
!173 = !DILocation(line: 45, column: 19, scope: !172)
!174 = !DILocation(line: 45, column: 5, scope: !169)
!175 = !DILocation(line: 47, column: 37, scope: !176)
!176 = distinct !DILexicalBlock(scope: !177, file: !3, line: 47, column: 13)
!177 = distinct !DILexicalBlock(scope: !172, file: !3, line: 46, column: 5)
!178 = !DILocation(line: 47, column: 29, scope: !176)
!179 = !DILocation(line: 47, column: 69, scope: !176)
!180 = !DILocation(line: 47, column: 60, scope: !176)
!181 = !DILocation(line: 47, column: 52, scope: !176)
!182 = !DILocation(line: 47, column: 13, scope: !176)
!183 = !DILocation(line: 47, column: 72, scope: !176)
!184 = !DILocation(line: 49, column: 13, scope: !185)
!185 = distinct !DILexicalBlock(scope: !176, file: !3, line: 48, column: 9)
!186 = !DILocation(line: 51, column: 5, scope: !177)
!187 = !DILocation(line: 45, column: 32, scope: !172)
!188 = !DILocation(line: 45, column: 5, scope: !172)
!189 = distinct !{!189, !174, !190, !111}
!190 = !DILocation(line: 51, column: 5, scope: !169)
!191 = !DILocation(line: 53, column: 12, scope: !192)
!192 = distinct !DILexicalBlock(scope: !133, file: !3, line: 53, column: 5)
!193 = !DILocation(line: 53, column: 10, scope: !192)
!194 = !DILocation(line: 53, column: 17, scope: !195)
!195 = distinct !DILexicalBlock(scope: !192, file: !3, line: 53, column: 5)
!196 = !DILocation(line: 53, column: 19, scope: !195)
!197 = !DILocation(line: 53, column: 5, scope: !192)
!198 = !DILocation(line: 55, column: 34, scope: !199)
!199 = distinct !DILexicalBlock(scope: !200, file: !3, line: 55, column: 13)
!200 = distinct !DILexicalBlock(scope: !195, file: !3, line: 54, column: 5)
!201 = !DILocation(line: 55, column: 26, scope: !199)
!202 = !DILocation(line: 55, column: 13, scope: !199)
!203 = !DILocation(line: 55, column: 44, scope: !199)
!204 = !DILocation(line: 57, column: 13, scope: !205)
!205 = distinct !DILexicalBlock(scope: !199, file: !3, line: 56, column: 9)
!206 = !DILocation(line: 59, column: 5, scope: !200)
!207 = !DILocation(line: 53, column: 32, scope: !195)
!208 = !DILocation(line: 53, column: 5, scope: !195)
!209 = distinct !{!209, !197, !210, !111}
!210 = !DILocation(line: 59, column: 5, scope: !192)
!211 = !DILocation(line: 61, column: 12, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 61, column: 5)
!213 = distinct !DILexicalBlock(scope: !133, file: !3, line: 61, column: 5)
!214 = !DILocation(line: 61, column: 14, scope: !212)
!215 = !DILocation(line: 61, column: 26, scope: !212)
!216 = !DILocation(line: 61, column: 29, scope: !212)
!217 = !DILocation(line: 61, column: 31, scope: !212)
!218 = !DILocation(line: 61, column: 5, scope: !212)
!219 = !DILocation(line: 63, column: 10, scope: !133)
!220 = !DILocation(line: 63, column: 5, scope: !133)
!221 = !DILocation(line: 65, column: 5, scope: !133)
!222 = distinct !DISubprogram(name: "ck_spinlock_clh_init", scope: !11, file: !11, line: 46, type: !81, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!223 = !DILocalVariable(name: "lock", arg: 1, scope: !222, file: !11, line: 46, type: !83)
!224 = !DILocation(line: 46, column: 47, scope: !222)
!225 = !DILocalVariable(name: "unowned", arg: 2, scope: !222, file: !11, line: 46, type: !17)
!226 = !DILocation(line: 46, column: 77, scope: !222)
!227 = !DILocation(line: 49, column: 2, scope: !222)
!228 = !DILocation(line: 49, column: 11, scope: !222)
!229 = !DILocation(line: 49, column: 20, scope: !222)
!230 = !DILocation(line: 50, column: 2, scope: !222)
!231 = !DILocation(line: 50, column: 11, scope: !222)
!232 = !DILocation(line: 50, column: 16, scope: !222)
!233 = !DILocation(line: 51, column: 10, scope: !222)
!234 = !DILocation(line: 51, column: 3, scope: !222)
!235 = !DILocation(line: 51, column: 8, scope: !222)
!236 = !DILocation(line: 52, column: 2, scope: !222)
!237 = !DILocation(line: 53, column: 2, scope: !222)
!238 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !239, file: !239, line: 112, type: !240, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!239 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!240 = !DISubroutineType(types: !241)
!241 = !{null}
!242 = !DILocation(line: 112, column: 1, scope: !238)
!243 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !244, file: !244, line: 304, type: !245, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!244 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!245 = !DISubroutineType(types: !246)
!246 = !{!8, !8, !8}
!247 = !DILocalVariable(name: "target", arg: 1, scope: !243, file: !244, line: 304, type: !8)
!248 = !DILocation(line: 304, column: 1, scope: !243)
!249 = !DILocalVariable(name: "v", arg: 2, scope: !243, file: !244, line: 304, type: !8)
!250 = !DILocalVariable(name: "previous", scope: !243, file: !244, line: 304, type: !8)
!251 = !{i64 2147596979}
!252 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !239, file: !239, line: 116, type: !240, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!253 = !DILocation(line: 116, column: 1, scope: !252)
!254 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !244, file: !244, line: 111, type: !255, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!255 = !DISubroutineType(types: !256)
!256 = !{!15, !25}
!257 = !DILocalVariable(name: "target", arg: 1, scope: !254, file: !244, line: 111, type: !25)
!258 = !DILocation(line: 111, column: 1, scope: !254)
!259 = !DILocalVariable(name: "r", scope: !254, file: !244, line: 111, type: !15)
!260 = !{i64 2147586563}
!261 = distinct !DISubprogram(name: "ck_pr_stall", scope: !244, file: !244, line: 54, type: !240, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!262 = !DILocation(line: 57, column: 2, scope: !261)
!263 = !{i64 85559}
!264 = !DILocation(line: 59, column: 2, scope: !261)
!265 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !239, file: !239, line: 122, type: !240, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!266 = !DILocation(line: 122, column: 1, scope: !265)
!267 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !244, file: !244, line: 76, type: !240, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!268 = !DILocation(line: 76, column: 1, scope: !267)
!269 = !{i64 2147581978}
!270 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !244, file: !244, line: 80, type: !240, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!271 = !DILocation(line: 80, column: 1, scope: !270)
!272 = !{i64 2147582792}
!273 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !244, file: !244, line: 86, type: !240, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!274 = !DILocation(line: 86, column: 1, scope: !273)
!275 = !{i64 2147583992}
!276 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !239, file: !239, line: 123, type: !240, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!277 = !DILocation(line: 123, column: 1, scope: !276)
!278 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !244, file: !244, line: 141, type: !279, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!279 = !DISubroutineType(types: !280)
!280 = !{null, !27, !15}
!281 = !DILocalVariable(name: "target", arg: 1, scope: !278, file: !244, line: 141, type: !27)
!282 = !DILocation(line: 141, column: 1, scope: !278)
!283 = !DILocalVariable(name: "v", arg: 2, scope: !278, file: !244, line: 141, type: !15)
!284 = !{i64 2147590270}
!285 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !244, file: !244, line: 87, type: !240, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!286 = !DILocation(line: 87, column: 1, scope: !285)
!287 = !{i64 2147584189}
!288 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !289, file: !289, line: 37, type: !240, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!289 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!290 = !DILocation(line: 40, column: 2, scope: !288)
!291 = !{i64 141260}
!292 = !DILocation(line: 41, column: 2, scope: !288)
