; ModuleID = 'benchmarks/ck/stack_empty.c'
source_filename = "benchmarks/ck/stack_empty.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_stack = type { ptr, ptr }
%struct.ck_stack_entry = type { ptr }

@stack = dso_local global %struct.ck_stack zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [25 x i8] c"CK_STACK_ISEMPTY(&stack)\00", align 1, !dbg !22
@.str.1 = private unnamed_addr constant [28 x i8] c"benchmarks/ck/stack_empty.c\00", align 1, !dbg !28
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !33

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @pusher_fn(ptr noundef %0) #0 !dbg !53 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !57, !DIExpression(), !58)
    #dbg_declare(ptr %3, !59, !DIExpression(), !61)
  store i32 0, ptr %3, align 4, !dbg !61
  br label %5, !dbg !62

5:                                                ; preds = %15, %1
  %6 = load i32, ptr %3, align 4, !dbg !63
  %7 = icmp slt i32 %6, 2, !dbg !65
  br i1 %7, label %8, label %18, !dbg !66

8:                                                ; preds = %5
    #dbg_declare(ptr %4, !67, !DIExpression(), !71)
  %9 = call ptr @malloc(i64 noundef 8) #4, !dbg !72
  store ptr %9, ptr %4, align 8, !dbg !71
  %10 = load ptr, ptr %4, align 8, !dbg !73
  %11 = icmp ne ptr %10, null, !dbg !73
  br i1 %11, label %13, label %12, !dbg !75

12:                                               ; preds = %8
  call void @exit(i32 noundef signext 1) #5, !dbg !76
  unreachable, !dbg !76

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 8, !dbg !78
  call void @ck_stack_push_upmc(ptr noundef @stack, ptr noundef %14), !dbg !79
  br label %15, !dbg !80

15:                                               ; preds = %13
  %16 = load i32, ptr %3, align 4, !dbg !81
  %17 = add nsw i32 %16, 1, !dbg !81
  store i32 %17, ptr %3, align 4, !dbg !81
  br label %5, !dbg !82, !llvm.loop !83

18:                                               ; preds = %5
  ret ptr null, !dbg !86
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !87 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !91, !DIExpression(), !92)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !93, !DIExpression(), !94)
    #dbg_declare(ptr %5, !95, !DIExpression(), !96)
  %6 = load ptr, ptr %3, align 8, !dbg !97
  %7 = getelementptr inbounds nuw %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !98
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !99
  store ptr %8, ptr %5, align 8, !dbg !100
  %9 = load ptr, ptr %5, align 8, !dbg !101
  %10 = load ptr, ptr %4, align 8, !dbg !102
  %11 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !103
  store ptr %9, ptr %11, align 8, !dbg !104
  call void @ck_pr_fence_store(), !dbg !105
  br label %12, !dbg !106

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 8, !dbg !107
  %14 = getelementptr inbounds nuw %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !108
  %15 = load ptr, ptr %5, align 8, !dbg !109
  %16 = load ptr, ptr %4, align 8, !dbg !110
  %17 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !111
  %18 = zext i1 %17 to i32, !dbg !111
  %19 = icmp eq i32 %18, 0, !dbg !112
  br i1 %19, label %20, label %24, !dbg !106

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 8, !dbg !113
  %22 = load ptr, ptr %4, align 8, !dbg !115
  %23 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !116
  store ptr %21, ptr %23, align 8, !dbg !117
  call void @ck_pr_fence_store(), !dbg !118
  br label %12, !dbg !106, !llvm.loop !119

24:                                               ; preds = %12
  ret void, !dbg !121
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @popper_fn(ptr noundef %0) #0 !dbg !122 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !123, !DIExpression(), !124)
    #dbg_declare(ptr %3, !125, !DIExpression(), !126)
  br label %4, !dbg !127

4:                                                ; preds = %7, %1
  %5 = call ptr @ck_stack_pop_upmc(ptr noundef @stack), !dbg !128
  store ptr %5, ptr %3, align 8, !dbg !129
  %6 = icmp eq ptr %5, null, !dbg !130
  br i1 %6, label %7, label %8, !dbg !127

7:                                                ; preds = %4
  br label %4, !dbg !127, !llvm.loop !131

