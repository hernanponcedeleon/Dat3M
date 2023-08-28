/*
 * Copyright (C) 2022-2023. Huawei Technologies Co., Ltd.
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

  std::map<int, Function *> my_load_atomic_fun;
  std::map<int, Function *> my_store_atomic_fun;
  std::map<int, Function *> my_cmpxchg_atomic_fun;
  std::map<int, Function *> my_rmw_atomic_fun;
  Function *my_fence_atomic;

  std::map<AtomicOrdering, Constant *, compareAtomicOrdering> my_ordering_constants;
  std::map<AtomicRMWInst::BinOp, Constant *> my_rmw_operation_constants;

  Function *createDeclaration(Module &M, const std::string &name, Type *returnType,
                              const std::vector<Type *> args) {
    FunctionType *ft = FunctionType::get(returnType, args, false);
    return Function::Create(ft, Function::ExternalLinkage, name, M);
  }

  void validate_size(int size) {
    assert((size == 1 || size == 2 || size == 4 || size == 8) && "unsupported type size");
  }

  std::string my_atomics_name_suffix(int size) {
    if (size == 0) {
      return "";
    } else {
      validate_size(size);
      return std::to_string(8*size);
    }
  }

  std::string my_atomics_name(const std::string &op, int size = 0) {
    return std::string("__llvm_atomic") + my_atomics_name_suffix(size) + "_" + op;
  }

  void createDeclarationsSize(Module &M, int size) {
    LLVMContext &ctx   = M.getContext();
    const auto ty      = Type::getIntNTy(ctx, 8*size);
    const auto ptr_ty  = Type::getIntNPtrTy(ctx, 8*size);
    const auto i32_ty  = Type::getInt32Ty(ctx);
    const auto i1_ty   = Type::getInt1Ty(ctx);
    const auto void_ty = Type::getVoidTy(ctx);

    my_load_atomic_fun[size] = createDeclaration(M, my_atomics_name("load", size),
        ty, {ptr_ty, i32_ty});
    my_store_atomic_fun[size] = createDeclaration(M, my_atomics_name("store", size),
        void_ty, {ptr_ty, ty, i32_ty});
    my_cmpxchg_atomic_fun[size] = createDeclaration(M, my_atomics_name("cmpxchg", size),
        StructType::get(ctx, {ty, i1_ty}), {ptr_ty, ty, ty, i32_ty, i32_ty});
    my_rmw_atomic_fun[size] = createDeclaration(M, my_atomics_name("rmw", size),
        ty, {ptr_ty, ty, i32_ty, i32_ty});
  }

  void createDeclarations(Module &M) {
    LLVMContext &ctx   = M.getContext();
    const auto i32_ty  = Type::getInt32Ty(ctx);
    const auto void_ty = Type::getVoidTy(ctx);

    createDeclarationsSize(M, 1);
    createDeclarationsSize(M, 2);
    createDeclarationsSize(M, 4);
    createDeclarationsSize(M, 8);

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

  Function *get_my_atomic(Module &M, Type *ty, std::map<int, Function *>& my_atomic_fun) {
    const DataLayout &DL = M.getDataLayout();
    int size             = DL.getTypeStoreSize(ty);
    validate_size(size);
    return my_atomic_fun[size];
  }

  void visitLoadInst(LoadInst *loadInst, Module &M, IRBuilder<> &builder) {
    if (is_atomic(loadInst->getOrdering())) {
      auto c = my_ordering_constants[loadInst->getOrdering()];

      Function *my_load_atomic = get_my_atomic(M, loadInst->getType(),
          my_load_atomic_fun);

      insertCallInstruction(builder, loadInst, my_load_atomic,
          {loadInst->getPointerOperand(), c});
    }
  }

  void visitStoreInst(StoreInst *storeInst, Module &M, IRBuilder<> &builder) {
    if (is_atomic(storeInst->getOrdering())) {
      auto c = my_ordering_constants[storeInst->getOrdering()];

      Function *my_store_atomic = get_my_atomic(M,
          storeInst->getValueOperand()->getType(),
          my_store_atomic_fun);

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
        my_cmpxchg_atomic_fun);

    insertCallInstruction(builder, cmpxchgInst, my_cmpxchg_atomic,
        {cmpxchgInst->getPointerOperand(), cmpxchgInst->getCompareOperand(),
        cmpxchgInst->getNewValOperand(), c_succ, c_fail});
  }

  void visitAtomicRMWInst(AtomicRMWInst *rmwInst, Module &M, IRBuilder<> &builder) {
    auto c = my_ordering_constants[rmwInst->getOrdering()];

    Function *my_rmw_atomic = get_my_atomic(M,
        rmwInst->getValOperand()->getType(),
        my_rmw_atomic_fun);

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
