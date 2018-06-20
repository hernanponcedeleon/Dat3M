package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.utils.exceptions.NotImplementedException;


class XTypeDeterminer {

    static XType determineType(XUnaryOperator operator, XLocalMemoryUnit operand) {
        XType operandType = operand.getType();
        switch (operator) {
            case BitNegation:
            case NoOperation:
                return operandType;
            default:
                throw new NotImplementedException(operator.name());
        }
    }

    static XType determineType(XBinaryOperator operator,
                               XLocalMemoryUnit firstOperand,
                               XLocalMemoryUnit secondOperand) {
        XType firstType = firstOperand.getType();
        XType secondType = secondOperand.getType();
        switch (operator) {
            case Addition:
            case Subtraction:
            case Multiplication:
            case Division:
            case Modulo:
            case LeftShift:
            case RightShift: {
                if (firstType != secondType) {
                    throw new IllegalArgumentException("Attempt to perform an operation with arguments of different types: " +
                            firstType + ", " + secondType);
                }
                //todo: Unsure that we need to take max bitness of operands
                return firstType;
            }
            case BitAnd:
            case BitOr:
            case BitXor: {
                if (firstType != secondType) {
                    //todo: bit alignment?
                    throw new IllegalArgumentException("Attempt to perform bit operation with arguments of different sizes");
                    // todo: throw special type of exception everywhere
                }
                return firstType;
            }
            case Conjunction:
            case Disjunction:
            case CompareEquals:
            case CompareNotEquals:
            case CompareLess:
            case CompareLessOrEquals:
            case CompareGreater:
            case CompareGreaterOrEquals: {
                return XType.bit1;
            }
            default:
                throw new IllegalArgumentException(operator.name());
        }
    }
}