8:                                                ; preds = %4
  %9 = load ptr, ptr %3, align 8, !dbg !133
  call void @free(ptr noundef %9), !dbg !134
  ret ptr null, !dbg !135
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_stack_pop_upmc(ptr noundef %0) #0 !dbg !136 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !139, !DIExpression(), !140)
    #dbg_declare(ptr %4, !141, !DIExpression(), !142)
    #dbg_declare(ptr %5, !143, !DIExpression(), !144)
  %6 = load ptr, ptr %3, align 8, !dbg !145
  %7 = getelementptr inbounds nuw %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !146
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !147
  store ptr %8, ptr %4, align 8, !dbg !148
  %9 = load ptr, ptr %4, align 8, !dbg !149
  %10 = icmp eq ptr %9, null, !dbg !151
  br i1 %10, label %11, label %12, !dbg !151

11:                                               ; preds = %1
  store ptr null, ptr %2, align 8, !dbg !152
  br label %34, !dbg !152

12:                                               ; preds = %1
  call void @ck_pr_fence_load(), !dbg !153
  %13 = load ptr, ptr %4, align 8, !dbg !154
  %14 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %13, i32 0, i32 0, !dbg !155
  %15 = load ptr, ptr %14, align 8, !dbg !155
  store ptr %15, ptr %5, align 8, !dbg !156
  br label %16, !dbg !157

16:                                               ; preds = %28, %12
  %17 = load ptr, ptr %3, align 8, !dbg !158
  %18 = getelementptr inbounds nuw %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !159
  %19 = load ptr, ptr %4, align 8, !dbg !160
  %20 = load ptr, ptr %5, align 8, !dbg !161
  %21 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %18, ptr noundef %19, ptr noundef %20, ptr noundef %4), !dbg !162
  %22 = zext i1 %21 to i32, !dbg !162
  %23 = icmp eq i32 %22, 0, !dbg !163
  br i1 %23, label %24, label %32, !dbg !157

24:                                               ; preds = %16
  %25 = load ptr, ptr %4, align 8, !dbg !164
  %26 = icmp eq ptr %25, null, !dbg !167
  br i1 %26, label %27, label %28, !dbg !167

27:                                               ; preds = %24
  br label %32, !dbg !168

28:                                               ; preds = %24
  call void @ck_pr_fence_load(), !dbg !169
  %29 = load ptr, ptr %4, align 8, !dbg !170
  %30 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %29, i32 0, i32 0, !dbg !171
  %31 = load ptr, ptr %30, align 8, !dbg !171
  store ptr %31, ptr %5, align 8, !dbg !172
  br label %16, !dbg !157, !llvm.loop !173

32:                                               ; preds = %27, %16
  %33 = load ptr, ptr %4, align 8, !dbg !175
  store ptr %33, ptr %2, align 8, !dbg !176
  br label %34, !dbg !176

34:                                               ; preds = %32, %11
  %35 = load ptr, ptr %2, align 8, !dbg !177
  ret ptr %35, !dbg !177
}

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !178 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x ptr], align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !181, !DIExpression(), !187)
    #dbg_declare(ptr %3, !188, !DIExpression(), !192)
    #dbg_declare(ptr %4, !193, !DIExpression(), !195)
  store i32 0, ptr %4, align 4, !dbg !195
  br label %8, !dbg !196

8:                                                ; preds = %19, %0
  %9 = load i32, ptr %4, align 4, !dbg !197
  %10 = icmp slt i32 %9, 1, !dbg !199
  br i1 %10, label %11, label %22, !dbg !200

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4, !dbg !201
  %13 = sext i32 %12 to i64, !dbg !204
  %14 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %13, !dbg !204
  %15 = call signext i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @pusher_fn, ptr noundef null), !dbg !205
  %16 = icmp ne i32 %15, 0, !dbg !206
  br i1 %16, label %17, label %18, !dbg !206

17:                                               ; preds = %11
  store i32 1, ptr %1, align 4, !dbg !207
  br label %68, !dbg !207

18:                                               ; preds = %11
  br label %19, !dbg !209

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4, !dbg !210
  %21 = add nsw i32 %20, 1, !dbg !210
  store i32 %21, ptr %4, align 4, !dbg !210
  br label %8, !dbg !211, !llvm.loop !212

22:                                               ; preds = %8
    #dbg_declare(ptr %5, !214, !DIExpression(), !216)
  store i32 0, ptr %5, align 4, !dbg !216
  br label %23, !dbg !217

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %5, align 4, !dbg !218
  %25 = icmp slt i32 %24, 2, !dbg !220
  br i1 %25, label %26, label %37, !dbg !221

