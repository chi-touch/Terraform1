package terra1.services;

import java.math.BigInteger;

public class Fibonacci {
    public static BigInteger calculateFibonacci(int n) {
        if (n < 0) {
            throw new IllegalArgumentException("Input must be a non-negative integer.");
        }

        if (n <= 1) {
            return BigInteger.valueOf(n);

        }

        BigInteger fib1 = BigInteger.ONE;
        BigInteger fib2 = BigInteger.ONE;
        BigInteger fib = BigInteger.ZERO;

        for (int i = 2; i <= n; i++) {
            fib = fib1.add(fib2);
            fib1 = fib2;
            fib2 = fib;
        }

        return fib;
    }


}
