; ModuleID = 'benchmarks/interrupts/c11_large.c'
source_filename = "benchmarks/interrupts/c11_large.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@__func__.reach = private unnamed_addr constant [6 x i8] c"reach\00", align 1, !dbg !0
@.str = private unnamed_addr constant [12 x i8] c"c11_large.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [33 x i8] c"VARIANT != variant || !condition\00", align 1, !dbg !11
@__func__.safe = private unnamed_addr constant [5 x i8] c"safe\00", align 1, !dbg !16
@.str.2 = private unnamed_addr constant [26 x i8] c"VARIANT != 0 || condition\00", align 1, !dbg !21
@x = global i32 0, align 4, !dbg !26
@z = global i32 0, align 4, !dbg !35
@y = global i32 0, align 4, !dbg !32

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @reach(i32 noundef %0, i32 noundef %1) #0 !dbg !47 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !51, !DIExpression(), !52)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !53, !DIExpression(), !54)
  %5 = load i32, ptr %3, align 4, !dbg !55
  %6 = icmp ne i32 0, %5, !dbg !55
  br i1 %6, label %11, label %7, !dbg !55

7:                                                ; preds = %2
  %8 = load i32, ptr %4, align 4, !dbg !55
  %9 = icmp ne i32 %8, 0, !dbg !55
  %10 = xor i1 %9, true, !dbg !55
  br label %11, !dbg !55

11:                                               ; preds = %7, %2
  %12 = phi i1 [ true, %2 ], [ %10, %7 ]
  %13 = xor i1 %12, true, !dbg !55
  %14 = zext i1 %13 to i32, !dbg !55
  %15 = sext i32 %14 to i64, !dbg !55
  %16 = icmp ne i64 %15, 0, !dbg !55
  br i1 %16, label %17, label %19, !dbg !55

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.reach, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #3, !dbg !55
  unreachable, !dbg !55

18:                                               ; No predecessors!
  br label %20, !dbg !55

19:                                               ; preds = %11
  br label %20, !dbg !55

20:                                               ; preds = %19, %18
  ret void, !dbg !56
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @safe(i32 noundef %0) #0 !dbg !57 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !60, !DIExpression(), !61)
  %3 = load i32, ptr %2, align 4, !dbg !62
  %4 = icmp ne i32 %3, 0, !dbg !62
  %5 = xor i1 %4, true, !dbg !62
  %6 = zext i1 %5 to i32, !dbg !62
  %7 = sext i32 %6 to i64, !dbg !62
  %8 = icmp ne i64 %7, 0, !dbg !62
  br i1 %8, label %9, label %11, !dbg !62

9:                                                ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.safe, ptr noundef @.str, i32 noundef 22, ptr noundef @.str.2) #3, !dbg !62
  unreachable, !dbg !62

10:                                               ; No predecessors!
  br label %12, !dbg !62

11:                                               ; preds = %1
  br label %12, !dbg !62

12:                                               ; preds = %11, %10
  ret void, !dbg !63
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler0(ptr noundef %0) #0 !dbg !64 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !67, !DIExpression(), !68)
  call void @__VERIFIER_disable_irq(), !dbg !69
  %4 = load i32, ptr @x, align 4, !dbg !70
  %5 = and i32 %4, 17, !dbg !71
  %6 = icmp eq i32 %5, 17, !dbg !72
  br i1 %6, label %7, label %12, !dbg !73

7:                                                ; preds = %1
  %8 = load atomic i32, ptr @z seq_cst, align 4, !dbg !74
  store i32 %8, ptr %3, align 4, !dbg !74
  %9 = load i32, ptr %3, align 4, !dbg !74
  %10 = and i32 %9, 1, !dbg !75
  %11 = icmp eq i32 %10, 1, !dbg !76
  br label %12

12:                                               ; preds = %7, %1
  %13 = phi i1 [ false, %1 ], [ %11, %7 ], !dbg !77
  %14 = zext i1 %13 to i32, !dbg !73
  call void @safe(i32 noundef %14), !dbg !78
  %15 = load i32, ptr @x, align 4, !dbg !79
  %16 = or i32 %15, 256, !dbg !79
  store i32 %16, ptr @x, align 4, !dbg !79
  %17 = load i32, ptr @x, align 4, !dbg !80
  %18 = or i32 %17, 512, !dbg !80
  store i32 %18, ptr @x, align 4, !dbg !80
  ret ptr null, !dbg !81
}

declare void @__VERIFIER_disable_irq() #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler1(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  %4 = load i32, ptr @x, align 4, !dbg !85
  %5 = and i32 %4, 1, !dbg !86
  %6 = icmp eq i32 %5, 1, !dbg !87
  %7 = zext i1 %6 to i32, !dbg !87
  call void @safe(i32 noundef %7), !dbg !88
  %8 = load i32, ptr @x, align 4, !dbg !89
  %9 = and i32 %8, 4096, !dbg !90
  %10 = icmp eq i32 %9, 0, !dbg !91
  %11 = zext i1 %10 to i32, !dbg !91
  %12 = load i32, ptr @x, align 4, !dbg !92
  %13 = and i32 %12, 8192, !dbg !93
  %14 = icmp eq i32 %13, 0, !dbg !94
  %15 = zext i1 %14 to i32, !dbg !94
  %16 = icmp eq i32 %11, %15, !dbg !95
  %17 = zext i1 %16 to i32, !dbg !95
  call void @safe(i32 noundef %17), !dbg !96
  %18 = load i32, ptr @x, align 4, !dbg !97
  %19 = and i32 %18, 12288, !dbg !98
  %20 = icmp eq i32 %19, 0, !dbg !99
  %21 = zext i1 %20 to i32, !dbg !99
  call void @reach(i32 noundef 1, i32 noundef %21), !dbg !100
  %22 = load i32, ptr @x, align 4, !dbg !101
  %23 = and i32 %22, 12288, !dbg !102
  %24 = icmp eq i32 %23, 12288, !dbg !103
  %25 = zext i1 %24 to i32, !dbg !103
  call void @reach(i32 noundef 2, i32 noundef %25), !dbg !104
  %26 = load i32, ptr @x, align 4, !dbg !105
  %27 = or i32 %26, 16, !dbg !105
  store i32 %27, ptr @x, align 4, !dbg !105
  call void @__VERIFIER_make_cb(), !dbg !106
  call void @__VERIFIER_make_interrupt_handler(), !dbg !107
    #dbg_declare(ptr %3, !108, !DIExpression(), !132)
  %28 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler0, ptr noundef null), !dbg !133
  call void @__VERIFIER_make_cb(), !dbg !134
  call void @__VERIFIER_disable_irq(), !dbg !135
  %29 = load i32, ptr @x, align 4, !dbg !136
  %30 = or i32 %29, 32, !dbg !136
  store i32 %30, ptr @x, align 4, !dbg !136
  call void @__VERIFIER_make_cb(), !dbg !137
  %31 = load i32, ptr @x, align 4, !dbg !138
  %32 = or i32 %31, 64, !dbg !138
  store i32 %32, ptr @x, align 4, !dbg !138
  call void @__VERIFIER_make_cb(), !dbg !139
  call void @__VERIFIER_enable_irq(), !dbg !140
  call void @__VERIFIER_disable_irq(), !dbg !141
  call void @__VERIFIER_make_cb(), !dbg !142
  %33 = load i32, ptr @x, align 4, !dbg !143
  %34 = or i32 %33, 128, !dbg !143
  store i32 %34, ptr @x, align 4, !dbg !143
  %35 = load i32, ptr @x, align 4, !dbg !144
  %36 = and i32 %35, 768, !dbg !145
  %37 = icmp ne i32 %36, 768, !dbg !146
  %38 = zext i1 %37 to i32, !dbg !146
  call void @reach(i32 noundef 3, i32 noundef %38), !dbg !147
  ret ptr null, !dbg !148
}

