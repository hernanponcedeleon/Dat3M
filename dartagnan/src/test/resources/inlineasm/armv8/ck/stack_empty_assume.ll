; ModuleID = 'tests/stack_empty.c'
source_filename = "tests/stack_empty.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_stack = type { ptr, ptr }
%struct.ck_stack_entry = type { ptr }

@stack = global %struct.ck_stack zeroinitializer, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !13
@.str = private unnamed_addr constant [14 x i8] c"stack_empty.c\00", align 1, !dbg !20
@.str.1 = private unnamed_addr constant [25 x i8] c"CK_STACK_ISEMPTY(&stack)\00", align 1, !dbg !25

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @pusher_fn(ptr noundef %0) #0 !dbg !44 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4, !dbg !53
  br label %5, !dbg !54

5:                                                ; preds = %15, %1
  %6 = load i32, ptr %3, align 4, !dbg !55
  %7 = icmp slt i32 %6, 2, !dbg !57
  br i1 %7, label %8, label %18, !dbg !58

8:                                                ; preds = %5
  %9 = call ptr @malloc(i64 noundef 8) #5, !dbg !64
  store ptr %9, ptr %4, align 8, !dbg !63
  %10 = load ptr, ptr %4, align 8, !dbg !65
  %11 = icmp ne ptr %10, null, !dbg !65
  br i1 %11, label %13, label %12, !dbg !67

12:                                               ; preds = %8
  call void @exit(i32 noundef 1) #6, !dbg !68
  unreachable, !dbg !68

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 8, !dbg !70
  call void @ck_stack_push_upmc(ptr noundef @stack, ptr noundef %14), !dbg !71
  br label %15, !dbg !72

15:                                               ; preds = %13
  %16 = load i32, ptr %3, align 4, !dbg !73
  %17 = add nsw i32 %16, 1, !dbg !73
  store i32 %17, ptr %3, align 4, !dbg !73
  br label %5, !dbg !74, !llvm.loop !75

18:                                               ; preds = %5
  ret ptr null, !dbg !78
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !79 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !89
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !89
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !89
  store ptr %8, ptr %5, align 8, !dbg !90
  %9 = load ptr, ptr %5, align 8, !dbg !91
  %10 = load ptr, ptr %4, align 8, !dbg !92
  %11 = getelementptr inbounds %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !93
  store ptr %9, ptr %11, align 8, !dbg !94
  call void @ck_pr_fence_store(), !dbg !95
  br label %12, !dbg !96

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 8, !dbg !97
  %14 = getelementptr inbounds %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !98
  %15 = load ptr, ptr %5, align 8, !dbg !99
  %16 = load ptr, ptr %4, align 8, !dbg !100
  %17 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !101
  %18 = zext i1 %17 to i32, !dbg !101
  %19 = icmp eq i32 %18, 0, !dbg !102
  br i1 %19, label %20, label %24, !dbg !96

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 8, !dbg !103
  %22 = load ptr, ptr %4, align 8, !dbg !105
  %23 = getelementptr inbounds %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !106
  store ptr %21, ptr %23, align 8, !dbg !107
  call void @ck_pr_fence_store(), !dbg !108
  br label %12, !dbg !96, !llvm.loop !109

24:                                               ; preds = %12
  ret void, !dbg !111
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @popper_fn(ptr noundef %0) #0 !dbg !112 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = call ptr @ck_stack_pop_upmc(ptr noundef @stack), !dbg !117
  store ptr %4, ptr %3, align 8, !dbg !118
  %5 = load ptr, ptr %3, align 8, !dbg !119
  %6 = icmp ne ptr %5, null, !dbg !120
  %7 = zext i1 %6 to i32, !dbg !120
  call void @__VERIFIER_assume(i32 noundef %7), !dbg !121
  %8 = load ptr, ptr %3, align 8, !dbg !122
  call void @free(ptr noundef %8), !dbg !123
  ret ptr null, !dbg !124
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_stack_pop_upmc(ptr noundef %0) #0 !dbg !125 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !134
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !134
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !134
  store ptr %8, ptr %4, align 8, !dbg !135
  %9 = load ptr, ptr %4, align 8, !dbg !136
  %10 = icmp eq ptr %9, null, !dbg !138
  br i1 %10, label %11, label %12, !dbg !139