26:                                               ; preds = %23
  %27 = load i32, ptr %5, align 4, !dbg !222
  %28 = sext i32 %27 to i64, !dbg !225
  %29 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %28, !dbg !225
  %30 = call signext i32 @pthread_create(ptr noundef %29, ptr noundef null, ptr noundef @popper_fn, ptr noundef null), !dbg !226
  %31 = icmp ne i32 %30, 0, !dbg !227
  br i1 %31, label %32, label %33, !dbg !227

32:                                               ; preds = %26
  store i32 1, ptr %1, align 4, !dbg !228
  br label %68, !dbg !228

33:                                               ; preds = %26
  br label %34, !dbg !230

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4, !dbg !231
  %36 = add nsw i32 %35, 1, !dbg !231
  store i32 %36, ptr %5, align 4, !dbg !231
  br label %23, !dbg !232, !llvm.loop !233

37:                                               ; preds = %23
    #dbg_declare(ptr %6, !235, !DIExpression(), !237)
  store i32 0, ptr %6, align 4, !dbg !237
  br label %38, !dbg !238

38:                                               ; preds = %47, %37
  %39 = load i32, ptr %6, align 4, !dbg !239
  %40 = icmp slt i32 %39, 1, !dbg !241
  br i1 %40, label %41, label %50, !dbg !242

41:                                               ; preds = %38
  %42 = load i32, ptr %6, align 4, !dbg !243
  %43 = sext i32 %42 to i64, !dbg !245
  %44 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %43, !dbg !245
  %45 = load ptr, ptr %44, align 8, !dbg !245
  %46 = call signext i32 @pthread_join(ptr noundef %45, ptr noundef null), !dbg !246
  br label %47, !dbg !247

47:                                               ; preds = %41
  %48 = load i32, ptr %6, align 4, !dbg !248
  %49 = add nsw i32 %48, 1, !dbg !248
  store i32 %49, ptr %6, align 4, !dbg !248
  br label %38, !dbg !249, !llvm.loop !250

50:                                               ; preds = %38
    #dbg_declare(ptr %7, !252, !DIExpression(), !254)
  store i32 0, ptr %7, align 4, !dbg !254
  br label %51, !dbg !255

51:                                               ; preds = %60, %50
  %52 = load i32, ptr %7, align 4, !dbg !256
  %53 = icmp slt i32 %52, 2, !dbg !258
  br i1 %53, label %54, label %63, !dbg !259

54:                                               ; preds = %51
  %55 = load i32, ptr %7, align 4, !dbg !260
  %56 = sext i32 %55 to i64, !dbg !262
  %57 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %56, !dbg !262
  %58 = load ptr, ptr %57, align 8, !dbg !262
  %59 = call signext i32 @pthread_join(ptr noundef %58, ptr noundef null), !dbg !263
  br label %60, !dbg !264

60:                                               ; preds = %54
  %61 = load i32, ptr %7, align 4, !dbg !265
  %62 = add nsw i32 %61, 1, !dbg !265
  store i32 %62, ptr %7, align 4, !dbg !265
  br label %51, !dbg !266, !llvm.loop !267

63:                                               ; preds = %51
  %64 = load ptr, ptr @stack, align 8, !dbg !269
  %65 = icmp eq ptr %64, null, !dbg !269
  br i1 %65, label %67, label %66, !dbg !272

66:                                               ; preds = %63
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 71, ptr noundef @__func__.main), !dbg !272
  br label %67, !dbg !272

67:                                               ; preds = %66, %63
  store i32 0, ptr %1, align 4, !dbg !273
  br label %68, !dbg !273