declare void @__VERIFIER_make_cb() #2

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare void @__VERIFIER_enable_irq() #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler2(ptr noundef %0) #0 !dbg !149 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !150, !DIExpression(), !151)
  call void @__VERIFIER_disable_irq(), !dbg !152
  %7 = load i32, ptr @x, align 4, !dbg !153
  %8 = and i32 %7, 1, !dbg !154
  %9 = icmp eq i32 %8, 1, !dbg !155
  %10 = zext i1 %9 to i32, !dbg !155
  call void @safe(i32 noundef %10), !dbg !156
    #dbg_declare(ptr %3, !157, !DIExpression(), !158)
  %11 = load i32, ptr @x, align 4, !dbg !159
  %12 = and i32 %11, 14, !dbg !160
  store i32 %12, ptr %3, align 4, !dbg !158
    #dbg_declare(ptr %4, !161, !DIExpression(), !162)
  %13 = load atomic i32, ptr @z seq_cst, align 4, !dbg !163
  store i32 %13, ptr %5, align 4, !dbg !163
  %14 = load i32, ptr %5, align 4, !dbg !163
  %15 = and i32 %14, 242, !dbg !164
  store i32 %15, ptr %4, align 4, !dbg !162
  %16 = load i32, ptr %3, align 4, !dbg !165
  %17 = icmp eq i32 %16, 0, !dbg !166
  br i1 %17, label %18, label %21, !dbg !167

18:                                               ; preds = %1
  %19 = load i32, ptr %4, align 4, !dbg !168
  %20 = icmp eq i32 %19, 0, !dbg !169
  br label %21

21:                                               ; preds = %18, %1
  %22 = phi i1 [ false, %1 ], [ %20, %18 ], !dbg !170
  %23 = zext i1 %22 to i32, !dbg !167
  call void @reach(i32 noundef 4, i32 noundef %23), !dbg !171
  %24 = load i32, ptr %3, align 4, !dbg !172
  %25 = icmp eq i32 %24, 0, !dbg !173
  br i1 %25, label %26, label %29, !dbg !174

26:                                               ; preds = %21
  %27 = load i32, ptr %4, align 4, !dbg !175
  %28 = icmp eq i32 %27, 2, !dbg !176
  br label %29

29:                                               ; preds = %26, %21
  %30 = phi i1 [ false, %21 ], [ %28, %26 ], !dbg !170
  %31 = zext i1 %30 to i32, !dbg !174
  call void @reach(i32 noundef 5, i32 noundef %31), !dbg !177
  %32 = load i32, ptr %3, align 4, !dbg !178
  %33 = icmp eq i32 %32, 2, !dbg !179
  br i1 %33, label %34, label %37, !dbg !180

34:                                               ; preds = %29
  %35 = load i32, ptr %4, align 4, !dbg !181
  %36 = icmp eq i32 %35, 0, !dbg !182
  br label %37

37:                                               ; preds = %34, %29
  %38 = phi i1 [ false, %29 ], [ %36, %34 ], !dbg !170
  %39 = zext i1 %38 to i32, !dbg !180
  call void @reach(i32 noundef 6, i32 noundef %39), !dbg !183
  %40 = load i32, ptr %3, align 4, !dbg !184
  %41 = icmp eq i32 %40, 2, !dbg !185
  br i1 %41, label %42, label %45, !dbg !186

42:                                               ; preds = %37
  %43 = load i32, ptr %4, align 4, !dbg !187
  %44 = icmp eq i32 %43, 2, !dbg !188
  br label %45

45:                                               ; preds = %42, %37
  %46 = phi i1 [ false, %37 ], [ %44, %42 ], !dbg !170
  %47 = zext i1 %46 to i32, !dbg !186
  call void @reach(i32 noundef 7, i32 noundef %47), !dbg !189
  %48 = load i32, ptr %3, align 4, !dbg !190
  %49 = icmp eq i32 %48, 6, !dbg !191
  br i1 %49, label %50, label %53, !dbg !192

50:                                               ; preds = %45
  %51 = load i32, ptr %4, align 4, !dbg !193
  %52 = icmp eq i32 %51, 2, !dbg !194
  br label %53

53:                                               ; preds = %50, %45
  %54 = phi i1 [ false, %45 ], [ %52, %50 ], !dbg !170
  %55 = zext i1 %54 to i32, !dbg !192
  call void @reach(i32 noundef 8, i32 noundef %55), !dbg !195
  %56 = load i32, ptr %3, align 4, !dbg !196
  %57 = icmp eq i32 %56, 6, !dbg !197
  br i1 %57, label %58, label %61, !dbg !198

58:                                               ; preds = %53
  %59 = load i32, ptr %4, align 4, !dbg !199
  %60 = icmp eq i32 %59, 242, !dbg !200
  br label %61