11:                                               ; preds = %1
  store ptr null, ptr %2, align 8, !dbg !140
  br label %34, !dbg !140

12:                                               ; preds = %1
  call void @ck_pr_fence_load(), !dbg !141
  %13 = load ptr, ptr %4, align 8, !dbg !142
  %14 = getelementptr inbounds %struct.ck_stack_entry, ptr %13, i32 0, i32 0, !dbg !143
  %15 = load ptr, ptr %14, align 8, !dbg !143
  store ptr %15, ptr %5, align 8, !dbg !144
  br label %16, !dbg !145

16:                                               ; preds = %28, %12
  %17 = load ptr, ptr %3, align 8, !dbg !146
  %18 = getelementptr inbounds %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !147
  %19 = load ptr, ptr %4, align 8, !dbg !148
  %20 = load ptr, ptr %5, align 8, !dbg !149
  %21 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %18, ptr noundef %19, ptr noundef %20, ptr noundef %4), !dbg !150
  %22 = zext i1 %21 to i32, !dbg !150
  %23 = icmp eq i32 %22, 0, !dbg !151
  br i1 %23, label %24, label %32, !dbg !145

24:                                               ; preds = %16
  %25 = load ptr, ptr %4, align 8, !dbg !152
  %26 = icmp eq ptr %25, null, !dbg !155
  br i1 %26, label %27, label %28, !dbg !156

27:                                               ; preds = %24
  br label %32, !dbg !157

28:                                               ; preds = %24
  call void @ck_pr_fence_load(), !dbg !158
  %29 = load ptr, ptr %4, align 8, !dbg !159
  %30 = getelementptr inbounds %struct.ck_stack_entry, ptr %29, i32 0, i32 0, !dbg !160
  %31 = load ptr, ptr %30, align 8, !dbg !160
  store ptr %31, ptr %5, align 8, !dbg !161
  br label %16, !dbg !145, !llvm.loop !162

32:                                               ; preds = %27, %16
  %33 = load ptr, ptr %4, align 8, !dbg !164
  store ptr %33, ptr %2, align 8, !dbg !165
  br label %34, !dbg !165

34:                                               ; preds = %32, %11
  %35 = load ptr, ptr %2, align 8, !dbg !166
  ret ptr %35, !dbg !166
}

declare void @__VERIFIER_assume(i32 noundef) #3

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !167 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x ptr], align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 0, ptr %4, align 4, !dbg !205
  br label %8, !dbg !206

8:                                                ; preds = %19, %0
  %9 = load i32, ptr %4, align 4, !dbg !207
  %10 = icmp slt i32 %9, 1, !dbg !209
  br i1 %10, label %11, label %22, !dbg !210

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4, !dbg !211
  %13 = sext i32 %12 to i64, !dbg !214
  %14 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %13, !dbg !214
  %15 = call i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @pusher_fn, ptr noundef null), !dbg !215
  %16 = icmp ne i32 %15, 0, !dbg !216
  br i1 %16, label %17, label %18, !dbg !217

17:                                               ; preds = %11
  store i32 1, ptr %1, align 4, !dbg !218
  br label %74, !dbg !218

18:                                               ; preds = %11
  br label %19, !dbg !220

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4, !dbg !221
  %21 = add nsw i32 %20, 1, !dbg !221
  store i32 %21, ptr %4, align 4, !dbg !221
  br label %8, !dbg !222, !llvm.loop !223

22:                                               ; preds = %8
  store i32 0, ptr %5, align 4, !dbg !227
  br label %23, !dbg !228

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %5, align 4, !dbg !229
  %25 = icmp slt i32 %24, 2, !dbg !231
  br i1 %25, label %26, label %37, !dbg !232

26:                                               ; preds = %23
  %27 = load i32, ptr %5, align 4, !dbg !233
  %28 = sext i32 %27 to i64, !dbg !236
  %29 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %28, !dbg !236
  %30 = call i32 @pthread_create(ptr noundef %29, ptr noundef null, ptr noundef @popper_fn, ptr noundef null), !dbg !237
  %31 = icmp ne i32 %30, 0, !dbg !238
  br i1 %31, label %32, label %33, !dbg !239

32:                                               ; preds = %26
  store i32 1, ptr %1, align 4, !dbg !240
  br label %74, !dbg !240

