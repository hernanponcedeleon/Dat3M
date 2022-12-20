/*
 * Copyright (C) 2022. Huawei Technologies Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the MIT License for more details.
 */

#include <atomic>
#include <map>
#include <string>
#include <vector>

#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
using namespace llvm;

#include "AtomicReplaceInterface.h"

namespace llvm
{

class AtomicReplacePass : public ModulePass {
public:
  static char ID;
  AtomicReplacePass() : ModulePass(ID) { }

private:
  std::vector<Instruction *> instructions_to_erase;

  struct compareAtomicOrdering {
    bool operator()(AtomicOrdering a, AtomicOrdering b) const {
      return static_cast<size_t>(a) < static_cast<size_t>(b);
    }
  };

  Function *my_load_atomic_4;
  Function *my_load_atomic_8;
  Function *my_store_atomic_4;
  Function *my_store_atomic_8;
  Function *my_cmpxchg_atomic_4;
  Function *my_cmpxchg_atomic_8;
  Function *my_rmw_atomic_4;
  Function *my_rmw_atomic_8;
  Function *my_fence_atomic;
  std::map<AtomicOrdering, Constant *, compareAtomicOrdering> my_ordering_constants;
  std::map<AtomicRMWInst::BinOp, Constant *> my_rmw_operation_constants;

  Function *createDeclaration(Module &M, const std::string &name, Type *returnType,
                              const std::vector<Type *> args) {
    FunctionType *ft = FunctionType::get(returnType, args, false);
    return Function::Create(ft, Function::ExternalLinkage, name, M);
  }

  std::string my_atomics_name_suffix(int size) {
    switch (size) {
      case 0:
        return "";
      case 4:
        return "32";
      case 8:
        return "64";
      default:
        assert(0 && "unsupported type size");
    }
    return "";
  }

  std::string my_atomics_name(const std::string &op, int size = 0) {
    return std::string("__llvm_atomic") + my_atomics_name_suffix(size) + "_" + op;
  }

  void createDeclarations(Module &M) {
    LLVMContext &ctx      = M.getContext();
    const auto i32_ty     = Type::getInt32Ty(ctx);
    const auto i32_ptr_ty = Type::getInt32PtrTy(ctx);
    const auto i64_ty     = Type::getInt64Ty(ctx);
    const auto i64_ptr_ty = Type::getInt64PtrTy(ctx);
    const auto i1_ty      = Type::getInt1Ty(ctx);
    const auto void_ty    = Type::getVoidTy(ctx);

    my_load_atomic_4 = createDeclaration(M, my_atomics_name("load", 4),
        i32_ty, {i32_ptr_ty, i32_ty});
    my_load_atomic_8 = createDeclaration(M, my_atomics_name("load", 8),
        i64_ty, {i64_ptr_ty, i32_ty});
    my_store_atomic_4 = createDeclaration(M, my_atomics_name("store", 4),
        void_ty, {i32_ptr_ty, i32_ty, i32_ty});
    my_store_atomic_8 = createDeclaration(M, my_atomics_name("store", 8),
        void_ty, {i64_ptr_ty, i64_ty, i32_ty});
    my_cmpxchg_atomic_4 = createDeclaration(M, my_atomics_name("cmpxchg", 4),
        StructType::get(ctx, {i32_ty, i1_ty}),
        {i32_ptr_ty, i32_ty, i32_ty, i32_ty, i32_ty});
    my_cmpxchg_atomic_8 = createDeclaration(M, my_atomics_name("cmpxchg", 8),
        StructType::get(ctx, {i64_ty, i1_ty}),
        {i64_ptr_ty, i64_ty, i64_ty, i32_ty, i32_ty});
    my_rmw_atomic_4 = createDeclaration(M, my_atomics_name("rmw", 4),
        i32_ty, {i32_ptr_ty, i32_ty, i32_ty, i32_ty});
    my_rmw_atomic_8 = createDeclaration(M, my_atomics_name("rmw", 8),
        i64_ty, {i64_ptr_ty, i64_ty, i32_ty, i32_ty});

    my_fence_atomic = createDeclaration(M, my_atomics_name("fence"),
        void_ty, {i32_ty});
  }

  void insertCallInstruction(IRBuilder<> &builder, Instruction *inst,
                             Function *my_atomic_fun,
                             const std::vector<Value *> args) {
    dbgs() << "Replace " << inst->getOpcodeName() << " with "
      << my_atomic_fun->getName() << "\n";
    builder.SetInsertPoint(inst->getNextNode());
    Value *callInst =
      builder.CreateCall(my_atomic_fun, ArrayRef<Value *>(args), "");
    inst->replaceAllUsesWith(callInst);
    instructions_to_erase.push_back(inst);
  }

  void cleanUp() {
    for (auto &inst : instructions_to_erase) {
      inst->eraseFromParent();
    }
  }

  void createOrderingConstant(Module &M, AtomicOrdering order,
                              std::memory_order sync) {
    my_ordering_constants[order] =
      ConstantInt::get(Type::getInt32Ty(M.getContext()), sync, true);
  }

  void createRMWOperationConstant(Module &M, AtomicRMWInst::BinOp op,
                                  my_rmw_op my_op) {
    my_rmw_operation_constants[op] =
      ConstantInt::get(Type::getInt32Ty(M.getContext()), my_op, true);
  }

