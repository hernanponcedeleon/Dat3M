; ModuleID = 'tests/stack_empty.c'
source_filename = "tests/stack_empty.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_stack = type { ptr, ptr }
%struct.ck_stack_entry = type { ptr }

@stack = global %struct.ck_stack zeroinitializer, align 8, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !18
@.str = private unnamed_addr constant [14 x i8] c"stack_empty.c\00", align 1, !dbg !25
@.str.1 = private unnamed_addr constant [25 x i8] c"CK_STACK_ISEMPTY(&stack)\00", align 1, !dbg !30

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @pusher_fn(ptr noundef %0) #0 !dbg !49 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4, !dbg !58
  br label %5, !dbg !59

5:                                                ; preds = %15, %1
  %6 = load i32, ptr %3, align 4, !dbg !60
  %7 = icmp slt i32 %6, 2, !dbg !62
  br i1 %7, label %8, label %18, !dbg !63

8:                                                ; preds = %5
  %9 = call ptr @malloc(i64 noundef 8) #5, !dbg !69
  store ptr %9, ptr %4, align 8, !dbg !68
  %10 = load ptr, ptr %4, align 8, !dbg !70
  %11 = icmp ne ptr %10, null, !dbg !70
  br i1 %11, label %13, label %12, !dbg !72

12:                                               ; preds = %8
  call void @exit(i32 noundef 1) #6, !dbg !73
  unreachable, !dbg !73

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 8, !dbg !75
  call void @ck_stack_push_upmc(ptr noundef @stack, ptr noundef %14), !dbg !76
  br label %15, !dbg !77

15:                                               ; preds = %13
  %16 = load i32, ptr %3, align 4, !dbg !78
  %17 = add nsw i32 %16, 1, !dbg !78
  store i32 %17, ptr %3, align 4, !dbg !78
  br label %5, !dbg !79, !llvm.loop !80

18:                                               ; preds = %5
  ret ptr null, !dbg !83
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !84 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !94
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !94
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !94
  store ptr %8, ptr %5, align 8, !dbg !95
  %9 = load ptr, ptr %5, align 8, !dbg !96
  %10 = load ptr, ptr %4, align 8, !dbg !97
  %11 = getelementptr inbounds %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !98
  store ptr %9, ptr %11, align 8, !dbg !99
  call void @ck_pr_fence_store(), !dbg !100
  br label %12, !dbg !101

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 8, !dbg !102
  %14 = getelementptr inbounds %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !103
  %15 = load ptr, ptr %5, align 8, !dbg !104
  %16 = load ptr, ptr %4, align 8, !dbg !105
  %17 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !106
  %18 = zext i1 %17 to i32, !dbg !106
  %19 = icmp eq i32 %18, 0, !dbg !107
  br i1 %19, label %20, label %24, !dbg !101

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 8, !dbg !108
  %22 = load ptr, ptr %4, align 8, !dbg !110
  %23 = getelementptr inbounds %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !111
  store ptr %21, ptr %23, align 8, !dbg !112
  call void @ck_pr_fence_store(), !dbg !113
  br label %12, !dbg !101, !llvm.loop !114

24:                                               ; preds = %12
  ret void, !dbg !116
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @popper_fn(ptr noundef %0) #0 !dbg !117 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %4, !dbg !122

4:                                                ; preds = %7, %1
  %5 = call ptr @ck_stack_pop_upmc(ptr noundef @stack), !dbg !123
  store ptr %5, ptr %3, align 8, !dbg !124
  %6 = icmp eq ptr %5, null, !dbg !125
  br i1 %6, label %7, label %8, !dbg !122

7:                                                ; preds = %4
  br label %4, !dbg !122, !llvm.loop !126

8:                                                ; preds = %4
  %9 = load ptr, ptr %3, align 8, !dbg !128
  call void @free(ptr noundef %9), !dbg !129
  ret ptr null, !dbg !130
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_stack_pop_upmc(ptr noundef %0) #0 !dbg !131 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !140
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !140
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !140
  store ptr %8, ptr %4, align 8, !dbg !141
  %9 = load ptr, ptr %4, align 8, !dbg !142
  %10 = icmp eq ptr %9, null, !dbg !144
  br i1 %10, label %11, label %12, !dbg !145