33:                                               ; preds = %26
  br label %34, !dbg !242

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4, !dbg !243
  %36 = add nsw i32 %35, 1, !dbg !243
  store i32 %36, ptr %5, align 4, !dbg !243
  br label %23, !dbg !244, !llvm.loop !245

37:                                               ; preds = %23
  store i32 0, ptr %6, align 4, !dbg !249
  br label %38, !dbg !250

38:                                               ; preds = %47, %37
  %39 = load i32, ptr %6, align 4, !dbg !251
  %40 = icmp slt i32 %39, 1, !dbg !253
  br i1 %40, label %41, label %50, !dbg !254

41:                                               ; preds = %38
  %42 = load i32, ptr %6, align 4, !dbg !255
  %43 = sext i32 %42 to i64, !dbg !257
  %44 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %43, !dbg !257
  %45 = load ptr, ptr %44, align 8, !dbg !257
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null), !dbg !258
  br label %47, !dbg !259

47:                                               ; preds = %41
  %48 = load i32, ptr %6, align 4, !dbg !260
  %49 = add nsw i32 %48, 1, !dbg !260
  store i32 %49, ptr %6, align 4, !dbg !260
  br label %38, !dbg !261, !llvm.loop !262

50:                                               ; preds = %38
  store i32 0, ptr %7, align 4, !dbg !266
  br label %51, !dbg !267

51:                                               ; preds = %60, %50
  %52 = load i32, ptr %7, align 4, !dbg !268
  %53 = icmp slt i32 %52, 2, !dbg !270
  br i1 %53, label %54, label %63, !dbg !271

54:                                               ; preds = %51
  %55 = load i32, ptr %7, align 4, !dbg !272
  %56 = sext i32 %55 to i64, !dbg !274
  %57 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %56, !dbg !274
  %58 = load ptr, ptr %57, align 8, !dbg !274
  %59 = call i32 @"\01_pthread_join"(ptr noundef %58, ptr noundef null), !dbg !275
  br label %60, !dbg !276

60:                                               ; preds = %54
  %61 = load i32, ptr %7, align 4, !dbg !277
  %62 = add nsw i32 %61, 1, !dbg !277
  store i32 %62, ptr %7, align 4, !dbg !277
  br label %51, !dbg !278, !llvm.loop !279

63:                                               ; preds = %51
  %64 = load ptr, ptr @stack, align 8, !dbg !281
  %65 = icmp eq ptr %64, null, !dbg !281
  %66 = xor i1 %65, true, !dbg !281
  %67 = zext i1 %66 to i32, !dbg !281
  %68 = sext i32 %67 to i64, !dbg !281
  %69 = icmp ne i64 %68, 0, !dbg !281
  br i1 %69, label %70, label %72, !dbg !281

70:                                               ; preds = %63
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 72, ptr noundef @.str.1) #7, !dbg !281
  unreachable, !dbg !281

71:                                               ; No predecessors!
  br label %73, !dbg !281

72:                                               ; preds = %63
  br label %73, !dbg !281

73:                                               ; preds = %72, %71
  store i32 0, ptr %1, align 4, !dbg !282
  br label %74, !dbg !282