61:                                               ; preds = %58, %53
  %62 = phi i1 [ false, %53 ], [ %60, %58 ], !dbg !170
  %63 = zext i1 %62 to i32, !dbg !198
  call void @reach(i32 noundef 9, i32 noundef %63), !dbg !201
  %64 = load i32, ptr %3, align 4, !dbg !202
  %65 = icmp eq i32 %64, 14, !dbg !203
  br i1 %65, label %66, label %69, !dbg !204

66:                                               ; preds = %61
  %67 = load i32, ptr %4, align 4, !dbg !205
  %68 = icmp eq i32 %67, 242, !dbg !206
  br label %69

69:                                               ; preds = %66, %61
  %70 = phi i1 [ false, %61 ], [ %68, %66 ], !dbg !170
  %71 = zext i1 %70 to i32, !dbg !204
  call void @reach(i32 noundef 10, i32 noundef %71), !dbg !207
    #dbg_declare(ptr %6, !208, !DIExpression(), !209)
  %72 = load i32, ptr @x, align 4, !dbg !210
  %73 = and i32 %72, 1008, !dbg !211
  store i32 %73, ptr %6, align 4, !dbg !209
  %74 = load i32, ptr %6, align 4, !dbg !212
  %75 = and i32 %74, 272, !dbg !213
  %76 = icmp ne i32 %75, 256, !dbg !214
  br i1 %76, label %77, label %81, !dbg !215

77:                                               ; preds = %69
  %78 = load i32, ptr %6, align 4, !dbg !216
  %79 = and i32 %78, 528, !dbg !217
  %80 = icmp ne i32 %79, 512, !dbg !218
  br label %81

81:                                               ; preds = %77, %69
  %82 = phi i1 [ false, %69 ], [ %80, %77 ], !dbg !170
  %83 = zext i1 %82 to i32, !dbg !215
  call void @safe(i32 noundef %83), !dbg !219
  %84 = load i32, ptr %6, align 4, !dbg !220
  %85 = and i32 %84, 256, !dbg !221
  %86 = icmp eq i32 %85, 0, !dbg !222
  %87 = zext i1 %86 to i32, !dbg !222
  %88 = load i32, ptr %6, align 4, !dbg !223
  %89 = and i32 %88, 512, !dbg !224
  %90 = icmp eq i32 %89, 0, !dbg !225
  %91 = zext i1 %90 to i32, !dbg !225
  %92 = icmp eq i32 %87, %91, !dbg !226
  %93 = zext i1 %92 to i32, !dbg !226
  call void @safe(i32 noundef %93), !dbg !227
  %94 = load i32, ptr %6, align 4, !dbg !228
  %95 = and i32 %94, 48, !dbg !229
  %96 = icmp ne i32 %95, 32, !dbg !230
  %97 = zext i1 %96 to i32, !dbg !230
  call void @safe(i32 noundef %97), !dbg !231
  %98 = load i32, ptr %6, align 4, !dbg !232
  %99 = and i32 %98, 32, !dbg !233
  %100 = icmp eq i32 %99, 0, !dbg !234
  %101 = zext i1 %100 to i32, !dbg !234
  %102 = load i32, ptr %6, align 4, !dbg !235
  %103 = and i32 %102, 64, !dbg !236
  %104 = icmp eq i32 %103, 0, !dbg !237
  %105 = zext i1 %104 to i32, !dbg !237
  %106 = icmp eq i32 %101, %105, !dbg !238
  %107 = zext i1 %106 to i32, !dbg !238
  call void @safe(i32 noundef %107), !dbg !239
  %108 = load i32, ptr %6, align 4, !dbg !240
  %109 = and i32 %108, 192, !dbg !241
  %110 = icmp ne i32 %109, 128, !dbg !242
  %111 = zext i1 %110 to i32, !dbg !242
  call void @safe(i32 noundef %111), !dbg !243
  %112 = load i32, ptr %6, align 4, !dbg !244
  %113 = icmp eq i32 %112, 0, !dbg !245
  %114 = zext i1 %113 to i32, !dbg !245
  call void @reach(i32 noundef 11, i32 noundef %114), !dbg !246
  %115 = load i32, ptr %6, align 4, !dbg !247
  %116 = icmp eq i32 %115, 16, !dbg !248
  %117 = zext i1 %116 to i32, !dbg !248
  call void @reach(i32 noundef 12, i32 noundef %117), !dbg !249
  %118 = load i32, ptr %6, align 4, !dbg !250
  %119 = icmp eq i32 %118, 112, !dbg !251
  %120 = zext i1 %119 to i32, !dbg !251
  call void @reach(i32 noundef 13, i32 noundef %120), !dbg !252
  %121 = load i32, ptr %6, align 4, !dbg !253
  %122 = icmp eq i32 %121, 240, !dbg !254
  %123 = zext i1 %122 to i32, !dbg !254
  call void @reach(i32 noundef 14, i32 noundef %123), !dbg !255
  %124 = load i32, ptr %6, align 4, !dbg !256
  %125 = icmp eq i32 %124, 784, !dbg !257
  %126 = zext i1 %125 to i32, !dbg !257
  call void @reach(i32 noundef 15, i32 noundef %126), !dbg !258
  %127 = load i32, ptr %6, align 4, !dbg !259
  %128 = icmp eq i32 %127, 880, !dbg !260
  %129 = zext i1 %128 to i32, !dbg !260
  call void @reach(i32 noundef 16, i32 noundef %129), !dbg !261
  %130 = load i32, ptr %6, align 4, !dbg !262
  %131 = icmp eq i32 %130, 1008, !dbg !263
  %132 = zext i1 %131 to i32, !dbg !263
  call void @reach(i32 noundef 17, i32 noundef %132), !dbg !264
  call void @__VERIFIER_make_cb(), !dbg !265
  %133 = load i32, ptr @x, align 4, !dbg !266
  %134 = or i32 %133, 4096, !dbg !266
  store i32 %134, ptr @x, align 4, !dbg !266
  call void @__VERIFIER_make_cb(), !dbg !267
  %135 = load i32, ptr @x, align 4, !dbg !268
  %136 = or i32 %135, 8192, !dbg !268
  store i32 %136, ptr @x, align 4, !dbg !268
  ret ptr null, !dbg !269
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler3(ptr noundef %0) #0 !dbg !270 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !271, !DIExpression(), !272)
  %5 = load i32, ptr @y, align 4, !dbg !273
  %6 = and i32 %5, 15, !dbg !274
  %7 = icmp eq i32 %6, 7, !dbg !275
  %8 = zext i1 %7 to i32, !dbg !275
  call void @safe(i32 noundef %8), !dbg !276
    #dbg_declare(ptr %3, !277, !DIExpression(), !278)
  %9 = load atomic i32, ptr @z seq_cst, align 4, !dbg !279
  store i32 %9, ptr %4, align 4, !dbg !279
  %10 = load i32, ptr %4, align 4, !dbg !279
  store i32 %10, ptr %3, align 4, !dbg !278
  %11 = load i32, ptr %3, align 4, !dbg !280
  %12 = and i32 %11, 177, !dbg !281
  %13 = icmp eq i32 %12, 49, !dbg !282
  %14 = zext i1 %13 to i32, !dbg !282
  call void @safe(i32 noundef %14), !dbg !283
  %15 = load i32, ptr %3, align 4, !dbg !284
  %16 = and i32 %15, 64, !dbg !285
  %17 = icmp eq i32 %16, 0, !dbg !286
  %18 = zext i1 %17 to i32, !dbg !286
  call void @reach(i32 noundef 18, i32 noundef %18), !dbg !287
  %19 = load i32, ptr %3, align 4, !dbg !288
  %20 = and i32 %19, 64, !dbg !289
  %21 = icmp eq i32 %20, 64, !dbg !290
  %22 = zext i1 %21 to i32, !dbg !290
  call void @reach(i32 noundef 19, i32 noundef %22), !dbg !291
  %23 = load i32, ptr %3, align 4, !dbg !292
  %24 = and i32 %23, 2, !dbg !293
  %25 = icmp eq i32 %24, 0, !dbg !294
  %26 = zext i1 %25 to i32, !dbg !294
  call void @reach(i32 noundef 20, i32 noundef %26), !dbg !295
  %27 = load i32, ptr %3, align 4, !dbg !296
  %28 = and i32 %27, 2, !dbg !297
  %29 = icmp eq i32 %28, 2, !dbg !298
  %30 = zext i1 %29 to i32, !dbg !298
  call void @reach(i32 noundef 21, i32 noundef %30), !dbg !299
  %31 = load i32, ptr @y, align 4, !dbg !300
  %32 = or i32 %31, 16, !dbg !300
  store i32 %32, ptr @y, align 4, !dbg !300
  ret ptr null, !dbg !301
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !302 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !303, !DIExpression(), !304)
  %12 = load i32, ptr @y, align 4, !dbg !305
  %13 = or i32 %12, 2, !dbg !305
  store i32 %13, ptr @y, align 4, !dbg !305
  store i32 16, ptr %3, align 4, !dbg !306
  %14 = load i32, ptr %3, align 4, !dbg !306
  %15 = atomicrmw or ptr @z, i32 %14 seq_cst, align 4, !dbg !306
  store i32 %15, ptr %4, align 4, !dbg !306
  %16 = load i32, ptr %4, align 4, !dbg !306
  call void @__VERIFIER_make_cb(), !dbg !307
  call void @__VERIFIER_disable_irq(), !dbg !308
    #dbg_declare(ptr %5, !309, !DIExpression(), !310)
  %17 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !311
  br i1 %17, label %18, label %20, !dbg !313