68:                                               ; preds = %67, %32, %17
  %69 = load i32, ptr %1, align 4, !dbg !274
  ret i32 %69, !dbg !274
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #3

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !275 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !281, !DIExpression(), !282)
    #dbg_declare(ptr %3, !283, !DIExpression(), !282)
  %4 = load ptr, ptr %2, align 8, !dbg !282
  %5 = call ptr asm sideeffect "ld${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #6, !dbg !282, !srcloc !284
  store ptr %5, ptr %3, align 8, !dbg !282
  %6 = load ptr, ptr %3, align 8, !dbg !282
  ret ptr %6, !dbg !282
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_store() #0 !dbg !285 {
  call void @ck_pr_fence_strict_store(), !dbg !289
  ret void, !dbg !289
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !290 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !293, !DIExpression(), !294)
  store ptr %1, ptr %6, align 8
    #dbg_declare(ptr %6, !295, !DIExpression(), !296)
  store ptr %2, ptr %7, align 8
    #dbg_declare(ptr %7, !297, !DIExpression(), !298)
  store ptr %3, ptr %8, align 8
    #dbg_declare(ptr %8, !299, !DIExpression(), !300)
    #dbg_declare(ptr %9, !301, !DIExpression(), !302)
  %10 = load ptr, ptr %5, align 8, !dbg !303
  %11 = load ptr, ptr %7, align 8, !dbg !304
  %12 = load ptr, ptr %6, align 8, !dbg !305
  %13 = call ptr asm sideeffect "1:ldarx $0, 0, $1;cmpd  0, $0, $3;bne-  2f;stdcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, ptr %11, ptr %12) #6, !dbg !306, !srcloc !307
  store ptr %13, ptr %9, align 8, !dbg !306
  %14 = load ptr, ptr %8, align 8, !dbg !308
  %15 = load ptr, ptr %9, align 8, !dbg !309
  call void @ck_pr_md_store_ptr(ptr noundef %14, ptr noundef %15), !dbg !310
  %16 = load ptr, ptr %9, align 8, !dbg !311
  %17 = load ptr, ptr %6, align 8, !dbg !312
  %18 = icmp eq ptr %16, %17, !dbg !313
  ret i1 %18, !dbg !314
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_store() #0 !dbg !315 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !316, !srcloc !317
  ret void, !dbg !316
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !318 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !321, !DIExpression(), !322)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !323, !DIExpression(), !322)
  %5 = load ptr, ptr %3, align 8, !dbg !322
  %6 = load ptr, ptr %4, align 8, !dbg !322
  call void asm sideeffect "std${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #6, !dbg !322, !srcloc !324
  ret void, !dbg !322
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_load() #0 !dbg !325 {
  call void @ck_pr_fence_strict_load(), !dbg !326
  ret void, !dbg !326
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_load() #0 !dbg !327 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !328, !srcloc !329
  ret void, !dbg !328
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack", scope: !2, file: !3, line: 16, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !21, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/stack_empty.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "99be8c5b41f0b7504e3cdccabae5429a")
!4 = !{!5, !6, !7, !12, !15, !20}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !9, line: 35, size: 64, elements: !10)
!9 = !DIFile(filename: "../ck/include/ck_stack.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!10 = !{!11}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !8, file: !9, line: 36, baseType: !7, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !13, line: 4, baseType: !14)
!13 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!14 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!19 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!21 = !{!0, !22, !28, !33}
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 200, elements: !26)
!25 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!26 = !{!27}
!27 = !DISubrange(count: 25)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 224, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 28)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 40, elements: !37)
!36 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!37 = !{!38}
!38 = !DISubrange(count: 5)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !9, line: 44, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !9, line: 40, size: 128, elements: !41)
!41 = !{!42, !43}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !40, file: !9, line: 41, baseType: !7, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !40, file: !9, line: 42, baseType: !44, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 8, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Homebrew clang version 22.1.8"}
!53 = distinct !DISubprogram(name: "pusher_fn", scope: !3, file: !3, line: 18, type: !54, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!5, !5}
!56 = !{}
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !3, line: 18, type: !5)
!58 = !DILocation(line: 18, column: 23, scope: !53)
!59 = !DILocalVariable(name: "i", scope: !60, file: !3, line: 20, type: !6)
!60 = distinct !DILexicalBlock(scope: !53, file: !3, line: 20, column: 5)
!61 = !DILocation(line: 20, column: 14, scope: !60)
!62 = !DILocation(line: 20, column: 10, scope: !60)
!63 = !DILocation(line: 20, column: 21, scope: !64)
!64 = distinct !DILexicalBlock(scope: !60, file: !3, line: 20, column: 5)
!65 = !DILocation(line: 20, column: 23, scope: !64)
!66 = !DILocation(line: 20, column: 5, scope: !60)
!67 = !DILocalVariable(name: "entry", scope: !68, file: !3, line: 22, type: !69)
!68 = distinct !DILexicalBlock(scope: !64, file: !3, line: 21, column: 5)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !9, line: 38, baseType: !8)
!71 = !DILocation(line: 22, column: 27, scope: !68)
!72 = !DILocation(line: 22, column: 35, scope: !68)
!73 = !DILocation(line: 23, column: 14, scope: !74)
!74 = distinct !DILexicalBlock(scope: !68, file: !3, line: 23, column: 13)
!75 = !DILocation(line: 23, column: 13, scope: !74)
!76 = !DILocation(line: 25, column: 13, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !3, line: 24, column: 9)
!78 = !DILocation(line: 27, column: 36, scope: !68)
!79 = !DILocation(line: 27, column: 9, scope: !68)
!80 = !DILocation(line: 28, column: 5, scope: !68)
!81 = !DILocation(line: 20, column: 39, scope: !64)
!82 = !DILocation(line: 20, column: 5, scope: !64)
!83 = distinct !{!83, !66, !84, !85}
!84 = !DILocation(line: 28, column: 5, scope: !60)
!85 = !{!"llvm.loop.mustprogress"}
!86 = !DILocation(line: 29, column: 5, scope: !53)
!87 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !9, file: !9, line: 54, type: !88, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !90, !7}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!91 = !DILocalVariable(name: "target", arg: 1, scope: !87, file: !9, line: 54, type: !90)
!92 = !DILocation(line: 54, column: 37, scope: !87)
!93 = !DILocalVariable(name: "entry", arg: 2, scope: !87, file: !9, line: 54, type: !7)
!94 = !DILocation(line: 54, column: 68, scope: !87)
!95 = !DILocalVariable(name: "stack", scope: !87, file: !9, line: 56, type: !7)
!96 = !DILocation(line: 56, column: 25, scope: !87)
!97 = !DILocation(line: 58, column: 26, scope: !87)
!98 = !DILocation(line: 58, column: 34, scope: !87)
!99 = !DILocation(line: 58, column: 10, scope: !87)
!100 = !DILocation(line: 58, column: 8, scope: !87)
!101 = !DILocation(line: 59, column: 16, scope: !87)
!102 = !DILocation(line: 59, column: 2, scope: !87)
!103 = !DILocation(line: 59, column: 9, scope: !87)
!104 = !DILocation(line: 59, column: 14, scope: !87)
!105 = !DILocation(line: 60, column: 2, scope: !87)
!106 = !DILocation(line: 62, column: 2, scope: !87)
!107 = !DILocation(line: 62, column: 30, scope: !87)
!108 = !DILocation(line: 62, column: 38, scope: !87)
!109 = !DILocation(line: 62, column: 44, scope: !87)
!110 = !DILocation(line: 62, column: 51, scope: !87)
!111 = !DILocation(line: 62, column: 9, scope: !87)
!112 = !DILocation(line: 62, column: 66, scope: !87)
!113 = !DILocation(line: 63, column: 17, scope: !114)
!114 = distinct !DILexicalBlock(scope: !87, file: !9, line: 62, column: 76)
!115 = !DILocation(line: 63, column: 3, scope: !114)
!116 = !DILocation(line: 63, column: 10, scope: !114)
!117 = !DILocation(line: 63, column: 15, scope: !114)
!118 = !DILocation(line: 64, column: 3, scope: !114)
!119 = distinct !{!119, !106, !120, !85}
!120 = !DILocation(line: 65, column: 2, scope: !87)
!121 = !DILocation(line: 67, column: 2, scope: !87)
!122 = distinct !DISubprogram(name: "popper_fn", scope: !3, file: !3, line: 32, type: !54, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!123 = !DILocalVariable(name: "arg", arg: 1, scope: !122, file: !3, line: 32, type: !5)
!124 = !DILocation(line: 32, column: 23, scope: !122)
!125 = !DILocalVariable(name: "entry", scope: !122, file: !3, line: 34, type: !69)
!126 = !DILocation(line: 34, column: 23, scope: !122)
!127 = !DILocation(line: 35, column: 5, scope: !122)
!128 = !DILocation(line: 35, column: 20, scope: !122)
!129 = !DILocation(line: 35, column: 18, scope: !122)
!130 = !DILocation(line: 35, column: 47, scope: !122)
!131 = distinct !{!131, !127, !132, !85}
!132 = !DILocation(line: 35, column: 55, scope: !122)
!133 = !DILocation(line: 36, column: 10, scope: !122)
!134 = !DILocation(line: 36, column: 5, scope: !122)
!135 = !DILocation(line: 37, column: 5, scope: !122)
!136 = distinct !DISubprogram(name: "ck_stack_pop_upmc", scope: !9, file: !9, line: 96, type: !137, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!137 = !DISubroutineType(types: !138)
!138 = !{!7, !90}
!139 = !DILocalVariable(name: "target", arg: 1, scope: !136, file: !9, line: 96, type: !90)
!140 = !DILocation(line: 96, column: 36, scope: !136)
!141 = !DILocalVariable(name: "entry", scope: !136, file: !9, line: 98, type: !7)
!142 = !DILocation(line: 98, column: 25, scope: !136)
!143 = !DILocalVariable(name: "next", scope: !136, file: !9, line: 98, type: !7)
!144 = !DILocation(line: 98, column: 33, scope: !136)
!145 = !DILocation(line: 100, column: 26, scope: !136)
!146 = !DILocation(line: 100, column: 34, scope: !136)
!147 = !DILocation(line: 100, column: 10, scope: !136)
!148 = !DILocation(line: 100, column: 8, scope: !136)
!149 = !DILocation(line: 101, column: 6, scope: !150)
!150 = distinct !DILexicalBlock(scope: !136, file: !9, line: 101, column: 6)
!151 = !DILocation(line: 101, column: 12, scope: !150)
!152 = !DILocation(line: 102, column: 3, scope: !150)
!153 = !DILocation(line: 104, column: 2, scope: !136)
!154 = !DILocation(line: 105, column: 9, scope: !136)
!155 = !DILocation(line: 105, column: 16, scope: !136)
!156 = !DILocation(line: 105, column: 7, scope: !136)
!157 = !DILocation(line: 106, column: 2, scope: !136)
!158 = !DILocation(line: 106, column: 30, scope: !136)
!159 = !DILocation(line: 106, column: 38, scope: !136)
!160 = !DILocation(line: 106, column: 44, scope: !136)
!161 = !DILocation(line: 106, column: 51, scope: !136)
!162 = !DILocation(line: 106, column: 9, scope: !136)
!163 = !DILocation(line: 106, column: 65, scope: !136)
!164 = !DILocation(line: 107, column: 7, scope: !165)
!165 = distinct !DILexicalBlock(scope: !166, file: !9, line: 107, column: 7)
!166 = distinct !DILexicalBlock(scope: !136, file: !9, line: 106, column: 75)
!167 = !DILocation(line: 107, column: 13, scope: !165)
!168 = !DILocation(line: 108, column: 4, scope: !165)
!169 = !DILocation(line: 110, column: 3, scope: !166)
!170 = !DILocation(line: 111, column: 10, scope: !166)
!171 = !DILocation(line: 111, column: 17, scope: !166)
!172 = !DILocation(line: 111, column: 8, scope: !166)
!173 = distinct !{!173, !157, !174, !85}
!174 = !DILocation(line: 112, column: 2, scope: !136)
!175 = !DILocation(line: 114, column: 9, scope: !136)
!176 = !DILocation(line: 114, column: 2, scope: !136)
!177 = !DILocation(line: 115, column: 1, scope: !136)
!178 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !179, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!179 = !DISubroutineType(types: !180)
!180 = !{!6}
!181 = !DILocalVariable(name: "pushers", scope: !178, file: !3, line: 42, type: !182)
!182 = !DICompositeType(tag: DW_TAG_array_type, baseType: !183, size: 64, elements: !185)
!183 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !184, line: 2, baseType: !5)
!184 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!185 = !{!186}
!186 = !DISubrange(count: 1)
!187 = !DILocation(line: 42, column: 15, scope: !178)
!188 = !DILocalVariable(name: "poppers", scope: !178, file: !3, line: 43, type: !189)
!189 = !DICompositeType(tag: DW_TAG_array_type, baseType: !183, size: 128, elements: !190)
!190 = !{!191}
!191 = !DISubrange(count: 2)
!192 = !DILocation(line: 43, column: 15, scope: !178)
!193 = !DILocalVariable(name: "i", scope: !194, file: !3, line: 45, type: !6)
!194 = distinct !DILexicalBlock(scope: !178, file: !3, line: 45, column: 5)
!195 = !DILocation(line: 45, column: 14, scope: !194)
!196 = !DILocation(line: 45, column: 10, scope: !194)
!197 = !DILocation(line: 45, column: 21, scope: !198)
!198 = distinct !DILexicalBlock(scope: !194, file: !3, line: 45, column: 5)
!199 = !DILocation(line: 45, column: 23, scope: !198)
!200 = !DILocation(line: 45, column: 5, scope: !194)
!201 = !DILocation(line: 47, column: 37, scope: !202)
!202 = distinct !DILexicalBlock(scope: !203, file: !3, line: 47, column: 13)
!203 = distinct !DILexicalBlock(scope: !198, file: !3, line: 46, column: 5)
!204 = !DILocation(line: 47, column: 29, scope: !202)
!205 = !DILocation(line: 47, column: 13, scope: !202)
!206 = !DILocation(line: 47, column: 64, scope: !202)
!207 = !DILocation(line: 49, column: 13, scope: !208)
!208 = distinct !DILexicalBlock(scope: !202, file: !3, line: 48, column: 9)
!209 = !DILocation(line: 51, column: 5, scope: !203)
!210 = !DILocation(line: 45, column: 39, scope: !198)
!211 = !DILocation(line: 45, column: 5, scope: !198)
!212 = distinct !{!212, !200, !213, !85}
!213 = !DILocation(line: 51, column: 5, scope: !194)
!214 = !DILocalVariable(name: "i", scope: !215, file: !3, line: 53, type: !6)
!215 = distinct !DILexicalBlock(scope: !178, file: !3, line: 53, column: 5)
!216 = !DILocation(line: 53, column: 14, scope: !215)
!217 = !DILocation(line: 53, column: 10, scope: !215)
!218 = !DILocation(line: 53, column: 21, scope: !219)
!219 = distinct !DILexicalBlock(scope: !215, file: !3, line: 53, column: 5)
!220 = !DILocation(line: 53, column: 23, scope: !219)
!221 = !DILocation(line: 53, column: 5, scope: !215)
!222 = !DILocation(line: 55, column: 37, scope: !223)
!223 = distinct !DILexicalBlock(scope: !224, file: !3, line: 55, column: 13)
!224 = distinct !DILexicalBlock(scope: !219, file: !3, line: 54, column: 5)
!225 = !DILocation(line: 55, column: 29, scope: !223)
!226 = !DILocation(line: 55, column: 13, scope: !223)
!227 = !DILocation(line: 55, column: 64, scope: !223)
!228 = !DILocation(line: 57, column: 13, scope: !229)
!229 = distinct !DILexicalBlock(scope: !223, file: !3, line: 56, column: 9)
!230 = !DILocation(line: 59, column: 5, scope: !224)
!231 = !DILocation(line: 53, column: 39, scope: !219)
!232 = !DILocation(line: 53, column: 5, scope: !219)
!233 = distinct !{!233, !221, !234, !85}
!234 = !DILocation(line: 59, column: 5, scope: !215)
!235 = !DILocalVariable(name: "i", scope: !236, file: !3, line: 61, type: !6)
!236 = distinct !DILexicalBlock(scope: !178, file: !3, line: 61, column: 5)
!237 = !DILocation(line: 61, column: 14, scope: !236)
!238 = !DILocation(line: 61, column: 10, scope: !236)
!239 = !DILocation(line: 61, column: 21, scope: !240)
!240 = distinct !DILexicalBlock(scope: !236, file: !3, line: 61, column: 5)
!241 = !DILocation(line: 61, column: 23, scope: !240)
!242 = !DILocation(line: 61, column: 5, scope: !236)
!243 = !DILocation(line: 63, column: 30, scope: !244)
!244 = distinct !DILexicalBlock(scope: !240, file: !3, line: 62, column: 5)
!245 = !DILocation(line: 63, column: 22, scope: !244)
!246 = !DILocation(line: 63, column: 9, scope: !244)
!247 = !DILocation(line: 64, column: 5, scope: !244)
!248 = !DILocation(line: 61, column: 39, scope: !240)
!249 = !DILocation(line: 61, column: 5, scope: !240)
!250 = distinct !{!250, !242, !251, !85}
!251 = !DILocation(line: 64, column: 5, scope: !236)
!252 = !DILocalVariable(name: "i", scope: !253, file: !3, line: 66, type: !6)
!253 = distinct !DILexicalBlock(scope: !178, file: !3, line: 66, column: 5)
!254 = !DILocation(line: 66, column: 14, scope: !253)
!255 = !DILocation(line: 66, column: 10, scope: !253)
!256 = !DILocation(line: 66, column: 21, scope: !257)
!257 = distinct !DILexicalBlock(scope: !253, file: !3, line: 66, column: 5)
!258 = !DILocation(line: 66, column: 23, scope: !257)
!259 = !DILocation(line: 66, column: 5, scope: !253)
!260 = !DILocation(line: 68, column: 30, scope: !261)
!261 = distinct !DILexicalBlock(scope: !257, file: !3, line: 67, column: 5)
!262 = !DILocation(line: 68, column: 22, scope: !261)
!263 = !DILocation(line: 68, column: 9, scope: !261)
!264 = !DILocation(line: 69, column: 5, scope: !261)
!265 = !DILocation(line: 66, column: 39, scope: !257)
!266 = !DILocation(line: 66, column: 5, scope: !257)
!267 = distinct !{!267, !259, !268, !85}
!268 = !DILocation(line: 69, column: 5, scope: !253)
!269 = !DILocation(line: 71, column: 12, scope: !270)
!270 = distinct !DILexicalBlock(scope: !271, file: !3, line: 71, column: 5)
!271 = distinct !DILexicalBlock(scope: !178, file: !3, line: 71, column: 5)
!272 = !DILocation(line: 71, column: 5, scope: !270)
!273 = !DILocation(line: 73, column: 5, scope: !178)
!274 = !DILocation(line: 74, column: 1, scope: !178)
!275 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !276, file: !276, line: 103, type: !277, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!276 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!277 = !DISubroutineType(types: !278)
!278 = !{!5, !279}
!279 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !280, size: 64)
!280 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!281 = !DILocalVariable(name: "target", arg: 1, scope: !275, file: !276, line: 103, type: !279)
!282 = !DILocation(line: 103, column: 1, scope: !275)
!283 = !DILocalVariable(name: "r", scope: !275, file: !276, line: 103, type: !5)
!284 = !{i64 2147585225}
!285 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !286, file: !286, line: 117, type: !287, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!286 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!287 = !DISubroutineType(types: !288)
!288 = !{null}
!289 = !DILocation(line: 117, column: 1, scope: !285)
!290 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !276, file: !276, line: 175, type: !291, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!291 = !DISubroutineType(types: !292)
!292 = !{!12, !5, !5, !5, !5}
!293 = !DILocalVariable(name: "target", arg: 1, scope: !290, file: !276, line: 175, type: !5)
!294 = !DILocation(line: 175, column: 27, scope: !290)
!295 = !DILocalVariable(name: "compare", arg: 2, scope: !290, file: !276, line: 175, type: !5)
!296 = !DILocation(line: 175, column: 41, scope: !290)
!297 = !DILocalVariable(name: "set", arg: 3, scope: !290, file: !276, line: 175, type: !5)
!298 = !DILocation(line: 175, column: 56, scope: !290)
!299 = !DILocalVariable(name: "value", arg: 4, scope: !290, file: !276, line: 175, type: !5)
!300 = !DILocation(line: 175, column: 67, scope: !290)
!301 = !DILocalVariable(name: "previous", scope: !290, file: !276, line: 177, type: !5)
!302 = !DILocation(line: 177, column: 8, scope: !290)
!303 = !DILocation(line: 187, column: 42, scope: !290)
!304 = !DILocation(line: 188, column: 14, scope: !290)
!305 = !DILocation(line: 189, column: 42, scope: !290)
!306 = !DILocation(line: 179, column: 9, scope: !290)
!307 = !{i64 89341}
!308 = !DILocation(line: 192, column: 28, scope: !290)
!309 = !DILocation(line: 192, column: 35, scope: !290)
!310 = !DILocation(line: 192, column: 9, scope: !290)
!311 = !DILocation(line: 193, column: 17, scope: !290)
!312 = !DILocation(line: 193, column: 29, scope: !290)
!313 = !DILocation(line: 193, column: 26, scope: !290)
!314 = !DILocation(line: 193, column: 9, scope: !290)
!315 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !276, file: !276, line: 78, type: !287, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!316 = !DILocation(line: 78, column: 1, scope: !315)
!317 = !{i64 2147583089}
!318 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !276, file: !276, line: 133, type: !319, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!319 = !DISubroutineType(types: !320)
!320 = !{null, !5, !279}
!321 = !DILocalVariable(name: "target", arg: 1, scope: !318, file: !276, line: 133, type: !5)
!322 = !DILocation(line: 133, column: 1, scope: !318)
!323 = !DILocalVariable(name: "v", arg: 2, scope: !318, file: !276, line: 133, type: !279)
!324 = !{i64 2147589117}
!325 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !286, file: !286, line: 116, type: !287, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!326 = !DILocation(line: 116, column: 1, scope: !325)
!327 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !276, file: !276, line: 80, type: !287, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!328 = !DILocation(line: 80, column: 1, scope: !327)
!329 = !{i64 2147583490}