11:                                               ; preds = %1
  store ptr null, ptr %2, align 8, !dbg !146
  br label %34, !dbg !146

12:                                               ; preds = %1
  call void @ck_pr_fence_load(), !dbg !147
  %13 = load ptr, ptr %4, align 8, !dbg !148
  %14 = getelementptr inbounds %struct.ck_stack_entry, ptr %13, i32 0, i32 0, !dbg !149
  %15 = load ptr, ptr %14, align 8, !dbg !149
  store ptr %15, ptr %5, align 8, !dbg !150
  br label %16, !dbg !151

16:                                               ; preds = %28, %12
  %17 = load ptr, ptr %3, align 8, !dbg !152
  %18 = getelementptr inbounds %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !153
  %19 = load ptr, ptr %4, align 8, !dbg !154
  %20 = load ptr, ptr %5, align 8, !dbg !155
  %21 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %18, ptr noundef %19, ptr noundef %20, ptr noundef %4), !dbg !156
  %22 = zext i1 %21 to i32, !dbg !156
  %23 = icmp eq i32 %22, 0, !dbg !157
  br i1 %23, label %24, label %32, !dbg !151

24:                                               ; preds = %16
  %25 = load ptr, ptr %4, align 8, !dbg !158
  %26 = icmp eq ptr %25, null, !dbg !161
  br i1 %26, label %27, label %28, !dbg !162

27:                                               ; preds = %24
  br label %32, !dbg !163

28:                                               ; preds = %24
  call void @ck_pr_fence_load(), !dbg !164
  %29 = load ptr, ptr %4, align 8, !dbg !165
  %30 = getelementptr inbounds %struct.ck_stack_entry, ptr %29, i32 0, i32 0, !dbg !166
  %31 = load ptr, ptr %30, align 8, !dbg !166
  store ptr %31, ptr %5, align 8, !dbg !167
  br label %16, !dbg !151, !llvm.loop !168

32:                                               ; preds = %27, %16
  %33 = load ptr, ptr %4, align 8, !dbg !170
  store ptr %33, ptr %2, align 8, !dbg !171
  br label %34, !dbg !171

34:                                               ; preds = %32, %11
  %35 = load ptr, ptr %2, align 8, !dbg !172
  ret ptr %35, !dbg !172
}

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !173 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x ptr], align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 0, ptr %4, align 4, !dbg !210
  br label %8, !dbg !211

8:                                                ; preds = %19, %0
  %9 = load i32, ptr %4, align 4, !dbg !212
  %10 = icmp slt i32 %9, 1, !dbg !214
  br i1 %10, label %11, label %22, !dbg !215

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4, !dbg !216
  %13 = sext i32 %12 to i64, !dbg !219
  %14 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %13, !dbg !219
  %15 = call i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @pusher_fn, ptr noundef null), !dbg !220
  %16 = icmp ne i32 %15, 0, !dbg !221
  br i1 %16, label %17, label %18, !dbg !222

17:                                               ; preds = %11
  store i32 1, ptr %1, align 4, !dbg !223
  br label %74, !dbg !223

18:                                               ; preds = %11
  br label %19, !dbg !225

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4, !dbg !226
  %21 = add nsw i32 %20, 1, !dbg !226
  store i32 %21, ptr %4, align 4, !dbg !226
  br label %8, !dbg !227, !llvm.loop !228

22:                                               ; preds = %8
  store i32 0, ptr %5, align 4, !dbg !232
  br label %23, !dbg !233

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %5, align 4, !dbg !234
  %25 = icmp slt i32 %24, 2, !dbg !236
  br i1 %25, label %26, label %37, !dbg !237

26:                                               ; preds = %23
  %27 = load i32, ptr %5, align 4, !dbg !238
  %28 = sext i32 %27 to i64, !dbg !241
  %29 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %28, !dbg !241
  %30 = call i32 @pthread_create(ptr noundef %29, ptr noundef null, ptr noundef @popper_fn, ptr noundef null), !dbg !242
  %31 = icmp ne i32 %30, 0, !dbg !243
  br i1 %31, label %32, label %33, !dbg !244

32:                                               ; preds = %26
  store i32 1, ptr %1, align 4, !dbg !245
  br label %74, !dbg !245

