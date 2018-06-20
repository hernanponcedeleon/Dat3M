package porthosc.utils;

import com.google.common.collect.ImmutableList;

import java.util.Collection;


public class ImmutableUtils {
    public static <T> ImmutableList<T> append(T first, Collection<T> others) {
        return ImmutableList.<T>builderWithExpectedSize(others.size()+1).add(first).addAll(others).build();
    }

    public static <T> ImmutableList<T> append(Collection<T> others, T last) {
        return ImmutableList.<T>builderWithExpectedSize(others.size()+1).addAll(others).add(last).build();
    }
}