  void createConstants(Module &M) {
    createOrderingConstant(M, AtomicOrdering::Monotonic, std::memory_order_relaxed);
    createOrderingConstant(M, AtomicOrdering::Acquire, std::memory_order_acquire);
    createOrderingConstant(M, AtomicOrdering::Release, std::memory_order_release);
    createOrderingConstant(M, AtomicOrdering::AcquireRelease, std::memory_order_acq_rel);
    createOrderingConstant(M, AtomicOrdering::SequentiallyConsistent, std::memory_order_seq_cst);

    createRMWOperationConstant(M, AtomicRMWInst::BinOp::Xchg, op_xchg);
    createRMWOperationConstant(M, AtomicRMWInst::BinOp::Add, op_add);
    createRMWOperationConstant(M, AtomicRMWInst::BinOp::Sub, op_sub);
    createRMWOperationConstant(M, AtomicRMWInst::BinOp::And, op_and);
    createRMWOperationConstant(M, AtomicRMWInst::BinOp::Or, op_or);
    createRMWOperationConstant(M, AtomicRMWInst::BinOp::Xor, op_xor);
  }

  bool is_atomic(AtomicOrdering order) {
    assert(order != AtomicOrdering::Unordered);
    return order != AtomicOrdering::NotAtomic;
  }

  Function *get_my_atomic(Module &M, Type *ty, Function *my_atomic_4,
                          Function *my_atomic_8) {
    const DataLayout &DL = M.getDataLayout();
    auto size            = DL.getTypeStoreSize(ty);
    if (size == 4)
      return my_atomic_4;
    else if (size == 8)
      return my_atomic_8;
    else
      assert(0 && "unsupported type size");
    return NULL;
  }

  void visitLoadInst(LoadInst *loadInst, Module &M, IRBuilder<> &builder) {
    if (is_atomic(loadInst->getOrdering())) {
      auto c = my_ordering_constants[loadInst->getOrdering()];

      Function *my_load_atomic = get_my_atomic(M, loadInst->getType(),
          my_load_atomic_4, my_load_atomic_8);

      insertCallInstruction(builder, loadInst, my_load_atomic,
          {loadInst->getPointerOperand(), c});
    }
  }

  void visitStoreInst(StoreInst *storeInst, Module &M, IRBuilder<> &builder) {
    if (is_atomic(storeInst->getOrdering())) {
      auto c = my_ordering_constants[storeInst->getOrdering()];

      Function *my_store_atomic = get_my_atomic(M,
          storeInst->getValueOperand()->getType(),
          my_store_atomic_4, my_store_atomic_8);

      insertCallInstruction(builder, storeInst, my_store_atomic,
          {storeInst->getPointerOperand(), storeInst->getValueOperand(), c});
    }
  }

  void visitAtomicCmpXchgInst(AtomicCmpXchgInst *cmpxchgInst,
                              Module &M, IRBuilder<> &builder) {
    auto c_succ = my_ordering_constants[cmpxchgInst->getSuccessOrdering()];
    auto c_fail = my_ordering_constants[cmpxchgInst->getFailureOrdering()];

    Function *my_cmpxchg_atomic = get_my_atomic(M,
        cmpxchgInst->getCompareOperand()->getType(),
        my_cmpxchg_atomic_4, my_cmpxchg_atomic_8);

    insertCallInstruction(builder, cmpxchgInst, my_cmpxchg_atomic,
        {cmpxchgInst->getPointerOperand(), cmpxchgInst->getCompareOperand(),
        cmpxchgInst->getNewValOperand(), c_succ, c_fail});
  }

  void visitAtomicRMWInst(AtomicRMWInst *rmwInst, Module &M, IRBuilder<> &builder) {
    auto c = my_ordering_constants[rmwInst->getOrdering()];

    Function *my_rmw_atomic = get_my_atomic(M,
        rmwInst->getValOperand()->getType(),
        my_rmw_atomic_4, my_rmw_atomic_8);

    insertCallInstruction(builder, rmwInst, my_rmw_atomic,
        {rmwInst->getPointerOperand(), rmwInst->getValOperand(), c,
        my_rmw_operation_constants[rmwInst->getOperation()]});
  }

  void visitFenceInst(FenceInst *fenceInst, Module &M, IRBuilder<> &builder) {
    auto c = my_ordering_constants[fenceInst->getOrdering()];

    insertCallInstruction(builder, fenceInst, my_fence_atomic, {c});
  }

  void visitInst(Instruction *inst, Module &M, IRBuilder<> &builder) {
    if (LoadInst *loadInst = dyn_cast<LoadInst>(inst)) {
      visitLoadInst(loadInst, M, builder);
    } else if (StoreInst *storeInst = dyn_cast<StoreInst>(inst)) {
      visitStoreInst(storeInst, M, builder);
    } else if (AtomicCmpXchgInst *cmpxchgInst = dyn_cast<AtomicCmpXchgInst>(inst)) {
      visitAtomicCmpXchgInst(cmpxchgInst, M, builder);
    } else if (AtomicRMWInst *rmwInst = dyn_cast<AtomicRMWInst>(inst)) {
      visitAtomicRMWInst(rmwInst, M, builder);
    } else if (FenceInst *fenceInst = dyn_cast<FenceInst>(inst)) {
      visitFenceInst(fenceInst, M, builder);
    }
  }

public:
  virtual bool runOnModule(Module &M) {
    createDeclarations(M);
    createConstants(M);

    for (auto &fun : M) {
      dbgs() << "Parse function " << fun.getName() << "\n";
      for (auto &bb : fun) {
        IRBuilder<> builder(&bb);

        for (auto &inst : bb) {
          visitInst(&inst, M, builder);
        }
      }
    }

    cleanUp();

    return false;
  }
};

char AtomicReplacePass::ID = 0;
static RegisterPass<AtomicReplacePass> X("atomic-replace",
  "Replace atomic instructions with external function calls", false, false);
static RegisterStandardPasses Y(PassManagerBuilder::EP_EarlyAsPossible,
                                [](const PassManagerBuilder &Builder,
                                   legacy::PassManagerBase &PM) {
                                    PM.add(new AtomicReplacePass());
                                });

}