33:                                               ; preds = %26
  br label %34, !dbg !247

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4, !dbg !248
  %36 = add nsw i32 %35, 1, !dbg !248
  store i32 %36, ptr %5, align 4, !dbg !248
  br label %23, !dbg !249, !llvm.loop !250

37:                                               ; preds = %23
  store i32 0, ptr %6, align 4, !dbg !254
  br label %38, !dbg !255

38:                                               ; preds = %47, %37
  %39 = load i32, ptr %6, align 4, !dbg !256
  %40 = icmp slt i32 %39, 1, !dbg !258
  br i1 %40, label %41, label %50, !dbg !259

41:                                               ; preds = %38
  %42 = load i32, ptr %6, align 4, !dbg !260
  %43 = sext i32 %42 to i64, !dbg !262
  %44 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %43, !dbg !262
  %45 = load ptr, ptr %44, align 8, !dbg !262
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null), !dbg !263
  br label %47, !dbg !264

47:                                               ; preds = %41
  %48 = load i32, ptr %6, align 4, !dbg !265
  %49 = add nsw i32 %48, 1, !dbg !265
  store i32 %49, ptr %6, align 4, !dbg !265
  br label %38, !dbg !266, !llvm.loop !267

50:                                               ; preds = %38
  store i32 0, ptr %7, align 4, !dbg !271
  br label %51, !dbg !272

51:                                               ; preds = %60, %50
  %52 = load i32, ptr %7, align 4, !dbg !273
  %53 = icmp slt i32 %52, 2, !dbg !275
  br i1 %53, label %54, label %63, !dbg !276

54:                                               ; preds = %51
  %55 = load i32, ptr %7, align 4, !dbg !277
  %56 = sext i32 %55 to i64, !dbg !279
  %57 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %56, !dbg !279
  %58 = load ptr, ptr %57, align 8, !dbg !279
  %59 = call i32 @"\01_pthread_join"(ptr noundef %58, ptr noundef null), !dbg !280
  br label %60, !dbg !281

60:                                               ; preds = %54
  %61 = load i32, ptr %7, align 4, !dbg !282
  %62 = add nsw i32 %61, 1, !dbg !282
  store i32 %62, ptr %7, align 4, !dbg !282
  br label %51, !dbg !283, !llvm.loop !284

63:                                               ; preds = %51
  %64 = load ptr, ptr @stack, align 8, !dbg !286
  %65 = icmp eq ptr %64, null, !dbg !286
  %66 = xor i1 %65, true, !dbg !286
  %67 = zext i1 %66 to i32, !dbg !286
  %68 = sext i32 %67 to i64, !dbg !286
  %69 = icmp ne i64 %68, 0, !dbg !286
  br i1 %69, label %70, label %72, !dbg !286

70:                                               ; preds = %63
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #7, !dbg !286
  unreachable, !dbg !286

71:                                               ; No predecessors!
  br label %73, !dbg !286

72:                                               ; preds = %63
  br label %73, !dbg !286

73:                                               ; preds = %72, %71
  store i32 0, ptr %1, align 4, !dbg !287
  br label %74, !dbg !287