74:                                               ; preds = %73, %32, %17
  %75 = load i32, ptr %1, align 4, !dbg !283
  ret i32 %75, !dbg !283
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !284 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8, !dbg !291
  %4 = load ptr, ptr %2, align 8, !dbg !291
  %5 = call i64 asm sideeffect "ldr $0, [$1]\0A", "=r,r,~{memory}"(ptr %4) #8, !dbg !291, !srcloc !293
  store i64 %5, ptr %3, align 8, !dbg !291
  %6 = load i64, ptr %3, align 8, !dbg !291
  %7 = inttoptr i64 %6 to ptr, !dbg !291
  ret ptr %7, !dbg !291
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 !dbg !294 {
  call void @ck_pr_fence_strict_store(), !dbg !298
  ret void, !dbg !298
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !299 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %11 = load ptr, ptr %5, align 8, !dbg !305
  %12 = load ptr, ptr %7, align 8, !dbg !305
  %13 = load ptr, ptr %6, align 8, !dbg !305
  %14 = call { ptr, ptr } asm sideeffect "1:\0Aldxr $0, [$2]\0Acmp  $0, $4\0Ab.ne 2f\0Astxr ${1:w}, $3, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, ptr %12, ptr %13) #8, !dbg !305, !srcloc !311
  %15 = extractvalue { ptr, ptr } %14, 0, !dbg !305
  %16 = extractvalue { ptr, ptr } %14, 1, !dbg !305
  store ptr %15, ptr %9, align 8, !dbg !305
  store ptr %16, ptr %10, align 8, !dbg !305
  %17 = load ptr, ptr %9, align 8, !dbg !305
  %18 = load ptr, ptr %8, align 8, !dbg !305
  store ptr %17, ptr %18, align 8, !dbg !305
  %19 = load ptr, ptr %9, align 8, !dbg !305
  %20 = load ptr, ptr %6, align 8, !dbg !305
  %21 = icmp eq ptr %19, %20, !dbg !305
  ret i1 %21, !dbg !305
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 !dbg !312 {
  call void asm sideeffect "dmb ishst", "r,~{memory}"(i32 0) #8, !dbg !313, !srcloc !314
  ret void, !dbg !313
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 !dbg !315 {
  call void @ck_pr_fence_strict_load(), !dbg !316
  ret void, !dbg !316
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 !dbg !317 {
  call void asm sideeffect "dmb ishld", "r,~{memory}"(i32 0) #8, !dbg !318, !srcloc !319
  ret void, !dbg !318
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

!llvm.module.flags = !{!36, !37, !38, !39, !40, !41, !42}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!43}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack", scope: !2, file: !3, line: 16, type: !30, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/stack_empty.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "567aa80bf5e7471f98427c9a1da3f795")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !8, line: 35, size: 64, elements: !9)
!8 = !DIFile(filename: "include/ck_stack.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!9 = !{!10}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !7, file: !8, line: 36, baseType: !6, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!12 = !{!0, !13, !20, !25}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 72, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 40, elements: !18)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{!19}
!19 = !DISubrange(count: 5)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 72, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 112, elements: !23)
!23 = !{!24}
!24 = !DISubrange(count: 14)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 72, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 200, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 25)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !8, line: 44, baseType: !31)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !8, line: 40, size: 128, elements: !32)
!32 = !{!33, !34}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !31, file: !8, line: 41, baseType: !6, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !31, file: !8, line: 42, baseType: !35, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!36 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{i32 8, !"PIC Level", i32 2}
!41 = !{i32 7, !"uwtable", i32 1}
!42 = !{i32 7, !"frame-pointer", i32 1}
!43 = !{!"Homebrew clang version 19.1.7"}
!44 = distinct !DISubprogram(name: "pusher_fn", scope: !3, file: !3, line: 18, type: !45, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!45 = !DISubroutineType(types: !46)
!46 = !{!5, !5}
!47 = !{}
!48 = !DILocalVariable(name: "arg", arg: 1, scope: !44, file: !3, line: 18, type: !5)
!49 = !DILocation(line: 18, column: 23, scope: !44)
!50 = !DILocalVariable(name: "i", scope: !51, file: !3, line: 20, type: !52)
!51 = distinct !DILexicalBlock(scope: !44, file: !3, line: 20, column: 5)
!52 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!53 = !DILocation(line: 20, column: 14, scope: !51)
!54 = !DILocation(line: 20, column: 10, scope: !51)
!55 = !DILocation(line: 20, column: 21, scope: !56)
!56 = distinct !DILexicalBlock(scope: !51, file: !3, line: 20, column: 5)
!57 = !DILocation(line: 20, column: 23, scope: !56)
!58 = !DILocation(line: 20, column: 5, scope: !51)
!59 = !DILocalVariable(name: "entry", scope: !60, file: !3, line: 22, type: !61)
!60 = distinct !DILexicalBlock(scope: !56, file: !3, line: 21, column: 5)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !8, line: 38, baseType: !7)
!63 = !DILocation(line: 22, column: 27, scope: !60)
!64 = !DILocation(line: 22, column: 35, scope: !60)
!65 = !DILocation(line: 23, column: 14, scope: !66)
!66 = distinct !DILexicalBlock(scope: !60, file: !3, line: 23, column: 13)
!67 = !DILocation(line: 23, column: 13, scope: !60)
!68 = !DILocation(line: 25, column: 13, scope: !69)
!69 = distinct !DILexicalBlock(scope: !66, file: !3, line: 24, column: 9)
!70 = !DILocation(line: 27, column: 36, scope: !60)
!71 = !DILocation(line: 27, column: 9, scope: !60)
!72 = !DILocation(line: 28, column: 5, scope: !60)
!73 = !DILocation(line: 20, column: 39, scope: !56)
!74 = !DILocation(line: 20, column: 5, scope: !56)
!75 = distinct !{!75, !58, !76, !77}
!76 = !DILocation(line: 28, column: 5, scope: !51)
!77 = !{!"llvm.loop.mustprogress"}
!78 = !DILocation(line: 29, column: 5, scope: !44)
!79 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !8, file: !8, line: 54, type: !80, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!80 = !DISubroutineType(types: !81)
!81 = !{null, !82, !6}
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!83 = !DILocalVariable(name: "target", arg: 1, scope: !79, file: !8, line: 54, type: !82)
!84 = !DILocation(line: 54, column: 37, scope: !79)
!85 = !DILocalVariable(name: "entry", arg: 2, scope: !79, file: !8, line: 54, type: !6)
!86 = !DILocation(line: 54, column: 68, scope: !79)
!87 = !DILocalVariable(name: "stack", scope: !79, file: !8, line: 56, type: !6)
!88 = !DILocation(line: 56, column: 25, scope: !79)
!89 = !DILocation(line: 58, column: 10, scope: !79)
!90 = !DILocation(line: 58, column: 8, scope: !79)
!91 = !DILocation(line: 59, column: 16, scope: !79)
!92 = !DILocation(line: 59, column: 2, scope: !79)
!93 = !DILocation(line: 59, column: 9, scope: !79)
!94 = !DILocation(line: 59, column: 14, scope: !79)
!95 = !DILocation(line: 60, column: 2, scope: !79)
!96 = !DILocation(line: 62, column: 2, scope: !79)
!97 = !DILocation(line: 62, column: 30, scope: !79)
!98 = !DILocation(line: 62, column: 38, scope: !79)
!99 = !DILocation(line: 62, column: 44, scope: !79)
!100 = !DILocation(line: 62, column: 51, scope: !79)
!101 = !DILocation(line: 62, column: 9, scope: !79)
!102 = !DILocation(line: 62, column: 66, scope: !79)
!103 = !DILocation(line: 63, column: 17, scope: !104)
!104 = distinct !DILexicalBlock(scope: !79, file: !8, line: 62, column: 76)
!105 = !DILocation(line: 63, column: 3, scope: !104)
!106 = !DILocation(line: 63, column: 10, scope: !104)
!107 = !DILocation(line: 63, column: 15, scope: !104)
!108 = !DILocation(line: 64, column: 3, scope: !104)
!109 = distinct !{!109, !96, !110, !77}
!110 = !DILocation(line: 65, column: 2, scope: !79)
!111 = !DILocation(line: 67, column: 2, scope: !79)
!112 = distinct !DISubprogram(name: "popper_fn", scope: !3, file: !3, line: 32, type: !45, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!113 = !DILocalVariable(name: "arg", arg: 1, scope: !112, file: !3, line: 32, type: !5)
!114 = !DILocation(line: 32, column: 23, scope: !112)
!115 = !DILocalVariable(name: "entry", scope: !112, file: !3, line: 34, type: !61)
!116 = !DILocation(line: 34, column: 23, scope: !112)
!117 = !DILocation(line: 35, column: 13, scope: !112)
!118 = !DILocation(line: 35, column: 11, scope: !112)
!119 = !DILocation(line: 36, column: 23, scope: !112)
!120 = !DILocation(line: 36, column: 29, scope: !112)
!121 = !DILocation(line: 36, column: 5, scope: !112)
!122 = !DILocation(line: 37, column: 10, scope: !112)
!123 = !DILocation(line: 37, column: 5, scope: !112)
!124 = !DILocation(line: 38, column: 5, scope: !112)
!125 = distinct !DISubprogram(name: "ck_stack_pop_upmc", scope: !8, file: !8, line: 96, type: !126, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!126 = !DISubroutineType(types: !127)
!127 = !{!6, !82}
!128 = !DILocalVariable(name: "target", arg: 1, scope: !125, file: !8, line: 96, type: !82)
!129 = !DILocation(line: 96, column: 36, scope: !125)
!130 = !DILocalVariable(name: "entry", scope: !125, file: !8, line: 98, type: !6)
!131 = !DILocation(line: 98, column: 25, scope: !125)
!132 = !DILocalVariable(name: "next", scope: !125, file: !8, line: 98, type: !6)
!133 = !DILocation(line: 98, column: 33, scope: !125)
!134 = !DILocation(line: 100, column: 10, scope: !125)
!135 = !DILocation(line: 100, column: 8, scope: !125)
!136 = !DILocation(line: 101, column: 6, scope: !137)
!137 = distinct !DILexicalBlock(scope: !125, file: !8, line: 101, column: 6)
!138 = !DILocation(line: 101, column: 12, scope: !137)
!139 = !DILocation(line: 101, column: 6, scope: !125)
!140 = !DILocation(line: 102, column: 3, scope: !137)
!141 = !DILocation(line: 104, column: 2, scope: !125)
!142 = !DILocation(line: 105, column: 9, scope: !125)
!143 = !DILocation(line: 105, column: 16, scope: !125)
!144 = !DILocation(line: 105, column: 7, scope: !125)
!145 = !DILocation(line: 106, column: 2, scope: !125)
!146 = !DILocation(line: 106, column: 30, scope: !125)
!147 = !DILocation(line: 106, column: 38, scope: !125)
!148 = !DILocation(line: 106, column: 44, scope: !125)
!149 = !DILocation(line: 106, column: 51, scope: !125)
!150 = !DILocation(line: 106, column: 9, scope: !125)
!151 = !DILocation(line: 106, column: 65, scope: !125)
!152 = !DILocation(line: 107, column: 7, scope: !153)
!153 = distinct !DILexicalBlock(scope: !154, file: !8, line: 107, column: 7)
!154 = distinct !DILexicalBlock(scope: !125, file: !8, line: 106, column: 75)
!155 = !DILocation(line: 107, column: 13, scope: !153)
!156 = !DILocation(line: 107, column: 7, scope: !154)
!157 = !DILocation(line: 108, column: 4, scope: !153)
!158 = !DILocation(line: 110, column: 3, scope: !154)
!159 = !DILocation(line: 111, column: 10, scope: !154)
!160 = !DILocation(line: 111, column: 17, scope: !154)
!161 = !DILocation(line: 111, column: 8, scope: !154)
!162 = distinct !{!162, !145, !163, !77}
!163 = !DILocation(line: 112, column: 2, scope: !125)
!164 = !DILocation(line: 114, column: 9, scope: !125)
!165 = !DILocation(line: 114, column: 2, scope: !125)
!166 = !DILocation(line: 115, column: 1, scope: !125)
!167 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !168, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!168 = !DISubroutineType(types: !169)
!169 = !{!52}
!170 = !DILocalVariable(name: "pushers", scope: !167, file: !3, line: 43, type: !171)
!171 = !DICompositeType(tag: DW_TAG_array_type, baseType: !172, size: 64, elements: !195)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !173, line: 31, baseType: !174)
!173 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !175, line: 118, baseType: !176)
!175 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !175, line: 103, size: 65536, elements: !178)
!178 = !{!179, !181, !191}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !177, file: !175, line: 104, baseType: !180, size: 64)
!180 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !177, file: !175, line: 105, baseType: !182, size: 64, offset: 64)
!182 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !183, size: 64)
!183 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !175, line: 57, size: 192, elements: !184)
!184 = !{!185, !189, !190}
!185 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !183, file: !175, line: 58, baseType: !186, size: 64)
!186 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !187, size: 64)
!187 = !DISubroutineType(types: !188)
!188 = !{null, !5}
!189 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !183, file: !175, line: 59, baseType: !5, size: 64, offset: 64)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !183, file: !175, line: 60, baseType: !182, size: 64, offset: 128)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !177, file: !175, line: 106, baseType: !192, size: 65408, offset: 128)
!192 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 65408, elements: !193)
!193 = !{!194}
!194 = !DISubrange(count: 8176)
!195 = !{!196}
!196 = !DISubrange(count: 1)
!197 = !DILocation(line: 43, column: 15, scope: !167)
!198 = !DILocalVariable(name: "poppers", scope: !167, file: !3, line: 44, type: !199)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !172, size: 128, elements: !200)
!200 = !{!201}
!201 = !DISubrange(count: 2)
!202 = !DILocation(line: 44, column: 15, scope: !167)
!203 = !DILocalVariable(name: "i", scope: !204, file: !3, line: 46, type: !52)
!204 = distinct !DILexicalBlock(scope: !167, file: !3, line: 46, column: 5)
!205 = !DILocation(line: 46, column: 14, scope: !204)
!206 = !DILocation(line: 46, column: 10, scope: !204)
!207 = !DILocation(line: 46, column: 21, scope: !208)
!208 = distinct !DILexicalBlock(scope: !204, file: !3, line: 46, column: 5)
!209 = !DILocation(line: 46, column: 23, scope: !208)
!210 = !DILocation(line: 46, column: 5, scope: !204)
!211 = !DILocation(line: 48, column: 37, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 48, column: 13)
!213 = distinct !DILexicalBlock(scope: !208, file: !3, line: 47, column: 5)
!214 = !DILocation(line: 48, column: 29, scope: !212)
!215 = !DILocation(line: 48, column: 13, scope: !212)
!216 = !DILocation(line: 48, column: 64, scope: !212)
!217 = !DILocation(line: 48, column: 13, scope: !213)
!218 = !DILocation(line: 50, column: 13, scope: !219)
!219 = distinct !DILexicalBlock(scope: !212, file: !3, line: 49, column: 9)
!220 = !DILocation(line: 52, column: 5, scope: !213)
!221 = !DILocation(line: 46, column: 39, scope: !208)
!222 = !DILocation(line: 46, column: 5, scope: !208)
!223 = distinct !{!223, !210, !224, !77}
!224 = !DILocation(line: 52, column: 5, scope: !204)
!225 = !DILocalVariable(name: "i", scope: !226, file: !3, line: 54, type: !52)
!226 = distinct !DILexicalBlock(scope: !167, file: !3, line: 54, column: 5)
!227 = !DILocation(line: 54, column: 14, scope: !226)
!228 = !DILocation(line: 54, column: 10, scope: !226)
!229 = !DILocation(line: 54, column: 21, scope: !230)
!230 = distinct !DILexicalBlock(scope: !226, file: !3, line: 54, column: 5)
!231 = !DILocation(line: 54, column: 23, scope: !230)
!232 = !DILocation(line: 54, column: 5, scope: !226)
!233 = !DILocation(line: 56, column: 37, scope: !234)
!234 = distinct !DILexicalBlock(scope: !235, file: !3, line: 56, column: 13)
!235 = distinct !DILexicalBlock(scope: !230, file: !3, line: 55, column: 5)
!236 = !DILocation(line: 56, column: 29, scope: !234)
!237 = !DILocation(line: 56, column: 13, scope: !234)
!238 = !DILocation(line: 56, column: 64, scope: !234)
!239 = !DILocation(line: 56, column: 13, scope: !235)
!240 = !DILocation(line: 58, column: 13, scope: !241)
!241 = distinct !DILexicalBlock(scope: !234, file: !3, line: 57, column: 9)
!242 = !DILocation(line: 60, column: 5, scope: !235)
!243 = !DILocation(line: 54, column: 39, scope: !230)
!244 = !DILocation(line: 54, column: 5, scope: !230)
!245 = distinct !{!245, !232, !246, !77}
!246 = !DILocation(line: 60, column: 5, scope: !226)
!247 = !DILocalVariable(name: "i", scope: !248, file: !3, line: 62, type: !52)
!248 = distinct !DILexicalBlock(scope: !167, file: !3, line: 62, column: 5)
!249 = !DILocation(line: 62, column: 14, scope: !248)
!250 = !DILocation(line: 62, column: 10, scope: !248)
!251 = !DILocation(line: 62, column: 21, scope: !252)
!252 = distinct !DILexicalBlock(scope: !248, file: !3, line: 62, column: 5)
!253 = !DILocation(line: 62, column: 23, scope: !252)
!254 = !DILocation(line: 62, column: 5, scope: !248)
!255 = !DILocation(line: 64, column: 30, scope: !256)
!256 = distinct !DILexicalBlock(scope: !252, file: !3, line: 63, column: 5)
!257 = !DILocation(line: 64, column: 22, scope: !256)
!258 = !DILocation(line: 64, column: 9, scope: !256)
!259 = !DILocation(line: 65, column: 5, scope: !256)
!260 = !DILocation(line: 62, column: 39, scope: !252)
!261 = !DILocation(line: 62, column: 5, scope: !252)
!262 = distinct !{!262, !254, !263, !77}
!263 = !DILocation(line: 65, column: 5, scope: !248)
!264 = !DILocalVariable(name: "i", scope: !265, file: !3, line: 67, type: !52)
!265 = distinct !DILexicalBlock(scope: !167, file: !3, line: 67, column: 5)
!266 = !DILocation(line: 67, column: 14, scope: !265)
!267 = !DILocation(line: 67, column: 10, scope: !265)
!268 = !DILocation(line: 67, column: 21, scope: !269)
!269 = distinct !DILexicalBlock(scope: !265, file: !3, line: 67, column: 5)
!270 = !DILocation(line: 67, column: 23, scope: !269)
!271 = !DILocation(line: 67, column: 5, scope: !265)
!272 = !DILocation(line: 69, column: 30, scope: !273)
!273 = distinct !DILexicalBlock(scope: !269, file: !3, line: 68, column: 5)
!274 = !DILocation(line: 69, column: 22, scope: !273)
!275 = !DILocation(line: 69, column: 9, scope: !273)
!276 = !DILocation(line: 70, column: 5, scope: !273)
!277 = !DILocation(line: 67, column: 39, scope: !269)
!278 = !DILocation(line: 67, column: 5, scope: !269)
!279 = distinct !{!279, !271, !280, !77}
!280 = !DILocation(line: 70, column: 5, scope: !265)
!281 = !DILocation(line: 72, column: 5, scope: !167)
!282 = !DILocation(line: 74, column: 5, scope: !167)
!283 = !DILocation(line: 75, column: 1, scope: !167)
!284 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !285, file: !285, line: 114, type: !286, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!285 = !DIFile(filename: "include/gcc/aarch64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "541343f389e38ab223846ef61e08c7c6")
!286 = !DISubroutineType(types: !287)
!287 = !{!5, !288}
!288 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !289, size: 64)
!289 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!290 = !DILocalVariable(name: "target", arg: 1, scope: !284, file: !285, line: 114, type: !288)
!291 = !DILocation(line: 114, column: 1, scope: !284)
!292 = !DILocalVariable(name: "r", scope: !284, file: !285, line: 114, type: !180)
!293 = !{i64 2148649777}
!294 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !295, file: !295, line: 113, type: !296, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!295 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!296 = !DISubroutineType(types: !297)
!297 = !{null}
!298 = !DILocation(line: 113, column: 1, scope: !294)
!299 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !300, file: !300, line: 144, type: !301, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!300 = !DIFile(filename: "include/gcc/aarch64/ck_pr_llsc.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "efbdce03086b6ddcc0e6ae2ac2ef7173")
!301 = !DISubroutineType(types: !302)
!302 = !{!303, !5, !5, !5, !5}
!303 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!304 = !DILocalVariable(name: "target", arg: 1, scope: !299, file: !300, line: 144, type: !5)
!305 = !DILocation(line: 144, column: 1, scope: !299)
!306 = !DILocalVariable(name: "compare", arg: 2, scope: !299, file: !300, line: 144, type: !5)
!307 = !DILocalVariable(name: "set", arg: 3, scope: !299, file: !300, line: 144, type: !5)
!308 = !DILocalVariable(name: "value", arg: 4, scope: !299, file: !300, line: 144, type: !5)
!309 = !DILocalVariable(name: "previous", scope: !299, file: !300, line: 144, type: !5)
!310 = !DILocalVariable(name: "tmp", scope: !299, file: !300, line: 144, type: !5)
!311 = !{i64 2148671200, i64 2148671250, i64 2148671317, i64 2148671383, i64 2148671436, i64 2148671508, i64 2148671566}
!312 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !285, file: !285, line: 73, type: !296, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!313 = !DILocation(line: 73, column: 1, scope: !312)
!314 = !{i64 2148647013}
!315 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !295, file: !295, line: 112, type: !296, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!316 = !DILocation(line: 112, column: 1, scope: !315)
!317 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !285, file: !285, line: 75, type: !296, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!318 = !DILocation(line: 75, column: 1, scope: !317)
!319 = !{i64 2148647556}