18:                                               ; preds = %1
  call void @__VERIFIER_make_interrupt_handler(), !dbg !314
  %19 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @handler3, ptr noundef null), !dbg !316
  br label %20, !dbg !317

20:                                               ; preds = %18, %1
  call void @__VERIFIER_make_cb(), !dbg !318
  %21 = load i32, ptr @y, align 4, !dbg !319
  %22 = or i32 %21, 4, !dbg !319
  store i32 %22, ptr @y, align 4, !dbg !319
  store i32 32, ptr %6, align 4, !dbg !320
  %23 = load i32, ptr %6, align 4, !dbg !320
  %24 = atomicrmw or ptr @z, i32 %23 seq_cst, align 4, !dbg !320
  store i32 %24, ptr %7, align 4, !dbg !320
  %25 = load i32, ptr %7, align 4, !dbg !320
  call void @__VERIFIER_enable_irq(), !dbg !321
  store i32 64, ptr %8, align 4, !dbg !322
  %26 = load i32, ptr %8, align 4, !dbg !322
  %27 = atomicrmw or ptr @z, i32 %26 seq_cst, align 4, !dbg !322
  store i32 %27, ptr %9, align 4, !dbg !322
  %28 = load i32, ptr %9, align 4, !dbg !322
  call void @__VERIFIER_disable_irq(), !dbg !323
  %29 = load i32, ptr @y, align 4, !dbg !324
  %30 = or i32 %29, 8, !dbg !324
  store i32 %30, ptr @y, align 4, !dbg !324
  store i32 128, ptr %10, align 4, !dbg !325
  %31 = load i32, ptr %10, align 4, !dbg !325
  %32 = atomicrmw or ptr @z, i32 %31 seq_cst, align 4, !dbg !325
  store i32 %32, ptr %11, align 4, !dbg !325
  %33 = load i32, ptr %11, align 4, !dbg !325
  %34 = load i32, ptr @y, align 4, !dbg !326
  %35 = and i32 %34, 16, !dbg !327
  %36 = icmp eq i32 %35, 0, !dbg !328
  %37 = zext i1 %36 to i32, !dbg !328
  call void @reach(i32 noundef 22, i32 noundef %37), !dbg !329
  %38 = load i32, ptr @y, align 4, !dbg !330
  %39 = and i32 %38, 16, !dbg !331
  %40 = icmp eq i32 %39, 16, !dbg !332
  %41 = zext i1 %40 to i32, !dbg !332
  call void @reach(i32 noundef 23, i32 noundef %41), !dbg !333
  ret ptr null, !dbg !334
}

declare zeroext i1 @__VERIFIER_nondet_bool() #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !335 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 1, ptr @x, align 4, !dbg !338
  store i32 1, ptr @y, align 4, !dbg !339
  store i32 1, ptr @z, align 4, !dbg !340
  %8 = load i32, ptr @x, align 4, !dbg !341
  %9 = load i32, ptr @y, align 4, !dbg !342
  %10 = or i32 %8, %9, !dbg !343
  %11 = icmp eq i32 %10, 1, !dbg !344
  br i1 %11, label %12, label %16, !dbg !345

12:                                               ; preds = %0
  %13 = load atomic i32, ptr @z seq_cst, align 4, !dbg !346
  store i32 %13, ptr %2, align 4, !dbg !346
  %14 = load i32, ptr %2, align 4, !dbg !346
  %15 = icmp eq i32 %14, 1, !dbg !347
  br label %16