74:                                               ; preds = %73, %32, %17
  %75 = load i32, ptr %1, align 4, !dbg !288
  ret i32 %75, !dbg !288
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !289 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8, !dbg !296
  %4 = load ptr, ptr %2, align 8, !dbg !296
  %5 = call i64 asm sideeffect "ld $0, 0($1)\0A", "=r,r,~{memory}"(ptr %4) #8, !dbg !296, !srcloc !298
  store i64 %5, ptr %3, align 8, !dbg !296
  %6 = load i64, ptr %3, align 8, !dbg !296
  %7 = inttoptr i64 %6 to ptr, !dbg !296
  ret ptr %7, !dbg !296
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 !dbg !299 {
  call void @ck_pr_fence_strict_store(), !dbg !303
  ret void, !dbg !303
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !304 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %11 = load ptr, ptr %5, align 8, !dbg !309
  %12 = load i64, ptr %11, align 8, !dbg !309
  %13 = load ptr, ptr %7, align 8, !dbg !309
  %14 = load ptr, ptr %6, align 8, !dbg !309
  %15 = ptrtoint ptr %14 to i64, !dbg !309
  %16 = call { ptr, i32, i64 } asm sideeffect "1:\0Ali $1, 1\0Alr.d $0, $2\0Abne $0, $4, 2f\0Asc.d $1, $3, $2\0Abnez $1, 1b\0A2:", "=&r,=&r,=r,r,r,2,~{memory}"(ptr %13, i64 %15, i64 %12) #8, !dbg !309, !srcloc !315
  %17 = extractvalue { ptr, i32, i64 } %16, 0, !dbg !309
  %18 = extractvalue { ptr, i32, i64 } %16, 1, !dbg !309
  %19 = extractvalue { ptr, i32, i64 } %16, 2, !dbg !309
  store ptr %17, ptr %9, align 8, !dbg !309
  store i32 %18, ptr %10, align 4, !dbg !309
  store i64 %19, ptr %11, align 8, !dbg !309
  %20 = load ptr, ptr %9, align 8, !dbg !309
  %21 = load ptr, ptr %8, align 8, !dbg !309
  store ptr %20, ptr %21, align 8, !dbg !309
  %22 = load i32, ptr %10, align 4, !dbg !309
  %23 = icmp eq i32 %22, 0, !dbg !309
  ret i1 %23, !dbg !309
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 !dbg !316 {
  call void asm sideeffect "fence w,w", "~{memory}"() #8, !dbg !317, !srcloc !318
  ret void, !dbg !317
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 !dbg !319 {
  call void @ck_pr_fence_strict_load(), !dbg !320
  ret void, !dbg !320
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 !dbg !321 {
  call void asm sideeffect "fence r,r", "~{memory}"() #8, !dbg !322, !srcloc !323
  ret void, !dbg !322
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

!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack", scope: !2, file: !3, line: 14, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/stack_empty.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "2fbdd2e50017f6d095e4050f4972b9fc")
!4 = !{!5, !6, !11, !15, !12, !16}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !8, line: 35, size: 64, elements: !9)
!8 = !DIFile(filename: "include/ck_stack.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!9 = !{!10}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !7, file: !8, line: 36, baseType: !6, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !13, line: 31, baseType: !14)
!13 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/_types/_uint64_t.h", directory: "", checksumkind: CSK_MD5, checksum: "77fc5e91653260959605f129691cf9b1")
!14 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!15 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!17 = !{!0, !18, !25, !30}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 40, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24}
!24 = !DISubrange(count: 5)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 112, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 14)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 200, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 25)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !8, line: 44, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !8, line: 40, size: 128, elements: !37)
!37 = !{!38, !39}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !36, file: !8, line: 41, baseType: !6, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !36, file: !8, line: 42, baseType: !40, size: 64, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!41 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 8, !"PIC Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 1}
!48 = !{!"Homebrew clang version 19.1.7"}
!49 = distinct !DISubprogram(name: "pusher_fn", scope: !3, file: !3, line: 16, type: !50, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{!5, !5}
!52 = !{}
!53 = !DILocalVariable(name: "arg", arg: 1, scope: !49, file: !3, line: 16, type: !5)
!54 = !DILocation(line: 16, column: 23, scope: !49)
!55 = !DILocalVariable(name: "i", scope: !56, file: !3, line: 17, type: !57)
!56 = distinct !DILexicalBlock(scope: !49, file: !3, line: 17, column: 5)
!57 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!58 = !DILocation(line: 17, column: 14, scope: !56)
!59 = !DILocation(line: 17, column: 10, scope: !56)
!60 = !DILocation(line: 17, column: 21, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !3, line: 17, column: 5)
!62 = !DILocation(line: 17, column: 23, scope: !61)
!63 = !DILocation(line: 17, column: 5, scope: !56)
!64 = !DILocalVariable(name: "entry", scope: !65, file: !3, line: 18, type: !66)
!65 = distinct !DILexicalBlock(scope: !61, file: !3, line: 17, column: 43)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !8, line: 38, baseType: !7)
!68 = !DILocation(line: 18, column: 27, scope: !65)
!69 = !DILocation(line: 18, column: 35, scope: !65)
!70 = !DILocation(line: 19, column: 14, scope: !71)
!71 = distinct !DILexicalBlock(scope: !65, file: !3, line: 19, column: 13)
!72 = !DILocation(line: 19, column: 13, scope: !65)
!73 = !DILocation(line: 20, column: 13, scope: !74)
!74 = distinct !DILexicalBlock(scope: !71, file: !3, line: 19, column: 21)
!75 = !DILocation(line: 22, column: 36, scope: !65)
!76 = !DILocation(line: 22, column: 9, scope: !65)
!77 = !DILocation(line: 23, column: 5, scope: !65)
!78 = !DILocation(line: 17, column: 39, scope: !61)
!79 = !DILocation(line: 17, column: 5, scope: !61)
!80 = distinct !{!80, !63, !81, !82}
!81 = !DILocation(line: 23, column: 5, scope: !56)
!82 = !{!"llvm.loop.mustprogress"}
!83 = !DILocation(line: 24, column: 5, scope: !49)
!84 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !8, file: !8, line: 54, type: !85, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !87, !6}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!88 = !DILocalVariable(name: "target", arg: 1, scope: !84, file: !8, line: 54, type: !87)
!89 = !DILocation(line: 54, column: 37, scope: !84)
!90 = !DILocalVariable(name: "entry", arg: 2, scope: !84, file: !8, line: 54, type: !6)
!91 = !DILocation(line: 54, column: 68, scope: !84)
!92 = !DILocalVariable(name: "stack", scope: !84, file: !8, line: 56, type: !6)
!93 = !DILocation(line: 56, column: 25, scope: !84)
!94 = !DILocation(line: 58, column: 10, scope: !84)
!95 = !DILocation(line: 58, column: 8, scope: !84)
!96 = !DILocation(line: 59, column: 16, scope: !84)
!97 = !DILocation(line: 59, column: 2, scope: !84)
!98 = !DILocation(line: 59, column: 9, scope: !84)
!99 = !DILocation(line: 59, column: 14, scope: !84)
!100 = !DILocation(line: 60, column: 2, scope: !84)
!101 = !DILocation(line: 62, column: 2, scope: !84)
!102 = !DILocation(line: 62, column: 30, scope: !84)
!103 = !DILocation(line: 62, column: 38, scope: !84)
!104 = !DILocation(line: 62, column: 44, scope: !84)
!105 = !DILocation(line: 62, column: 51, scope: !84)
!106 = !DILocation(line: 62, column: 9, scope: !84)
!107 = !DILocation(line: 62, column: 66, scope: !84)
!108 = !DILocation(line: 63, column: 17, scope: !109)
!109 = distinct !DILexicalBlock(scope: !84, file: !8, line: 62, column: 76)
!110 = !DILocation(line: 63, column: 3, scope: !109)
!111 = !DILocation(line: 63, column: 10, scope: !109)
!112 = !DILocation(line: 63, column: 15, scope: !109)
!113 = !DILocation(line: 64, column: 3, scope: !109)
!114 = distinct !{!114, !101, !115, !82}
!115 = !DILocation(line: 65, column: 2, scope: !84)
!116 = !DILocation(line: 67, column: 2, scope: !84)
!117 = distinct !DISubprogram(name: "popper_fn", scope: !3, file: !3, line: 27, type: !50, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !117, file: !3, line: 27, type: !5)
!119 = !DILocation(line: 27, column: 23, scope: !117)
!120 = !DILocalVariable(name: "entry", scope: !117, file: !3, line: 28, type: !66)
!121 = !DILocation(line: 28, column: 23, scope: !117)
!122 = !DILocation(line: 29, column: 5, scope: !117)
!123 = !DILocation(line: 29, column: 21, scope: !117)
!124 = !DILocation(line: 29, column: 19, scope: !117)
!125 = !DILocation(line: 29, column: 48, scope: !117)
!126 = distinct !{!126, !122, !127, !82}
!127 = !DILocation(line: 30, column: 9, scope: !117)
!128 = !DILocation(line: 31, column: 10, scope: !117)
!129 = !DILocation(line: 31, column: 5, scope: !117)
!130 = !DILocation(line: 32, column: 5, scope: !117)
!131 = distinct !DISubprogram(name: "ck_stack_pop_upmc", scope: !8, file: !8, line: 96, type: !132, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!132 = !DISubroutineType(types: !133)
!133 = !{!6, !87}
!134 = !DILocalVariable(name: "target", arg: 1, scope: !131, file: !8, line: 96, type: !87)
!135 = !DILocation(line: 96, column: 36, scope: !131)
!136 = !DILocalVariable(name: "entry", scope: !131, file: !8, line: 98, type: !6)
!137 = !DILocation(line: 98, column: 25, scope: !131)
!138 = !DILocalVariable(name: "next", scope: !131, file: !8, line: 98, type: !6)
!139 = !DILocation(line: 98, column: 33, scope: !131)
!140 = !DILocation(line: 100, column: 10, scope: !131)
!141 = !DILocation(line: 100, column: 8, scope: !131)
!142 = !DILocation(line: 101, column: 6, scope: !143)
!143 = distinct !DILexicalBlock(scope: !131, file: !8, line: 101, column: 6)
!144 = !DILocation(line: 101, column: 12, scope: !143)
!145 = !DILocation(line: 101, column: 6, scope: !131)
!146 = !DILocation(line: 102, column: 3, scope: !143)
!147 = !DILocation(line: 104, column: 2, scope: !131)
!148 = !DILocation(line: 105, column: 9, scope: !131)
!149 = !DILocation(line: 105, column: 16, scope: !131)
!150 = !DILocation(line: 105, column: 7, scope: !131)
!151 = !DILocation(line: 106, column: 2, scope: !131)
!152 = !DILocation(line: 106, column: 30, scope: !131)
!153 = !DILocation(line: 106, column: 38, scope: !131)
!154 = !DILocation(line: 106, column: 44, scope: !131)
!155 = !DILocation(line: 106, column: 51, scope: !131)
!156 = !DILocation(line: 106, column: 9, scope: !131)
!157 = !DILocation(line: 106, column: 65, scope: !131)
!158 = !DILocation(line: 107, column: 7, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !8, line: 107, column: 7)
!160 = distinct !DILexicalBlock(scope: !131, file: !8, line: 106, column: 75)
!161 = !DILocation(line: 107, column: 13, scope: !159)
!162 = !DILocation(line: 107, column: 7, scope: !160)
!163 = !DILocation(line: 108, column: 4, scope: !159)
!164 = !DILocation(line: 110, column: 3, scope: !160)
!165 = !DILocation(line: 111, column: 10, scope: !160)
!166 = !DILocation(line: 111, column: 17, scope: !160)
!167 = !DILocation(line: 111, column: 8, scope: !160)
!168 = distinct !{!168, !151, !169, !82}
!169 = !DILocation(line: 112, column: 2, scope: !131)
!170 = !DILocation(line: 114, column: 9, scope: !131)
!171 = !DILocation(line: 114, column: 2, scope: !131)
!172 = !DILocation(line: 115, column: 1, scope: !131)
!173 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 35, type: !174, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!174 = !DISubroutineType(types: !175)
!175 = !{!57}
!176 = !DILocalVariable(name: "pushers", scope: !173, file: !3, line: 36, type: !177)
!177 = !DICompositeType(tag: DW_TAG_array_type, baseType: !178, size: 64, elements: !200)
!178 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !179, line: 31, baseType: !180)
!179 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !181, line: 118, baseType: !182)
!181 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!182 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !183, size: 64)
!183 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !181, line: 103, size: 65536, elements: !184)
!184 = !{!185, !186, !196}
!185 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !183, file: !181, line: 104, baseType: !15, size: 64)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !183, file: !181, line: 105, baseType: !187, size: 64, offset: 64)
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!188 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !181, line: 57, size: 192, elements: !189)
!189 = !{!190, !194, !195}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !188, file: !181, line: 58, baseType: !191, size: 64)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = !DISubroutineType(types: !193)
!193 = !{null, !5}
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !188, file: !181, line: 59, baseType: !5, size: 64, offset: 64)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !188, file: !181, line: 60, baseType: !187, size: 64, offset: 128)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !183, file: !181, line: 106, baseType: !197, size: 65408, offset: 128)
!197 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 65408, elements: !198)
!198 = !{!199}
!199 = !DISubrange(count: 8176)
!200 = !{!201}
!201 = !DISubrange(count: 1)
!202 = !DILocation(line: 36, column: 15, scope: !173)
!203 = !DILocalVariable(name: "poppers", scope: !173, file: !3, line: 37, type: !204)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !178, size: 128, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 2)
!207 = !DILocation(line: 37, column: 15, scope: !173)
!208 = !DILocalVariable(name: "i", scope: !209, file: !3, line: 39, type: !57)
!209 = distinct !DILexicalBlock(scope: !173, file: !3, line: 39, column: 5)
!210 = !DILocation(line: 39, column: 14, scope: !209)
!211 = !DILocation(line: 39, column: 10, scope: !209)
!212 = !DILocation(line: 39, column: 21, scope: !213)
!213 = distinct !DILexicalBlock(scope: !209, file: !3, line: 39, column: 5)
!214 = !DILocation(line: 39, column: 23, scope: !213)
!215 = !DILocation(line: 39, column: 5, scope: !209)
!216 = !DILocation(line: 40, column: 37, scope: !217)
!217 = distinct !DILexicalBlock(scope: !218, file: !3, line: 40, column: 13)
!218 = distinct !DILexicalBlock(scope: !213, file: !3, line: 39, column: 43)
!219 = !DILocation(line: 40, column: 29, scope: !217)
!220 = !DILocation(line: 40, column: 13, scope: !217)
!221 = !DILocation(line: 40, column: 64, scope: !217)
!222 = !DILocation(line: 40, column: 13, scope: !218)
!223 = !DILocation(line: 41, column: 13, scope: !224)
!224 = distinct !DILexicalBlock(scope: !217, file: !3, line: 40, column: 70)
!225 = !DILocation(line: 43, column: 5, scope: !218)
!226 = !DILocation(line: 39, column: 39, scope: !213)
!227 = !DILocation(line: 39, column: 5, scope: !213)
!228 = distinct !{!228, !215, !229, !82}
!229 = !DILocation(line: 43, column: 5, scope: !209)
!230 = !DILocalVariable(name: "i", scope: !231, file: !3, line: 45, type: !57)
!231 = distinct !DILexicalBlock(scope: !173, file: !3, line: 45, column: 5)
!232 = !DILocation(line: 45, column: 14, scope: !231)
!233 = !DILocation(line: 45, column: 10, scope: !231)
!234 = !DILocation(line: 45, column: 21, scope: !235)
!235 = distinct !DILexicalBlock(scope: !231, file: !3, line: 45, column: 5)
!236 = !DILocation(line: 45, column: 23, scope: !235)
!237 = !DILocation(line: 45, column: 5, scope: !231)
!238 = !DILocation(line: 46, column: 37, scope: !239)
!239 = distinct !DILexicalBlock(scope: !240, file: !3, line: 46, column: 13)
!240 = distinct !DILexicalBlock(scope: !235, file: !3, line: 45, column: 43)
!241 = !DILocation(line: 46, column: 29, scope: !239)
!242 = !DILocation(line: 46, column: 13, scope: !239)
!243 = !DILocation(line: 46, column: 64, scope: !239)
!244 = !DILocation(line: 46, column: 13, scope: !240)
!245 = !DILocation(line: 47, column: 13, scope: !246)
!246 = distinct !DILexicalBlock(scope: !239, file: !3, line: 46, column: 70)
!247 = !DILocation(line: 49, column: 5, scope: !240)
!248 = !DILocation(line: 45, column: 39, scope: !235)
!249 = !DILocation(line: 45, column: 5, scope: !235)
!250 = distinct !{!250, !237, !251, !82}
!251 = !DILocation(line: 49, column: 5, scope: !231)
!252 = !DILocalVariable(name: "i", scope: !253, file: !3, line: 51, type: !57)
!253 = distinct !DILexicalBlock(scope: !173, file: !3, line: 51, column: 5)
!254 = !DILocation(line: 51, column: 14, scope: !253)
!255 = !DILocation(line: 51, column: 10, scope: !253)
!256 = !DILocation(line: 51, column: 21, scope: !257)
!257 = distinct !DILexicalBlock(scope: !253, file: !3, line: 51, column: 5)
!258 = !DILocation(line: 51, column: 23, scope: !257)
!259 = !DILocation(line: 51, column: 5, scope: !253)
!260 = !DILocation(line: 52, column: 30, scope: !261)
!261 = distinct !DILexicalBlock(scope: !257, file: !3, line: 51, column: 43)
!262 = !DILocation(line: 52, column: 22, scope: !261)
!263 = !DILocation(line: 52, column: 9, scope: !261)
!264 = !DILocation(line: 53, column: 5, scope: !261)
!265 = !DILocation(line: 51, column: 39, scope: !257)
!266 = !DILocation(line: 51, column: 5, scope: !257)
!267 = distinct !{!267, !259, !268, !82}
!268 = !DILocation(line: 53, column: 5, scope: !253)
!269 = !DILocalVariable(name: "i", scope: !270, file: !3, line: 55, type: !57)
!270 = distinct !DILexicalBlock(scope: !173, file: !3, line: 55, column: 5)
!271 = !DILocation(line: 55, column: 14, scope: !270)
!272 = !DILocation(line: 55, column: 10, scope: !270)
!273 = !DILocation(line: 55, column: 21, scope: !274)
!274 = distinct !DILexicalBlock(scope: !270, file: !3, line: 55, column: 5)
!275 = !DILocation(line: 55, column: 23, scope: !274)
!276 = !DILocation(line: 55, column: 5, scope: !270)
!277 = !DILocation(line: 56, column: 30, scope: !278)
!278 = distinct !DILexicalBlock(scope: !274, file: !3, line: 55, column: 43)
!279 = !DILocation(line: 56, column: 22, scope: !278)
!280 = !DILocation(line: 56, column: 9, scope: !278)
!281 = !DILocation(line: 57, column: 5, scope: !278)
!282 = !DILocation(line: 55, column: 39, scope: !274)
!283 = !DILocation(line: 55, column: 5, scope: !274)
!284 = distinct !{!284, !276, !285, !82}
!285 = !DILocation(line: 57, column: 5, scope: !270)
!286 = !DILocation(line: 59, column: 5, scope: !173)
!287 = !DILocation(line: 61, column: 5, scope: !173)
!288 = !DILocation(line: 62, column: 1, scope: !173)
!289 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !290, file: !290, line: 115, type: !291, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!290 = !DIFile(filename: "include/gcc/riscv64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "c9263d9958a21a89a9b325c62ad6ee9c")
!291 = !DISubroutineType(types: !292)
!292 = !{!5, !293}
!293 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !294, size: 64)
!294 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!295 = !DILocalVariable(name: "target", arg: 1, scope: !289, file: !290, line: 115, type: !293)
!296 = !DILocation(line: 115, column: 1, scope: !289)
!297 = !DILocalVariable(name: "r", scope: !289, file: !290, line: 115, type: !15)
!298 = !{i64 2147776718}
!299 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !300, file: !300, line: 113, type: !301, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!300 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!301 = !DISubroutineType(types: !302)
!302 = !{null}
!303 = !DILocation(line: 113, column: 1, scope: !299)
!304 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !290, file: !290, line: 206, type: !305, scopeLine: 206, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!305 = !DISubroutineType(types: !306)
!306 = !{!307, !5, !5, !5, !5}
!307 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!308 = !DILocalVariable(name: "target", arg: 1, scope: !304, file: !290, line: 206, type: !5)
!309 = !DILocation(line: 206, column: 1, scope: !304)
!310 = !DILocalVariable(name: "compare", arg: 2, scope: !304, file: !290, line: 206, type: !5)
!311 = !DILocalVariable(name: "set", arg: 3, scope: !304, file: !290, line: 206, type: !5)
!312 = !DILocalVariable(name: "value", arg: 4, scope: !304, file: !290, line: 206, type: !5)
!313 = !DILocalVariable(name: "previous", scope: !304, file: !290, line: 206, type: !5)
!314 = !DILocalVariable(name: "tmp", scope: !304, file: !290, line: 206, type: !57)
!315 = !{i64 2147788868, i64 2147788950, i64 2147789031, i64 2147789112, i64 2147789193, i64 2147789274, i64 2147789355}
!316 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !290, file: !290, line: 85, type: !301, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!317 = !DILocation(line: 85, column: 1, scope: !316)
!318 = !{i64 2147773676}
!319 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !300, file: !300, line: 112, type: !301, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!320 = !DILocation(line: 112, column: 1, scope: !319)
!321 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !290, file: !290, line: 87, type: !301, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!322 = !DILocation(line: 87, column: 1, scope: !321)
!323 = !{i64 2147774183}