16:                                               ; preds = %12, %0
  %17 = phi i1 [ false, %0 ], [ %15, %12 ], !dbg !348
  %18 = zext i1 %17 to i32, !dbg !345
  call void @safe(i32 noundef %18), !dbg !349
  call void @__VERIFIER_make_cb(), !dbg !350
    #dbg_declare(ptr %3, !351, !DIExpression(), !352)
  %19 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !353
    #dbg_declare(ptr %4, !354, !DIExpression(), !355)
    #dbg_declare(ptr %5, !356, !DIExpression(), !357)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !358
  %20 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @handler1, ptr noundef null), !dbg !359
  call void @__VERIFIER_make_interrupt_handler(), !dbg !360
  %21 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @handler2, ptr noundef null), !dbg !361
  call void @__VERIFIER_make_cb(), !dbg !362
  %22 = load i32, ptr @x, align 4, !dbg !363
  %23 = or i32 %22, 2, !dbg !363
  store i32 %23, ptr @x, align 4, !dbg !363
  store i32 2, ptr %6, align 4, !dbg !364
  %24 = load i32, ptr %6, align 4, !dbg !364
  %25 = atomicrmw or ptr @z, i32 %24 seq_cst, align 4, !dbg !364
  store i32 %25, ptr %7, align 4, !dbg !364
  %26 = load i32, ptr %7, align 4, !dbg !364
  call void @__VERIFIER_make_cb(), !dbg !365
  %27 = load i32, ptr @x, align 4, !dbg !366
  %28 = or i32 %27, 4, !dbg !366
  store i32 %28, ptr @x, align 4, !dbg !366
  %29 = load ptr, ptr %3, align 8, !dbg !367
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null), !dbg !368
  %31 = load i32, ptr @x, align 4, !dbg !369
  %32 = and i32 %31, 3, !dbg !370
  %33 = icmp eq i32 %32, 3, !dbg !371
  %34 = zext i1 %33 to i32, !dbg !371
  call void @safe(i32 noundef %34), !dbg !372
  %35 = load i32, ptr @y, align 4, !dbg !373
  %36 = icmp eq i32 %35, 31, !dbg !374
  %37 = zext i1 %36 to i32, !dbg !374
  call void @safe(i32 noundef %37), !dbg !375
  %38 = load i32, ptr @x, align 4, !dbg !376
  %39 = or i32 %38, 8, !dbg !376
  store i32 %39, ptr @x, align 4, !dbg !376
  ret i32 0, !dbg !377
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!28}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/interrupts/c11.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8bb476b78fac99e4f4d580ef1493d5f3")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 48, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 6)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 48, elements: !6)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 264, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 33)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !2, line: 22, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: 5)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 22, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 208, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 26)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !28, file: !2, line: 12, type: !34, isLocal: false, isDefinition: true)
!28 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !29, globals: !31, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !{!0, !8, !11, !16, !21, !26, !32, !35}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "y", scope: !28, file: !2, line: 13, type: !34, isLocal: false, isDefinition: true)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "z", scope: !28, file: !2, line: 14, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !38, line: 104, baseType: !39)
!38 = !DIFile(filename: ".local/universal/llvm-19.1.7/lib/clang/19/include/stdatomic.h", directory: "/Users/r", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!39 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !34)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 8, !"PIC Level", i32 2}
!44 = !{i32 7, !"uwtable", i32 1}
!45 = !{i32 7, !"frame-pointer", i32 1}
!46 = !{!"Homebrew clang version 19.1.7"}
!47 = distinct !DISubprogram(name: "reach", scope: !2, file: !2, line: 16, type: !48, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!48 = !DISubroutineType(types: !49)
!49 = !{null, !34, !34}
!50 = !{}
!51 = !DILocalVariable(name: "variant", arg: 1, scope: !47, file: !2, line: 16, type: !34)
!52 = !DILocation(line: 16, column: 16, scope: !47)
!53 = !DILocalVariable(name: "condition", arg: 2, scope: !47, file: !2, line: 16, type: !34)
!54 = !DILocation(line: 16, column: 29, scope: !47)
!55 = !DILocation(line: 18, column: 5, scope: !47)
!56 = !DILocation(line: 19, column: 1, scope: !47)
!57 = distinct !DISubprogram(name: "safe", scope: !2, file: !2, line: 20, type: !58, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!58 = !DISubroutineType(types: !59)
!59 = !{null, !34}
!60 = !DILocalVariable(name: "condition", arg: 1, scope: !57, file: !2, line: 20, type: !34)
!61 = !DILocation(line: 20, column: 15, scope: !57)
!62 = !DILocation(line: 22, column: 5, scope: !57)
!63 = !DILocation(line: 23, column: 1, scope: !57)
!64 = distinct !DISubprogram(name: "handler0", scope: !2, file: !2, line: 26, type: !65, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!65 = !DISubroutineType(types: !66)
!66 = !{!30, !30}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !64, file: !2, line: 26, type: !30)
!68 = !DILocation(line: 26, column: 22, scope: !64)
!69 = !DILocation(line: 29, column: 5, scope: !64)
!70 = !DILocation(line: 31, column: 11, scope: !64)
!71 = !DILocation(line: 31, column: 13, scope: !64)
!72 = !DILocation(line: 31, column: 23, scope: !64)
!73 = !DILocation(line: 31, column: 33, scope: !64)
!74 = !DILocation(line: 31, column: 37, scope: !64)
!75 = !DILocation(line: 31, column: 53, scope: !64)
!76 = !DILocation(line: 31, column: 58, scope: !64)
!77 = !DILocation(line: 0, scope: !64)
!78 = !DILocation(line: 31, column: 5, scope: !64)
!79 = !DILocation(line: 32, column: 7, scope: !64)
!80 = !DILocation(line: 36, column: 7, scope: !64)
!81 = !DILocation(line: 37, column: 5, scope: !64)
!82 = distinct !DISubprogram(name: "handler1", scope: !2, file: !2, line: 42, type: !65, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!83 = !DILocalVariable(name: "arg", arg: 1, scope: !82, file: !2, line: 42, type: !30)
!84 = !DILocation(line: 42, column: 22, scope: !82)
!85 = !DILocation(line: 45, column: 11, scope: !82)
!86 = !DILocation(line: 45, column: 13, scope: !82)
!87 = !DILocation(line: 45, column: 18, scope: !82)
!88 = !DILocation(line: 45, column: 5, scope: !82)
!89 = !DILocation(line: 46, column: 12, scope: !82)
!90 = !DILocation(line: 46, column: 14, scope: !82)
!91 = !DILocation(line: 46, column: 22, scope: !82)
!92 = !DILocation(line: 46, column: 33, scope: !82)
!93 = !DILocation(line: 46, column: 35, scope: !82)
!94 = !DILocation(line: 46, column: 43, scope: !82)
!95 = !DILocation(line: 46, column: 28, scope: !82)
!96 = !DILocation(line: 46, column: 5, scope: !82)
!97 = !DILocation(line: 48, column: 15, scope: !82)
!98 = !DILocation(line: 48, column: 17, scope: !82)
!99 = !DILocation(line: 48, column: 32, scope: !82)
!100 = !DILocation(line: 48, column: 5, scope: !82)
!101 = !DILocation(line: 49, column: 15, scope: !82)
!102 = !DILocation(line: 49, column: 17, scope: !82)
!103 = !DILocation(line: 49, column: 32, scope: !82)
!104 = !DILocation(line: 49, column: 5, scope: !82)
!105 = !DILocation(line: 51, column: 7, scope: !82)
!106 = !DILocation(line: 53, column: 5, scope: !82)
!107 = !DILocation(line: 54, column: 5, scope: !82)
!108 = !DILocalVariable(name: "h0", scope: !82, file: !2, line: 55, type: !109)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !110, line: 31, baseType: !111)
!110 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !112, line: 118, baseType: !113)
!112 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !112, line: 103, size: 65536, elements: !115)
!115 = !{!116, !118, !128}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !114, file: !112, line: 104, baseType: !117, size: 64)
!117 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !114, file: !112, line: 105, baseType: !119, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !112, line: 57, size: 192, elements: !121)
!121 = !{!122, !126, !127}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !120, file: !112, line: 58, baseType: !123, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !30}
!126 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !120, file: !112, line: 59, baseType: !30, size: 64, offset: 64)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !120, file: !112, line: 60, baseType: !119, size: 64, offset: 128)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !114, file: !112, line: 106, baseType: !129, size: 65408, offset: 128)
!129 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !130)
!130 = !{!131}
!131 = !DISubrange(count: 8176)
!132 = !DILocation(line: 55, column: 15, scope: !82)
!133 = !DILocation(line: 56, column: 5, scope: !82)
!134 = !DILocation(line: 58, column: 5, scope: !82)
!135 = !DILocation(line: 59, column: 5, scope: !82)
!136 = !DILocation(line: 60, column: 7, scope: !82)
!137 = !DILocation(line: 62, column: 5, scope: !82)
!138 = !DILocation(line: 63, column: 7, scope: !82)
!139 = !DILocation(line: 65, column: 5, scope: !82)
!140 = !DILocation(line: 66, column: 5, scope: !82)
!141 = !DILocation(line: 68, column: 5, scope: !82)
!142 = !DILocation(line: 70, column: 5, scope: !82)
!143 = !DILocation(line: 71, column: 7, scope: !82)
!144 = !DILocation(line: 74, column: 15, scope: !82)
!145 = !DILocation(line: 74, column: 17, scope: !82)
!146 = !DILocation(line: 74, column: 30, scope: !82)
!147 = !DILocation(line: 74, column: 5, scope: !82)
!148 = !DILocation(line: 75, column: 5, scope: !82)
!149 = distinct !DISubprogram(name: "handler2", scope: !2, file: !2, line: 80, type: !65, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!150 = !DILocalVariable(name: "arg", arg: 1, scope: !149, file: !2, line: 80, type: !30)
!151 = !DILocation(line: 80, column: 22, scope: !149)
!152 = !DILocation(line: 82, column: 5, scope: !149)
!153 = !DILocation(line: 85, column: 11, scope: !149)
!154 = !DILocation(line: 85, column: 13, scope: !149)
!155 = !DILocation(line: 85, column: 18, scope: !149)
!156 = !DILocation(line: 85, column: 5, scope: !149)
!157 = !DILocalVariable(name: "ax", scope: !149, file: !2, line: 88, type: !34)
!158 = !DILocation(line: 88, column: 9, scope: !149)
!159 = !DILocation(line: 88, column: 14, scope: !149)
!160 = !DILocation(line: 88, column: 16, scope: !149)
!161 = !DILocalVariable(name: "az", scope: !149, file: !2, line: 89, type: !34)
!162 = !DILocation(line: 89, column: 9, scope: !149)
!163 = !DILocation(line: 89, column: 14, scope: !149)
!164 = !DILocation(line: 89, column: 30, scope: !149)
!165 = !DILocation(line: 91, column: 14, scope: !149)
!166 = !DILocation(line: 91, column: 17, scope: !149)
!167 = !DILocation(line: 91, column: 22, scope: !149)
!168 = !DILocation(line: 91, column: 25, scope: !149)
!169 = !DILocation(line: 91, column: 28, scope: !149)
!170 = !DILocation(line: 0, scope: !149)
!171 = !DILocation(line: 91, column: 5, scope: !149)
!172 = !DILocation(line: 93, column: 14, scope: !149)
!173 = !DILocation(line: 93, column: 17, scope: !149)
!174 = !DILocation(line: 93, column: 22, scope: !149)
!175 = !DILocation(line: 93, column: 25, scope: !149)
!176 = !DILocation(line: 93, column: 28, scope: !149)
!177 = !DILocation(line: 93, column: 5, scope: !149)
!178 = !DILocation(line: 95, column: 14, scope: !149)
!179 = !DILocation(line: 95, column: 17, scope: !149)
!180 = !DILocation(line: 95, column: 22, scope: !149)
!181 = !DILocation(line: 95, column: 25, scope: !149)
!182 = !DILocation(line: 95, column: 28, scope: !149)
!183 = !DILocation(line: 95, column: 5, scope: !149)
!184 = !DILocation(line: 97, column: 14, scope: !149)
!185 = !DILocation(line: 97, column: 17, scope: !149)
!186 = !DILocation(line: 97, column: 22, scope: !149)
!187 = !DILocation(line: 97, column: 25, scope: !149)
!188 = !DILocation(line: 97, column: 28, scope: !149)
!189 = !DILocation(line: 97, column: 5, scope: !149)
!190 = !DILocation(line: 99, column: 14, scope: !149)
!191 = !DILocation(line: 99, column: 17, scope: !149)
!192 = !DILocation(line: 99, column: 26, scope: !149)
!193 = !DILocation(line: 99, column: 29, scope: !149)
!194 = !DILocation(line: 99, column: 32, scope: !149)
!195 = !DILocation(line: 99, column: 5, scope: !149)
!196 = !DILocation(line: 101, column: 14, scope: !149)
!197 = !DILocation(line: 101, column: 17, scope: !149)
!198 = !DILocation(line: 101, column: 26, scope: !149)
!199 = !DILocation(line: 101, column: 29, scope: !149)
!200 = !DILocation(line: 101, column: 32, scope: !149)
!201 = !DILocation(line: 101, column: 5, scope: !149)
!202 = !DILocation(line: 103, column: 15, scope: !149)
!203 = !DILocation(line: 103, column: 18, scope: !149)
!204 = !DILocation(line: 103, column: 29, scope: !149)
!205 = !DILocation(line: 103, column: 32, scope: !149)
!206 = !DILocation(line: 103, column: 35, scope: !149)
!207 = !DILocation(line: 103, column: 5, scope: !149)
!208 = !DILocalVariable(name: "bx", scope: !149, file: !2, line: 106, type: !34)
!209 = !DILocation(line: 106, column: 9, scope: !149)
!210 = !DILocation(line: 106, column: 14, scope: !149)
!211 = !DILocation(line: 106, column: 16, scope: !149)
!212 = !DILocation(line: 108, column: 11, scope: !149)
!213 = !DILocation(line: 108, column: 14, scope: !149)
!214 = !DILocation(line: 108, column: 26, scope: !149)
!215 = !DILocation(line: 108, column: 33, scope: !149)
!216 = !DILocation(line: 108, column: 37, scope: !149)
!217 = !DILocation(line: 108, column: 40, scope: !149)
!218 = !DILocation(line: 108, column: 52, scope: !149)
!219 = !DILocation(line: 108, column: 5, scope: !149)
!220 = !DILocation(line: 109, column: 12, scope: !149)
!221 = !DILocation(line: 109, column: 15, scope: !149)
!222 = !DILocation(line: 109, column: 22, scope: !149)
!223 = !DILocation(line: 109, column: 33, scope: !149)
!224 = !DILocation(line: 109, column: 36, scope: !149)
!225 = !DILocation(line: 109, column: 43, scope: !149)
!226 = !DILocation(line: 109, column: 28, scope: !149)
!227 = !DILocation(line: 109, column: 5, scope: !149)
!228 = !DILocation(line: 110, column: 11, scope: !149)
!229 = !DILocation(line: 110, column: 14, scope: !149)
!230 = !DILocation(line: 110, column: 25, scope: !149)
!231 = !DILocation(line: 110, column: 5, scope: !149)
!232 = !DILocation(line: 111, column: 12, scope: !149)
!233 = !DILocation(line: 111, column: 15, scope: !149)
!234 = !DILocation(line: 111, column: 21, scope: !149)
!235 = !DILocation(line: 111, column: 32, scope: !149)
!236 = !DILocation(line: 111, column: 35, scope: !149)
!237 = !DILocation(line: 111, column: 41, scope: !149)
!238 = !DILocation(line: 111, column: 27, scope: !149)
!239 = !DILocation(line: 111, column: 5, scope: !149)
!240 = !DILocation(line: 112, column: 11, scope: !149)
!241 = !DILocation(line: 112, column: 14, scope: !149)
!242 = !DILocation(line: 112, column: 26, scope: !149)
!243 = !DILocation(line: 112, column: 5, scope: !149)
!244 = !DILocation(line: 114, column: 15, scope: !149)
!245 = !DILocation(line: 114, column: 18, scope: !149)
!246 = !DILocation(line: 114, column: 5, scope: !149)
!247 = !DILocation(line: 116, column: 15, scope: !149)
!248 = !DILocation(line: 116, column: 18, scope: !149)
!249 = !DILocation(line: 116, column: 5, scope: !149)
!250 = !DILocation(line: 118, column: 15, scope: !149)
!251 = !DILocation(line: 118, column: 18, scope: !149)
!252 = !DILocation(line: 118, column: 5, scope: !149)
!253 = !DILocation(line: 120, column: 15, scope: !149)
!254 = !DILocation(line: 120, column: 18, scope: !149)
!255 = !DILocation(line: 120, column: 5, scope: !149)
!256 = !DILocation(line: 122, column: 15, scope: !149)
!257 = !DILocation(line: 122, column: 18, scope: !149)
!258 = !DILocation(line: 122, column: 5, scope: !149)
!259 = !DILocation(line: 124, column: 15, scope: !149)
!260 = !DILocation(line: 124, column: 18, scope: !149)
!261 = !DILocation(line: 124, column: 5, scope: !149)
!262 = !DILocation(line: 126, column: 15, scope: !149)
!263 = !DILocation(line: 126, column: 18, scope: !149)
!264 = !DILocation(line: 126, column: 5, scope: !149)
!265 = !DILocation(line: 128, column: 5, scope: !149)
!266 = !DILocation(line: 129, column: 7, scope: !149)
!267 = !DILocation(line: 131, column: 5, scope: !149)
!268 = !DILocation(line: 132, column: 7, scope: !149)
!269 = !DILocation(line: 133, column: 5, scope: !149)
!270 = distinct !DISubprogram(name: "handler3", scope: !2, file: !2, line: 137, type: !65, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!271 = !DILocalVariable(name: "arg", arg: 1, scope: !270, file: !2, line: 137, type: !30)
!272 = !DILocation(line: 137, column: 22, scope: !270)
!273 = !DILocation(line: 141, column: 11, scope: !270)
!274 = !DILocation(line: 141, column: 13, scope: !270)
!275 = !DILocation(line: 141, column: 26, scope: !270)
!276 = !DILocation(line: 141, column: 5, scope: !270)
!277 = !DILocalVariable(name: "bz", scope: !270, file: !2, line: 142, type: !34)
!278 = !DILocation(line: 142, column: 9, scope: !270)
!279 = !DILocation(line: 142, column: 14, scope: !270)
!280 = !DILocation(line: 143, column: 11, scope: !270)
!281 = !DILocation(line: 143, column: 14, scope: !270)
!282 = !DILocation(line: 143, column: 31, scope: !270)
!283 = !DILocation(line: 143, column: 5, scope: !270)
!284 = !DILocation(line: 146, column: 16, scope: !270)
!285 = !DILocation(line: 146, column: 19, scope: !270)
!286 = !DILocation(line: 146, column: 25, scope: !270)
!287 = !DILocation(line: 146, column: 5, scope: !270)
!288 = !DILocation(line: 147, column: 16, scope: !270)
!289 = !DILocation(line: 147, column: 19, scope: !270)
!290 = !DILocation(line: 147, column: 25, scope: !270)
!291 = !DILocation(line: 147, column: 5, scope: !270)
!292 = !DILocation(line: 149, column: 16, scope: !270)
!293 = !DILocation(line: 149, column: 19, scope: !270)
!294 = !DILocation(line: 149, column: 24, scope: !270)
!295 = !DILocation(line: 149, column: 5, scope: !270)
!296 = !DILocation(line: 150, column: 16, scope: !270)
!297 = !DILocation(line: 150, column: 19, scope: !270)
!298 = !DILocation(line: 150, column: 24, scope: !270)
!299 = !DILocation(line: 150, column: 5, scope: !270)
!300 = !DILocation(line: 152, column: 7, scope: !270)
!301 = !DILocation(line: 153, column: 5, scope: !270)
!302 = distinct !DISubprogram(name: "thread1", scope: !2, file: !2, line: 156, type: !65, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!303 = !DILocalVariable(name: "arg", arg: 1, scope: !302, file: !2, line: 156, type: !30)
!304 = !DILocation(line: 156, column: 21, scope: !302)
!305 = !DILocation(line: 158, column: 7, scope: !302)
!306 = !DILocation(line: 159, column: 5, scope: !302)
!307 = !DILocation(line: 161, column: 5, scope: !302)
!308 = !DILocation(line: 162, column: 5, scope: !302)
!309 = !DILocalVariable(name: "h3", scope: !302, file: !2, line: 163, type: !109)
!310 = !DILocation(line: 163, column: 15, scope: !302)
!311 = !DILocation(line: 164, column: 9, scope: !312)
!312 = distinct !DILexicalBlock(scope: !302, file: !2, line: 164, column: 9)
!313 = !DILocation(line: 164, column: 9, scope: !302)
!314 = !DILocation(line: 166, column: 9, scope: !315)
!315 = distinct !DILexicalBlock(scope: !312, file: !2, line: 165, column: 5)
!316 = !DILocation(line: 167, column: 9, scope: !315)
!317 = !DILocation(line: 168, column: 5, scope: !315)
!318 = !DILocation(line: 170, column: 5, scope: !302)
!319 = !DILocation(line: 171, column: 7, scope: !302)
!320 = !DILocation(line: 172, column: 5, scope: !302)
!321 = !DILocation(line: 174, column: 5, scope: !302)
!322 = !DILocation(line: 175, column: 5, scope: !302)
!323 = !DILocation(line: 177, column: 5, scope: !302)
!324 = !DILocation(line: 178, column: 7, scope: !302)
!325 = !DILocation(line: 179, column: 5, scope: !302)
!326 = !DILocation(line: 181, column: 16, scope: !302)
!327 = !DILocation(line: 181, column: 18, scope: !302)
!328 = !DILocation(line: 181, column: 24, scope: !302)
!329 = !DILocation(line: 181, column: 5, scope: !302)
!330 = !DILocation(line: 182, column: 16, scope: !302)
!331 = !DILocation(line: 182, column: 18, scope: !302)
!332 = !DILocation(line: 182, column: 24, scope: !302)
!333 = !DILocation(line: 182, column: 5, scope: !302)
!334 = !DILocation(line: 183, column: 5, scope: !302)
!335 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 186, type: !336, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !50)
!336 = !DISubroutineType(types: !337)
!337 = !{!34}
!338 = !DILocation(line: 188, column: 7, scope: !335)
!339 = !DILocation(line: 189, column: 7, scope: !335)
!340 = !DILocation(line: 190, column: 5, scope: !335)
!341 = !DILocation(line: 192, column: 11, scope: !335)
!342 = !DILocation(line: 192, column: 15, scope: !335)
!343 = !DILocation(line: 192, column: 13, scope: !335)
!344 = !DILocation(line: 192, column: 18, scope: !335)
!345 = !DILocation(line: 192, column: 23, scope: !335)
!346 = !DILocation(line: 192, column: 26, scope: !335)
!347 = !DILocation(line: 192, column: 42, scope: !335)
!348 = !DILocation(line: 0, scope: !335)
!349 = !DILocation(line: 192, column: 5, scope: !335)
!350 = !DILocation(line: 194, column: 5, scope: !335)
!351 = !DILocalVariable(name: "t", scope: !335, file: !2, line: 195, type: !109)
!352 = !DILocation(line: 195, column: 15, scope: !335)
!353 = !DILocation(line: 196, column: 5, scope: !335)
!354 = !DILocalVariable(name: "h1", scope: !335, file: !2, line: 198, type: !109)
!355 = !DILocation(line: 198, column: 15, scope: !335)
!356 = !DILocalVariable(name: "h2", scope: !335, file: !2, line: 198, type: !109)
!357 = !DILocation(line: 198, column: 19, scope: !335)
!358 = !DILocation(line: 199, column: 5, scope: !335)
!359 = !DILocation(line: 200, column: 5, scope: !335)
!360 = !DILocation(line: 201, column: 5, scope: !335)
!361 = !DILocation(line: 202, column: 5, scope: !335)
!362 = !DILocation(line: 204, column: 5, scope: !335)
!363 = !DILocation(line: 205, column: 7, scope: !335)
!364 = !DILocation(line: 206, column: 5, scope: !335)
!365 = !DILocation(line: 208, column: 5, scope: !335)
!366 = !DILocation(line: 209, column: 7, scope: !335)
!367 = !DILocation(line: 211, column: 18, scope: !335)
!368 = !DILocation(line: 211, column: 5, scope: !335)
!369 = !DILocation(line: 213, column: 11, scope: !335)
!370 = !DILocation(line: 213, column: 13, scope: !335)
!371 = !DILocation(line: 213, column: 22, scope: !335)
!372 = !DILocation(line: 213, column: 5, scope: !335)
!373 = !DILocation(line: 215, column: 10, scope: !335)
!374 = !DILocation(line: 215, column: 12, scope: !335)
!375 = !DILocation(line: 215, column: 5, scope: !335)
!376 = !DILocation(line: 217, column: 7, scope: !335)
!377 = !DILocation(line: 219, column: 5, scope: !335)
